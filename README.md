# Math Monsters 🧮👾

A fun iOS math practice app for kids, built in SwiftUI.  
Reverse-engineered from the original **Math Project** Windows app and reimagined with a monster theme.

## Features

- **Grade Levels 1–4** — number ranges scale with difficulty (1–10, 1–20, 1–50, 1–100)
- **Addition & Subtraction** — subtraction always produces non-negative results
- **Live Feedback** — celebratory or encouraging response after every answer
- **Score Tracking** — correct/incorrect counts visible at all times
- **Summary Screen** — percentage score + motivational message at the end of a session

## Project Structure

```
math-monsters/
├── project.yml                  # xcodegen config
├── MathMonsters.xcodeproj/
└── MathMonsters/
    ├── MathMonstersApp.swift    # App entry point
    ├── ContentView.swift        # Navigation root
    ├── GameView.swift           # Main game screen
    ├── GameViewModel.swift      # Game logic & state
    ├── SummaryView.swift        # Session summary
    └── Assets.xcassets/
```

## Requirements

- Xcode 15+
- iOS 17+

## Building

```bash
# Regenerate the .xcodeproj (if project.yml is changed)
brew install xcodegen
xcodegen generate

# Build for simulator
xcodebuild -scheme MathMonsters -destination 'generic/platform=iOS Simulator' build
```
