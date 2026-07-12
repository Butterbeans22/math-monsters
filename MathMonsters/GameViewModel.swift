import SwiftUI

// MARK: - MathOperation

enum MathOperation: String, CaseIterable, Identifiable, Hashable {
    case addition       = "Addition"
    case subtraction    = "Subtraction"
    case multiplication = "Multiplication"
    case division       = "Division"

    var id: String { rawValue }

    var symbol: String {
        switch self {
        case .addition:       return "+"
        case .subtraction:    return "−"
        case .multiplication: return "×"
        case .division:       return "÷"
        }
    }

    var emoji: String {
        switch self {
        case .addition:       return "➕"
        case .subtraction:    return "➖"
        case .multiplication: return "✖️"
        case .division:       return "➗"
        }
    }

    var color: Color {
        switch self {
        case .addition:       return .green
        case .subtraction:    return .orange
        case .multiplication: return .blue
        case .division:       return .purple
        }
    }

    var cheerLine: String {
        switch self {
        case .addition:       return "Let's build bigger numbers!"
        case .subtraction:    return "Let's solve the sneaky take-aways!"
        case .multiplication: return "Let's power up with fast groups!"
        case .division:       return "Let's split it up like math bosses!"
        }
    }
}

// MARK: - GradeLevel

enum GradeLevel: Int, CaseIterable, Identifiable, Hashable {
    case grade1 = 1, grade2, grade3, grade4, grade5

    var id: Int { rawValue }
    var displayName: String { "Grade \(rawValue)" }

    var monsterName: String {
        switch self {
        case .grade1: return "Bloop"
        case .grade2: return "Miso"
        case .grade3: return "Wob"
        case .grade4: return "Spike"
        case .grade5: return "Inky"
        }
    }

    var monsterFamily: String {
        switch self {
        case .grade1: return "Fuzzball"
        case .grade2: return "Cat Monster"
        case .grade3: return "Cyclops"
        case .grade4: return "Spike Beast"
        case .grade5: return "Tentacle Boss"
        }
    }

    var monsterLabel: String {
        "\(monsterName) the \(monsterFamily)"
    }

    var monsterStyleLine: String {
        switch self {
        case .grade1: return "Soft, bouncy, and loves number games"
        case .grade2: return "Quick paws and sneaky subtraction skills"
        case .grade3: return "Big eye, big focus, all-operation pro"
        case .grade4: return "Spiky energy with fast fact power"
        case .grade5: return "Wiggly mastermind for the trickiest math"
        }
    }

    var monsterCatchphrase: String {
        switch self {
        case .grade1: return "Hi! Let's bounce through + and -!"
        case .grade2: return "Psst... I can spot sneaky number tricks!"
        case .grade3: return "One big eye, four big math moves!"
        case .grade4: return "Zap! Let's crunch facts super fast!"
        case .grade5: return "Wiggle wiggle... bring me the hard ones!"
        }
    }

    func streakCatchphrase(for streak: Int) -> String {
        switch streak {
        case 3:
            return "Three in a row! You're on a roll!"
        case 4:
            return "Four straight! My monster brain is cheering!"
        case 5...:
            return "Mega streak! You're unstoppable!"
        default:
            return monsterCatchphrase
        }
    }

    func summaryCatchphrase(score: Double) -> String {
        switch score {
        case 90...100:
            return "Roar! You crushed this whole round!"
        case 70..<90:
            return "Yes! That was a strong monster round!"
        case 50..<70:
            return "Nice work. Let's level up the next round!"
        default:
            return "No worries. Monsters grow with practice too!"
        }
    }

    var perfectRoundCatchphrase: String {
        switch self {
        case .grade1: return "Boing! Perfect round! You made every number sparkle!"
        case .grade2: return "Purr-fect! You caught every sneaky answer!"
        case .grade3: return "All-seeing victory! You nailed every problem!"
        case .grade4: return "Zap-zing! That's a flawless monster round!"
        case .grade5: return "Tentacle triumph! Absolute math mastery!"
        }
    }

    var pressedCatchphrase: String {
        switch self {
        case .grade1: return "Boing! Tap me and let's start!"
        case .grade2: return "Pounce! Pick me for a math mission!"
        case .grade3: return "Zoom in! I'm ready for every sign!"
        case .grade4: return "Crackle! Let's race through facts!"
        case .grade5: return "Swish! Bring on the brainy challenge!"
        }
    }

