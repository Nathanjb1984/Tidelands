/* ═══════════════════════════════════════════════════════════════════
   TIDELINES: Cedar, Sea & Legacy — React Vertical-Slice
   ═══════════════════════════════════════════════════════════════════
   One self-contained component.  No backend, no build step needed.
   All game state lives in a single React useState object.
   ═══════════════════════════════════════════════════════════════════ */
const { useState, useRef, useEffect, useCallback } = React;

// ─── Palette ────────────────────────────────────────────────────────
const P = {
  bg:'#0a0a1a', panel:'#12122a', panelHi:'#1a1a3a', border:'#2a2a4a',
  gold:'#c4a000', cedar:'#8c2600', teal:'#1a3a3a', tealHi:'#245050',
  text:'#e8dcc8', dim:'#807868', green:'#40c030', red:'#cc3318',
  blue:'#3088cc', darkBg:'#08081a', debugBg:'#060612', legacyBg:'#0a0610',
};

// ─── Constants ──────────────────────────────────────────────────────
const PHASES = ['Village','Travel','Encounter','Resolution','Withdrawal','Aftermath'];

const TACTIC_MODS = {
  overwhelming_assault:    { atk:1.30, loss:1.50 },
  measured_push:           { atk:1.10, loss:1.00 },
  feint_and_probe:         { atk:0.80, loss:0.60 },
  negotiation_under_arms:  { atk:0.40, loss:0.10 },
};

const TURNING_POINTS = [
  { id:'warrior_falls',  text:'A named warrior falls in the fighting.',          atkB:-5,  defB:10 },
  { id:'chief_rallies',  text:'Your chief rallies the crew with a battle cry!',  atkB:15,  defB:0  },
  { id:'canoe_captured', text:'A canoe is seized in the chaos!',                 atkB:12,  defB:-8 },
  { id:'fire_breaks_out',text:'Fire erupts — smoke and confusion.',              atkB:-5,  defB:-5 },
  { id:'war_song',       text:'Kaahl the War Singer lifts the ancient battle song!', atkB:10, defB:0 },
  { id:'fog_rolls_in',   text:'Sudden fog. Both sides lose cohesion.',           atkB:-8,  defB:-3 },
  { id:'champion_duel',  text:'Two warriors face each other between the lines.', atkB:8,   defB:8  },
];

// ─── Utilities ──────────────────────────────────────────────────────
const ri  = (a,b) => Math.floor(Math.random()*(b-a+1))+a;
const rf  = (a,b) => Math.random()*(b-a)+a;
const cl  = (v,lo,hi) => Math.max(lo,Math.min(hi,v));
const L   = (t,c='') => ({t,c});                     // narrative line
const pct = (v,m) => cl(v/m*100,0,100)+'%';

const feudName = e =>
  e<=0?'RESOLVED': e<=3?'SMOULDERING': e<=5?'GRIEVANCE': e<=12?'ACTIVE_FEUD':'BLOOD_FEUD';

const phaseOf = step =>
  ['vil','trv','enc','res','wth','aft'].findIndex(p => step.startsWith(p));

// ─── Deep-dup helper (shallow copy + array/object children) ─────────
function dup(s){
  return {
    ...s,
    log:            [...s.log],
    defender:       {...s.defender},
    namedCrew:      s.namedCrew.map(c=>({...c})),
    rounds:         s.rounds.map(r=>({...r})),
    spoils:         [...s.spoils],
    traitsEarned:   [...s.traitsEarned],
    legacyEntries:  [...s.legacyEntries],
  };
}

// ═════════════════════════════════════════════════════════════════════
//  ENGINE — pure math (operates on mutable draft)
// ═════════════════════════════════════════════════════════════════════

function calcIntimidation(s){
  let sc=0;
  sc += 14;                                     // war_canoe_rating
  sc += 12;                                     // conflict_reputation
  sc += 8;                                      // battle_tested trait
  sc += 7;                                      // crest_display
  sc += Math.min(Math.floor(s.prestige/100),10);// prestige
  sc += 5;                                      // war song
  sc += s.intimidationBonus;
  return sc;
}

function calcResolve(d){
  let sc=0;
  sc += Math.max(20,Math.min(d.communitySize,60));
  sc += Math.min(d.leadership,15);
  sc += Math.min(d.alliance,15);
  sc += Math.min(d.fortification*5,15);
  return sc;
}

function doIntimidation(s){
  s.intimScore  = calcIntimidation(s);
  s.resolveScore= calcResolve(s.defender);
  s.intimDelta  = s.intimScore - s.resolveScore;

  if(s.intimDelta>=50){
    s.intimResult='OVERWHELMING'; s.defenderFled=true; s.defender.morale-=30;
  } else if(s.intimDelta>=30){
    s.intimResult='DOMINANT'; s.defender.morale-=20;
  } else if(s.intimDelta>=15){
    s.intimResult='STRONG'; s.defender.morale-=ri(15,25);
  } else if(s.intimDelta>=1){
    s.intimResult='SLIGHT'; s.defender.morale-=ri(5,10);
  } else if(s.intimDelta<=-15){
    s.intimResult='REVERSED'; s.morale-=ri(5,15);
  } else {
    s.intimResult='NEUTRAL';
  }
  s.defender.morale=cl(s.defender.morale,5,100);
  s.morale=cl(s.morale,5,100);
}

function roundScore(f,type,isAtk,tacMod){
  let sc=0;
  const m=f.morale||50, q=f.quality||f.crewQuality||50,
        sz=f.crewSize||10, cc=f.canoeCombat||f.canoeCondition||50,
        lead=f.leadership||50, stam=f.stamina||65;
  switch(type){
    case 'opening':
      sc+=m*0.40; sc+=q*0.20; sc+=(sz/20)*100*0.20; sc+=cc*0.10; break;
    case 'sustained':
      sc+=q*0.35; sc+=(sz/20)*100*0.25; sc+=stam*0.20; sc+=lead*0.15; sc+=cc*0.05; break;
    case 'turning':
      sc+=m*0.35; sc+=q*0.25; sc+=lead*0.20; sc*=rf(0.80,1.20); break;
  }
  sc*=tacMod;
  if(isAtk){ sc+=3; sc+=(type==='turning'?5:2); }
  return sc;
}

