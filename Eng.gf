--# -path=.:.:alltenses
concrete Eng of DCEC = open SyntaxEng, ConstructorsEng, ParadigmsEng in {

  lincat Agent = NP;
	 ActionType1 = V;
	 ActionType2 = {verb : V2; arg : NP};
	 Event = Cl;
	 Boolean = {pol:Pol; tense: Tense; clause: Cl};
	 Moment = Tense;
	 Fluent = Cl;
	 Utterance = S;
  lin
    --
    reify b = (mkS b.tense b.pol b.clause);


    -- Logic
    and x y = (mkS and_Conj (mkListS x y));
    or x y = (mkS or_Conj (mkListS x y));
    if x y = (mkS if_then_Conj (mkListS x y));
    not x = (bool x.tense  negativePol x.clause);
    -- [Note: not is a bit different as it has to interact with the verb.]
    -- Modalities
    p a t F  = (modal1 (mkV "see" "saw" "saw") a t F);    

    k a t F  = (modal1 (mkV "know" "knew" "knew") a t F);

    b a t F  = (modal1 (mkV "believe") a t F);
    
    s1 a t F = (modal1 (mkV "declare") a t F);


    d a t F  = (modal1 (mkV "desire") a t F);
    
    i1now a t1 Act  = (bool t1 positivePol
			  (mkCl a want_VV  (mkVP (mkVP Act) (ParadigmsEng.mkAdv "now"))));

    i1later a t1 Act = (bool t1 positivePol (mkCl a want_VV  
				  (mkVP 
				     (mkVP Act) 
				     (ConstructorsEng.mkAdv (mkA "eventual")))));

 
    --EC Core
     --action
    action1 agent actiontype = (mkCl agent actiontype)  ;
    action2 agent actiontype = (mkCl agent actiontype.verb actiontype.arg)  ;
    
    -- initially
    --- mkCl:	SC -> VP -> Cl	
    initially fluent = (bool presentTense positivePol
			  (mkCl (mkSC (mkS fluent)) 
			     (mkVP 
				(mkVP (mkV "hold")) 
				(ConstructorsEng.mkAdv (mkA "initial")))));
    --holds
    holds fluent moment = (bool moment positivePol fluent);

    -- happens
    happens event moment = (bool moment positivePol event);


  --- *** Domain Specific ***
  --- TODO: Modularize Specific Domains  

    -- Agents
    jack   = (mkNP (mkPN "Jack")) ;
    cogito = (mkNP (mkPN "Cogito"));
    i = i_NP ;
    he ref = he_NP;
    she ref= she_NP;
    you = you_NP;

    -- Unary ActionTypes
    laugh = (mkV "laugh" "laughed" "laughed");
    die = (mkV "die" "died" "died");
    sleep = (mkV "sleep" "slept" "slept");
    eat = (mkV "eat" "ate" "eaten");
    -- Binary ActionTypes
    hurt2 a= {verb = (mkV2 (mkV "hurt" "hurt" "hurt")); arg = a};
    guard2 a= {verb = (mkV2 (mkV "guard")); arg = a};
    harm2 a= {verb = (mkV2 (mkV "harm")); arg = a};
    disable2 a= {verb = (mkV2 (mkV "disable")); arg = a};

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
      modal1 : 
	V -> NP -> Tense -> 
	{pol:Pol; tense: Tense; clause: Cl} ->
	{pol:Pol; tense: Tense; clause: Cl} 
	=
	\verb,a,t,F -> 
	(bool t positivePol
	   (mkCl a (mkVP 
		      (mkVS verb)
		      (reify F))));
 
    bool: Tense -> Pol-> Cl-> {pol:Pol; tense: Tense; clause: Cl} =
      \t, p,cl -> {tense=t; pol=p; clause = cl};
}