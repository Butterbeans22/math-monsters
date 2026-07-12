import SwiftUI

// NOTE: File kept as GameView.swift; struct renamed PracticeView for semantic clarity.

struct PracticeView: View {
    let grade: GradeLevel
    let operation: MathOperation

    @StateObject private var viewModel: GameViewModel
    @EnvironmentObject private var router: AppRouter
    @FocusState private var answerFocused: Bool

    private var isProblemFinished: Bool {
        viewModel.answerState == .correct || viewModel.answerState == .incorrect
    }

    init(grade: GradeLevel, operation: MathOperation) {
        self.grade     = grade
        self.operation = operation
        _viewModel     = StateObject(wrappedValue: GameViewModel(grade: grade, operation: operation))
    }

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground).ignoresSafeArea()

            VStack(spacing: 0) {
                scoreBar
                Spacer()
                problemSection
                Spacer()
                answerSection
                feedbackSection
                Spacer()
                endSessionButton
                    .padding(.bottom, 32)
            }
            .padding(.horizontal, 24)
        }
        .navigationTitle("\(grade.displayName) · \(operation.rawValue)")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack(spacing: 6) {
                    Text(grade.emoji)
                    Text("\(grade.displayName)  ·  \(operation.symbol)")
                        .font(.headline)
                }
            }
        }
        .onTapGesture { answerFocused = false }
    }

    // MARK: - Score Bar

    private var scoreBar: some View {
        HStack(spacing: 20) {
            scorePill(count: viewModel.correctCount,   label: "Correct",   color: .green,  icon: "checkmark.circle.fill")
            Spacer()
            scorePill(count: viewModel.incorrectCount, label: "Incorrect", color: .red,    icon: "xmark.circle.fill")
        }
        .padding(.top, 16)
    }

    private func scorePill(count: Int, label: String, color: Color, icon: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .foregroundStyle(color)
            Text("\(count)  \(label)")
                .font(.subheadline.bold())
                .foregroundStyle(color)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(color.opacity(0.12))
        .clipShape(Capsule())
    }

    // MARK: - Problem Display

    private var problemSection: some View {
        VStack(spacing: 16) {
            Text(viewModel.currentProblem.problemText)
                .font(.system(size: 60, weight: .black, design: .rounded))
                .minimumScaleFactor(0.4)
                .lineLimit(1)
                .foregroundStyle(.primary)

            Text("= ?")
                .font(.system(size: 44, weight: .bold, design: .rounded))
                .foregroundStyle(operation.color)
        }
        .multilineTextAlignment(.center)
        .padding(28)
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 4)
    }

    // MARK: - Answer Input

    private var answerSection: some View {
        HStack(spacing: 12) {
            TextField("Your answer", text: $viewModel.answerText)
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .multilineTextAlignment(.center)
                .keyboardType(.numberPad)
                .focused($answerFocused)
                .padding()
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(answerBorderColor, lineWidth: 2)
                )
                .disabled(isProblemFinished)
                .frame(maxWidth: .infinity)

            if !isProblemFinished {
                Button {
                    answerFocused = false
                    viewModel.checkAnswer()
                } label: {
                    Text(viewModel.answerState == .retry ? "Retry" : "Check")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 18)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(viewModel.answerText.isEmpty ? Color.gray : operation.color)
                        )
                }
                .disabled(viewModel.answerText.isEmpty)
            } else {
                Button {
                    viewModel.nextProblem()
                    answerFocused = true
                } label: {
                    Label("Next", systemImage: "arrow.right")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 18)
                        .background(RoundedRectangle(cornerRadius: 14).fill(operation.color))
                }
                .transition(.move(edge: .trailing).combined(with: .opacity))
            }
        }
        .animation(.spring(duration: 0.25), value: viewModel.answerState)
        .padding(.top, 24)
    }

    private var answerBorderColor: Color {
        switch viewModel.answerState {
        case .unanswered: return Color.secondary.opacity(0.3)
        case .retry:      return .orange
        case .correct:    return .green
        case .incorrect:  return .red
        }
    }

    // MARK: - Feedback

    @ViewBuilder
    private var feedbackSection: some View {
        switch viewModel.answerState {
        case .unanswered:
            Color.clear.frame(height: 72)
        case .retry:
            feedbackBanner(
                emoji: "🔁",
                text: "Try one more time!",
                color: .orange
            )
        case .correct:
            feedbackBanner(emoji: "🎉", text: "Correct!", color: .green)
        case .incorrect:
            feedbackBanner(
                emoji: "😬",
                text: "Not quite — the answer is \(viewModel.currentProblem.correctAnswer)",
                color: .red
            )
        }
    }

    private func feedbackBanner(emoji: String, text: String, color: Color) -> some View {
        HStack(spacing: 10) {
            Text(emoji).font(.system(size: 32))
            Text(text)
                .font(.subheadline.bold())
                .foregroundStyle(color)
        }
        .frame(height: 72)
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity)
        .background(color.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .transition(.scale(scale: 0.9).combined(with: .opacity))
        .animation(.spring(duration: 0.3), value: viewModel.answerState)
    }

    // MARK: - End Session

    private var endSessionButton: some View {
        Button {
            router.navigate(to: .summary(
                correct:   viewModel.correctCount,
                incorrect: viewModel.incorrectCount
            ))
        } label: {
            Label("End Session", systemImage: "flag.checkered")
                .font(.subheadline.bold())
                .foregroundStyle(.secondary)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }
}
