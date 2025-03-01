//
//  SUPERSET25App.swift
//  SUPERSET25
//
//  Created by dick braam on 01/03/2025.
//

import SwiftUI
import AVFoundation
import AudioToolbox
import Combine

@main
struct SUPERSET25App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

// MARK: - Localization
enum Language: String, CaseIterable {
    case english = "English"
    case dutch = "Nederlands"
    case french = "Français"
    case chinese = "中文"
    case hindi = "हिंदी"
    
    var flag: String {
        switch self {
        case .english: return "🇬🇧"
        case .dutch: return "🇳🇱"
        case .french: return "🇫🇷"
        case .chinese: return "🇨🇳"
        case .hindi: return "🇮🇳"
        }
    }
}
class LocalizationManager {
    static let shared = LocalizationManager()
    var selectedLanguage: Language = .english
    
    private let texts: [String: String] = [
        "title": "SuperSET 2025",
        "new_here": "SET",
        "learn_set": "the rules",
        "practice": "Practice SET",
        "play_own_pace": "and get better",
        "multiplayer": "Multiplayer",
        "play_friends": "Play with friends",
        "what_is_set": "What is a SET?",
        "set_type_1": "SET type 1: Three cards where only one property differs\n(only the NUMBER differs)",
        "set_type_2": "SET type 2: Two properties differ\n(NUMBER AND SHAPE differ)",
        "set_type_3": "SET type 3: Three properties differ\n(number, shape AND color)",
        "set_type_4": "SET type 4: All properties differ.\n(NUMBER - SHAPE - COLOR AND FILLING)",
        "show_more": "Show another example",
        "more_info": "More info",
        "play_now": "PLAY NOW!",
        "skip": "SKIP",
        "understood": "Got it!",
        "pause": "Pause",
        "resume": "Resume",
        "switch_card": "Switch Card",
        "new_game": "New Game",
        "valid_set": "Valid SET!",
        "invalid_set": "BUMMER - not a valid set! You will miss the next turn",
        "super_set_chance": "SUPER SET CHANCE!",
        "super_set_success": "SUPERset !!! *** 10 points ***",
        "try_super_set": "Want to try making a Super Set?",
        "yes_points": "SUPERset !!! *** 10 points ***",
        "no_points": "No (3 points)",
        "choose_avatar": "Choose your avatar",
        "choose_players": "Choose number of players:",
        "player_1": "1 player: Perfect for practice",
        "player_2": "2 players: Play against a friend",
        "player_3": "3 players: Play with three",
        "player_4": "4 players: Play with four players",
        "start_game": "Start Game",
        "select_position": "Select position",
        "top_left": "Top Left",
        "top_right": "Top Right",
        "bottom_left": "Bottom Left",
        "bottom_right": "Bottom Right",
        "set_success_exclamation": "BOEM!!",
        "valid_set_with_choice": "Valid SET!! \nWant to win 10 points? \nMake a SUPERset! \nBut ... WRONG set? NO points!",
            "what_do_you_do": "WHAT DO YOU DO:",
            "yes_super_set": "I'll go for the SUPERset",
            "no_keep_points": "No - I'll just keep my 3 points",
        "super_set_fail": "BUMMER wrong SET. You loose your points.",
        "set_fail_exclamation": "OOPS!",
        "avatar_fox": "Fox",
        "avatar_lion": "Lion",
        "avatar_tiger": "Tiger",
        "avatar_frog": "Frog",
        "avatar_owl": "Owl",
        "avatar_panda": "Panda",
        "avatar_unicorn": "Unicorn",
        "avatar_koala": "Koala",
        "avatar_elephant": "Elephant",
        "avatar_dolphin": "Dolphin"
    ]
    
    func text(_ key: String) -> String {
        return texts[key] ?? key
    }
    
    static func text(_ key: String) -> String {
        return shared.text(key)
    }
}
// MARK: - 1. Kaart model
struct SetCard: Identifiable, Equatable, Hashable {
    let id = UUID()
    let aantal: Int
    let kleur: CardKleur
    let vorm: CardVorm
    let vulling: CardVulling
    
    enum CardKleur: Int, CaseIterable, Hashable {
        case rood = 1
        case groen = 2
        case paars = 3
    }
    
    enum CardVorm: Int, CaseIterable, Hashable {
        case rechthoek = 1
        case ovaal = 2
        case ruit = 3
    }
    
    enum CardVulling: Int, CaseIterable, Hashable {
        case volledig = 1
        case gestippeld = 2
        case leeg = 3
    }
    
    // Implementeer Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(aantal)
        hasher.combine(kleur)
        hasher.combine(vorm)
        hasher.combine(vulling)
    }
}
// MARK: - 2. ViewModel
class SetGameViewModel: ObservableObject {
    @Published var hintKaarten: [SetCard] = []
    @Published var aantalHintsGetoond = 0
    @Published private var model: SetGameModel
    @Published var geselecteerdeKaarten: [SetCard] = []
    @Published var toonGeldigeSet = false
    @Published var toonOngeldigeSet = false
    @Published var toonBummer = false
    @Published var toonSuperSetKans = false
    @Published var toonSuperSetResultaat = false
    @Published var isSuccesvolSuperSet = false
    @Published var laatsteGevondenSet: [SetCard]?
    @Published var tijdResterend = 300
    @Published var isPauze = false
    @Published var spelModus: SpelModus = .oefenen
    @Published var spelerNamen: [String] = []
    @Published var actieveSpeler: Int?
    @Published var magKaartenSelecteren = false
    @Published var selectieTijdResterend: Double = 300.0
    @Published private var geblokkeerdeSpelers: Set<Int> = []
    @Published var spelFase: SpelFase = .startScherm
    @Published var spelerPosities: [SpelerPositie] = []
    @Published var spelerAvatars: [SpelerPositie: SpelerAvatar] = [:]
    @Published var superSetTijdResterend: Double = 300.0
    @Published var toonSuperSetKeuze = false
    @Published var inSuperSetMode = false
    @Published var selectedLanguage: Language = .english
    @Published var superSetKaarten: [SetCard] = []
    @Published var geselecteerdeKaartVoorSuperSet: SetCard?
    @Published var eindSpelStatistieken: EindSpelStats?
    @Published var verlichtKaart: SetCard? = nil
    private var verlichtTimer: Timer?
    private var huidigeSetIndex = 0
    private var huidigeSetVoorDemo: [SetCard] = []
    @Published private(set) var aantalMogelijkeSets: Int = 0
    private var audioPlayer: AVAudioPlayer?
    var timerCancellable: AnyCancellable?  // Voeg deze property toe
    
    struct EindSpelStats {
        let scores: [Int]
        let gevondenSets: Int
        let superSets: Int
        let speelTijd: TimeInterval
        let winnaar: Int?
    }
    
    private var origineleSet: [SetCard]?
    private var timer: Timer?
    private var selectieTimer: Timer?
    private var superSetTimer: Timer?
    private var aantalGeselecteerdeKaarten: Int = 0

    enum SpelStatus {
        case normaalSpel
        case superSetKeuze(geldigeSet: [SetCard], spelerMetSet: Int)
        case superSetSelectie(origineleSet: [SetCard], spelerMetSet: Int)
        case superSetKaartenKiezen(origineleSet: [SetCard], geselecteerdeKaart: SetCard, spelerMetSet: Int)
    }
    
    @Published private var spelStatus: SpelStatus = .normaalSpel

    enum SpelModus {
        case oefenen, tweeSpelers, drieSpelers, vierSpelers
        
        var aantalSpelers: Int {
            switch self {
            case .oefenen: return 1
            case .tweeSpelers: return 2
            case .drieSpelers: return 3
            case .vierSpelers: return 4
            }
        }
        
        var posities: [SpelerPositie] {
            switch self {
            case .tweeSpelers: return [.linksBoven, .rechtsBoven]
            case .drieSpelers: return [.linksBoven, .rechtsBoven, .linksOnder]
            case .vierSpelers: return [.linksBoven, .rechtsBoven, .linksOnder, .rechtsOnder]
            case .oefenen: return []
            }
        }
    }
    
    enum SpelFase {
        case startScherm
        case positieKiezen
        case spelen
        case eindSpel
    }
    
    enum SpelerPositie: String, CaseIterable {
        case linksBoven = "Links Boven"
        case rechtsBoven = "Rechts Boven"
        case linksOnder = "Links Onder"
        case rechtsOnder = "Rechts Onder"
    }

