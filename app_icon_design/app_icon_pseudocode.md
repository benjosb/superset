# SUPERSET25 App Icoon Pseudocode

Dit is een stapsgewijze handleiding voor het maken van het SUPERSET25 app-icoon in een grafisch programma zoals Sketch, Figma of Adobe Illustrator.

## Stap 1: Canvas instellen
```
Canvas maken met afmetingen 1024x1024 pixels
Raster instellen op 32x32 voor nauwkeurige plaatsing
Veilige zone markeren (binnenste 90% van canvas)
```

## Stap 2: Achtergrond maken
```
Afgerond vierkant maken met radius = 20% van breedte
Gradiënt vulling toepassen:
    Startkleur: #1A237E (diepblauw) bij top-left (0%, 0%)
    Eindkleur: #4A148C (paars) bij bottom-right (100%, 100%)
    Type: Lineair
```

## Stap 3: Subtiele achtergrondpatronen
```
Laag maken voor watermerken
Opacity instellen op 10%
Kleine speelkaartsymbolen (harten, ruiten, klaveren, schoppen) verspreiden
Grootte variëren tussen 24-48px
Willekeurig roteren tussen 0-360 graden
```

## Stap 4: Kaarten maken
```
// Kaart 1 (linksboven)
Witte rechthoek maken met afmetingen 400x600px
Hoeken afronden met radius 40px
Dunne rode rand toevoegen (#D32F2F, 4px)
Roteren met -15 graden
Positioneren op x=300px, y=350px

// Kaart 2 (rechtsboven)
Witte rechthoek maken met afmetingen 400x600px
Hoeken afronden met radius 40px
Dunne groene rand toevoegen (#388E3C, 4px)
Roteren met 15 graden
Positioneren op x=600px, y=350px

// Kaart 3 (onderaan)
Witte rechthoek maken met afmetingen 400x600px
Hoeken afronden met radius 40px
Dunne paarse rand toevoegen (#7B1FA2, 4px)
Roteren met 0 graden
Positioneren op x=450px, y=500px

// Schaduw toevoegen aan alle kaarten
Schaduw instellen:
    Kleur: #000000
    Opacity: 30%
    Offset: x=0px, y=8px
    Blur: 16px
```

## Stap 5: Symbolen op kaarten tekenen
```
// Kaart 1: Eén rood ovaal met gestippelde vulling
Ovaal tekenen met afmetingen 120x80px
Centreren op kaart 1
Kleur: #D32F2F (rood)
Vulling: Gestippeld patroon (stippen 4px, afstand 8px)
Lijndikte: 4px

// Kaart 2: Twee groene ruiten met volle vulling
Ruit 1 tekenen met afmetingen 100x100px
Positioneren op 1/3 van kaart 2
Ruit 2 tekenen met afmetingen 100x100px
Positioneren op 2/3 van kaart 2
Kleur voor beide: #388E3C (groen)
Vulling: 100% dekkend
Lijndikte: 4px

// Kaart 3: Drie paarse rechthoeken zonder vulling
Rechthoek 1 tekenen met afmetingen 80x120px
Positioneren op 1/4 van kaart 3
Rechthoek 2 tekenen met afmetingen 80x120px
Positioneren op 2/4 van kaart 3
Rechthoek 3 tekenen met afmetingen 80x120px
Positioneren op 3/4 van kaart 3
Kleur voor alle drie: #7B1FA2 (paars)
Vulling: Geen (transparant)
Lijndikte: 4px
```

## Stap 6: Glow effect toevoegen
```
Selecteer alle drie kaarten
Dupliceer en combineer tot één vorm
Voeg glow effect toe:
    Kleur: #FFD700 (goudgeel)
    Opacity: 60%
    Blur: 20px
    Spread: 10px
Plaats deze laag onder de kaarten
```

## Stap 7: Starburst met "25" toevoegen
```
Starburst vorm maken in rechterbovenhoek:
    Diameter: 150px
    Aantal punten: 12
    Binnenste radius: 40%
    Kleur: #FFD700 (goudgeel)
    
Tekst "25" toevoegen:
    Font: Handgeschreven stijl (bijv. Marker Felt of Brush Script)
    Grootte: 80px
    Kleur: #FFFFFF (wit)
    Centreren in starburst
    Schaduw toevoegen voor leesbaarheid
```

## Stap 8: Tekst toevoegen
```
Tekst "SUPER" toevoegen:
    Font: Bold sans-serif (bijv. Helvetica Neue Bold)
    Grootte: 100px
    Kleur: #FFFFFF (wit)
    Positioneren bovenaan, gecentreerd
    
Tekst "SET" toevoegen:
    Font: Extra Bold sans-serif (bijv. Helvetica Neue Black)
    Grootte: 160px
    Kleur: #FFFFFF (wit)
    Positioneren onder "SUPER", gecentreerd
    
Voeg schaduw toe aan beide teksten:
    Kleur: #000000
    Opacity: 40%
    Offset: x=0px, y=4px
    Blur: 8px
```

## Stap 9: Laatste aanpassingen
```
Controleer alle elementen op uitlijning
Pas helderheid/contrast aan indien nodig
Zorg dat alle elementen binnen de veilige zone vallen
Controleer hoe het icoon eruitziet op verschillende achtergronden
```

## Stap 10: Exporteren
```
Exporteer als PNG met transparante achtergrond
Maak verschillende formaten voor iOS vereisten:
    - 1024x1024 (App Store)
    - 180x180 (iPhone)
    - 167x167 (iPad Pro)
    - 152x152 (iPad)
    - 120x120 (iPhone spotlight)
    - 80x80 (Spotlight)
    - 76x76 (iPad settings)
    - 58x58 (Settings)
    - 40x40 (Spotlight)
```

Dit pseudocode document dient als een gedetailleerde handleiding voor het maken van het SUPERSET25 app-icoon. De exacte implementatie kan variëren afhankelijk van het gebruikte grafische programma, maar de stappen en elementen blijven hetzelfde. 