function doEngagement(s){
  const tm = TACTIC_MODS[s.attackerTactic]||TACTIC_MODS.measured_push;
  const af = { morale:s.morale, quality:s.crewQuality, crewSize:s.crewAlive,
               canoeCombat:s.canoeCondition*0.6, leadership:55, stamina:70 };
  const df = { morale:s.defender.morale, quality:s.defender.quality,
               crewSize:s.defender.crewSize, canoeCombat:s.defender.canoeCombat,
               leadership:s.defender.leadership, stamina:60 };

  let r1a=roundScore(af,'opening',true,tm.atk), r1d=roundScore(df,'opening',false,1.0);
  if(s.surpriseBonus>10) r1a*=1+s.surpriseBonus/100;

  let r2a=roundScore(af,'sustained',true,tm.atk), r2d=roundScore(df,'sustained',false,1.0);

  const tp = TURNING_POINTS[Math.floor(Math.random()*TURNING_POINTS.length)];
  let r3a=roundScore(af,'turning',true,tm.atk), r3d=roundScore(df,'turning',false,1.0);
  r3a+=tp.atkB; r3d+=tp.defB;

  s.turningPoint = tp;
  s.rounds = [
    {name:'Opening Clash',        atk:r1a, def:r1d},
    {name:'Sustained Engagement', atk:r2a, def:r2d},
    {name:'Turning Point',        atk:r3a, def:r3d, event:tp},
  ];

  let ta = (r1a+r2a+r3a)*rf(0.88,1.12);
  let td = (r1d+r2d+r3d)*rf(0.88,1.12);
  s.atkTotal=ta; s.defTotal=td;
  s.outcomeRatio = ta/Math.max(td,1);

  if(s.outcomeRatio>1.8)       s.outcome='DECISIVE_VICTORY';
  else if(s.outcomeRatio>1.3)  s.outcome='VICTORY';
  else if(s.outcomeRatio>0.85) s.outcome='STALEMATE';
  else if(s.outcomeRatio>0.55) s.outcome='DEFEAT';
  else                         s.outcome='DEVASTATING_DEFEAT';

  s.prestigeChange = {DECISIVE_VICTORY:30,VICTORY:15,STALEMATE:0,DEFEAT:-15,DEVASTATING_DEFEAT:-30}[s.outcome]||0;
}

function doCasualties(s){
  const isWin = s.outcome==='DECISIVE_VICTORY'||s.outcome==='VICTORY';
  const tm = TACTIC_MODS[s.attackerTactic]||TACTIC_MODS.measured_push;
  let bl=0;
  switch(s.outcome){
    case 'DECISIVE_VICTORY': bl=0.05; break;
    case 'VICTORY':          bl=0.12; break;
    case 'STALEMATE':        bl=0.10; break;
    case 'DEFEAT':           bl=0.25; break;
    case 'DEVASTATING_DEFEAT': bl=0.45; break;
  }
  bl = cl(bl*tm.loss*rf(0.7,1.3), 0, 0.60);

  const hit = Math.floor(s.crewAlive*bl);
  s.crewKilled  = Math.floor(hit*rf(0.2,0.4));
  s.crewWounded = hit - s.crewKilled;
  s.crewAlive   = Math.max(s.crewAlive - s.crewKilled, 1);

  // Named crew casualties
  let pool = s.namedCrew.filter(c=>c.alive);
  for(let i=0;i<s.crewKilled&&pool.length;i++){
    const idx=Math.floor(Math.random()*pool.length);
    pool[idx].alive=false; pool.splice(idx,1);
  }
  for(let i=0;i<s.crewWounded&&pool.length;i++){
    const idx=Math.floor(Math.random()*pool.length);
    pool[idx].wounded=true; pool.splice(idx,1);
  }

  // Canoe damage
  if(s.outcome==='DEVASTATING_DEFEAT') s.canoeCondition-=ri(30,70);
  else if(s.outcome==='DEFEAT')        s.canoeCondition-=ri(10,30);
  else                                 s.canoeCondition-=ri(0,15);
  s.canoeCondition=cl(s.canoeCondition,5,100);

  // Spoils
  s.spoils=[];
  if(isWin){
    if(s.outcome==='DECISIVE_VICTORY'){
      s.spoils=[{r:'Dried Fish',n:25},{r:'Cedar Bark',n:10},{r:'Dentalium',n:8}]; s.cargo=40;
    } else {
      s.spoils=[{r:'Dried Fish',n:15},{r:'Cedar Bark',n:5}]; s.cargo=20;
    }
  }

  // Morale
  if(isWin) s.morale += s.outcome==='DECISIVE_VICTORY'?20:10;
  else      s.morale -= s.outcome==='DEVASTATING_DEFEAT'?25:15;
  s.morale=cl(s.morale,0,100);

  s.prestige += s.prestigeChange;
  s.feudEscalation += isWin?3:1;
}


