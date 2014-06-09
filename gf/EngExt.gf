concrete EngExt of DCECExt = Eng ** open  SyntaxEng, ConstructorsEng, ParadigmsEng in {

      --- *** Domain Specific ***
    lin

    -- Agents and their descriptions
    
    jack   = {descr = (mkNP (mkN human (mkN "named Jack"))); name = (mkNP (mkN human (mkN "Jack"))) } ;
    cogito = {descr = (mkNP (mkN "named Cogito")); name = (mkNP (mkN "Cogito")) };

    robot_n = {descr = (mkNP (mkN "named N")); name = (mkNP (mkN "N")) };
    robot_s = {descr = (mkNP (mkN "named S")); name = (mkNP (mkN "S")) };

    
    robot1   = {descr = (mkNP (mkN "named Robot 1")); name = (mkNP (mkN "Robot 1")) } ;
    robot2 = {descr = (mkNP (mkN "named Robot 2")); name = (mkNP (mkN "Robot 2")) };
    robot3 = {descr = (mkNP (mkN "named Robot 3")); name = (mkNP (mkN "Robot 3")) };



    -- Unary ActionTypes
    laugh = (unaryAction (mkV "laugh" "laughed" "laughed"));
    sleep = (unaryAction (mkV "sleep" "slept" "slept"));
    eat = (unaryAction (mkV "eat" "ate" "eaten"));
    run = (unaryAction (mkV "run" "ran" "run"));

    -- Binary ActionTypes
    hurt a= (binaryAction (mkV "hurt" "hurt" "hurt") a);
    guard a= (binaryAction (mkV "guard") a);
    harm a= (binaryAction (mkV "harm") a);
    disable a= (binaryAction (mkV "disable") a);
    destroy a= (binaryAction (mkV "destroy") a);
    injure a= (binaryAction (mkV "injure") a);
    shoot a= (binaryAction (mkV "shoot" "shot" "shot") a);

   -- refrain3 act agent = {verb1 =  (mkV2 "refrain") ; arg=agent.name; verb2= act.verb};
    
    raining = (nullaryFluent (mkV "rain"));
    snowing = (nullaryFluent (mkV "snow"));

    hungry agent = (unaryFluent agent  (mkAP (mkA "hungry"))) ;
    tired agent = (unaryFluent agent  (mkAP (mkA "tired"))) ;
    sick agent = (unaryFluent agent  (mkAP (mkA "sick"))) ;
    sad agent = (unaryFluent agent  (mkAP (mkA "sad"))) ;
    happy agent = (unaryFluent agent  (mkAP (mkA "happy"))) ;
    angry agent = (unaryFluent agent (mkAP (mkA "angry"))) ;


    laugh_f agent = (activityFluent agent (mkV "laugh"));
    run_f agent = (activityFluent agent (mkV "run" "ran" "run"));
    sleep_f agent= (activityFluent agent (mkV "sleep" "slept" "slept"));
    eat_f agent= (activityFluent agent (mkV "eat" "ate" "eaten"));
    
    oper
     activityFluent: {descr:NP; name: NP} -> V -> Cl = 
	  \agent,verb -> (mkCl agent.name (progressiveVP (mkVP verb)));
     
     nullaryFluent: V -> Cl = \verb -> (mkCl (mkVP verb));
     
     unaryFluent: {descr:NP; name: NP} -> AP-> Cl = \agent, ap -> (mkCl agent.name ap);

     unaryAction: V -> VP = 
       \verb -> (mkVP verb);

     binaryAction: V->{descr:NP; name: NP} -> VP = 
       \verb, agent -> (mkVP (mkV2 verb) agent.name);
}