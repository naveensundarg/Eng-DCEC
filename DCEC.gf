abstract DCEC = {

  flags startcat = Boolean ;
	
  cat  Agent; ActionType1; ActionType2; Event; Moment; Boolean; Fluent;
      
  fun

    -- Logic
    and : Boolean -> Boolean -> Boolean; 
    if : Boolean -> Boolean -> Boolean; 
    or : Boolean -> Boolean -> Boolean; 
    
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
    i, he , she, you : Agent ;
    jack, cogito  : Agent ;
    
    --- ActionTypes
    laugh, die, sleep,eat  : ActionType1 ;
   
    hurt2, guard2, harm2, disable2 : Agent-> ActionType2;
    
    --- Moments
    now,tf,tp: Moment;
    
    --- Fluents
    raining, snowing : Fluent;
    hungry,tired, sick,sad,happy,angry: Agent->Fluent;
    
   }
      