// ═════════════════════════════════════════════════════════════════════
//  STATE FACTORY
// ═════════════════════════════════════════════════════════════════════
function initState(carry={}){
  return {
    step:'vil_intel', scene:'village',
    log:[
      L('═══ THE VILLAGE ═══','gold'),
      L('The decision has been made. Cedar Creek will answer for what they have taken.'),
      L('Before the war canoe is loaded, you must learn what awaits.'),
      L(''),
    ],
    morale:65, fear:0, canoeCondition:100,
    cargo:0, cargoCapacity:40,
    prestige:  carry.prestige  ?? 200,
    feudEscalation: carry.feudEscalation ?? 8,
    crewSize:15, crewQuality:55, crewAlive:15,
    crewWounded:0, crewKilled:0, captivesTaken:0,
    intelQuality:'NONE', surpriseBonus:0, stealthBonus:0,
    intimidationBonus:0, approachTime:'dawn', formation:'single',
    attackerTactic:'measured_push',
    intimScore:0, resolveScore:0, intimDelta:0, intimResult:'',
    defenderFled:false,
    rounds:[], outcome:'', outcomeRatio:0,
    atkTotal:0, defTotal:0, turningPoint:null, prestigeChange:0,
    defender:{
      name:'Cedar Creek', crewSize:12, morale:55,
      quality:45, canoeCombat:40, communitySize:35,
      leadership:40, fortification:0, alliance:5,
    },
    namedCrew:[
      {id:'gwaay', name:'Gwaay', traits:['veteran'],     alive:true, wounded:false},
      {id:'kaahl', name:'Kaahl', traits:['war_singer'],  alive:true, wounded:false},
      {id:'naang', name:'Naang', traits:[],               alive:true, wounded:false},
    ],
    legacyEntries: carry.legacyEntries ? [...carry.legacyEntries] : [],
    traitsEarned:[], spoils:[],
    showDebug:false,
  };
}


// ═════════════════════════════════════════════════════════════════════
//  TRANSITION FUNCTIONS  — each takes prev state, returns new state
// ═════════════════════════════════════════════════════════════════════

// ── Phase 0: Village ─────────────────────────────────────────────
function pickIntel(prev, id){
  const s=dup(prev);
  switch(id){
    case 'scouts':
      s.intelQuality='ACCURATE'; s.surpriseBonus+=5;
      if(Math.random()<0.15){
        s.defender.morale+=5;
        s.log.push(L('⚠ Your scouts may have been spotted!','red'));
      }
      s.log.push(L('Your scouts return — they counted three canoes, twelve warriors, no fortifications. The chief does not expect trouble.'));
      s.log.push(L('Intel: ACCURATE — crew ~12, defenses: none, alert: unaware.','green'));
      s.morale+=3;
      break;
    case 'traders':
      s.intelQuality='VAGUE';
      s.log.push(L('"A modest village," the eldest trader says. "Their chief talks big but their canoes are old. There was talk of a marriage with the Skidegate people."'));
      s.log.push(L('Intel: VAGUE — moderate force, possible alliance.','dim'));
      break;
    case 'omens':
      s.intelQuality='VAGUE'; s.morale+=5;
      s.log.push(L('"I see water between two fires. The wind will be with you, but the tide will not wait."'));
      s.log.push(L('Intel: VAGUE — omen suggests favorable weather but narrow timing.','dim'));
      break;
  }
  s.log.push(L(''));
  s.log.push(L('Your war canoe is loaded. Fifteen warriors sit at the paddles.'));
  s.step='vil_prep';
  return s;
}

function pickPrep(prev, id){
  const s=dup(prev);
  switch(id){
    case 'war_paint':
      s.intimidationBonus+=10; s.morale=cl(s.morale+5,0,100);
      s.log.push(L('Eagle and Killer Whale crests shine on every shield. Your crew is ready.'));
      break;
    case 'extra_supplies':
      s.cargoCapacity+=10; s.canoeCondition=Math.min(100,s.canoeCondition+10);
      s.log.push(L('The canoe sits deeper in the water — well provisioned for the crossing.'));
      break;
    case 'blessing':
      s.morale=cl(s.morale+8,0,100); s.surpriseBonus+=5;
      s.log.push(L('The spiritual advisor places cedar on the fire. "The spirits walk with you."'));
      break;
  }
  s.step='vil_done';
  return s;
}

// ── Phase 1: Travel ─────────────────────────────────────────────
function enterTravel(prev){
  const s=dup(prev);
  s.step='trv_arrival'; s.scene='travel';
  s.log.push(L(''));
  s.log.push(L('═══ THE CROSSING ═══','gold'));
  s.log.push(L("The morning fog clings to the water as you push off. Cedar Creek lies half a day's paddle to the north. Every stroke takes you closer to the moment where words end and actions begin."));
  return s;
}

function pickArrival(prev, id){
  const s=dup(prev);
  switch(id){
    case 'dawn':
      s.approachTime='dawn'; s.surpriseBonus+=15;
      s.log.push(L('You paddle through the night. As the first grey light touches the sky, Cedar Creek appears — smoke rising, a dog barking. No one is on the beach.'));
      break;
    case 'night':
      s.approachTime='night'; s.surpriseBonus+=25;
      if(Math.random()<0.20){
        s.canoeCondition-=10;
        s.log.push(L('A rock scrapes the hull — hearts stop — but the canoe holds.','red'));
      }
      s.log.push(L('The darkness is total except for phosphorescence. You reach the shallows in absolute silence.'));
      break;
    case 'fog':
      s.approachTime='fog'; s.surpriseBonus+=20; s.stealthBonus+=5;
      s.log.push(L('The fog is a gift. Your canoe slides through it like a spirit. You hear Cedar Creek before you see it.'));
      break;
  }
  s.log.push(L(''));
  s.step='trv_form';
  return s;
}

function pickFormation(prev, id){
  const s=dup(prev);
  if(id==='stealth'){
    s.formation='stealth'; s.stealthBonus+=10; s.intimidationBonus-=5;
    s.log.push(L('One canoe. One chance. Every paddle dips in unison, silent as breathing.'));
  } else {
    s.formation='intimidating'; s.intimidationBonus+=15; s.stealthBonus-=10;
    s.log.push(L('Your canoe fans out, war crests visible. Anyone watching will see not a raid but an invasion.'));
  }
  s.step='trv_done';
  return s;
}

