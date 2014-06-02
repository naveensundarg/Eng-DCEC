abstract DCEC = {

  flags startcat = Utterance ;
	
  cat  Agent; ActionType1; ActionType2; Event; Moment; Boolean; Fluent;Utterance;
         Dom; 
  fun
    
    -- Top 
    s : Boolean -> Utterance;
    -- Logic
     and : Utterance -> Utterance -> Utterance; 
     if : Utterance -> Utterance -> Utterance; 
     or : Utterance -> Utterance -> Utterance; 
     not: Boolean -> Boolean;
     forall : Agent -> Dom -> Boolean -> Boolean;
     all : Agent -> Dom -> Utterance -> Utterance;
      -- Modalities
    p: Agent -> Moment -> Utterance -> Boolean;
    k: Agent -> Moment -> Utterance -> Boolean;
    b: Agent -> Moment -> Utterance -> Boolean;
    s1: Agent -> Moment -> Utterance -> Boolean;
    d: Agent -> Moment -> Utterance -> Boolean;
    i1now: Agent -> Moment -> ActionType1 -> Boolean;
    i1later: Agent -> Moment -> ActionType1 -> Boolean;
    i2now: Agent -> Moment -> ActionType2 -> Boolean;
    i2later: Agent -> Moment -> ActionType2 -> Boolean;

    --I2: Agent -> Moment -> ActionType2 -> Moment -> Boolean;
    -- Event Calculus
    action1 : Agent -> ActionType1 -> Event ;
    action2 : Agent -> ActionType2 -> Event ;
    
    action1c : Agent -> ActionType1 -> Event ;
    action2c : Agent -> ActionType2 -> Event ;
    initially: Fluent -> Boolean;	
    happens : Event -> Moment -> Boolean;
    holds : Fluent -> Moment -> Boolean;

    --- *** Domain Specific ***
    --- TODO: Modularize Specific Domains
    -- Agents, ActionTypes, Moments and Fluents
    --- Agents
    i, you : Agent ;
    he , she : Agent -> Agent;
    --- Moments
    now,tf,tp: Moment;
    
    agent : Dom;

    x,y,z : Agent -> Agent;
 

   }
      