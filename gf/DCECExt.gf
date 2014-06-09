abstract DCECExt = DCEC  ** { 
  
  
  fun 
    -- Agents
    jack, cogito, robot1, robot2, robot3, robot_n, robot_s  : Agent ;

    --- ActionTypes
    laugh, sleep, eat, die  : ActionType1 ;
   
    hurt2, guard2, harm2, disable2, destroy2, shoot2, injure2 : Agent-> ActionType2;

    refrain3 :  ActionType2-> Agent->ActionType3;

    
    --- Fluents
    raining, snowing : Fluent;
    hungry,tired, sick,sad,happy,angry: Agent->Fluent;
    laugh_f, run_f, sleep_f, eat_f, die_f: Agent->Fluent;


}