abstract DCECExt = DCEC ** { 
  
  
  fun 
    -- Agents
    jack, cogito  : Agent ;

    --- ActionTypes
    laugh, die, sleep,eat  : ActionType1 ;
   
    hurt2, guard2, harm2, disable2 : Agent-> ActionType2;
    
    --- Fluents
    raining, snowing : Fluent;
    hungry,tired, sick,sad,happy,angry: Agent->Fluent;


}