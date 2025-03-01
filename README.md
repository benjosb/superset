# SUPERSET25
SUPERSET

<code moet nog worden aangepast>
R. Over de randvoorwaarden van het programmeren 

r.1 we programmeren op een macbookpro 
r.2 we gebruiken Swift en xcode versie 16 
r.3 we ontwikkelen een spel voor de iPad 
r.4 de opmaak kantelt mee met het kantelen van de iPad  
r.5 jij bent een ervaren programmeur 
r.6 jij komt met creatieve en werkende oplossingen
r.7 jij genereert altijd de HELE code
r.8 je nummert de code per samenhangende blokken
r.9 je voorziet de code altijd met uitgebreid Nederlandstalig commentaar

D Het doel en de regels van het spel 

d.1 Het doel van het spel is om zoveel mogelijk geldige sets te verzamelen.  
d.2 De speler met de meeste geldige sets wint. 
d.3 het spel kan gespeeld worden met 2,3 of 4 spelers
d.4 of in de 'oefenmodus' zonder telling van sets en zonder spelersknop 
d.5 Het spel bestaat uit een deck van 81 kaarten 
d.6 elke kaart is uniek en komt dus maar één keer voor  

Het speelbord en De speelkaarten

s.1 er liggen altijd twaalf kaarten op tafel
s.2 (zolang er voldoende kaarten in het deck zijn) 
s.3 kaarten liggen in een grid van 3 x 4 of van 4 x 3 
s.4 de speelkaarten zijn allemaal even groot 
s.5 de symbolen hebben ALTIJD dezelfde grootte: ongeacht of er 1, 2 of 3 symbolen op staan 
s.6 Op elke kaart staan symbolen met VIER eigenschappen: vorm, kleur, aantal, vulling. 
s.7 Elk van die eigenschappen heeft drie verschijningsvormen: 
	1) Aantal: is 1 of 2 of 3 
	2) Kleur: is rood of groen of paars (de kleuren moeten goed te 	onderscheiden zijn)  
	3) vorm: is rechthoek, ovaal of ruit 
	4) vulling: is volledig gevuld, gestippeld of leeg 

V. Voorbereiding van het spel

v.1 er is een opstartscherm, blauw, witte letters SuperSET 2025 
v.2 dan verschijnt er een keuzescherm voor het spel begint
v.3 in het keuzescherm kiezen de spelers voor de spelvorm
v.4 er is een oefenmodus zonder timer/score. 
v.5 er is een spel voor 2,3 of 4 spelers
v.6 de speler(s) kiezen een spelvorm die bepaalt het startscherm
v.7 de spelers kiezen een spelersnaam die op de knop verschijnt 
v.8 het spel start 

Start van het spel 

- Creëer het speelbord: leg precies 12 kaarten uit een deck van 81 
- blind trekken zonder terugleggen
- het spel begint met 12 kaarten op tafel in het grid van 3 x 4 

Opbouw van het scherm 

- op het scherm staat het speelbord met de twaalf kaarten
- met daarom heen in de hoeken de vier spelersknoppen met score en naam 
- boven in het midden staat het totaal en het resterende aantal kaarten. 
- onderin staan knoppen om het spel te bedienen; stop spel, nieuw spel 


Spelverloop 

sv.1 een speler die een SET ziet, klikt op zijn of haar spelersknop en toetst binnen 10(TIEN)seconden drie verschillende kaarten aan.
sv.2 die drie kaarten krijgen een dikke blauwe rand / contour ter onderscheiding van de rest
sv.3 een kaart kan ge-de-selecteerd worden door er nogmaals op te klikken. 
sv.4 na het aanklikken van drie kaarten wordt er een controle uitgevoerd:  

GELDIGE SET

Een geldige set bestaat uit 
1) drie kaarten waarin de vier eigenschappen ALLE VIER verschillend zijn of 
2) drie kaarten met drie identieke eigenschappen. 
Let op: 
vier identieke eigenschappen kan niet, want dan zouden het 4 gelijke kaarten zijn
				
- als het een geldige set is, verschijnt het splashscherm voor een geldige set 
- en krijgt die speler DRIE punten (want het aantal kaarten) 
- aan het speelbord worden drie nieuwe random kaarten uit het deck toegevoegd 
- zolang er kaarten beschikbaar zijn, worden die na een geldige set aangevuld 

ONGELDIGE SET

