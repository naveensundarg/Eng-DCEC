--# -path=.:.:alltenses
concrete Eng of DCEC = open SyntaxEng, ConstructorsEng, ParadigmsEng in {

  lincat Agent ={descr:NP; name: NP};
	 ActionType1 = V;
	 ActionType2 = {verb : V2; arg : NP};
	 Event = Cl;
	 Boolean = {pol:Pol; tense: Tense; clause: Cl};
	 Moment = Tense;
	 Fluent = Cl;
	 Utterance = S;
	 Dom= CN;
	 [Agent] = NP;

  printname fun action1,action2,action1c,action2c = "action";

  lin
    --
    s b = (mkS b.tense b.pol b.clause);

    -- Logic
    and x y = (mkS and_Conj (mkListS x y));
    or x y = (mkS or_Conj (mkListS x y));
    if x y = (mkS if_then_Conj (mkListS x y));
    not x = (bool x.tense  negativePol x.clause);
    forall xs A B = (bool presentTense positivePol (mkCl (ConstructorsEng.mkAdv for_Prep (mkNP all_Predet (mkNP a_Quant plNum (mkCN A xs.descr)))) (s B)));
 	
	      -- every one 
    -- [Note: not is a bit different as it has to interact with the verb.]
    -- Modalities
    p a t F  = (modal1 (mkV "see" "saw" "saw") a t F);    

    k a t F  = (modal1 (mkV "know" "knew" "knew") a t F);

    b a t F  = (modal1 (mkV "believe") a t F);
    
    s1 a t F = (modal1 (mkV "declare") a t F);


    d a t F  = (modal1 (mkV "desire") a t F);
    
    i1now a t Act  = (intends a t (mkVP Act)(ParadigmsEng.mkAdv "now"));

    i1later a t Act = (intends a t (mkVP Act)(ConstructorsEng.mkAdv (mkA "eventual")));
    
    i2now a t Act  = (intends a t (mkVP Act.verb Act.arg) (ParadigmsEng.mkAdv "now"));

    i2later a t Act = (intends a t (mkVP Act.verb Act.arg) (ConstructorsEng.mkAdv (mkA "eventual")));

 
    --EC Core
     --action
    action1 agent actiontype = (mkCl agent.name actiontype)  ;
    action2 agent actiontype = (mkCl agent.name actiontype.verb actiontype.arg)  ;

    action1c agent actiontype = (mkCl agent.name (progressiveVP (mkVP actiontype)))  ;
    action2c agent actiontype = (mkCl agent.name  (progressiveVP 
						     (mkVP actiontype.verb actiontype.arg)));

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



    -- Agents
    i = {descr = (mkNP (mkN "person")); name = i_NP } ;
    he ref = {descr = (mkNP (mkN "man")); name = he_NP };
    she ref={descr = (mkNP (mkN "woman")); name = she_NP };
    you = {descr = (mkNP (mkN "person")); name = you_NP };
    -- Moments
    now = presentTense;
    tf = futureTense;
    tp = pastTense;


    agent = (mkCN (mkN "agent"));
    x _ = {descr = (mkNP (mkN "x")); name = (mkNP (mkN "x")) };
    y _ = {descr = (mkNP (mkN "y")); name = (mkNP (mkN "y")) };
    z _ = {descr = (mkNP (mkN "z")); name = (mkNP (mkN "z")) };
     
    BaseAgent x =x;
    ConsAgent x xs = mkNP and_Conj (mkListNP x xs);
        oper
      -- Construct modalities
      modal1 : 
	V -> {descr:NP; name: NP} -> Tense -> 
	S ->
	{pol:Pol; tense: Tense; clause: Cl} 
	=
	\verb,a,t,F -> 
	(bool t positivePol
	   (mkCl a.name (mkVP 
		      (mkVS verb)
		      F)));
 
      -- construct boolean objects with tense and polarities
    bool: Tense -> Pol-> Cl-> {pol:Pol; tense: Tense; clause: Cl} =
      \t, p,cl -> {tense=t; pol=p; clause = cl};


    intends: {descr:NP; name: NP}->Tense -> VP -> Adv -> {pol:Pol; tense: Tense; clause: Cl}=
      \a,t,vp,adv ->
      (bool t positivePol 
	 (mkCl a.name want_VV 
	    (mkVP vp 
	       adv)));

}
