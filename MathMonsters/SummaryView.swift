import SwiftUI

struct SummaryView: View {
    let grade: GradeLevel
    let correctCount: Int
    let incorrectCount: Int
    @EnvironmentObject private var router: AppRouter

    private var totalQuestions: Int { correctCount + incorrectCount }

    private var isPerfectRound: Bool {
        totalQuestions > 0 && incorrectCount == 0 && correctCount == totalQuestions
    }

    private var percentage: Double {
        guard totalQuestions > 0 else { return 0 }
        return Double(correctCount) / Double(totalQuestions) * 100
    }

    private var monsterMood: GradeMonsterMood {
        switch percentage {
        case 90...100: return .excited
        case 70..<90:  return .proud
        case 50..<70:  return .calm
        default:       return .determined
        }
    }

    private var message: String {
        if isPerfectRound {
            return "Perfect round! Every answer was right."
        }

        switch percentage {
        case 90...100: return "Amazing work, Math Monster!"
        case 70..<90:  return "Great job! Keep it up!"
        case 50..<70:  return "Good effort! Practice makes perfect."
        default:       return "Keep practicing — you've got this!"
        }
    }

    var body: some View {
        VStack(spacing: 32) {
            GradeMonsterBadge(grade: grade, size: 128, mood: isPerfectRound ? .excited : monsterMood, showsIdleMotion: true)

            Text(isPerfectRound ? grade.perfectRoundCatchphrase : grade.summaryCatchphrase(score: percentage))
                .font(.headline)
                .foregroundStyle(grade.color)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(grade.color.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

            Text(message)
                .font(.title2.bold())
                .multilineTextAlignment(.center)
                .foregroundStyle(.primary)

            Text("\(grade.displayName) Results")
                .font(.headline)
                .foregroundStyle(grade.color)

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
                router.popToRoot()
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