- als het een ongeldige set is, krijgt de speler 0 punten 
- en de speler moet een beurt overslaan. 
- er verschijnt kort (1 sec) het scherm voor de ongeldige set 
- en de spelersknop wordt inactief tot de volgende set door een andere speler is geselecteerd. 
	


Bijzondere schermen

- splashscherm bij een geldige set: 
- 	dit verschijnt vrolijk met een animatie 
- 	met de tekst " BOEM - geldige set" 
- 	het scherm verdwijnt dan na een seconde
- splashscherm bij een ongeldige set:  
- 	dit verschijnt met de melding; "GEEN geldige set - BEURT overslaan" 
- 	en verdwijnt na een seconde
- splashscherm als een speler een kaart aanklikt zonder dat er eerst een 	spelers(knop) is geselecteerd (alleen bij 2, 3, 4 spelers)
- het winst splashscherm: BOEM BOEM jij bent de WINNAAR speler [speler met de meeste sets]


Einde van het spel 

- als de kaarten uit het deck met 81 kaarten op zijn, wordt gekeken naar de speler met de meeste sets; die speler wint. 
- het winst splashscherm verschijnt
- of als de knop 'einde spel' wordt ingeklikt. 
- vraag na het indrukken van de knop 1x om bevestiging; "weet je het zeker ja / nee" 


SUPERSET

Hier is een duidelijke beschrijving van de SuperSet functionaliteit in normale taal:
•  Basis Verloop
•  Speler vindt een normale SET (3 kaarten)
•  Systeem checkt of deze SET klopt
•  Als het klopt: speler krijgt de kans om voor SuperSET te gaan
•  Er start een timer voor de beslissing (bijvoorbeeld 10 seconden)
•  SuperSet Keuze
•  Speler ziet een scherm met twee knoppen:
•  "Ja, probeer SuperSet!" (in groen)
•  "Nee, hou gewoon 3 punten" (in blauw)
•  Als de tijd op is zonder keuze: telt als "Nee"
•  SuperSet Poging
•  Als speler "Ja" kiest:
•  Moet een 4e kaart vinden die ook een SET maakt met de originele kaarten
•  Er start een nieuwe timer (bijvoorbeeld 15 seconden)
•  Als het lukt = 5 punten
•  Als het niet lukt = 0 punten
•  Als speler "Nee" kiest:
•  Krijgt gewoon de normale 3 punten
•  Spel gaat gewoon door
•  Benodigde ViewModel Eigenschappen
•  toonSuperSetKeuze: Ja/nee voor of dat keuzescherm zichtbaar is
•  superSetTijdOver: Hoeveel seconden er nog over zijn
•  isSuperSetGelukt: Of de poging succesvol was
•  origineleSet: De 3 kaarten waarmee het begon
•  superSetPogingBezig: Of er nu een SuperSet poging loopt
•  superSetKeuzetijd: Hoelang je hebt voor de keuze
•  superSetPogingTijd: Hoelang je hebt voor de poging zelf
•  Benodigde ViewModel Functies
•  kiesSuperSet(): Start de SuperSet poging
•  houdNormaleSet(): Geeft normale punten en gaat door
•  checkSuperSet(): Kijkt of de 4e kaart een geldige SET maakt
•  startSuperSetTimer(): Regelt de aftelling voor beide timers
•  stopSuperSetPoging(): Handelt timeout of annulering af
•  geefSuperSetPunten(): Regelt de puntentelling
•  resetSuperSetStatus(): Maakt alles weer schoon na een poging

Deze opzet zorgt voor een duidelijke, modulaire implementatie waarbij alle onderdelen netjes gescheiden zijn en de status goed bijgehouden wordt.


Eindspel Situaties:


Wanneer eindigt het spel?
•  Als het deck leeg is (geen kaarten meer over)
•  EN er geen geldige sets meer mogelijk zijn op tafel
•  OF als er geen zetten meer mogelijk zijn met de huidige kaarten

Wat gebeurt er dan?
•  Het spel moet controleren of er nog sets mogelijk zijn
•  Als er geen sets meer mogelijk zijn:
•  Toon een "Spel Afgelopen" melding
•  Toon de eindscores
•  In multiplayer: kondig de winnaar aan
•  Geef opties om opnieuw te spelen of terug te gaan naar het hoofdmenu

Specifieke functionaliteit die nodig is:
•  Een functie die controleert of er nog sets mogelijk zijn op tafel
•  Een functie die checkt of het deck leeg is
•  Een eindscherm met scores en resultaten
•  Een systeem om de winnaar te bepalen (hoogste score)

 
Vooraf 

