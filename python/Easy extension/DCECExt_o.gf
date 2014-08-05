abstract DCECExt = DCEC  ** { 
  
  
  fun 
    -- Agents
    jack, cogito, robot1, robot2, robot3, robot_n, robot_s  : Agent ;

    --- ActionTypes
    laugh, sleep, run, eat, die  : ActionType;
   
    hurt, guard, harm, disable, destroy, shoot, injure,kick : Agent-> ActionType;

    eat2,read2 : Object-> ActionType;

--    refrain3 :  ActionType2-> Agent->ActionType3;

    
    --- Fluents
    raining, snowing : Fluent;
    hungry,tired, sick,sad,happy,angry: Agent->Fluent;
    laugh_f, run_f, sleep_f, eat_f, die_f: Agent->Fluent;
    custody: Agent->Agent->Fluent;

    continuous: Agent->ActionType->Fluent;

    -- Objects
    apple, book : Class;



}
