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
}

// MARK: - GradeLevel

enum GradeLevel: Int, CaseIterable, Identifiable, Hashable {
    case grade1 = 1, grade2, grade3, grade4, grade5

    var id: Int { rawValue }
    var displayName: String { "Grade \(rawValue)" }

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
            answerState  = .correct
            updateSessionCompletion()
        } else if retriesRemaining > 0 {
            retriesRemaining -= 1
            answerState = .retry
            answerText = ""
        } else {
            incorrectCount += 1
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
