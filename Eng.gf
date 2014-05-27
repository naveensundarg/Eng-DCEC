concrete Eng of DCEC = open SyntaxEng, StructuralEng, ConstructorsEng, ParadigmsEng in {

  lincat Agent = NP;
	 ActionType1 = V;
	 ActionType2 = {verb : V2; arg : NP};
	 Event = Cl;
	 Boolean = S;
	 Moment = Tense;
	 Fluent = Cl;

  lin
    -- Logic
    and x y = (mkS and_Conj (mkListS x y));
    or x y = (mkS or_Conj (mkListS x y));
    if x y = (mkS if_then_Conj (mkListS x y));

    -- Modalities
    P a t F  = (mkS t (mkCl a (mkVP 
				 (mkVP (mkV "see"))
				 (ConstructorsEng.mkAdv that_Subj F))));
	
    K a t F  = (mkS t (mkCl a (mkVP 
				 (mkVP (mkV "know"))
				 (ConstructorsEng.mkAdv that_Subj F))));

    B a t F  = (mkS t (mkCl a (mkVP 
				 (mkVP (mkV "believe"))
				 (ConstructorsEng.mkAdv that_Subj F))));
    
    S1 a t F  = (mkS t (mkCl a (mkVP 
				 (mkVP (mkV "declare"))
				 (ConstructorsEng.mkAdv that_Subj F))));

    D a t F  = (mkS t (mkCl a (mkVP 
				 (mkVP (mkV "desire"))
				 (ConstructorsEng.mkAdv that_Subj F))));
	


    happens event moment = (mkS moment event);

    -- initially
    --- mkCl:	SC -> VP -> Cl	
    initially fluent = (mkS presentTense
			  (mkCl (mkSC (mkS fluent)) 
			     (mkVP 
				(mkVP (mkV "hold")) 
				(ConstructorsEng.mkAdv (mkA "initial")))));

     --action
    action1 agent actiontype = (mkCl agent actiontype)  ;
    action2 agent actiontype = (mkCl agent actiontype.verb actiontype.arg)  ;
    

  --- *** Domain Specific ***
  --- TODO: Modularize Specific Domains  

    -- Agents
    jack   = (mkNP (mkPN "Jack")) ;
    cogito = (mkNP (mkPN "Cogito"));

    -- Unary ActionTypes
    sleep1 = (mkV "sleep" "slept" "slept");


    -- Binary ActionTypes
    hurt2 a= {verb = (mkV2 (mkV "hurt" "hurt" "hurt")); arg = a};
    guard2 a= {verb = (mkV2 (mkV "guard")); arg = a};

    now = presentTense;
    tf = futureTense;
    tp = pastTense;
    
    raining = (mkCl (mkVP (mkV "rain")));
    snowing = (mkCl (mkVP (mkV "snow")));

    hungry agent = (mkCl agent (mkAP (mkA "hungry"))) ;
    tired agent = (mkCl agent (mkAP (mkA "tired"))) ;
    sick agent = (mkCl agent (mkAP (mkA "sick"))) ;
    sad agent = (mkCl agent (mkAP (mkA "sad"))) ;
    happy agent = (mkCl agent (mkAP (mkA "happy"))) ;
    angry agent = (mkCl agent (mkAP (mkA "angry"))) ;
	
    
}