    enum SpelerAvatar: String, CaseIterable {
        case vos = "🦊"
        case leeuw = "🦁"
        case tijger = "🐯"
        case kikker = "🐸"
        case uil = "🦉"
        case panda = "🐼"
        case eenhoorn = "🦄"
        case koala = "🐨"
        case olifant = "🐘"  // Nieuwe avatar
        case dolfijn = "🐬"  // Nieuwe avatar
        
        var vertaalSleutel: String {
            switch self {
            case .vos: return "avatar_fox"
            case .leeuw: return "avatar_lion"
            case .tijger: return "avatar_tiger"
            case .kikker: return "avatar_frog"
            case .uil: return "avatar_owl"
            case .panda: return "avatar_panda"
            case .eenhoorn: return "avatar_unicorn"
            case .koala: return "avatar_koala"
            case .olifant: return "avatar_elephant"  // Nieuwe vertaling
            case .dolfijn: return "avatar_dolphin"   // Nieuwe vertaling
            }
        }
        
        var vertaaldeNaam: String {
            return LocalizationManager.text(vertaalSleutel)
        }
    }

    init() {
        model = SetGameModel()
        // Alleen timer starten in oefenmodus
        if spelModus == .oefenen {
            startTimer()
        }
        updateAantalMogelijkeSets()
        configureAudio()
    }

    var kaarten: [SetCard] { model.kaarten }
    var deck: [SetCard] { model.deck }
    var scores: [Int] { model.scores }
    var aantalKaartenInDeck: Int { model.aantalKaartenInDeck }
    
