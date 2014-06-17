abstract DCEC =  {

  flags startcat = Utterance ;
	
  cat  Agent; ActionType; Event; Moment; Boolean; Fluent;Utterance;
         Dom; 
  fun
    
    -- Top 
    s : Boolean -> Utterance;
    -- Logic
     and : Utterance -> Utterance -> Utterance; 
     and_seq: Utterance -> Utterance -> Utterance;
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
    inow: Agent -> Moment -> ActionType -> Boolean;
    ilater: Agent -> Moment -> ActionType -> Boolean;
    
    -- Event Calculus
    action : Agent -> ActionType-> Event ;
    
    initially: Fluent -> Boolean;	
    happens : Event -> Moment -> Boolean;
    happensp : Event -> Moment -> Boolean;
    holds : Fluent -> Moment -> Boolean;

    --- *** Domain Specific ***
    --- TODO: Modularize Specific Domains
    -- Agents, ActionTypes, Moments and Fluents
    --- Agents
  --  self :  Agent-> Agent; 
    i, you : Agent ;
   -- he , she : Agent -> Agent;
    he, she,it : Agent -> Agent;


    --- Moments
    now,tf,tp: Moment;
    
    agent : Dom;

    x,y,z : Agent -> Agent;
 

   }
      