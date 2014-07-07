abstract DCEC =  {

  flags startcat = Utterance;
	
  cat  Agent; ActionType; Event; Moment; Boolean; Fluent;Sentence;
        Class; Dom; Entity; Object; Query;Utterance;
  fun
    
    -- Top 
    u1 : Sentence -> Utterance;
    u2 : Boolean -> Sentence;
    justify: Boolean -> Utterance;
    -- Logic
     and : Sentence -> Sentence -> Sentence; 
     and_seq: Sentence -> Sentence -> Sentence;
     ss : Boolean -> Boolean -> Sentence; 
     if : Sentence -> Sentence -> Sentence; 
     or : Sentence -> Sentence -> Sentence; 
     not: Boolean -> Boolean;
     forall : Agent -> Dom -> Boolean -> Boolean;
     all : Agent -> Dom -> Sentence -> Sentence;
      -- Modalities
    p: Agent -> Moment -> Sentence -> Boolean;
    k: Agent -> Moment -> Sentence -> Boolean;
    b: Agent -> Moment -> Sentence -> Boolean;
    s1: Agent -> Moment -> Sentence -> Boolean;
    d: Agent -> Moment -> Sentence -> Boolean;
    inow: Agent -> Moment -> ActionType -> Boolean;
    ilater: Agent -> Moment -> ActionType -> Boolean;
    ought: Agent -> Moment -> Sentence -> ActionType -> Sentence;
    ought_refrain: Agent -> Moment -> Sentence -> ActionType -> Sentence;
	
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
    
    the, a : Class -> Object;

   }
      