    private func activeerOefenModus() {
        actieveSpeler = 0
        magKaartenSelecteren = true
        selectieTijdResterend = 10.0
        
        selectieTimer?.invalidate()
        selectieTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.selectieTijdResterend > 0 {
                self.selectieTijdResterend -= 0.1
            } else {
                self.beeindigBeurt()
                if self.spelModus == .oefenen {
                    self.activeerOefenModus()
                }
            }
        }
    }
    
    func isKaartInOrigineleSet(_ kaart: SetCard) -> Bool {
        if case .superSetKeuze(let geldigeSet, _) = spelStatus {
            return geldigeSet.contains(kaart)
        }
        if case .superSetSelectie(let origineleSet, _) = spelStatus {
            return origineleSet.contains(kaart)
        }
        if case .superSetKaartenKiezen(let origineleSet, _, _) = spelStatus {
            return origineleSet.contains(kaart)
        }
        return false
    }
    
    func isKaartGeselecteerdVoorSuperSet(_ kaart: SetCard) -> Bool {
        return geselecteerdeKaartVoorSuperSet == kaart
    }
    
    func verwerkSpelerPosities(_ posities: [SpelerPositie: SpelerAvatar]) {
        spelerAvatars = posities
        spelerPosities = Array(posities.keys)
        spelFase = .spelen
        model = SetGameModel(aantalSpelers: spelModus.aantalSpelers)
    }

    func selecteerSpeler(_ spelerIndex: Int) {
        guard !geblokkeerdeSpelers.contains(spelerIndex) else { return }
        guard actieveSpeler == nil || actieveSpeler == spelerIndex else { return }
           
        actieveSpeler = spelerIndex
        magKaartenSelecteren = true
        geselecteerdeKaarten.removeAll()
        aantalGeselecteerdeKaarten = 0
    }
    
    func wisselWillekeurigeKaart() {
        guard !kaarten.isEmpty, !deck.isEmpty else { return }
        let willekeurigeIndex = Int.random(in: 0..<kaarten.count)
        if let nieuweKaart = deck.last {
            model.wisselKaart(opIndex: willekeurigeIndex, metNieuweKaart: nieuweKaart)
            updateAantalMogelijkeSets()
            if model.aantalKaartenInDeck == 0 && !heeftGeldigeSet() {
                eindSpel()
            }
        }
    }

    private func beeindigBeurt() {
        selectieTimer?.invalidate()
        selectieTimer = nil
        magKaartenSelecteren = false
        
        if let huidigeSpeler = actieveSpeler {
            geblokkeerdeSpelers = geblokkeerdeSpelers.filter { $0 == huidigeSpeler }
        }
        
        actieveSpeler = nil
        selectieTijdResterend = 0
        geselecteerdeKaarten.removeAll()
        aantalGeselecteerdeKaarten = 0
        
        if model.aantalKaartenInDeck == 0 && !heeftGeldigeSet() {
            eindSpel()
        }
        
        if spelModus == .oefenen {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.activeerOefenModus()
            }
        }
    }

    func selecteerKaart(_ kaart: SetCard) {
        guard magKaartenSelecteren else { return }
        
        switch spelStatus {
        case .normaalSpel:
            if geselecteerdeKaarten.contains(kaart) {
                if let index = geselecteerdeKaarten.firstIndex(of: kaart) {
                    geselecteerdeKaarten.remove(at: index)
                    aantalGeselecteerdeKaarten -= 1
                }
            } else if aantalGeselecteerdeKaarten < 3 {
                geselecteerdeKaarten.append(kaart)
                aantalGeselecteerdeKaarten += 1
                
                if aantalGeselecteerdeKaarten == 3 {
                    controleerSet()
                }
            }
            
        case .superSetSelectie(let origineleSet, let spelerMetSet):
            if origineleSet.contains(kaart) {
                geselecteerdeKaartVoorSuperSet = kaart
                spelStatus = .superSetKaartenKiezen(origineleSet: origineleSet,
                                                  geselecteerdeKaart: kaart,
                                                  spelerMetSet: spelerMetSet)
                superSetKaarten = [kaart]
            }
            
        case .superSetKaartenKiezen(let origineleSet, _, let spelerMetSet):
            if !origineleSet.contains(kaart) && !superSetKaarten.contains(kaart) {
                var nieuweKaarten = superSetKaarten
                nieuweKaarten.append(kaart)
                superSetKaarten = nieuweKaarten  // Forceert een update
                
                if superSetKaarten.count == 3 {
                    controleerSuperSet(origineleSet: origineleSet, spelerMetSet: spelerMetSet)
                }
            }
            
        case .superSetKeuze:
            break
        }
    }

    private func controleerSet() {
        guard let actieveSpeler = actieveSpeler else { return }
        
        if model.isSet(geselecteerdeKaarten) {
            toonGeldigeSet = true
            laatsteGevondenSet = geselecteerdeKaarten
            resetHints()
            
            // Controleer eindspel na een geldige set
            if model.aantalKaartenInDeck == 0 && !heeftGeldigeSet() {
                eindSpel()
                return
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.toonGeldigeSet = false
                self.toonSuperSetKeuze = true
                self.spelStatus = .superSetKeuze(geldigeSet: self.geselecteerdeKaarten, spelerMetSet: actieveSpeler)
                self.magKaartenSelecteren = true
                self.selectieTijdResterend = 20.0
            }
            updateAantalMogelijkeSets()
        } else {
            // Ongeldige set - hier komt de aanpassing
            toonOngeldigeSet = true
            
            // Alleen in multiplayer blokkeren we de speler
            if spelModus != .oefenen {
                geblokkeerdeSpelers.insert(actieveSpeler)
            }
            
            // Reset hints na een ongeldige set
            resetHints()
            
            beeindigBeurt()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.toonOngeldigeSet = false
            }
        }
    }

    func kiesSuperSet() {
        if case .superSetKeuze(let geldigeSet, let spelerMetSet) = spelStatus {
            spelStatus = .superSetSelectie(origineleSet: geldigeSet, spelerMetSet: spelerMetSet)
            superSetKaarten.removeAll()
            geselecteerdeKaartVoorSuperSet = nil
            toonSuperSetKeuze = false
            inSuperSetMode = true
            actieveSpeler = spelerMetSet
            magKaartenSelecteren = true
            selectieTijdResterend = 20.0
        }
    }
    
    func behoudNormaleSet() {
        if case .superSetKeuze(let geldigeSet, let spelerMetSet) = spelStatus {
            model.updateScore(voor: spelerMetSet, met: 3)
            model.verwijderSet(geldigeSet)
            beeindigSuperSetPoging()
        }
    }
    
    private func controleerSuperSet(origineleSet: [SetCard], spelerMetSet: Int) {
        if model.isSet(superSetKaarten) {
            isSuccesvolSuperSet = true
            model.updateScore(voor: spelerMetSet, met: 10)
            model.verwijderSet(superSetKaarten)
        } else {
            isSuccesvolSuperSet = false
            model.updateScore(voor: spelerMetSet, met: 0)
        }
        
        toonSuperSetResultaat = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.toonSuperSetResultaat = false
            self.beeindigSuperSetPoging()
        }
    }
    
    private func beeindigSuperSetPoging() {
        spelStatus = .normaalSpel
        laatsteGevondenSet = nil
        geselecteerdeKaarten.removeAll()
        superSetKaarten.removeAll()
        aantalGeselecteerdeKaarten = 0
        geselecteerdeKaartVoorSuperSet = nil
        toonSuperSetKans = false
        toonSuperSetKeuze = false
        inSuperSetMode = false
        beeindigBeurt()
    }

    func isSpelerGeblokkeerd(_ spelerIndex: Int) -> Bool {
        return geblokkeerdeSpelers.contains(spelerIndex)
    }

    func resetAlleState() {
        // Stop alle timers
        timer?.invalidate()
        timer = nil
        selectieTimer?.invalidate()
        selectieTimer = nil
        superSetTimer?.invalidate()
        superSetTimer = nil
        verlichtTimer?.invalidate()
        verlichtTimer = nil
        timerCancellable?.cancel()
        timerCancellable = nil
        
        // Reset alle state variabelen
        geselecteerdeKaarten.removeAll()
        superSetKaarten.removeAll()
        geselecteerdeKaartVoorSuperSet = nil
        toonGeldigeSet = false
        toonOngeldigeSet = false
        toonSuperSetKans = false
        toonSuperSetResultaat = false
        geblokkeerdeSpelers.removeAll()
        eindSpelStatistieken = nil
        spelStatus = .normaalSpel
    }

    func naarHoofdmenu() {
        resetAlleState()
        model = SetGameModel()
        spelFase = .startScherm
    }

    func startNieuwSpel(modus: SpelModus) {
        resetAlleState()
        model = SetGameModel(aantalSpelers: modus.aantalSpelers)
        self.spelModus = modus
        
        if modus == .oefenen {
            spelFase = .spelen
            activeerOefenModus()
            startTimer() // Alleen timer starten in oefenmodus
        } else {
            spelFase = .positieKiezen
        }
    }

    func schakelPauze() {
        isPauze.toggle()
        if isPauze {
            timer?.invalidate()
            selectieTimer?.invalidate()
            superSetTimer?.invalidate()
        } else {
            startTimer()
        }
    }

    private func startTimer() {
        // Alleen timer starten als we in oefenmodus zijn
        guard spelModus == .oefenen else { return }
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if !self.isPauze {
                if self.tijdResterend > 0 {
                    self.tijdResterend -= 1
                } else {
                    self.model.deelEenKaart()
                    self.tijdResterend = 45
                }
            }
        }
    }
    private func vindGeldigeSet() -> [SetCard]? {
           let alleKaarten = kaarten
           for i in 0..<alleKaarten.count {
               for j in (i+1)..<alleKaarten.count {
                   for k in (j+1)..<alleKaarten.count {
                       let mogelijkeSet = [alleKaarten[i], alleKaarten[j], alleKaarten[k]]
                       if model.isSet(mogelijkeSet) {
                           return mogelijkeSet
                       }
                   }
               }
           }
           return nil
       }
    func geefHint() {
            guard spelModus == .oefenen else { return }
            guard aantalHintsGetoond < 2 else { return }
            
            if hintKaarten.isEmpty {
                if let geldigeSet = vindGeldigeSet() {
                    hintKaarten = geldigeSet
                }
            }
            
            if !hintKaarten.isEmpty {
                aantalHintsGetoond += 1
            }
        }
        
        func resetHints() {
            hintKaarten.removeAll()
            aantalHintsGetoond = 0
        }
    
    private func heeftGeldigeSet() -> Bool {
        let alleKaarten = kaarten
        for i in 0..<alleKaarten.count {
            for j in (i+1)..<alleKaarten.count {
                for k in (j+1)..<alleKaarten.count {
                    let mogelijkeSet = [alleKaarten[i], alleKaarten[j], alleKaarten[k]]
                    if model.isSet(mogelijkeSet) {
                        return true
                    }
                }
            }
        }
        return false
    }
    
    private func eindSpel() {
        // Stop alle timers
        timer?.invalidate()
        selectieTimer?.invalidate()
        superSetTimer?.invalidate()
        
        // Bepaal de winnaar(s)
        let hoogsteScore = scores.max() ?? 0
        let winnaars = scores.enumerated().filter { $0.element == hoogsteScore }.map { $0.offset }
        
        // Voor zowel oefenmodus als multiplayer
        eindSpelStatistieken = EindSpelStats(
            scores: scores,
            gevondenSets: model.totaalGevondenSets,
            superSets: model.totaalSuperSets,
            speelTijd: model.speelTijd,
            winnaar: spelModus == .oefenen ? 0 : (winnaars.count == 1 ? winnaars[0] : nil)
        )
        
        speelEindspelMuziek()  // Dit werkt nu voor beide modi
        spelFase = .eindSpel    // Dit triggert de confetti voor beide modi
    }

    func toonEenSet() {
        // Vind eerst een geldige set
        let alleKaarten = kaarten
        for i in 0..<alleKaarten.count {
            for j in (i+1)..<alleKaarten.count {
                for k in (j+1)..<alleKaarten.count {
                    let mogelijkeSet = [alleKaarten[i], alleKaarten[j], alleKaarten[k]]
                    if model.isSet(mogelijkeSet) {
                        // Gevonden! Start de animatie
                        huidigeSetVoorDemo = mogelijkeSet
                        huidigeSetIndex = 0
                        verlichtVolgendeKaart()
                        return
                    }
                }
            }
        }
    }

    private func verlichtVolgendeKaart() {
        guard huidigeSetIndex < huidigeSetVoorDemo.count else {
            // Reset alles als we klaar zijn
            verlichtKaart = nil
            huidigeSetVoorDemo = []
            return
        }
        
        // Verlicht de huidige kaart
        verlichtKaart = huidigeSetVoorDemo[huidigeSetIndex]
        
        // Plan de volgende verlichting
        verlichtTimer?.invalidate()
        verlichtTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { [weak self] _ in
            self?.huidigeSetIndex += 1
            self?.verlichtVolgendeKaart()
        }
    }

    private func updateAantalMogelijkeSets() {
        aantalMogelijkeSets = model.aantalMogelijkeSets()
    }
    
    private func speelEindspelMuziek() {
        DispatchQueue.global().async {
            // Speel een vrolijk deuntje met verschillende tonen
            AudioServicesPlaySystemSound(1326)  // Positief geluid
            Thread.sleep(forTimeInterval: 0.2)
            AudioServicesPlaySystemSound(1327)  // Oplopende toon
            Thread.sleep(forTimeInterval: 0.2)
            AudioServicesPlaySystemSound(1328)  // Finale toon
        }
    }

    // Controleer of alle timers correct worden opgeruimd
    private func cleanupTimers() {
        timer?.invalidate()
        selectieTimer?.invalidate()
        superSetTimer?.invalidate()
        verlichtTimer?.invalidate()
        timerCancellable?.cancel()
    }

    // Voeg deze aanroep toe in deinit en waar nodig
    deinit {
        cleanupTimers()
    }

    // Laad geluiden efficiënter
    private func configureAudio() {
        // Vooraf laden van geluidsbestanden
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Audio configuratie fout: \(error)")
        }
    }

    // Voeg een dispose functie toe
    func dispose() {
        cleanupTimers()
        model = SetGameModel()
        resetAlleState()
    }

    func testEindAnimatie() {
        // Simuleer een spel met 4 spelers waar de Panda wint
        spelModus = .vierSpelers
        spelFase = .positieKiezen
        
        // Configureer de spelers met de Panda als winnaar
        spelerAvatars = [
            .linksBoven: .uil,
            .rechtsBoven: .vos,
            .linksOnder: .leeuw,
            .rechtsOnder: .panda
        ]
        spelerPosities = [.linksBoven, .rechtsBoven, .linksOnder, .rechtsOnder]
        
        // Stel de scores in (Panda wint met 60 punten)
        model = SetGameModel(aantalSpelers: 4)
        model.testScores(winnaar: 3, score: 60)  // Verander index naar 3 voor panda
        
        // Toon het eindscherm
        eindSpelStatistieken = EindSpelStats(
            scores: [0, 0, 0, 60],  // Verplaats de 60 punten naar laatste positie
            gevondenSets: 20,
            superSets: 6,
            speelTijd: 300,
            winnaar: 3  // Verander naar index 3 voor panda
        )
        
        spelFase = .eindSpel
    }

    func beeindigHuidigSpel() {
        // Gebruik de huidige spel status in plaats van test data
        if let actieveSpeler = actieveSpeler {
            eindSpelStatistieken = EindSpelStats(
                scores: scores,
                gevondenSets: model.totaalGevondenSets,
                superSets: model.totaalSuperSets,
                speelTijd: model.speelTijd,
                winnaar: actieveSpeler
            )
            spelFase = .eindSpel
        }
    }
}
// MARK: - 3. Model
struct SetGameModel {
    private(set) var kaarten: [SetCard] = []
    private(set) var deck: [SetCard] = []
    private(set) var scores: [Int]
    private(set) var huidigeSpeler = 0
    var aantalKaartenInDeck: Int { deck.count }
    private(set) var totaalGevondenSets: Int = 0
    private(set) var totaalSuperSets: Int = 0
    private(set) var startTijd: Date = Date()
    
