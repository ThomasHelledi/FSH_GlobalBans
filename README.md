# FSH_GlobalBans
Globalt Ban system til FiveM.

Jeg introducere til jer, FSH Global Bans. 

**Hvad er FSH Global Bans?** Det er kort sagt et global ban system, der gøre at hvis jeg banner en person i min database, så banner den spilleren på alle servere med denne resource/script. Dette er for at bekæmpe modders & trollers. 

**Hvordan virker det?**
Kort og simpelt. Den connecter til min database på min VPS, hvor den så henter alle globally banned spillere, derefter matcher den ens steam “id” med jeres database, og hvis den finder et match så banner den vedkommende. 

**Hvordan kommer det til at foregå?**
Det kommer til at foregå således at hvis jeg får nok beviser på en bestemt person hacker/modder/troller hårdt så banner jeg vedkommende i global databasen. I global databasen er der også et felt der hedder “grund”, hvori al bevismaterialet vil blive fremvist. Dette felt vil blive sendt til jeres discord webhook, så i kan se ban grundlaget så snart en person bliver bannet. 

**Installation & Setup**
I skal blot følge github linket herunder, eller direct download den vedhæftet fil. Derefter skal den ligges i resource mappen og startes i server.cfg. I FSH_GlobalBans finder i en config.lua. Her er en kort beskrivelse: _SQL_: I skal **IKKE** pille ved SQL’en, ellers kommer det ikke til at virke.
_Discordwebhook_: Et discord web hook link, hvis i ønsker at modtage beskeder om global bans med grundlag og id.
_Bypass_: Hvis I har nogle spillere på jeres server, som i mener er blevet uretfærdigt globally banned så kan i putte enten deres ingame ID eller steam ID ind i bypass, og så vil de ikke blive bannet.

**Andet Information** Nej, der er intet fusk i dette. server.lua er minimeret til en linje grundet besparrelse på plads & hurtigere eksekvering + at folk ikke piller ved source code for meget. Jeg uploader source code til github engang imorgen, hvis i gerne vil tage et kig på hvordan det hele hænger sammen. Jeg gentager lige igen, der er intet snyderi i dette, jeg ligger den ind på ByensRP om en lille halv time, så kan i se det er legit.

SQL brugeren er oprettet med select only permissions, så nej, I kan ikke gå ind og redigere i lortet (nice try tho)

Har du beviser på en person modder/troller/hacker? Så send det i en privatbesked til mig og så vil jeg tage et kig på det, og hvis jeg finder der er tilstrækkelige beviser så vil vedkommende modtage et global ban.

I #global-bans kan I se hvilke servere bruger FSH_GlobalBans.

**Jeg håber så mange muligt får brugt denne resource, da det formindsker antallet af modders drastisk!**