// ── Phase 2: Encounter ──────────────────────────────────────────
function enterEncounter(prev){
  const s=dup(prev);
  s.scene='encounter';
  s.log.push(L(''));
  s.log.push(L('═══ THE BEACH AT CEDAR CREEK ═══','gold'));

  doIntimidation(s);

  const sign = s.intimDelta>=0?'+':'';
  s.log.push(L(`Intimidation: ${s.intimScore}  vs  Resolve: ${s.resolveScore}  (Δ ${sign}${s.intimDelta})`,'green'));
  s.log.push(L(`Result: ${s.intimResult}`, s.intimDelta>0?'green':'red'));

  if(s.defenderFled){
    s.log.push(L('Before you beach the canoe, Cedar Creek\'s chief appears with arms raised. "We will talk! Come ashore as guests, not enemies!"'));
    s.log.push(L('Your reputation has done the work. Cedar Creek capitulates.','green'));
    s.outcome='DECISIVE_VICTORY'; s.prestigeChange=30;
    s.spoils=[{r:'Dried Fish',n:25},{r:'Cedar Bark',n:10},{r:'Dentalium',n:8}];
    s.cargo=40; s.prestige+=30; s.feudEscalation+=3;
    s.step='enc_fled';
  } else {
    s.log.push(L('Warriors spill from the longhouse. Not many — but they are armed, and they are moving to the beach.'));
    s.log.push(L(''));
    s.log.push(L('The bow of your war canoe grinds into the gravel. Your warriors leap into the shallow water. This is the moment.'));
    s.step='enc_tactic';
  }
  return s;
}

function pickTactic(prev, id){
  const s=dup(prev);
  switch(id){
    case 'overwhelming':
      s.attackerTactic='overwhelming_assault';
      s.log.push(L('You raise your weapon and shout the war cry. Your warriors surge forward!'));
      s.morale+=5; s.fear=Math.max(s.fear-10,0);
      break;
    case 'measured':
      s.attackerTactic='measured_push';
      s.log.push(L('Your warriors form a line across the beach, moving steadily forward with disciplined silence.'));
      break;
    case 'feint':
      s.attackerTactic='feint_and_probe';
      s.log.push(L("Three warriors rush forward — clash briefly — then fall back. You watch. There. That's where the line is thin."));
      break;
    case 'negotiate':
      s.attackerTactic='negotiation_under_arms';
      s.log.push(L('"We did not come for your lives," you say. "We came for what is owed. Return it, and we leave."'));
      s.feudEscalation-=1;
      break;
  }
  s.step='enc_done';
  return s;
}

// ── Phase 3: Resolution ─────────────────────────────────────────
function enterResolution(prev){
  const s=dup(prev);
  s.scene='battle';
  s.log.push(L(''));
  s.log.push(L('═══ THE CLASH ═══','gold'));

  // If defender already fled, skip real combat
  if(s.outcome==='DECISIVE_VICTORY'){
    s.log.push(L('Cedar Creek surrendered before battle was joined.','green'));
    s.step='res_done';
    return s;
  }

  doEngagement(s);

  const roundNarr = [
    "Your warriors hit Cedar Creek's line like a wave against a seawall. The defenders stagger — your surprise and momentum carry the first moments.",
    "Cedar Creek's chief rallies his people. The fighting becomes close and grinding. Your veteran Gwaay holds the center with terrible calm.",
  ];

  s.rounds.forEach((r,i)=>{
    s.log.push(L(`⚔ ${r.name}`,'gold'));
    if(i<2) s.log.push(L(roundNarr[i]));
    if(r.event) s.log.push(L(`✦ ${r.event.text}`,'red'));
    s.log.push(L(`  ATK: ${r.atk.toFixed(1)}  DEF: ${r.def.toFixed(1)}`,'green'));
    s.log.push(L(''));
  });

  const oc = s.outcome.includes('VICTORY')?'green': s.outcome.includes('DEFEAT')?'red':'gold';
  s.log.push(L('════════════════════════════',oc));
  s.log.push(L(`  OUTCOME: ${s.outcome}`,oc));
  s.log.push(L('════════════════════════════',oc));
  s.log.push(L(`  Ratio: ${s.outcomeRatio.toFixed(2)}  |  ATK: ${s.atkTotal.toFixed(0)}  DEF: ${s.defTotal.toFixed(0)}`,'green'));

  if(s.outcome==='VICTORY'||s.outcome==='DECISIVE_VICTORY')
    s.log.push(L("Cedar Creek's line breaks. The beach belongs to you."));
  else if(s.outcome==='STALEMATE')
    s.log.push(L('Neither side can press the advantage. Both withdraw to lick their wounds.'));
  else
    s.log.push(L('Your crew is pushed back. The assault has failed.','red'));

  doCasualties(s);
  s.step='res_done';
  return s;
}

// ── Phase 4: Withdrawal ─────────────────────────────────────────
function enterWithdrawal(prev){
  const s=dup(prev);
  s.scene='travel';
  s.log.push(L(''));
  s.log.push(L('═══ LOADING AND LEAVING ═══','gold'));

  const isWin = s.outcome==='DECISIVE_VICTORY'||s.outcome==='VICTORY';
  if(!isWin){
    s.log.push(L('Your crew falls back to the canoe. There are no spoils — only the bitter taste of retreat.'));
    s.step='wth_retreat';
  } else {
    s.log.push(L("The fighting is over. Cedar Creek's warriors watch from the tree line. Your crew must work fast — load the spoils, tend the wounded, and get back to sea."));
    s.step='wth_choose';
  }
  return s;
}

function pickWithdrawal(prev, id){
  const s=dup(prev);
  switch(id){
    case 'quick':
      s.cargo=Math.floor(s.cargo*0.6);
      s.log.push(L('Speed over greed. Your crew loads what they can in armfuls. Within minutes, you are pushing off.'));
      break;
    case 'thorough':
      s.log.push(L('You strip the fish racks clean. Cedar bark. Dentalium shells.'));
      if(Math.random()<0.30){
        s.log.push(L('⚠ Cedar Creek reorganizes and charges! A brief skirmish costs you.','red'));
        s.crewAlive=Math.max(s.crewAlive-1,1); s.morale-=5;
      }
      s.log.push(L('The canoe is loaded deep and pushing through the surf.'));
      break;
    case 'mark':
      s.cargo=Math.floor(s.cargo*0.8); s.prestige+=10; s.feudEscalation+=3;
      s.log.push(L("Before leaving, you drive a carved Eagle post into the gravel of Cedar Creek's beach. Your crest, facing their longhouse. Every morning, their chief will wake and see it."));
      s.log.push(L('+10 Prestige. Feud deepened.','gold'));
      break;
  }
  s.step='wth_done';
  return s;
}

