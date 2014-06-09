concrete EngExt of DCECExt = Eng ** open  SyntaxEng, ConstructorsEng, ParadigmsEng in {

      --- *** Domain Specific ***
    lin
    
    jack   = {descr = (mkNP (mkN human (mkN "named Jack"))); name = (mkNP (mkN human (mkN "Jack"))) } ;
    cogito = {descr = (mkNP (mkN "named Cogito")); name = (mkNP (mkN "Cogito")) };

    robot_n = {descr = (mkNP (mkN "named N")); name = (mkNP (mkN "N")) };
    robot_s = {descr = (mkNP (mkN "named S")); name = (mkNP (mkN "S")) };

    
    robot1   = {descr = (mkNP (mkN "named Robot 1")); name = (mkNP (mkN "Robot 1")) } ;
    robot2 = {descr = (mkNP (mkN "named Robot 2")); name = (mkNP (mkN "Robot 2")) };
    robot3 = {descr = (mkNP (mkN "named Robot 3")); name = (mkNP (mkN "Robot 3")) };




    -- Unary ActionTypes
    laugh = (mkV "laugh" "laughed" "laughed");
    sleep = (mkV "sleep" "slept" "slept");
    eat = (mkV "eat" "ate" "eaten");
   -- die= die_V;
    -- Binary ActionTypes
    hurt2 a= {verb = (mkV2 (mkV "hurt" "hurt" "hurt")); arg = a.name};
    guard2 a= {verb = (mkV2 (mkV "guard")); arg =  a.name};
    harm2 a= {verb = (mkV2 (mkV "harm")); arg =  a.name};
    disable2 a= {verb = (mkV2 (mkV "disable")); arg =  a.name};
    destroy2 a= {verb = (mkV2 (mkV "destroy")); arg =  a.name};
    injure2 a= {verb = (mkV2 (mkV "injure")); arg =  a.name};

    shoot2 a= {verb = (mkV2 (mkV "shoot" "shot" "shot")); arg =  a.name};

   -- refrain3 act agent = {verb1 =  (mkV2 "refrain") ; arg=agent.name; verb2= act.verb};
    
    raining = (mkCl (mkVP (mkV "rain")));
    snowing = (mkCl (mkVP (mkV "snow")));

    hungry agent = (mkCl agent.name  (mkAP (mkA "hungry"))) ;
    tired agent = (mkCl agent.name  (mkAP (mkA "tired"))) ;
    sick agent = (mkCl agent.name  (mkAP (mkA "sick"))) ;
    sad agent = (mkCl agent.name  (mkAP (mkA "sad"))) ;
    happy agent = (mkCl agent.name  (mkAP (mkA "happy"))) ;
    angry agent = (mkCl agent.name (mkAP (mkA "angry"))) ;


    laugh_f agent = (activity agent (mkV "laugh"));
    run_f agent = (activity agent (mkV "run" "ran" "run"));
    sleep_f agent= (activity agent (mkV "sleep" "slept" "slept"));
    eat_f agent= (activity agent (mkV "eat" "ate" "eaten"));
    oper
     activity: {descr:NP; name: NP} -> V -> Cl = 
	  \agent,verb -> (mkCl agent.name (progressiveVP (mkVP verb)));
}