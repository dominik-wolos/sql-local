# Wordle - Dokumentacja Projektu

**Przedmiot:** Zaawansowane Programowanie w języku SWIFT  
**Semestr:** 2  
**Rok akademicki:** 2025/2026

---

## 1. Tytuł projektu

**Wordle** — gra słowna w SwiftUI. Gracz ma 6 prób na odgadnięcie ukrytego słowa. Obsługuje trzy języki (EN, ES, RU), konfiguralną długość słowa (4–11 liter), system podpowiedzi i statystyki.

---

## 2. Osoby realizujące

| Lp. | Imię i nazwisko | Rola |
|-----|----------------|------|
| 1.  | `[UZUPEŁNIJ]`  | Członek zespołu |
| 2.  | `[UZUPEŁNIJ]`  | Członek zespołu |
| 3.  | `[UZUPEŁNIJ]`  | Członek zespołu |

---

## 3. Podział pracy

Podzieliliśmy projekt na trzy części według warstw MVVM.

**Osoba 1 — logika i dane**  
Modele danych (`Game`, `Word`, `Status`, `GameResult` itp.), główny `GameViewModel`, serwisy `WordDictionary` i `StatisticManager` (SwiftData), mocki do podglądów, konfiguracja punktu wejścia aplikacji.

**Osoba 2 — widoki i nawigacja**  
Wszystkie pełnoekranowe widoki: `GameView`, `OnboardingView`, `SettingsView`, `StatisticsView`, `SetLanguageView`, `RootView`. Nawigacja przez `NavigationStack` i `Router`, gesty i animacje przejść.

**Osoba 3 — komponenty UI i zasoby**  
Komponenty wielokrotnego użytku: plansza (`BoardView`, `RowView`, `LetterView` z animacją flip 3D), klawiatura (`KeyboardView`), nakładki (`ResultView`, `HintView`, `ErrorView`). Stałe konfiguracyjne, rozszerzenia `Color`/`Font`/`Image`, integracja Lottie i zasoby (słownik JSON, asset catalog).

---

## 4. Architektura

Aplikacja oparta na **MVVM**:

```
WordleApp
├── GameViewModel
│   ├── Game
│   ├── WordDictionary
│   └── StatisticManager (SwiftData)
└── RootView
    ├── OnboardingView
    └── GameView
        ├── BoardView → RowView → LetterView
        ├── KeyboardView
        ├── ResultView, HintView, ErrorView, CustomAlertView
        └── NavigationStack → SettingsView, StatisticsView, SetLanguageView
```

---

## 5. Spełnienie wymagań

| Lp. | Wymaganie | Realizacja |
|-----|-----------|------------|
| 1 | Charakter gry | Wordle z pełną mechaniką rozgrywki |
| 2 | Min. jeden widok rozgrywki | `GameView` z planszą i klawiaturą |
| 3 | Struktury i widoki w osobnych plikach | 40+ plików Swift |
| 4 | Weryfikacja danych | Walidacja słów względem słownika, `WordleError` |
| 5 | Min. 1 gest | Drag w dół do wyświetlenia podpowiedzi |
| 6 | Min. 1 animacja | Flip 3D liter, confetti Lottie, pulsujący indykator |
| 7 | Wzorzec MVVM | `Model/`, `ViewModel/`, `Views/` |
| 8 | Czytelny kod | Podział na moduły, protokoły, stałe w osobnych plikach |
| 9 | Informacje o przebiegu gry | Statusy liter, klawiatura, ekran wyniku, statystyki |
| 10 | Nowa gra | Przycisk "NEW GAME" na ekranie gry i w widoku wyniku |

---

## 6. Technologie

Swift, SwiftUI, SwiftData, Lottie, MVVM, Xcode
