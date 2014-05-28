concrete Form of DCEC = {


	
  lincat  Boolean = Str;
      
  lin

    -- Logic
    and  x y = "(" ++ "and" ++ x ++ y ")"; 
    if x y = "(" ++ "and" ++ x ++ y ")"; 
    or : Boolean -> Boolean -> Boolean; 
    
    -- Modalities
    P: Agent -> Moment -> Boolean -> Boolean;
    K: Agent -> Moment -> Boolean -> Boolean;
    B: Agent -> Moment -> Boolean -> Boolean;
    S1: Agent -> Moment -> Boolean -> Boolean;
    D: Agent -> Moment -> Boolean -> Boolean;
    I1now: Agent -> Moment -> ActionType1 -> Boolean;
    I1later: Agent -> Moment -> ActionType1 -> Boolean;
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
    jack, cogito  : Agent ;
    
    --- ActionTypes
    sleep1 : ActionType1 ;
    hurt2, guard2 : Agent-> ActionType2;
    
    --- Moments
    now,tf,tp: Moment;
    
    --- Fluents
    raining, snowing : Fluent;
    hungry,tired, sick,sad,happy,angry: Agent->Fluent;
    
   }
      