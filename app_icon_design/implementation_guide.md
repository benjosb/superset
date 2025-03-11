# Implementatiegids voor SUPERSET25 App Icoon

Deze gids bevat praktische informatie voor het implementeren van je SUPERSET25 app-icoon op verschillende platforms en in verschillende formaten.

## Vereiste Formaten voor iOS

Voor iOS-apps heb je de volgende formaten nodig:

| Gebruik | Afmeting | Bestandsnaam |
|---------|----------|--------------|
| App Store | 1024 x 1024 px | AppIcon-1024.png |
| iPhone Notification | 20 x 20 pt (@2x) | AppIcon-20@2x.png |
| iPhone Notification | 20 x 20 pt (@3x) | AppIcon-20@3x.png |
| iPhone Settings | 29 x 29 pt (@2x) | AppIcon-29@2x.png |
| iPhone Settings | 29 x 29 pt (@3x) | AppIcon-29@3x.png |
| iPhone Spotlight | 40 x 40 pt (@2x) | AppIcon-40@2x.png |
| iPhone Spotlight | 40 x 40 pt (@3x) | AppIcon-40@3x.png |
| iPhone App | 60 x 60 pt (@2x) | AppIcon-60@2x.png |
| iPhone App | 60 x 60 pt (@3x) | AppIcon-60@3x.png |
| iPad Notifications | 20 x 20 pt (@1x) | AppIcon-20.png |
| iPad Notifications | 20 x 20 pt (@2x) | AppIcon-20@2x.png |
| iPad Settings | 29 x 29 pt (@1x) | AppIcon-29.png |
| iPad Settings | 29 x 29 pt (@2x) | AppIcon-29@2x.png |
| iPad Spotlight | 40 x 40 pt (@1x) | AppIcon-40.png |
| iPad Spotlight | 40 x 40 pt (@2x) | AppIcon-40@2x.png |
| iPad App | 76 x 76 pt (@1x) | AppIcon-76.png |
| iPad App | 76 x 76 pt (@2x) | AppIcon-76@2x.png |
| iPad Pro App | 83.5 x 83.5 pt (@2x) | AppIcon-83.5@2x.png |

## Vereiste Formaten voor Android

Voor Android-apps heb je de volgende formaten nodig:

| Dichtheid | Afmeting | Bestandsnaam |
|-----------|----------|--------------|
| ldpi | 36 x 36 px | ic_launcher_ldpi.png |
| mdpi | 48 x 48 px | ic_launcher_mdpi.png |
| hdpi | 72 x 72 px | ic_launcher_hdpi.png |
| xhdpi | 96 x 96 px | ic_launcher_xhdpi.png |
| xxhdpi | 144 x 144 px | ic_launcher_xxhdpi.png |
| xxxhdpi | 192 x 192 px | ic_launcher_xxxhdpi.png |
| Play Store | 512 x 512 px | ic_launcher_playstore.png |

## Implementatie in Xcode

1. Open je project in Xcode
2. Selecteer je project in de Project Navigator
3. Selecteer je target en ga naar het tabblad "General"
4. Scroll naar beneden naar "App Icons and Launch Images"
5. Klik op de pijl naast "App Icons Source"
6. Sleep je iconen naar de juiste vakjes of gebruik een tool zoals [Icon Set Creator](https://apps.apple.com/us/app/icon-set-creator/id939343785) om automatisch alle formaten te genereren

## Implementatie in Android Studio

1. Open je project in Android Studio
2. Navigeer naar app > src > main > res
3. Plaats de iconen in de juiste mipmap-folders (mipmap-ldpi, mipmap-mdpi, etc.)
4. Controleer of het icoon correct is ingesteld in je AndroidManifest.xml:
   ```xml
   <application
       android:icon="@mipmap/ic_launcher"
       android:roundIcon="@mipmap/ic_launcher_round"
       ...
   ```

## Aanbevolen Tools voor Icoon Creatie

- **Adobe Illustrator**: Ideaal voor vectorgebaseerde ontwerpen
- **Sketch**: Populair onder iOS-ontwikkelaars
- **Figma**: Gratis alternatief met krachtige ontwerptools
- **Icon Set Creator**: Specifiek voor het genereren van alle benodigde iOS-formaten
- **Image Asset Studio (Android Studio)**: Ingebouwd in Android Studio voor het genereren van Android-iconen

## Best Practices

1. **Begin met een vector**: Ontwerp je icoon eerst als vector om schaalbaarheid te garanderen
2. **Houd het simpel**: Iconen moeten herkenbaar zijn, zelfs op kleine formaten
3. **Test op verschillende achtergronden**: Zorg dat je icoon goed zichtbaar is op zowel lichte als donkere achtergronden
4. **Respecteer de veilige zone**: Houd belangrijke elementen binnen de veilige zone om afsnijding te voorkomen
5. **Consistentie**: Zorg dat je icoon past bij de stijl van het platform (iOS of Android)
6. **Exporteer in PNG-formaat**: Voor de beste kwaliteit en ondersteuning

## Adaptieve Iconen (Android 8.0+)

Voor moderne Android-apps is het aan te raden om adaptieve iconen te gebruiken:

1. Maak een voorgrondlaag (meestal je logo zonder achtergrond)
2. Maak een achtergrondlaag (meestal een effen kleur of eenvoudige gradiënt)
3. Implementeer deze in je project volgens de Android-richtlijnen

## Testen

Test je icoon altijd in de volgende scenario's:
- Op het startscherm van het apparaat
- In de app-drawer/bibliotheek
- In de instellingen van het apparaat
- In de app store
- Naast andere apps op het startscherm

Door deze gids te volgen, zorg je ervoor dat je SUPERSET25 app-icoon er professioneel uitziet en correct wordt weergegeven op alle ondersteunde apparaten en platforms. 