    var speelTijd: TimeInterval {
        return Date().timeIntervalSince(startTijd)
    }
    
    init(aantalSpelers: Int = 1) {
        scores = Array(repeating: 0, count: max(1, aantalSpelers))
        resetSpel()
    }
    
    mutating func resetSpel() {
        kaarten.removeAll()
        deck.removeAll()
        scores = Array(repeating: 0, count: scores.count)
        huidigeSpeler = 0
        
        // Maak een Set om unieke kaarten te garanderen
        var uniqueCards = Set<SetCard>()
        
        // Maak alle 81 unieke kaarten (3x3x3x3 = 81)
        for aantal in 1...3 {
            for kleur in SetCard.CardKleur.allCases {
                for vorm in SetCard.CardVorm.allCases {
                    for vulling in SetCard.CardVulling.allCases {
                        let kaart = SetCard(aantal: aantal, kleur: kleur, vorm: vorm, vulling: vulling)
                        uniqueCards.insert(kaart)
                    }
                }
            }
        }
        
        // Converteer naar array en shuffle
        deck = Array(uniqueCards)
        assert(deck.count == 81, "Deck moet exact 81 kaarten bevatten!")
        
        deck.shuffle()
        
        // Trek precies 12 kaarten
        for _ in 0..<12 {
            guard let kaart = deck.popLast() else {
                fatalError("Niet genoeg kaarten in deck!")
            }
            kaarten.append(kaart)
        }
        
        assert(kaarten.count == 12, "Er moeten exact 12 kaarten op tafel liggen!")
        assert(Set(kaarten).count == kaarten.count, "Er zijn dubbele kaarten op tafel!")
    }
    
    mutating func deelDrieKaarten() {
        // Stop als we al 12 kaarten hebben of als het deck leeg is
        guard kaarten.count < 12, !deck.isEmpty else { return }
        
        let ruimteOver = 12 - kaarten.count
        let aantalTeDelenKaarten = min(3, min(ruimteOver, deck.count))
        
        for _ in 0..<aantalTeDelenKaarten {
            guard let kaart = deck.popLast() else { break }
            kaarten.append(kaart)
        }
        
        assert(kaarten.count <= 12, "Er mogen niet meer dan 12 kaarten op tafel liggen!")
        assert(Set(kaarten).count == kaarten.count, "Er zijn dubbele kaarten op tafel!")
    }
    
    mutating func deelEenKaart() {
        // Stop als we al 12 kaarten hebben of als het deck leeg is
        guard kaarten.count < 12, !deck.isEmpty else { return }
        
        if let kaart = deck.popLast() {
            kaarten.append(kaart)
        }
        
        assert(kaarten.count <= 12, "Er mogen niet meer dan 12 kaarten op tafel liggen!")
        assert(Set(kaarten).count == kaarten.count, "Er zijn dubbele kaarten op tafel!")
    }
    
    func isSet(_ geselecteerdeKaarten: [SetCard]) -> Bool {
        guard geselecteerdeKaarten.count == 3 else { return false }
        
        // Eerst controleren of er geen dubbele kaarten zijn
        if Set(geselecteerdeKaarten).count != 3 { return false }
        
        let aantallen = Set(geselecteerdeKaarten.map { $0.aantal })
        let kleuren = Set(geselecteerdeKaarten.map { $0.kleur })
        let vormen = Set(geselecteerdeKaarten.map { $0.vorm })
        let vullingen = Set(geselecteerdeKaarten.map { $0.vulling })
        
        return (aantallen.count == 1 || aantallen.count == 3) &&
               (kleuren.count == 1 || kleuren.count == 3) &&
               (vormen.count == 1 || vormen.count == 3) &&
               (vullingen.count == 1 || vullingen.count == 3)
    }
    
    mutating func verwijderSet(_ setKaarten: [SetCard]) {
        // Verwijder de gevonden set
        kaarten.removeAll { setKaarten.contains($0) }
        
        // Deel nieuwe kaarten als er minder dan 12 kaarten liggen
        // EN als er nog kaarten in het deck zijn
        if kaarten.count < 12 && !deck.isEmpty {
            deelDrieKaarten()
        }
        
        assert(kaarten.count <= 12, "Er mogen niet meer dan 12 kaarten op tafel liggen!")
        assert(Set(kaarten).count == kaarten.count, "Er zijn dubbele kaarten op tafel!")
        totaalGevondenSets += 1
    }
    
    mutating func updateScore(voor speler: Int, met hoeveelheid: Int) {
        guard speler >= 0 && speler < scores.count else { return }
        scores[speler] += hoeveelheid
    }
    
    mutating func wisselKaart(opIndex index: Int, metNieuweKaart nieuweKaart: SetCard) {
        guard index < kaarten.count else { return }
        kaarten.remove(at: index)
        kaarten.insert(nieuweKaart, at: index)
        _ = deck.popLast() // Verwijder de nieuwe kaart uit het deck
        
        assert(kaarten.count <= 12, "Er mogen niet meer dan 12 kaarten op tafel liggen!")
        assert(Set(kaarten).count == kaarten.count, "Er zijn dubbele kaarten op tafel!")
    }
    
    mutating func verwerkSuperSet() {
        totaalSuperSets += 1
    }
    
    func aantalMogelijkeSets() -> Int {
        var aantalSets = 0
        let alleKaarten = kaarten
        
        // Check alle mogelijke combinaties van 3 kaarten
        for i in 0..<alleKaarten.count {
            for j in (i+1)..<alleKaarten.count {
                for k in (j+1)..<alleKaarten.count {
                    let mogelijkeSet = [alleKaarten[i], alleKaarten[j], alleKaarten[k]]  // Extra ] verwijderd
                    if isSet(mogelijkeSet) {
                        aantalSets += 1
                    }
                }
            }
        }
        return aantalSets
    }
    
    mutating func testScores(winnaar: Int, score: Int) {
        scores = Array(repeating: 0, count: scores.count)  // Reset alle scores
        scores[winnaar] = score  // Zet de score voor de winnaar
    }
}
// MARK: - 4. Views
struct VoorbeeldKaart: View {
    let id = UUID()
    let aantal: Int
    let kleur: SetCard.CardKleur
    let vorm: SetCard.CardVorm
    let vulling: SetCard.CardVulling
    
    var body: some View {
        KaartView(
            kaart: SetCard(
                aantal: aantal,
                kleur: kleur,
                vorm: vorm,
                vulling: vulling
            ),
            isGeselecteerd: false,
            isVerlicht: false,
            viewModel: SetGameViewModel()
        )
        .frame(width: 80, height: 120)
    }
}
// MARK: - GameContentView
struct GameContentView: View {
    @StateObject var viewModel = SetGameViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            switch viewModel.spelFase {
            case .startScherm:
                StartScherm(viewModel: viewModel)
            case .positieKiezen:
                PositieKeuzeView(viewModel: viewModel)
            case .spelen:
                SpelScherm(viewModel: viewModel, geometry: geometry)
            case .eindSpel:
                EindSpelOverlay(viewModel: viewModel)
            }
        }
    }
}
// MARK: - Scherm
struct StartScherm: View {
    @ObservedObject var viewModel: SetGameViewModel
    @State private var toonSpeluitleg = false
    @State private var toonSuperSetUitleg = false
    @State private var voorbeeldSetNummer = 1
    @State private var animationOffset = 0.0
    @State private var hoverButton: Int? = nil
    
