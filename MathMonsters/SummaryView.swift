import SwiftUI

struct SummaryView: View {
    let correctCount: Int
    let incorrectCount: Int
    let onPlayAgain: () -> Void

    private var totalQuestions: Int { correctCount + incorrectCount }

    private var percentage: Double {
        guard totalQuestions > 0 else { return 0 }
        return Double(correctCount) / Double(totalQuestions) * 100
    }

    private var monsterEmoji: String {
        switch percentage {
        case 90...100: return "🏆"
        case 70..<90:  return "⭐️"
        case 50..<70:  return "👍"
        default:       return "💪"
        }
    }

    private var message: String {
        switch percentage {
        case 90...100: return "Amazing work, Math Monster!"
        case 70..<90:  return "Great job! Keep it up!"
        case 50..<70:  return "Good effort! Practice makes perfect."
        default:       return "Keep practicing — you've got this!"
        }
    }

    var body: some View {
        VStack(spacing: 32) {
            Text(monsterEmoji)
                .font(.system(size: 80))

            Text(message)
                .font(.title2.bold())
                .multilineTextAlignment(.center)
                .foregroundStyle(.primary)

            VStack(spacing: 16) {
                summaryRow(label: "Total Questions", value: "\(totalQuestions)", color: .primary)
                summaryRow(label: "Correct", value: "\(correctCount)", color: .green)
                summaryRow(label: "Incorrect", value: "\(incorrectCount)", color: .red)
                summaryRow(label: "Score", value: String(format: "%.0f%%", percentage), color: .indigo)
            }
            .padding()
            .background(Color(.systemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16))

            Button {
                onPlayAgain()
            } label: {
                Label("Play Again", systemImage: "arrow.counterclockwise.circle.fill")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(RoundedRectangle(cornerRadius: 14).fill(Color.orange))
            }
        }
        .padding(24)
        .navigationTitle("Summary")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func summaryRow(label: String, value: String, color: Color) -> some View {
        HStack {
            Text(label)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .font(.headline)
                .foregroundStyle(color)
        }
        .padding(.horizontal, 8)
    }
}