    func operationCatchphrase(for operation: MathOperation) -> String {
        switch (self, operation) {
        case (.grade1, .addition): return "Tiny hops make bigger totals!"
        case (.grade1, .subtraction): return "Pop! One goes away!"
        case (.grade2, .addition): return "Quick paws count up fast!"
        case (.grade2, .subtraction): return "I can sniff out what's left!"
        case (.grade3, .addition): return "My big eye spots every sum!"
        case (.grade3, .subtraction): return "Watch me track the difference!"
        case (.grade3, .multiplication): return "Groups, groups, groups... easy!"
        case (.grade3, .division): return "Split it neatly and keep going!"
        case (.grade4, .addition): return "Lightning sums coming through!"
        case (.grade4, .subtraction): return "Let's shave numbers down fast!"
        case (.grade4, .multiplication): return "Spike power loves fact families!"
        case (.grade4, .division): return "Let's divide like champions!"
        case (.grade5, .addition): return "Big numbers? Delicious."
        case (.grade5, .subtraction): return "I untangle giant numbers!"
        case (.grade5, .multiplication): return "Tentacles ready for mega groups!"
        case (.grade5, .division): return "Tricky sharing is my favorite!"
        default: return operation.cheerLine
        }
    }

    var emoji: String {
        switch self {
        case .grade1: return "🌱"
        case .grade2: return "🌿"
        case .grade3: return "🌳"
        case .grade4: return "🔥"
        case .grade5: return "⚡️"
        }
    }

    var skillDescription: String {
        switch self {
        case .grade1: return "Single-digit numbers\nAddition & Subtraction"
        case .grade2: return "Numbers up to 20\nAddition & Subtraction"
        case .grade3: return "Numbers up to 100\nAll 4 operations · ×÷ tables 1–5"
        case .grade4: return "Numbers up to 999\nAll 4 operations · ×÷ tables 1–12"
        case .grade5: return "Numbers up to 9,999\nMulti-digit ×÷ · ÷ tables 1–12"
        }
    }

    var color: Color {
        switch self {
        case .grade1: return .teal
        case .grade2: return .green
        case .grade3: return .blue
        case .grade4: return .orange
        case .grade5: return .purple
        }
    }

    /// Operations unlocked at this grade level.
    var availableOperations: [MathOperation] {
        switch self {
        case .grade1, .grade2:
            return [.addition, .subtraction]
        case .grade3, .grade4, .grade5:
            return MathOperation.allCases
        }
    }

    var operationSummary: String {
        availableOperations.map(\ .symbol).joined(separator: "  ")
    }
}

// MARK: - MathProblem

struct MathProblem {
    let firstNumber: Int
    let secondNumber: Int
    let operation: MathOperation

    var correctAnswer: Int {
        switch operation {
        case .addition:       return firstNumber + secondNumber
        case .subtraction:    return firstNumber - secondNumber
        case .multiplication: return firstNumber * secondNumber
        case .division:       return firstNumber / secondNumber  // always exact — see generate()
        }
    }

    var problemText: String { "\(firstNumber)  \(operation.symbol)  \(secondNumber)" }