// ── Phase 5: Aftermath ──────────────────────────────────────────
function enterAftermath(prev){
  const s=dup(prev);
  s.scene='village';
  s.log.push(L(''));
  s.log.push(L('═══ THE RETURN AND THE RECKONING ═══','gold'));
  s.log.push(L('Your canoe rounds the headland and your village comes into view. People are already gathering on the beach.'));

  // Casualty report
  s.log.push(L('— Casualty Report —','gold'));
  s.log.push(L(`  ☠ Killed: ${s.crewKilled}   ⚔ Wounded: ${s.crewWounded}   Crew alive: ${s.crewAlive}`, s.crewKilled>0?'red':''));
  s.namedCrew.forEach(c=>{
    if(!c.alive) s.log.push(L(`  ☠ ${c.name} — fell in the fighting.`,'red'));
    else if(c.wounded) s.log.push(L(`  ⚔ ${c.name} — wounded, will recover.`,'dim'));
  });

  // Spoils
  if(s.spoils.length>0){
    s.log.push(L('— Spoils —','gold'));
    s.spoils.forEach(sp=> s.log.push(L(`  ${sp.r}: ×${sp.n}`,'green')));
    s.log.push(L(`  Cargo: ${s.cargo}/${s.cargoCapacity}`));
  }

  // Status changes
  s.log.push(L('— Status Changes —','gold'));
  s.log.push(L(`  Prestige: ${s.prestigeChange>=0?'+':''}${s.prestigeChange} (now ${s.prestige})`));
  s.log.push(L(`  Feud Escalation: ${s.feudEscalation} — ${feudName(s.feudEscalation)}`));
  s.log.push(L(`  Canoe Condition: ${s.canoeCondition}%`, s.canoeCondition<50?'red':''));
  if(s.canoeCondition<50) s.log.push(L('  🛶 Your canoe took serious damage. Repairs needed.','red'));

  // Traits
  s.traitsEarned=[];
  if(s.crewKilled>0) s.traitsEarned.push('grief_hardened');
  if(s.outcome==='DECISIVE_VICTORY') s.traitsEarned.push('battle_tested');
  if(s.traitsEarned.length>0) s.log.push(L(`  Traits earned: ${s.traitsEarned.join(', ')}`,'gold'));

  // Long-term
  s.log.push(L(''));
  s.log.push(L('— Long-Term Effects —','gold'));
  const fs = feudName(s.feudEscalation);
  s.log.push(L(`The feud with Cedar Creek: ${fs}. ${fs==='BLOOD_FEUD'?'There is no trade, no communication, no peace.':'Tensions remain high.'}`));

  const ret = s.outcome.includes('VICTORY') ? (s.outcome==='DECISIVE_VICTORY'?6:4) : 0;
  if(ret>0) s.log.push(L(`⏳ Expect retaliation from Cedar Creek in ~${ret} turns.`,'red'));

  if(s.outcome==='DECISIVE_VICTORY'){
    s.log.push(L('♫ A battle song is composed — "The Beach at Cedar Creek."','gold'));
    s.log.push(L('🏔 Your master carver offers to begin a war history pole.','gold'));
  }

  // Legacy entry
  const tone = {DECISIVE_VICTORY:'A great victory.',VICTORY:'The crew returned with honor.',STALEMATE:'Neither side could claim victory.',DEFEAT:'A bitter retreat.',DEVASTATING_DEFEAT:'Many did not return.'}[s.outcome]||'';
  const dead = s.namedCrew.filter(c=>!c.alive).map(c=>c.name);
  let leg = `The village raided Cedar Creek. ${tone}`;
  if(dead.length>0) leg+=` Lost: ${dead.join(', ')}.`;
  if(s.traitsEarned.length>0) leg+=` Traits: ${s.traitsEarned.join(', ')}.`;
  s.legacyEntries.push(leg);

  s.step='aft_show';
  return s;
}

// ── Continue button routing ─────────────────────────────────────
const CONT = {
  vil_done:    enterTravel,
  trv_done:    enterEncounter,
  enc_fled:    enterWithdrawal,   // intimidation capitulation → skip to withdrawal
  enc_done:    enterResolution,
  res_done:    enterWithdrawal,
  wth_retreat: enterAftermath,
  wth_done:    enterAftermath,
};


// ═════════════════════════════════════════════════════════════════════
//  INJECTED CSS
// ═════════════════════════════════════════════════════════════════════
const CSS = `
@import url('https://fonts.googleapis.com/css2?family=Press+Start+2P&display=swap');
@keyframes tl-bob{0%,100%{transform:translateY(0)}50%{transform:translateY(-3px)}}
.tl-canoe-bob{animation:tl-bob 2s ease-in-out infinite}
.tl-log::-webkit-scrollbar{width:6px}
.tl-log::-webkit-scrollbar-thumb{background:${P.border};border-radius:3px}
.tl-log::-webkit-scrollbar-track{background:transparent}
.tl-choice:hover{background:${P.tealHi}!important;border-color:${P.gold}!important}
.tl-action:hover{background:#aa3200!important}
`;


// ═════════════════════════════════════════════════════════════════════
//  SUB-COMPONENTS
// ═════════════════════════════════════════════════════════════════════

function StatBar({label, value, max, color, noBar}){
  const display = typeof value==='string'? value : value;
  const w = (max&&max>0&&typeof value==='number') ? cl(value/max*100,0,100) : 0;
  return (
    <div style={S.statBox}>
      <div style={S.statLabel}>{label}</div>
      <div style={S.statValue}>{display}</div>
      {!noBar && max>0 && (
        <div style={S.statTrack}>
          <div style={{...S.statFill, width:w+'%', background:color}} />
        </div>
      )}
    </div>
  );
}