    // Levendigere kleuren
    let gradientColors: [Color] = [
        Color(red: 0.2, green: 0.6, blue: 1.0),    // Helder blauw
        Color(red: 0.8, green: 0.3, blue: 1.0),    // Paars
        Color(red: 0.2, green: 0.8, blue: 0.8),    // Turquoise
        Color(red: 0.1, green: 0.4, blue: 0.9)     // Koningsblauw
    ]
    
    var body: some View {
        ZStack {
            // Dynamische achtergrond
            GeometryReader { geometry in
                ZStack {
                    // Bewegende gradiënt achtergrond
                    LinearGradient(colors: gradientColors, startPoint: .topLeading, endPoint: .bottomTrailing)
                        .opacity(0.7)
                        .blur(radius: 20)
                    
                    // Animerende cirkels op de achtergrond
                    ForEach(0..<5) { index in
                        Circle()
                            .fill(gradientColors[index % gradientColors.count])
                            .frame(width: geometry.size.width * CGFloat(0.5 + Double(index) * 0.1))
                            .offset(
                                x: sin(animationOffset + Double(index) * 0.5) * 100,
                                y: cos(animationOffset + Double(index) * 0.5) * 100
                            )  // Verwijder extra )
                            .blur(radius: 30)
                            .opacity(0.4)
                    }
                }
                .ignoresSafeArea()
            }
            
            // Content
            VStack(spacing: 30) {
                Text(LocalizationManager.text("title"))
                    .font(.system(size: 50, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(color: .blue, radius: 10, x: 0, y: 0)
                    .padding(.top, 40)
                
                Spacer()
                
                // Moderne horizontale banen
                VStack(spacing: 25) {
                    ForEach(0..<3) { index in
                        MenuButton(
                            icon: menuIcons[index],
                            title: menuTitles[index],
                            subtitle: menuSubtitles[index],
                            isHovered: hoverButton == index,
                            gradientColors: buttonGradients[index],
                            action: {
                                handleMenuAction(index)
                            }
                        )
                        .onHover { isHovered in
                            withAnimation(.easeInOut(duration: 0.2)) {
                                hoverButton = isHovered ? index : nil
                            }
                        }
                    }
                }
                .padding(.horizontal, 25)
                
                Spacer()
                
                // Test knop voor eindanimatie
                Button(action: {
                    viewModel.beeindigHuidigSpel()
                }) {
                    Text("End Game 🏁")  // Verander de tekst van de knop
                        .font(.headline)
                        .padding()
                        .background(Color.red.opacity(0.7))  // Verander de kleur naar rood
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.bottom, 20)
            }
            
            if toonSpeluitleg {
                speluitlegOverlay
            }
        }
        .onAppear {
            // Start de achtergrondanimatie
            withAnimation(.linear(duration: 20).repeatForever(autoreverses: false)) {
                animationOffset = 4 * .pi
            }
        }
    }
    
    private let menuIcons = ["questionmark.circle.fill", "graduationcap.fill", "figure.run.circle.fill"]
    
    private let menuTitles = [
        "Learn SET",
        "Practice Mode",
        "Multiplayer"
    ]
    
    private let menuSubtitles = [
        "Learn the basics & SUPERset",
        "Train your skills",
        "Play with friends"
    ]
    
    // Kleurrijke gradiënten voor elke knop
    private let buttonGradients: [[Color]] = [
        [Color(red: 1.0, green: 0.5, blue: 0.0), Color(red: 1.0, green: 0.7, blue: 0.0)],  // Oranje/Goud
        [Color(red: 0.0, green: 0.8, blue: 0.4), Color(red: 0.0, green: 0.6, blue: 0.8)],  // Groen/Blauw
        [Color(red: 0.8, green: 0.2, blue: 0.8), Color(red: 0.6, green: 0.0, blue: 1.0)]   // Paars/Violet
    ]
    
    private func handleMenuAction(_ index: Int) {
        switch index {
        case 0:
            withAnimation { toonSpeluitleg = true }
        case 1:
            withAnimation { viewModel.startNieuwSpel(modus: .oefenen) }
        case 2:
            withAnimation { viewModel.startNieuwSpel(modus: .vierSpelers) }
        default:
            break
        }
    }
    
    private var speluitlegOverlay: some View {
        ZStack {
            Color.black.opacity(0.8)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 30) {
                    Text("Learn SET & SUPERset")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.top, 40)
                    
                    // SET uitleg
                    VStack(spacing: 20) {
                        Text("What is a SET?")
                            .font(.title)
                            .foregroundColor(.yellow)
                        
                        Group {
                            switch voorbeeldSetNummer {
                            case 1:
                                Text(LocalizationManager.text("set_type_1"))
                                    .foregroundColor(.white)
                            case 2:
                                Text(LocalizationManager.text("set_type_2"))
                                    .foregroundColor(.white)
                            case 3:
                                Text(LocalizationManager.text("set_type_3"))
                                    .foregroundColor(.white)
                            case 4:
                                Text(LocalizationManager.text("set_type_4"))
                                    .foregroundColor(.white)
                            default:
                                EmptyView()
                            }
                            
                            HStack(spacing: 15) {
                                ForEach(voorbeeldSet(), id: \.id) { kaart in
                                    kaart
                                }
                            }
                            .padding(.vertical)
                        }
                        
                        // SUPERset uitleg
                        if voorbeeldSetNummer == 4 {
                            VStack(spacing: 20) {
                                Text("What is a SUPERset?")
                                    .font(.title)
                                    .foregroundColor(.purple)
                                    .padding(.top)
                                
                                Text("A SUPERset is a special challenge that appears after finding a normal SET!")
                                    .foregroundColor(.white)
                                
                                Text("When you find a SET, you can choose to:")
                                    .foregroundColor(.white)
                                
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("• Keep your 3 points")
                                    Text("• Try for a SUPERset worth 10 points!")
                                    Text("• But be careful: if you fail, you get NO points!")
                                }
                                .foregroundColor(.white)
                                .padding()
                                
                                Text("To make a SUPERset:")
                                    .foregroundColor(.white)
                                
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("1. Select one card from your SET")
                                    Text("2. Find two new cards that make a SET")
                                    Text("3. Success = 10 points! ⭐️")
                                }
                                .foregroundColor(.white)
                                .padding()
                            }
                        }
                    }
                    
                    if voorbeeldSetNummer < 4 {
                        Button(LocalizationManager.text("show_more")) {
                            withAnimation {
                                voorbeeldSetNummer += 1
                            }
                        }
                        .buttonStyle(GlowingButtonStyle(color: .blue))
                    }
                    
                    Button(voorbeeldSetNummer == 4 ? LocalizationManager.text("play_now") : LocalizationManager.text("skip")) {
                        withAnimation {
                            toonSpeluitleg = false
                            voorbeeldSetNummer = 1
                        }
                    }
                    .buttonStyle(GlowingButtonStyle(color: .green))
                }
                .padding(30)
            }
        }
    }
    
    private func voorbeeldSet() -> [VoorbeeldKaart] {
        switch voorbeeldSetNummer {
        case 1:
            return [
                VoorbeeldKaart(aantal: 1, kleur: .rood, vorm: .ruit, vulling: .volledig),
                VoorbeeldKaart(aantal: 2, kleur: .rood, vorm: .ruit, vulling: .volledig),
                VoorbeeldKaart(aantal: 3, kleur: .rood, vorm: .ruit, vulling: .volledig)
            ]
        case 2:
            return [
                VoorbeeldKaart(aantal: 1, kleur: .rood, vorm: .ruit, vulling: .volledig),
                VoorbeeldKaart(aantal: 2, kleur: .rood, vorm: .rechthoek, vulling: .volledig),
                VoorbeeldKaart(aantal: 3, kleur: .rood, vorm: .ovaal, vulling: .volledig)
            ]
        case 3:
            return [
                VoorbeeldKaart(aantal: 1, kleur: .rood, vorm: .ruit, vulling: .volledig),
                VoorbeeldKaart(aantal: 2, kleur: .groen, vorm: .rechthoek, vulling: .volledig),
                VoorbeeldKaart(aantal: 3, kleur: .paars, vorm: .ovaal, vulling: .volledig)
            ]
        case 4:
            return [
                VoorbeeldKaart(aantal: 1, kleur: .rood, vorm: .ruit, vulling: .volledig),
                VoorbeeldKaart(aantal: 2, kleur: .groen, vorm: .rechthoek, vulling: .leeg),
                VoorbeeldKaart(aantal: 3, kleur: .paars, vorm: .ovaal, vulling: .gestippeld)
            ]
        default:
            return []
        }
    }
}

