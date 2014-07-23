concrete EngExt of DCECExt = Eng ** open  SyntaxEng, ConstructorsEng, ParadigmsEng in {

      --  *** Domain Specific ***
    lin

    -- Agents and their descriptions
    
    jack   = {descr = (mkNP (mkN human (mkN "named Jack"))); name = (mkNP (mkPN "Jack")) ; gender= masculine} ;
    cogito = {descr = (mkNP (mkN "named Cogito")); name = (mkNP (mkPN "Cogito")); gender= masculine };
    
    robot_n = {descr = (mkNP (mkN "named N")); name = (mkNP (mkN "N")); gender= masculine};
    robot_s = {descr = (mkNP (mkN "named S")); name = (mkNP (mkN "S")); gender= masculine };

    
    robot1   = {descr = (mkNP (mkN "named Robot 1")); name = (mkNP (mkN "Robot 1")) ; gender= masculine} ;
    robot2 = {descr = (mkNP (mkN "named Robot 2")); name = (mkNP (mkN "Robot 2")) ; gender= masculine};
    robot3 = {descr = (mkNP (mkN "named Robot 3")); name = (mkNP (mkN "Robot 3")) ; gender= masculine};

    ibm = {descr = (mkNP (mkN "entity named IBM")); name = (mkNP (mkPN "IBM")); gender= masculine };


    -- classes
    apple = {name = (mkN "apple"); indef = (mkN "an apple")};
    book = {name =  (mkN "book"); indef = (mkN "a book")};

    -- Unary ActionTypes
    laugh = (unaryAction (mkV "laugh" "laughed" "laughed"));
    sleep = (unaryAction (mkV "sleep" "slept" "slept"));
    eat = (unaryAction (mkV "eat" "ate" "eaten"));
    run = (unaryAction (mkV "run" "ran" "run"));

    -- Binary ActionTypes
    hurt a= (binaryAction (mkV "hurt" "hurt" "hurt") a);
    guard a= (binaryAction (mkV "guard") a);
    kick a= (binaryAction (mkV "kick") a);
    harm a= (binaryAction (mkV "harm") a);
    disable a= (binaryAction (mkV "disable") a);
    destroy a= (binaryAction (mkV "destroy") a);
    injure a= (binaryAction (mkV "injure") a);
    shoot a= (binaryAction (mkV "shoot" "shot" "shot") a);
    eat2 obj = (binaryAction (mkV "eat" "ate" "eaten") obj);
    read2 obj = (binaryAction (mkV "read" "read" "read") obj);

    acquire obj = (binaryAction (mkV "acquire") obj);

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
    
    custody a1 a2 =binaryFluent a1 a2 (mkV2 "guard");

    continuous agent action = (mkCl agent.name (progressiveVP action));
    oper
     activityFluent: {descr:NP; name: NP; gender: Gender} -> V -> Cl = 
	  \agent,verb -> (mkCl agent.name (progressiveVP (mkVP verb)));
     
     nullaryFluent: V -> Cl = \verb -> (mkCl (mkVP verb));
     
     unaryFluent: EntityLinType -> AP-> Cl = \agent, ap -> (mkCl agent.name ap);
     binaryFluent: EntityLinType -> EntityLinType-> V2-> Cl = \agent1, agent2,v -> (mkCl agent1.name (progressiveVP (mkVP v agent2.name)));


     
     unaryAction: V -> VP = 
       \verb -> (mkVP verb);

     binaryAction: V->EntityLinType -> VP = 
       \verb, entity -> (mkVP (mkV2 verb)entity.name) | (reflexiveVP (mkV2 verb));
}