function Scene({type}){
  const water = <div style={S.water}/>;
  const land  = (extra={}) => <div style={{...S.land,...extra}}/>;
  const canoe = <div className="tl-canoe-bob" style={S.canoe}><span style={S.canoeProw}>⟐</span></div>;
  const hut   = (h=30,w=30) => <div style={{...S.hut,height:h,width:w}}><span style={S.hutRoof}>▲</span></div>;

  let children;
  switch(type){
    case 'village':
      children = <>{water}{land({width:'60%',left:'20%',right:'20%'})}{hut()}{hut(24,30)}{hut(20,22)}</>;
      break;
    case 'travel':
      children = <>{water}{canoe}</>;
      break;
    case 'encounter':
      children = <>{water}{land({})}{<div style={{marginRight:40,position:'relative',zIndex:2}}>{canoe}</div>}{hut()}</>;
      break;
    case 'battle':
      children = <>{water}{land({width:'70%',left:'15%',right:'15%'})}<span style={{position:'relative',zIndex:2,fontSize:20}}>⚔</span></>;
      break;
    default:
      children = <>{water}</>;
  }
  return <div style={S.scene}>{children}</div>;
}

function ChoiceBtn({label, desc, risk, onClick}){
  return (
    <button className="tl-choice" style={S.choiceBtn} onClick={onClick}>
      <div style={{color:P.text}}>{label}</div>
      {desc && <div style={{fontSize:7,color:P.dim,marginTop:3}}>{desc}</div>}
      {risk && <div style={{fontSize:7,color:P.red,marginTop:2}}>⚠ {risk}</div>}
    </button>
  );
}

function ContinueBtn({onClick}){
  return <button className="tl-action" style={S.actionBtn} onClick={onClick}>▸ Continue</button>;
}

// Narrative color map
const narrColor = c =>
  c==='gold'?P.gold: c==='red'?P.red: c==='green'?P.green: c==='dim'?P.dim: P.text;


// ═════════════════════════════════════════════════════════════════════
//  MAIN COMPONENT
// ═════════════════════════════════════════════════════════════════════

