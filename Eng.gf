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
    P a t F  = (modal1 (mkV "see" "saw" "saw") a t F);    

    K a t F  = (modal1 (mkV "know" "know" "knew") a t F);

    B a t F  = (modal1 (mkV "believe") a t F);
    
    S1 a t F = (modal1 (mkV "declare") a t F);


    D a t F  = (modal1 (mkV "desire") a t F);
     I1now a t1 Act  = (mkS t1 (mkCl a want_VV  (mkVP (mkVP Act) (ParadigmsEng.mkAdv "now"))));

    I1later a t1 Act = (mkS t1 (mkCl a want_VV  
				  (mkVP 
				     (mkVP Act) 
				     (ConstructorsEng.mkAdv (mkA "eventual")))));

    happens event moment = (mkS moment event);

    --EC Core
     --action
    action1 agent actiontype = (mkCl agent actiontype)  ;
    action2 agent actiontype = (mkCl agent actiontype.verb actiontype.arg)  ;
    
    -- initially
    --- mkCl:	SC -> VP -> Cl	
    initially fluent = (mkS presentTense
			  (mkCl (mkSC (mkS fluent)) 
			     (mkVP 
				(mkVP (mkV "hold")) 
				(ConstructorsEng.mkAdv (mkA "initial")))));
    --holds
    holds fluent moment = (mkS moment fluent);

    -- happens
    happens event moment = (mkS moment event);


  --- *** Domain Specific ***
  --- TODO: Modularize Specific Domains  

    -- Agents
    jack   = (mkNP (mkPN "Jack")) ;
    cogito = (mkNP (mkPN "Cogito"));
    I = i_NP ;
    he = he_NP;
    she = she_NP;
    you = you_NP;

    -- Unary ActionTypes
    laugh = (mkV "laugh" "laughed" "laughed");
    die = (mkV "die" "died" "died");
    sleep = (mkV "sleep" "slept" "slept");

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
	
    oper
      modal1 : V -> NP -> Tense -> S ->S =
	\verb,a,t,F -> (mkS t (mkCl a (mkVP 
					 (mkVP verb)
					 (ConstructorsEng.mkAdv that_Subj F))));
    
}