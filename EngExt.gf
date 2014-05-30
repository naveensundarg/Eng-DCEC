concrete EngExt of DCECExt = Eng ** open  SyntaxEng, ConstructorsEng, ParadigmsEng in {

      --- *** Domain Specific ***
    lin
    
    jack   = (mkNP (mkPN "Jack")) ;
    cogito = (mkNP (mkPN "Cogito"));

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

    
    raining = (mkCl (mkVP (mkV "rain")));
    snowing = (mkCl (mkVP (mkV "snow")));

    hungry agent = (mkCl agent (mkAP (mkA "hungry"))) ;
    tired agent = (mkCl agent (mkAP (mkA "tired"))) ;
    sick agent = (mkCl agent (mkAP (mkA "sick"))) ;
    sad agent = (mkCl agent (mkAP (mkA "sad"))) ;
    happy agent = (mkCl agent (mkAP (mkA "happy"))) ;
    angry agent = (mkCl agent (mkAP (mkA "angry"))) ;
}