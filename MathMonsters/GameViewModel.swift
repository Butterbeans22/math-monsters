import Foundation

enum MathOperation: String, CaseIterable, Identifiable {
    case addition = "Addition"
    case subtraction = "Subtraction"

    var id: String { rawValue }

    var symbol: String {
        switch self {
        case .addition: return "+"
        case .subtraction: return "−"
        }
    }
}

enum GradeLevel: Int, CaseIterable, Identifiable {
    case grade1 = 1
    case grade2 = 2
    case grade3 = 3
    case grade4 = 4

    var id: Int { rawValue }
    var displayName: String { "Grade \(rawValue)" }

    /// Max value for each operand based on grade level, mirroring the original exe.
    var maxNumber: Int {
        switch self {
        case .grade1: return 10
        case .grade2: return 20
        case .grade3: return 50
        case .grade4: return 100
        }
    }
}

struct MathProblem {
    let firstNumber: Int
    let secondNumber: Int
    let operation: MathOperation

    var correctAnswer: Int {
        switch operation {
        case .addition: return firstNumber + secondNumber
        case .subtraction: return firstNumber - secondNumber
        }
    }

    var displayString: String {
        "\(firstNumber)  \(operation.symbol)  \(secondNumber)  ="
    }
}

@MainActor
final class GameViewModel: ObservableObject {
    @Published var selectedGrade: GradeLevel = .grade1
    @Published var selectedOperation: MathOperation = .addition
    @Published var currentProblem: MathProblem = MathProblem(firstNumber: 0, secondNumber: 0, operation: .addition)
    @Published var answerText: String = ""
    @Published var correctCount: Int = 0
    @Published var incorrectCount: Int = 0
    @Published var answerState: AnswerState = .unanswered

    enum AnswerState {
        case unanswered
        case correct
        case incorrect
    }

    init() {
        generateProblem()
    }

    /// Mirrors GenerateAndDisplayNumbers from the original exe.
    func generateProblem() {
        let max = selectedGrade.maxNumber
        var first = Int.random(in: 1...max)
        var second = Int.random(in: 1...max)

        // For subtraction, ensure non-negative result (child-friendly)
        if selectedOperation == .subtraction, first < second {
            swap(&first, &second)
        }

        currentProblem = MathProblem(firstNumber: first, secondNumber: second, operation: selectedOperation)
        answerText = ""
        answerState = .unanswered
    }

    /// Mirrors ProcessGradeRadioButtons — regenerates when grade changes.
    func gradeChanged() {
        generateProblem()
    }

    /// Mirrors uiCheckAnswerButton_Click logic.
    func checkAnswer() {
        guard let userAnswer = Int(answerText.trimmingCharacters(in: .whitespaces)) else { return }
        if userAnswer == currentProblem.correctAnswer {
            correctCount += 1
            answerState = .correct
        } else {
            incorrectCount += 1
            answerState = .incorrect
        }
    }

    func nextProblem() {
        generateProblem()
    }

    func resetGame() {
        correctCount = 0
        incorrectCount = 0
        generateProblem()
    }
}
