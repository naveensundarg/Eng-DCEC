abstract DCEC = {

  flags startcat = Utterance ;
	
  cat  Agent; ActionType1; ActionType2; Event; Moment; Boolean; Fluent;Utterance;
      
  fun
    
    -- Top 
    reify : Boolean -> Utterance;
    -- Logic
     and : Utterance -> Utterance -> Utterance; 
     if : Utterance -> Utterance -> Utterance; 
     or : Utterance -> Utterance -> Utterance; 
     not: Boolean -> Boolean;
    -- Modalities
    p: Agent -> Moment -> Boolean -> Boolean;
    k: Agent -> Moment -> Boolean -> Boolean;
    b: Agent -> Moment -> Boolean -> Boolean;
    s1: Agent -> Moment -> Boolean -> Boolean;
    d: Agent -> Moment -> Boolean -> Boolean;
    i1now: Agent -> Moment -> ActionType1 -> Boolean;
    i1later: Agent -> Moment -> ActionType1 -> Boolean;

    --I2: Agent -> Moment -> ActionType2 -> Moment -> Boolean;
    -- Event Calculus
    

    action1 : Agent -> ActionType1 -> Event ;
    action2 : Agent -> ActionType2 -> Event ;
    
    initially: Fluent -> Boolean;	
    happens : Event -> Moment -> Boolean;
    holds : Fluent -> Moment -> Boolean;

    --- *** Domain Specific ***
    --- TODO: Modularize Specific Domains
    -- Agents, ActionTypes, Moments and Fluents
    --- Agents
    i, you : Agent ;
    jack, cogito  : Agent ;
    he , she : Agent -> Agent;

    --- ActionTypes
    laugh, die, sleep,eat  : ActionType1 ;
   
    hurt2, guard2, harm2, disable2 : Agent-> ActionType2;
    
    --- Moments
    now,tf,tp: Moment;
    
    --- Fluents
    raining, snowing : Fluent;
    hungry,tired, sick,sad,happy,angry: Agent->Fluent;
    
   }
      