struct MenuButton: View {
    let icon: String
    let title: String
    let subtitle: String
    let isHovered: Bool
    let gradientColors: [Color]
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 35, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 70)
                    .shadow(color: .black.opacity(0.3), radius: 5)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.title2.bold())
                        .foregroundColor(.white)
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                    .opacity(isHovered ? 1 : 0.7)
                    .scaleEffect(isHovered ? 1.2 : 1.0)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(LinearGradient(
                        colors: gradientColors,
                        startPoint: .leading,
                        endPoint: .trailing
                    ))
                    .opacity(isHovered ? 0.9 : 0.7)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white.opacity(0.3), lineWidth: 2)
                    )
                    .shadow(color: gradientColors[0].opacity(0.5), radius: isHovered ? 15 : 5)
            )
            .scaleEffect(isHovered ? 1.03 : 1)
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isHovered)
    }
}

struct PositieKeuzeView: View {
    @ObservedObject var viewModel: SetGameViewModel
    @State private var geselecteerdeAvatars: [SetGameViewModel.SpelerPositie: SetGameViewModel.SpelerAvatar] = [:]
    @State private var beschikbareAvatars = SetGameViewModel.SpelerAvatar.allCases
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.9).ignoresSafeArea()
            
            VStack {
                Text("Choose your avatars!")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(color: .blue, radius: 10)
                    .padding(.top, 20)
                
                Text("Drag an animal to your corner!")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding()
                
                // Speelveld met avatars en dropzones
                GeometryReader { geometry in
                    ZStack {
                        // Dropzones in de hoeken
                        ForEach(viewModel.spelModus.posities, id: \.self) { positie in
                            let position = dropZonePosition(for: positie, in: geometry)
                            DropZone(
                                positie: positie,
                                geselecteerdeAvatars: $geselecteerdeAvatars,
                                beschikbareAvatars: $beschikbareAvatars
                            )
                            .position(x: position.x, y: position.y)
                        }
                        
                        // Cirkel van avatars in het midden
                        ForEach(Array(beschikbareAvatars.enumerated()), id: \.element) { index, avatar in
                            let angle = 2 * .pi * Double(index) / Double(beschikbareAvatars.count)
                            let radius: CGFloat = 150  // Was 200, nu 150
                            
                            AvatarView(avatar: avatar)
                                .draggable(avatar.rawValue) {
                                    AvatarView(avatar: avatar)
                                        .frame(width: 100, height: 100)  // Was 200x200, nu 100x100
                                }
                                .offset(
                                    x: cos(angle) * radius,
                                    y: sin(angle) * radius
                                )
                                .scaleEffect(1.2)  // Was 1.5, nu 1.2
                        }
                    }
                }
                
                // Start Game knop
                if geselecteerdeAvatars.count >= 2 {  // Simpele check voor 2 spelers
                    Button(action: {
                        viewModel.verwerkSpelerPosities(geselecteerdeAvatars)
                    }) {
                        Text("START GAME!")
                            .font(.title.bold())
                            .padding()
                            .frame(width: 300)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(15)
                    }
                    .padding(.bottom, 40)
                }
            }
        }
    }
    
    private func dropZonePosition(for positie: SetGameViewModel.SpelerPositie, in geometry: GeometryProxy) -> CGPoint {
        let padding: CGFloat = 50
        switch positie {
        case .linksBoven: return CGPoint(x: padding, y: padding)
        case .rechtsBoven: return CGPoint(x: geometry.size.width - padding, y: padding)
        case .linksOnder: return CGPoint(x: padding, y: geometry.size.height - padding)
        case .rechtsOnder: return CGPoint(x: geometry.size.width - padding, y: geometry.size.height - padding)
        }
    }
}

struct AvatarView: View {
    let avatar: SetGameViewModel.SpelerAvatar
    
    var body: some View {
        VStack {
            Text(avatar.rawValue)
                .font(.system(size: 50))  // Was 50, nu 50
            Text(avatar.vertaaldeNaam)
                .font(.title3)  // Was caption, nu title3
                .foregroundColor(.white)
        }
        .padding(10)  // Was 15, nu 10
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.blue.opacity(0.2))
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.blue.opacity(0.5), lineWidth: 2)
                )
        )
    }
}

struct DropZone: View {
    let positie: SetGameViewModel.SpelerPositie
    @Binding var geselecteerdeAvatars: [SetGameViewModel.SpelerPositie: SetGameViewModel.SpelerAvatar]
    @Binding var beschikbareAvatars: [SetGameViewModel.SpelerAvatar]
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.blue.opacity(0.2))
                .frame(width: 150, height: 150)
            
            if let avatar = geselecteerdeAvatars[positie] {
                // Toon geplaatste avatar
                AvatarView(avatar: avatar)
                    .onTapGesture {
                        // Verwijder avatar en zet terug in beschikbare avatars
                        beschikbareAvatars.append(avatar)
                        geselecteerdeAvatars.removeValue(forKey: positie)
                    }
            } else {
                VStack {
                    Image(systemName: "arrow.down.circle.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.blue)
                    Text("DROP HERE")
                        .font(.headline)
                        .foregroundColor(.white)
                }
            }
        }
        .dropDestination(for: String.self) { items, _ in
            guard let avatarString = items.first,
                  let avatar = SetGameViewModel.SpelerAvatar(rawValue: avatarString),
                  beschikbareAvatars.contains(avatar) else {
                return false
            }
            
            // Verwijder oude avatar als die er was
            if let oudeAvatar = geselecteerdeAvatars[positie] {
                beschikbareAvatars.append(oudeAvatar)
            }
            
            // Update selecties
            geselecteerdeAvatars[positie] = avatar
            beschikbareAvatars.removeAll { $0 == avatar }
            
            return true
        }
    }
}

struct SpelScherm: View {
    @ObservedObject var viewModel: SetGameViewModel
    let geometry: GeometryProxy
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack {
                // Speelveld met kaarten
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 10) {
                    ForEach(viewModel.kaarten) { kaart in
                        KaartView(
                            kaart: kaart,
                            isGeselecteerd: viewModel.geselecteerdeKaarten.contains(kaart),
                            isVerlicht: viewModel.verlichtKaart == kaart,
                            viewModel: viewModel
                        )
                        .aspectRatio(2/3, contentMode: .fit)
                        .onTapGesture {
                            viewModel.selecteerKaart(kaart)
                        }
                        .disabled(!viewModel.magKaartenSelecteren)
                    }
                }
                .padding()
                
                if viewModel.spelModus == .oefenen {
                    HStack(spacing: 15) {
                        Button(action: {
                            viewModel.geefHint()
                        }) {
                            Text("HINT")
                                .font(.headline)
                                .padding()
                                .background(Color.orange)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .disabled(viewModel.aantalHintsGetoond >= 2)
                        .opacity(viewModel.aantalHintsGetoond >= 2 ? 0.5 : 1)
                        
                        Text("\(viewModel.aantalMogelijkeSets) SETS")
                            .font(.headline)
                            .padding()
                            .background(Color.purple.opacity(0.7))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .onTapGesture {
                                viewModel.toonEenSet()
                            }
                    }
                    .padding()
                }
                
                // Spelinfo
                HStack {
                    if viewModel.spelModus == .oefenen {
                        Text("Tijd: \(viewModel.tijdResterend)")
                            .font(.headline)
                        Spacer()
                    }
                }
                .padding()
                
                // Knoppen
                HStack {
                    Button(LocalizationManager.text("switch_card")) {
                        viewModel.wisselWillekeurigeKaart()
                    }
                    .padding()
                    .background(Color.blue.opacity(0.3))
                    .foregroundColor(.white)
                    .cornerRadius(10)

                    // Deck teller in het midden
                    Text("In deck: \(viewModel.aantalKaartenInDeck)")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue.opacity(0.3))
                        .cornerRadius(10)

                    Button(LocalizationManager.text("new_game")) {
                        viewModel.spelFase = .startScherm
                    }
                    .padding()
                    .background(Color.blue.opacity(0.3))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(.top)
                .padding(.bottom, 5)
            }
            .blur(radius: viewModel.toonGeldigeSet || viewModel.toonOngeldigeSet ? 3 : 0)
            