    /// Grade-specific problem generation.
    /// Division problems are always constructed to have exact integer answers.
    static func generate(grade: GradeLevel, operation: MathOperation) -> MathProblem {
        switch (grade, operation) {

        // ── Grade 1: single digits, no negatives ─────────────────────────────
        case (.grade1, .addition):
            return .init(Int.random(in: 1...9), Int.random(in: 1...9), .addition)
        case (.grade1, .subtraction):
            let a = Int.random(in: 1...10)
            let b = Int.random(in: 0...a)
            return .init(a, b, .subtraction)

        // ── Grade 2: up to 20, no negatives ──────────────────────────────────
        case (.grade2, .addition):
            return .init(Int.random(in: 1...20), Int.random(in: 1...20), .addition)
        case (.grade2, .subtraction):
            let b = Int.random(in: 1...20)
            let a = Int.random(in: b...40)
            return .init(a, b, .subtraction)

        // ── Grade 3: up to 100; ×÷ tables 1–5 ───────────────────────────────
        case (.grade3, .addition):
            return .init(Int.random(in: 1...100), Int.random(in: 1...100), .addition)
        case (.grade3, .subtraction):
            let b = Int.random(in: 1...100)
            let a = Int.random(in: b...100)
            return .init(a, b, .subtraction)
        case (.grade3, .multiplication):
            return .init(Int.random(in: 1...5), Int.random(in: 1...5), .multiplication)
        case (.grade3, .division):
            let divisor  = Int.random(in: 1...5)
            let quotient = Int.random(in: 1...5)
            return .init(divisor * quotient, divisor, .division)

        // ── Grade 4: up to 999; ×÷ full tables 1–12 ─────────────────────────
        case (.grade4, .addition):
            return .init(Int.random(in: 1...999), Int.random(in: 1...999), .addition)
        case (.grade4, .subtraction):
            let b = Int.random(in: 1...999)
            let a = Int.random(in: b...999)
            return .init(a, b, .subtraction)
        case (.grade4, .multiplication):
            return .init(Int.random(in: 1...12), Int.random(in: 1...12), .multiplication)
        case (.grade4, .division):
            let divisor  = Int.random(in: 1...12)
            let quotient = Int.random(in: 1...12)
            return .init(divisor * quotient, divisor, .division)

        // ── Grade 5: up to 9,999; 2-digit × 1-digit; ÷ quotients up to 20 ───
        case (.grade5, .addition):
            return .init(Int.random(in: 1...9_999), Int.random(in: 1...9_999), .addition)
        case (.grade5, .subtraction):
            let b = Int.random(in: 1...9_999)
            let a = Int.random(in: b...9_999)
            return .init(a, b, .subtraction)
        case (.grade5, .multiplication):
            return .init(Int.random(in: 1...99), Int.random(in: 1...12), .multiplication)
        case (.grade5, .division):
            let divisor  = Int.random(in: 1...12)
            let quotient = Int.random(in: 1...20)
            return .init(divisor * quotient, divisor, .division)

        // ── Fallback (shouldn't occur — operations filtered per grade) ────────
        default:
            return generate(grade: grade, operation: .addition)
        }
    }

    private init(_ first: Int, _ second: Int, _ op: MathOperation) {
        firstNumber = first; secondNumber = second; operation = op
    }
}

// MARK: - GameViewModel

@MainActor
final class GameViewModel: ObservableObject {
    let grade: GradeLevel
    let operation: MathOperation
    let problemCount: Int
    private let maxRetriesPerProblem = 1

    @Published var currentProblem: MathProblem
    @Published var answerText: String = ""
    @Published var correctCount: Int = 0
    @Published var incorrectCount: Int = 0
    @Published var consecutiveCorrectCount: Int = 0
    @Published var retriesRemaining: Int = 1
    @Published var answerState: AnswerState = .unanswered
    @Published var sessionComplete: Bool = false

    var completedProblems: Int { correctCount + incorrectCount }
    var remainingProblems: Int { max(0, problemCount - completedProblems) }

    enum AnswerState { case unanswered, retry, correct, incorrect }

    init(grade: GradeLevel, operation: MathOperation, problemCount: Int) {
        self.grade     = grade
        self.operation = operation
        self.problemCount = max(1, problemCount)
        self.currentProblem = MathProblem.generate(grade: grade, operation: operation)
    }

    func checkAnswer() {
        guard let userAnswer = Int(answerText.trimmingCharacters(in: .whitespaces)) else { return }
        if userAnswer == currentProblem.correctAnswer {
            correctCount += 1
            consecutiveCorrectCount += 1
            answerState  = .correct
            updateSessionCompletion()
        } else if retriesRemaining > 0 {
            retriesRemaining -= 1
            consecutiveCorrectCount = 0
            answerState = .retry
            answerText = ""
        } else {
            incorrectCount += 1
            consecutiveCorrectCount = 0
            answerState    = .incorrect
            updateSessionCompletion()
        }
    }

    func nextProblem() {
        guard !sessionComplete else { return }
        currentProblem = MathProblem.generate(grade: grade, operation: operation)
        answerText     = ""
        retriesRemaining = maxRetriesPerProblem
        answerState    = .unanswered
    }

    private func updateSessionCompletion() {
        if completedProblems >= problemCount {
            sessionComplete = true
        }
    }
}
