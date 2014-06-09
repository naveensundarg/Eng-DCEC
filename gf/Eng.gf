--# -path=.:.:alltenses
concrete Eng of DCEC =  open SyntaxEng, ConstructorsEng, ParadigmsEng in {

  lincat Agent ={descr:NP; name: NP};
	 ActionType=VP;
	 Event = Cl;
	 Boolean = {pol:Pol; anteriority:Ant; tense: Tense; clause: Cl};
	 Moment = Tense;
	 Fluent = Cl;
	 Utterance = S;
	 Dom= CN;


  lin
    --
    s b = (mkS b.tense b.anteriority b.pol b.clause);

    -- Logic
    and x y = (mkS and_Conj (mkListS x y));


    and_seq x y = (mkS and_Conj (mkListS x (mkS (ConstructorsEng.mkAdv  (mkA "then")) y)));
    or x y = (mkS or_Conj (mkListS x y));
    if x y = (mkS if_then_Conj (mkListS x y));
    not x = (bool x.tense simultaneousAnt negativePol x.clause);
    forall xs A B = (bool presentTense simultaneousAnt positivePol (mkCl (ConstructorsEng.mkAdv for_Prep (mkNP all_Predet (mkNP a_Quant plNum (mkCN A xs.descr)))) (s B)));
    all xs A  B=  (mkS (ConstructorsEng.mkAdv for_Prep (mkNP all_Predet (mkNP a_Quant plNum (mkCN A xs.descr)))) B);
	      -- every one 
    -- [Note: not is a bit different as it has to interact with the verb.]
    -- Modalities
    p a t F  = (modal1 (mkV "see" "saw" "saw") a t F);    

    k a t F  = (modal1 (mkV "know" "knew" "knew") a t F);

    b a t F  = (modal1 (mkV "believe") a t F);
    
    s1 a t F = (modal1 (mkV "declare") a t F);


    d a t F  = (modal1 (mkV "desire") a t F);
    
    inow a t Act  = (intends a  t simultaneousAnt Act (ParadigmsEng.mkAdv "now"));

    ilater a t Act = (intends a  t simultaneousAnt Act (ConstructorsEng.mkAdv (mkA "eventual")));
    
 
    --EC Core
     --action
    action agent actiontype = (mkCl agent.name actiontype)  ;

    --action2I agent actiontype = (mkCl agent.name (reflexiveVP actiontype.verb))  ;
  --  action3 agent actiontype = (mkCl agent.name actiontype.verb1  (mkNP actiontype.arg actiontype.verb2 ));
 --   action3I agent actiontype = (mkCl agent.name (reflexiveVP actiontype.verb1) (mkVP actiontype.verb2 actiontype.arg2))  ;


    -- initially
    --- mkCl:	SC -> VP -> Cl	
    initially fluent = (bool presentTense simultaneousAnt positivePol
			  (mkCl (mkSC (mkS fluent)) 
			     (mkVP 
				(mkVP (mkV "hold")) 
				(ConstructorsEng.mkAdv (mkA "initial")))));
    --holds
    holds fluent moment = (bool moment simultaneousAnt positivePol fluent);

    -- happens
    happens event moment = (bool moment simultaneousAnt positivePol event);
    happensp event moment = (bool moment anteriorAnt positivePol event);



    -- Agents
    i = {descr = (mkNP (mkN "person")); name = i_NP } ;
    he ref = {descr = (mkNP (mkN "man")); name = he_NP };
    she ref={descr = (mkNP (mkN "woman")); name = she_NP };

    he_p ref = {descr = (mkNP (mkN "man")); name = (mkNP he_Pron) };
    she_p ref={descr = (mkNP (mkN "woman")); name =(mkNP she_Pron)};
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
	{pol:Pol; anteriority:Ant; tense: Tense; clause: Cl} 
	=
	\verb,a,t,F -> 
	(bool t simultaneousAnt positivePol
	   (mkCl a.name (mkVP 
		      (mkVS verb)
		      F)));
 
      -- construct boolean objects with tense and polarities
    bool: Tense -> Ant ->Pol-> Cl-> {pol:Pol; anteriority:Ant; tense: Tense; clause: Cl} =
      \t,a,p,cl -> {tense=t; anteriority=a; pol=p; clause = cl};





    intends: {descr:NP; name: NP}->Tense -> Ant -> VP -> Adv -> 
      {pol:Pol; anteriority:Ant; tense: Tense; clause: Cl}=
      \a,t, ant, vp,adv ->
      (bool t ant positivePol 
	 (mkCl a.name want_VV 
	    (mkVP vp 
	       adv)));

}