            // Spelerknoppen in de hoeken
            VStack {
                HStack {
                    spelerKnopVoorPositie(.linksBoven)
                    Spacer()
                    spelerKnopVoorPositie(.rechtsBoven)
                }
                Spacer()
                HStack {
                    spelerKnopVoorPositie(.linksOnder)
                    Spacer()
                    spelerKnopVoorPositie(.rechtsOnder)
                }
            }
            .padding()
            
            // Overlays voor feedback
            if viewModel.toonGeldigeSet {
                geldigeSetOverlay
            }
            
            if viewModel.toonOngeldigeSet {
                ongeldigeSetOverlay
            }
            
            if viewModel.toonSuperSetKeuze {
                superSetKeuzeOverlay
            }
            
            if viewModel.toonSuperSetResultaat {
                superSetResultaatOverlay
            }
            
            if viewModel.spelFase == .eindSpel {
                EindSpelOverlay(viewModel: viewModel)
            }
        }
    }
    
    private func spelerKnopVoorPositie(_ positie: SetGameViewModel.SpelerPositie) -> some View {
        let spelerIndex = viewModel.spelerPosities.firstIndex(of: positie) ?? -1
        if let avatar = viewModel.spelerAvatars[positie] {
            return AnyView(
                SpelerKnop(
                    avatar: avatar,
                    score: spelerIndex >= 0 ? viewModel.scores[spelerIndex] : 0,
                    isActief: viewModel.actieveSpeler == spelerIndex,
                    magSelecteren: viewModel.magKaartenSelecteren && viewModel.actieveSpeler == spelerIndex,
                    isGeblokkeerd: spelerIndex >= 0 && viewModel.isSpelerGeblokkeerd(spelerIndex),
                    action: {
                        if spelerIndex >= 0 {
                            viewModel.selecteerSpeler(spelerIndex)
                        }
                    },
                    isBovenaan: positie == .linksBoven || positie == .rechtsBoven
                )
            )
        } else {
            return AnyView(EmptyView())
        }
    }
    
    private var geldigeSetOverlay: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()
            VStack {
                Text("💥 \(LocalizationManager.text("set_success_exclamation")) 💥")
                    .font(.system(size: 60))
                    .bold()
                    .foregroundColor(.yellow)
                    .shadow(color: .orange, radius: 2)
                
                Text(LocalizationManager.text("valid_set"))
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()
            }
        }
        .transition(.scale.combined(with: .opacity))
    }
    private var ongeldigeSetOverlay: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()
            VStack {
                Text("💥 \(LocalizationManager.text("set_fail_exclamation")) 💥")
                    .font(.system(size: 60))
                    .bold()
                    .foregroundColor(.red)
                    .shadow(color: .orange, radius: 2)
                
                if viewModel.spelModus == .oefenen {
                    Text("Sorry, this is not a valid set. Try again!")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                } else {
                    Text(LocalizationManager.text("invalid_set"))
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                }
            }
        }
        .transition(.scale.combined(with: .opacity))
    }
    private var superSetKeuzeOverlay: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()
            VStack(spacing: 20) {
                Text(LocalizationManager.text("set_success_exclamation"))
                    .font(.title)
                    .foregroundColor(.yellow)
                
                Text(LocalizationManager.text("valid_set_with_choice"))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text(LocalizationManager.text("what_do_you_do"))
                    .foregroundColor(.white)
                    .padding(.top)
                
                HStack(spacing: 20) {
                    Button(LocalizationManager.text("yes_super_set")) {
                        viewModel.kiesSuperSet()
                    }
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                    Button(LocalizationManager.text("no_keep_points")) {
                        viewModel.behoudNormaleSet()
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
            .padding()
            .background(Color.black.opacity(0.8))
            .cornerRadius(20)
        }
    }
    
    private var superSetResultaatOverlay: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()
            VStack {
                if viewModel.isSuccesvolSuperSet {
                    Text("🌟 SUPER SET! 🌟")
                        .font(.system(size: 60))
                    Text("🌟🌟 GREAT - WELL DONE! +10 points! 🌟🌟🌟")
                        .font(.title)
                        .foregroundColor(.white)
                } else {
                    Text("😢 BUMMER!")
                        .font(.system(size: 60))
                        .foregroundColor(.red)
                    Text("Not a valid SUPERSet. \nNO points for you.")
                        .font(.title)
                        .foregroundColor(.white)
                }
            }
        }
    }
}

struct SpelerKnop: View {
    let avatar: SetGameViewModel.SpelerAvatar
    let score: Int
    let isActief: Bool
    let magSelecteren: Bool
    let isGeblokkeerd: Bool
    let action: () -> Void
    let isBovenaan: Bool
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Group {
                    Text(avatar.rawValue)
                        .font(.system(size: 50))
                    Text("\(score)")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color.black.opacity(0.6))
                        .cornerRadius(8)
                    if isGeblokkeerd {
                        Text("⛔️")
                            .font(.caption)
                    }
                }
                .rotationEffect(isBovenaan ? .degrees(180) : .degrees(0))
            }
            .padding(6)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(achtergrondKleur)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(isActief ? Color.yellow : Color.clear, lineWidth: 3)
            )
        }
        .disabled(isActief || isGeblokkeerd)
    }
    
    private var achtergrondKleur: Color {
        if isGeblokkeerd {
            return Color.red.opacity(0.3)
        } else if isActief {
            return Color.blue.opacity(0.3)
        } else {
            return Color.gray.opacity(0.2)
        }
    }
}

struct KaartView: View {
    let kaart: SetCard
    let isGeselecteerd: Bool
    let isVerlicht: Bool
    @ObservedObject var viewModel: SetGameViewModel
    
    var randKleur: Color {
        if isVerlicht {
            // Een felle, neon-achtige kleur die pulseert
            return .yellow.opacity(0.8 + 0.2 * sin(Date().timeIntervalSince1970 * 3))
        } else if viewModel.isKaartGeselecteerdVoorSuperSet(kaart) {
            return .purple
        } else if viewModel.superSetKaarten.contains(kaart) {
            return .purple
        } else if viewModel.isKaartInOrigineleSet(kaart) {
            return .blue
        } else if isGeselecteerd {
            return .blue
        } else if viewModel.hintKaarten.contains(kaart) &&
                  viewModel.hintKaarten.firstIndex(of: kaart)! < viewModel.aantalHintsGetoond {
            return .orange  // of een andere kleur voor hints
        }
        return .gray
    }
    
    var randDikte: CGFloat {
        if isVerlicht {
            return 12  // Veel dikkere rand
        } else if isGeselecteerd ||
                  viewModel.isKaartInOrigineleSet(kaart) ||
                  viewModel.superSetKaarten.contains(kaart) ||
                  (viewModel.hintKaarten.contains(kaart) &&
                   viewModel.hintKaarten.firstIndex(of: kaart)! < viewModel.aantalHintsGetoond) {
            return 8
        }
        return 2
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                let vorm = RoundedRectangle(cornerRadius: 10)
                vorm.fill().foregroundColor(.white)
                vorm.strokeBorder(
                    randKleur,
                    lineWidth: randDikte
                )
                VStack {
                    ForEach(0..<kaart.aantal, id: \.self) { _ in
                        kaartVorm
                            .frame(height: geometry.size.height * 0.2)
                    }
                }
                .padding(5)
                
                if isVerlicht {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(
                            LinearGradient(
                                colors: [.yellow, .orange, .red, .orange, .yellow],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: randDikte
                        )
                }
            }
            .scaleEffect(isVerlicht ? 1.05 : 1.0)  // Kleinere vergroting
            .brightness(isVerlicht ? 0.1 : 0)      // Subtielere glow
            .animation(.easeInOut(duration: 0.5), value: isVerlicht)
        }
    }
    
    @ViewBuilder
    private var kaartVorm: some View {
        switch kaart.vorm {
        case .ruit:
            vormMetVulling(RuitVorm())
        case .rechthoek:
            vormMetVulling(Rectangle())
        case .ovaal:
            vormMetVulling(Capsule())
        }
    }
    
    @ViewBuilder
    private func vormMetVulling<T: Shape>(_ shape: T) -> some View {
        switch kaart.vulling {
        case .volledig:
            shape.fill(vormKleur)
        case .leeg:
            shape.stroke(vormKleur, lineWidth: 2)
        case .gestippeld:
            shape
                .stroke(vormKleur, lineWidth: 2)
                .overlay(
                    shape
                        .fill(vormKleur)
                        .opacity(0.3)
                )
        }
    }
    
    private var vormKleur: Color {
        switch kaart.kleur {
        case .rood:
            return .red
        case .groen:
            return .green
        case .paars:
            return .purple
        }
    }
}

