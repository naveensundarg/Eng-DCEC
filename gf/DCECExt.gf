abstract DCECExt = DCEC ** { 
  
  
  fun 
    -- Agents
    jack, cogito, robot1, robot2, robot3  : Agent ;

    --- ActionTypes
    laugh, die, sleep,eat  : ActionType1 ;
   
    hurt2, guard2, harm2, disable2, destroy2, shoot2 : Agent-> ActionType2;
    
    --- Fluents
    raining, snowing : Fluent;
    hungry,tired, sick,sad,happy,angry: Agent->Fluent;


}