function TidelinesApp(){
  const [G, setG] = useState(()=>initState());
  const logRef = useRef(null);

  // Auto-scroll narrative
  useEffect(()=>{
    if(logRef.current) logRef.current.scrollTop = logRef.current.scrollHeight;
  },[G.log.length]);

  // Transition helper
  const act = useCallback((fn,...args) => setG(prev=>fn(prev,...args)), []);

  // Continue handler
  const onContinue = useCallback(()=>{
    setG(prev => {
      const fn = CONT[prev.step];
      return fn ? fn(prev) : prev;
    });
  },[]);

  // Raid Again
  const onReset = useCallback(()=>{
    setG(prev => initState({
      prestige: prev.prestige,
      feudEscalation: prev.feudEscalation,
      legacyEntries: prev.legacyEntries,
    }));
  },[]);

  // Toggle debug
  const toggleDebug = useCallback(()=>{
    setG(prev=>({...prev, showDebug:!prev.showDebug}));
  },[]);

  // Derived values
  const phase   = phaseOf(G.step);
  const fearVal = cl(G.fear + (G.intimDelta<0 ? -G.intimDelta : 0), 0, 100);
  const hasCont = !!CONT[G.step];

  // ── Render ──────────────────────────────────────────────────────
  return (
    <div style={S.app}>
      <style>{CSS}</style>

      {/* ── Header ──────────────────────────────────────────── */}
      <div style={S.header}>
        <h1 style={S.title}>⛵ TIDELINES ⛵</h1>
        <div style={S.subtitle}>Cedar, Sea &amp; Legacy — Vertical Slice</div>
      </div>

      {/* ── Phase pips ──────────────────────────────────────── */}
      <div style={S.phaseLabels}>
        {PHASES.map(p=><span key={p} style={S.phaseLabelItem}>{p}</span>)}
      </div>
      <div style={S.phasePips}>
        {PHASES.map((_,i)=>(
          <div key={i} style={{
            ...S.pip,
            background: i<phase?P.green : i===phase?P.gold : P.panelHi,
          }}/>
        ))}
      </div>

      {/* ── Stats row ───────────────────────────────────────── */}
      <div style={S.statsRow}>
        <StatBar label="♥ Morale" value={G.morale} max={100} color={P.green}/>
        <StatBar label="😨 Fear"  value={fearVal}  max={100} color={P.red}/>
        <StatBar label="🛶 Canoe" value={G.canoeCondition} max={100} color={P.blue}/>
        <StatBar label="📦 Cargo" value={G.cargo}  max={G.cargoCapacity} color={P.gold}/>
        <StatBar label="⭐ Prestige" value={G.prestige} max={500} color={P.gold}/>
        <StatBar label="🔥 Feud"  value={G.feudEscalation} max={20} color={P.cedar}/>
        <StatBar label="⚔ Crew"  value={`${G.crewAlive}/${G.crewSize}`} noBar/>
      </div>

      {/* ── Pixel scene ─────────────────────────────────────── */}
      <Scene type={G.scene}/>

      {/* ── Narrative log ───────────────────────────────────── */}
      <div className="tl-log" style={S.narrativeLog} ref={logRef}>
        {G.log.map((l,i)=>(
          <div key={i} style={{marginBottom:4, color:narrColor(l.c), minHeight:l.t?undefined:8}}>{l.t}</div>
        ))}
      </div>

      {/* ── Choices / Continue ──────────────────────────────── */}
      <div style={{marginBottom:8}}>

        {/* Village: Intel */}
        {G.step==='vil_intel' && <>
          <div style={S.prompt}>How will you gather intelligence?</div>
          <ChoiceBtn label="🔭 Send Scouts" desc="Best intel quality. Costs time, risks detection." risk="15% detection chance" onClick={()=>act(pickIntel,'scouts')}/>
          <ChoiceBtn label="🗣 Ask Traders" desc="Free information but may be outdated." onClick={()=>act(pickIntel,'traders')}/>
          <ChoiceBtn label="🔮 Read the Omens" desc="Mystical insight. Unpredictable quality." onClick={()=>act(pickIntel,'omens')}/>
        </>}

        {/* Village: Prep */}
        {G.step==='vil_prep' && <>
          <div style={S.prompt}>Final preparations:</div>
          <ChoiceBtn label="🎨 Full War Paint & Crest Display" desc="+10 intimidation, +5 morale. The enemy will see who is coming." onClick={()=>act(pickPrep,'war_paint')}/>
          <ChoiceBtn label="🧺 Load Extra Supplies" desc="More cargo space and +10 canoe condition for the journey." onClick={()=>act(pickPrep,'extra_supplies')}/>
          <ChoiceBtn label="🙏 Seek Spiritual Blessing" desc="+8 morale, +5 surprise. The spirits guide your paddles." onClick={()=>act(pickPrep,'blessing')}/>
        </>}

        {/* Travel: Arrival */}
        {G.step==='trv_arrival' && <>
          <div style={S.prompt}>When will you arrive?</div>
          <ChoiceBtn label="🌅 Dawn Arrival" desc="+15 surprise. Good visibility. Strike as the village wakes." onClick={()=>act(pickArrival,'dawn')}/>
          <ChoiceBtn label="🌙 Night Approach" desc="+25 surprise but high navigation risk." risk="20% chance of canoe scrape" onClick={()=>act(pickArrival,'night')}/>
          <ChoiceBtn label="🌫 Use the Morning Fog" desc="+20 surprise, medium risk. Slide through like spirits." onClick={()=>act(pickArrival,'fog')}/>
        </>}

        {/* Travel: Formation */}
        {G.step==='trv_form' && <>
          <div style={S.prompt}>How does your force approach?</div>
          <ChoiceBtn label="🤫 Single Canoe, Tight and Quiet" desc="+10 stealth. One canoe, one chance." onClick={()=>act(pickFormation,'stealth')}/>
          <ChoiceBtn label="⚔ Spread Formation — Maximum Intimidation" desc="+15 intimidation but -10 stealth." onClick={()=>act(pickFormation,'intimidating')}/>
        </>}

        {/* Encounter: Tactic */}
        {G.step==='enc_tactic' && <>
          <div style={S.prompt}>Choose your tactic:</div>
          <ChoiceBtn label="⚔ Overwhelming Assault" desc="Maximum force. ATK ×1.3 but losses ×1.5." risk="Very high casualties if you lose" onClick={()=>act(pickTactic,'overwhelming')}/>
          <ChoiceBtn label="🛡 Measured Push" desc="Balanced risk. ATK ×1.1, losses ×1.0." onClick={()=>act(pickTactic,'measured')}/>
          <ChoiceBtn label="👁 Feint & Probe" desc="Low risk. ATK ×0.8 but losses only ×0.6." onClick={()=>act(pickTactic,'feint')}/>
          <ChoiceBtn label="🕊 Negotiate Under Arms" desc="Minimal combat. ATK ×0.4 but losses only ×0.1." onClick={()=>act(pickTactic,'negotiate')}/>
        </>}

        {/* Withdrawal: Choices */}
        {G.step==='wth_choose' && <>
          <div style={S.prompt}>How will you withdraw?</div>
          <ChoiceBtn label="💨 Quick Load & Go" desc="Safest. Take 60% of spoils. No pursuit risk." onClick={()=>act(pickWithdrawal,'quick')}/>
          <ChoiceBtn label="📦 Take Everything" desc="Max spoils but 30% pursuit risk." risk="30% counterattack chance" onClick={()=>act(pickWithdrawal,'thorough')}/>
          <ChoiceBtn label="🦅 Take Spoils & Plant Your Crest" desc="+10 prestige, +3 feud escalation. Maximum humiliation." onClick={()=>act(pickWithdrawal,'mark')}/>
        </>}

        {/* Aftermath: Raid Again */}
        {G.step==='aft_show' && <>
          <ChoiceBtn label="🔄 Raid Again" desc="Reset and launch another expedition." onClick={onReset}/>
        </>}

        {/* Continue button */}
        {hasCont && <ContinueBtn onClick={onContinue}/>}
      </div>

      {/* ── Debug toggle ────────────────────────────────────── */}
      <div style={{textAlign:'right',marginBottom:4}}>
        <span style={{fontSize:7,color:P.dim,cursor:'pointer'}} onClick={toggleDebug}>☰ DEBUG</span>
      </div>

      {/* ── Debug panel ─────────────────────────────────────── */}
      {G.showDebug && (
        <div style={S.debugPanel}>
          <span style={{color:P.gold}}>Phase:</span> {PHASES[phase]||'—'}<br/>
          <span style={{color:P.gold}}>── Forces ──</span><br/>
          ATK morale: {G.morale}  DEF morale: {G.defender.morale}<br/>
          Crew: {G.crewAlive}/{G.crewSize}  DEF crew: {G.defender.crewSize}<br/>
          <span style={{color:P.gold}}>── Modifiers ──</span><br/>
          Intel: {G.intelQuality}  Surprise: {G.surpriseBonus}  Stealth: {G.stealthBonus}<br/>
          Intim bonus: {G.intimidationBonus}  Approach: {G.approachTime}  Form: {G.formation}<br/>
          <span style={{color:P.gold}}>── Intimidation ──</span><br/>
          Score: {G.intimScore}  Resolve: {G.resolveScore}  Δ: {G.intimDelta}  Result: {G.intimResult||'—'}<br/>
          <span style={{color:P.gold}}>── Engagement ──</span><br/>
          Tactic: {G.attackerTactic}  Outcome: {G.outcome||'—'}<br/>
          ATK: {G.atkTotal.toFixed(1)}  DEF: {G.defTotal.toFixed(1)}  Ratio: {G.outcomeRatio.toFixed(2)}<br/>
          {G.rounds.map((r,i)=>(
            <span key={i}>R{i+1}: ATK {r.atk.toFixed(1)} DEF {r.def.toFixed(1)}{r.event?` ✦${r.event.id}`:''}<br/></span>
          ))}
          <span style={{color:P.gold}}>── Aftermath ──</span><br/>
          Killed: {G.crewKilled}  Wounded: {G.crewWounded}  Cargo: {G.cargo}<br/>
          Prestige Δ: {G.prestigeChange}  Feud: {G.feudEscalation} ({feudName(G.feudEscalation)})<br/>
          Traits: {G.traitsEarned.join(', ')||'—'}<br/>
          Canoe: {G.canoeCondition}%  TP: {G.turningPoint?G.turningPoint.id:'—'}
        </div>
      )}

      {/* ── Legacy log ──────────────────────────────────────── */}
      <div style={S.legacyTitle}>📜 LEGACY LOG</div>
      <div style={S.legacyPanel}>
        {G.legacyEntries.length===0
          ? <span style={{color:P.dim}}>No entries yet. Complete a raid to record history.</span>
          : G.legacyEntries.map((e,i)=>(
            <div key={i} style={{marginBottom:6}}>
              <span style={{color:P.gold}}>Entry {i+1}:</span><br/>{e}
            </div>
          ))
        }
      </div>
    </div>
  );
}