struct RuitVorm: Shape {
    func path(in rect: CGRect) -> Path {
        var pad = Path()
        pad.move(to: CGPoint(x: rect.midX, y: rect.minY))
        pad.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        pad.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        pad.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        pad.closeSubpath()
        return pad
    }
}

struct EindSpelOverlay: View {
    @ObservedObject var viewModel: SetGameViewModel
    @State private var showWinnaar = false
    @State private var showStats = false
    @State private var showButtons = false
    @State private var pijlOffset: CGFloat = -50
    
    var body: some View {
        ZStack {
            // Achtergrond
            Color.black.opacity(0.9).ignoresSafeArea()
            
            // Confetti animatie
            SterrenConfetti()
            
            VStack {
                if let stats = viewModel.eindSpelStatistieken,
                   let winnaarIndex = stats.winnaar,
                   let winnaarPositie = viewModel.spelerPosities[safe: winnaarIndex],
                   let winnaarAvatar = viewModel.spelerAvatars[winnaarPositie] {
                    
                    // Winnaar animatie
                    VStack {
                        Text("🏆 WINNER! 🏆")
                            .font(.system(size: 50, weight: .bold))
                            .foregroundColor(.yellow)
                            .opacity(showWinnaar ? 1 : 0)
                            .scaleEffect(showWinnaar ? 1 : 0.5)
                        
                        // Grote avatar van winnaar
                        Text(winnaarAvatar.rawValue)
                            .font(.system(size: 120))
                            .opacity(showWinnaar ? 1 : 0)
                            .scaleEffect(showWinnaar ? 1 : 0.1)
                            .rotation3DEffect(.degrees(showWinnaar ? 360 : 0), axis: (x: 0, y: 1, z: 0))
                        
                        // Score van winnaar
                        Text("\(stats.scores[winnaarIndex]) points!")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(.green)
                            .opacity(showWinnaar ? 1 : 0)
                    }
                    
                    // Statistieken
                    if showStats {
                        VStack(spacing: 15) {
                            Text("Sets found: \(stats.gevondenSets)")
                            Text("Super Sets: \(stats.superSets)")
                            Text("Play time: \(Int(stats.speelTijd)) seconds")
                        }
                        .font(.title2)
                        .foregroundColor(.white)
                        .transition(.scale.combined(with: .opacity))
                    }
                    
                    // Knoppen
                    if showButtons {
                        VStack(spacing: 20) {  // Verander HStack naar VStack voor verticale layout
                            Button {
                                viewModel.startNieuwSpel(modus: viewModel.spelModus)
                            } label: {
                                Text("REVANCHE! 🎮")
                                    .font(.title)
                                    .padding()
                                    .background(Color.green)
                                    .foregroundColor(.white)
                                    .cornerRadius(15)
                            }
                            
                            Button {
                                viewModel.spelFase = .startScherm  // Start een nieuw spel met nieuwe instellingen
                            } label: {
                                Text("NEW GAME 🎲")
                                    .font(.title)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(15)
                            }
                            
                            Button {
                                viewModel.naarHoofdmenu()
                            } label: {
                                Text("EXIT 👋")
                                    .font(.title)
                                    .padding()
                                    .background(Color.red)
                                    .foregroundColor(.white)
                                    .cornerRadius(15)
                            }
                        }
                        .transition(.scale.combined(with: .opacity))
                    }
                }
            }
            
            // Pijl naar winnaar positie (indien van toepassing)
            if let winnaarIndex = viewModel.eindSpelStatistieken?.winnaar,
               let positie = viewModel.spelerPosities[safe: winnaarIndex] {
                WinnaarPijl(positie: positie, offset: pijlOffset)
            }
        }
        .onAppear {
            speelWinnaarMuziek()
            startAnimaties()
        }
    }
    
    private func startAnimaties() {
        // Sequentiële animaties
        withAnimation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.3)) {
            showWinnaar = true
        }
        
        withAnimation(.easeInOut(duration: 0.5).delay(1.0)) {
            showStats = true
        }
        
        withAnimation(.spring(response: 0.6).delay(1.5)) {
            showButtons = true
        }
        
        // Pijl animatie
        withAnimation(.easeInOut(duration: 1.0).repeatForever()) {
            pijlOffset = 50
        }
    }
    
    private func speelWinnaarMuziek() {
        // Speel een reeks vrolijke geluiden
        DispatchQueue.global().async {
            AudioServicesPlaySystemSound(1327) // Vrolijk geluid 1
            Thread.sleep(forTimeInterval: 0.2)
            AudioServicesPlaySystemSound(1328) // Vrolijk geluid 2
            Thread.sleep(forTimeInterval: 0.2)
            AudioServicesPlaySystemSound(1329) // Vrolijk geluid 3
        }
    }
}

// Helper view voor de winnaar pijl
struct WinnaarPijl: View {
    let positie: SetGameViewModel.SpelerPositie
    let offset: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            let pijlPositie = pijlCoordinaten(in: geometry)
            let rotatie = pijlRotatie()
            
            Image(systemName: "arrow.down")
                .font(.system(size: 60))
                .foregroundColor(.yellow)
                .position(x: pijlPositie.x, y: pijlPositie.y)
                .rotationEffect(.degrees(rotatie))
                .offset(y: offset)
        }
    }
    
    private func pijlCoordinaten(in geometry: GeometryProxy) -> CGPoint {
        switch positie {
        case .linksBoven:
            return CGPoint(x: geometry.size.width * 0.2, y: geometry.size.height * 0.2)
        case .rechtsBoven:
            return CGPoint(x: geometry.size.width * 0.8, y: geometry.size.height * 0.2)
        case .linksOnder:
            return CGPoint(x: geometry.size.width * 0.2, y: geometry.size.height * 0.8)
        case .rechtsOnder:
            return CGPoint(x: geometry.size.width * 0.8, y: geometry.size.height * 0.8)
        }
    }
    
    private func pijlRotatie() -> Double {
        switch positie {
        case .linksBoven, .rechtsBoven: return 180
        case .linksOnder, .rechtsOnder: return 0
        }
    }
}

// Helper extension voor veilige array toegang
extension Array {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

// Nieuwe, eenvoudigere confetti met sterren
struct SterrenConfetti: View {
    let sterren = ["⭐️", "🌟", "✨", "💫"]
    @State private var sterrenPosities: [(String, CGPoint, Double)] = []
    @State private var timerCancellable: AnyCancellable?
    
    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                for (ster, positie, rotatie) in sterrenPosities {
                    context.draw(Text(ster).font(.system(size: 30)), at: positie, anchor: .center)
                }
            }
            .onAppear {
                // Start met 20 sterren op willekeurige posities
                for _ in 0..<20 {
                    voegSterToe()
                }
                // Start timer
                timerCancellable = Timer.publish(every: 0.1, on: .main, in: .common)
                    .autoconnect()
                    .sink { _ in
                        updateSterren()
                    }
            }
            .onDisappear {
                // Cancel timer when view disappears
                timerCancellable?.cancel()
            }
        }
    }
    
    private func voegSterToe() {
        let ster = sterren.randomElement() ?? "⭐️"
        let x = CGFloat.random(in: 50...300)
        let y = CGFloat.random(in: -50...700)
        let rotatie = Double.random(in: 0...360)
        sterrenPosities.append((ster, CGPoint(x: x, y: y), rotatie))
    }
    
    private func updateSterren() {
        for i in sterrenPosities.indices {
            var (ster, positie, rotatie) = sterrenPosities[i]
            positie.y += 2
            rotatie += 5
            
            if positie.y > 800 {
                positie.y = -50
                positie.x = CGFloat.random(in: 50...300)
            }
            
            sterrenPosities[i] = (ster, positie, rotatie)
        }
    }
}

// Voeg een mooie button style toe
struct GlowingButtonStyle: ButtonStyle {
    let color: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 30)
            .padding(.vertical, 15)
            .background(color)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .shadow(color: color.opacity(0.5), radius: configuration.isPressed ? 5 : 15)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.isPressed)
    }
}