ik heb een document met spelregels, doel, opmaak, gameplay etc. 
Ik wil dat je nog geen code schrijft, maar alle regels onderbrengt in de structuur van de bestanden die jij zelf hebt voorgesteld. De bedoeling is: 

1) dat het een werkend spel is
2) jij neemt de rol aan van een professionele programmeur
3) dus jij geeft kwalitatief hoogwaardig werk 
4) ik wil dat je alle regels etc die ik zo inkopieer op een logische manier verdeelt over de bestanden die we hebben benoemd
5) de bedoeling is dat de bestanden niet te lang worden; niet langer dan het equivalent van 1A4


Bedankt voor het delen van deze informatie. Ik zal de regels en specificaties nu verdelen over de bestanden die we eerder hebben gedefinieerd. Hier is een logische verdeling van de informatie:

SetGameGoal.swift:
*  Het doel van het spel is om zoveel mogelijk geldige sets te verzamelen.
*  De speler met de meeste geldige sets wint.

SetCard.swift:
*  Het spel bestaat uit een deck van 81 kaarten en elke kaart is uniek.
*  Elk van die eigenschappen heeft drie verschijningsvormen:
	1) Aantal is 1 of 2 of 3
	2) Kleur is rood of groen of paars (alle kleuren moeten goed te onderscheiden 	zijn)
	3) Vorm is rechthoek, ovaal of ruit
	4) Vulling is vol of gestippeld of leeg

SetCardView.swift:
*  De speelkaarten zijn allemaal even groot
*  De symbolen hebben dezelfde grootte, ongeacht of er 1, 2 of 3 symbolen op staan
*  Op elke kaart staan symbolen met VIER eigenschappen: vorm, kleur, aantal, vulling

SetBoardView.swift:
*  Er liggen altijd twaalf kaarten op tafel (zolang er voldoende kaarten in de deck zijn)
*  Kaarten liggen in een grid van 3 x 4
*  De opmaak kantelt mee met het kantelen van de ipad

SetGameLogic.swift:
*  Zodra de 12 kaarten op tafel liggen, begint het spel.
*  De symbolen op de kaart hebben alle dezelfde afmeting
*  Creëer het speelbord: leg precies12 kaarten uit een deck van 81
*  Er zijn 0,1,2,3 of 4 spelersknoppen
*  Het spel kan voor aanvang van het spel worden bepaald door de spelers

SetGameRules.swift:
*  GELDIGE SET:
*  Een geldige set bestaat uit:
1) drie kaarten waarin de vier eigenschappen ALLE VIER verschillend zijn óf
2) drie kaarten met drie identieke eigenschappen. Let op:
3) twee dezelfde eigenschappen en twee verschillende is GEEN set
4) geldig is ook als alle 4 gelijke kaarten zijn

SetGameState.swift:
*  Houd score bij op de spelersknop
*  Start en pauzeer de timer
*  Houd het aantal aanwezige kaarten en nog resterende kaarten bij

SetGameViewModel.swift:
*  Verbind de spellogica met de UI-elementen
*  Beheer de spelersacties en update de spelstaat
*  SetScreenViews.swift:
*  Toon de verschillende schermen (start, spel, einde)
*  Toon de spelersknoppen
*  Toon de timer en scores

StartGame.swift:
*  Initialiseer het spel met 81 kaarten
*  Schud de kaarten
*  Leg de eerste 12 kaarten op tafel
*  Start de timer wanneer het spel begint

Deze verdeling zorgt ervoor dat elk bestand een specifieke verantwoordelijkheid heeft en niet te lang wordt. Het volgt ook de principes van een goede softwarearchitectuur, waarbij de logica, weergave en spelstaat gescheiden zijn.

SuperSet2025/
├── Models/
│   ├── KaartModels.swift        (BLOK 1)
│   └── SpelModels.swift         (BLOK 2)
├── Setup/
│   └── SpelSetup.swift          (BLOK 3)
├── Controllers/
│   └── SpelController.swift     (BLOK 4)
├── Layout/
│   └── LayoutConstants.swift    (BLOK 5)
├── ViewControllers/
│   └── GameViewControllers.swift (BLOK 6)
├── Views/
│   └── GameViews.swift          (BLOK 7)
└── Utilities/
    └── Helpers.swift            (BLOK 8)