// ═════════════════════════════════════════════════════════════════════
//  INLINE STYLE OBJECTS
// ═════════════════════════════════════════════════════════════════════
const font = "'Press Start 2P', monospace";

const S = {
  app:{
    maxWidth:960, margin:'0 auto', padding:8,
    fontFamily:font, fontSize:10, lineHeight:1.6,
    color:P.text, background:P.bg, minHeight:'100vh',
  },
  header:{
    textAlign:'center', padding:'12px 0 6px',
    borderBottom:`2px solid ${P.gold}`, marginBottom:8,
  },
  title:{ fontSize:14, color:P.gold, letterSpacing:2, margin:0 },
  subtitle:{ fontSize:8, color:P.dim, marginTop:4 },

  // Phase indicator
  phaseLabels:{ display:'flex', gap:3, marginBottom:4, fontSize:6, color:P.dim },
  phaseLabelItem:{ flex:1, textAlign:'center' },
  phasePips:{ display:'flex', gap:3, marginBottom:8 },
  pip:{ flex:1, height:6, borderRadius:3, transition:'background 0.3s' },

  // Stats
  statsRow:{
    display:'flex', flexWrap:'wrap', gap:6, marginBottom:8,
    padding:6, background:P.panel, border:`1px solid ${P.border}`, borderRadius:4,
  },
  statBox:{
    flex:'1 1 120px', background:P.panelHi,
    border:`1px solid ${P.border}`, borderRadius:3,
    padding:'4px 6px', minWidth:100,
  },
  statLabel:{ fontSize:7, color:P.dim, textTransform:'uppercase' },
  statValue:{ fontSize:11, marginTop:2 },
  statTrack:{
    height:6, background:'#1a1a2a', borderRadius:3, marginTop:3, overflow:'hidden',
  },
  statFill:{ height:'100%', borderRadius:3, transition:'width 0.4s ease' },

  // Scene
  scene:{
    height:80, background:'#06061a', border:`1px solid ${P.border}`,
    borderRadius:3, marginBottom:8, display:'flex',
    alignItems:'flex-end', justifyContent:'center', gap:4,
    padding:8, position:'relative', overflow:'hidden',
  },
  water:{
    position:'absolute', bottom:0, left:0, right:0, height:20,
    background:'linear-gradient(180deg,#0a2040 0%,#061830 100%)',
  },
  land:{
    position:'absolute', bottom:18, right:0, width:'40%', height:30,
    background:'#1a3a18', borderRadius:'8px 8px 0 0',
  },
  canoe:{
    position:'relative', zIndex:2, width:60, height:16,
    background:P.cedar, borderRadius:'0 8px 4px 0',
    border:'1px solid #5a1a00', display:'flex', alignItems:'center',
  },
  canoeProw:{ position:'absolute', left:-4, top:-2, fontSize:14, color:P.gold },
  hut:{
    position:'relative', zIndex:2, width:30, height:30,
    background:'#3a2a18', border:'1px solid #5a3a18', borderRadius:2,
    display:'inline-block', marginLeft:4,
  },
  hutRoof:{ position:'absolute', top:-10, left:6, fontSize:14, color:'#5a3a18' },

  // Narrative log
  narrativeLog:{
    maxHeight:200, overflowY:'auto', padding:6,
    background:P.darkBg, border:`1px solid ${P.border}`,
    borderRadius:3, marginBottom:8, fontFamily:font, fontSize:9, lineHeight:1.7,
  },

  // Choices
  prompt:{ fontSize:9, color:P.dim, marginBottom:6 },
  choiceBtn:{
    display:'block', width:'100%', textAlign:'left',
    background:P.teal, color:P.text,
    border:`1px solid ${P.border}`, borderRadius:3,
    padding:'8px 10px', marginBottom:5, fontFamily:font,
    fontSize:9, cursor:'pointer', lineHeight:1.5,
    transition:'background 0.15s',
  },
  actionBtn:{
    display:'inline-block', background:P.cedar, color:P.text,
    border:`1px solid ${P.gold}`, borderRadius:3,
    padding:'8px 18px', fontFamily:font, fontSize:10,
    cursor:'pointer', marginTop:6, transition:'background 0.15s',
  },

  // Debug
  debugPanel:{
    background:P.debugBg, border:'1px solid #1a3a1a', borderRadius:4,
    padding:8, marginBottom:8, fontSize:8, color:P.green,
    maxHeight:220, overflowY:'auto', lineHeight:1.8,
  },

  // Legacy
  legacyTitle:{
    fontSize:8, color:P.gold, borderBottom:`1px solid ${P.border}`,
    paddingBottom:4, marginBottom:4,
  },
  legacyPanel:{
    background:P.legacyBg, border:'1px solid #3a2a10', borderRadius:4,
    padding:8, marginBottom:8, fontSize:8, color:P.text,
    maxHeight:140, overflowY:'auto',
  },
};
