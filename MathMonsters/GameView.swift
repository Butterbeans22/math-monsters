import SwiftUI

// NOTE: File kept as GameView.swift; struct renamed PracticeView for semantic clarity.

struct PracticeView: View {
    let grade: GradeLevel
    let operation: MathOperation
    let problemCount: Int

    @StateObject private var viewModel: GameViewModel
    @EnvironmentObject private var router: AppRouter
    @FocusState private var answerFocused: Bool

    private var isProblemFinished: Bool {
        viewModel.answerState == .correct || viewModel.answerState == .incorrect
    }

    init(grade: GradeLevel, operation: MathOperation, problemCount: Int) {
        self.grade     = grade
        self.operation = operation
        self.problemCount = problemCount
        _viewModel     = StateObject(wrappedValue: GameViewModel(grade: grade, operation: operation, problemCount: problemCount))
    }

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground).ignoresSafeArea()

            VStack(spacing: 0) {
                scoreBar
                progressBar
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
                    GradeMonsterBadge(grade: grade, size: 24)
                    Text("\(grade.displayName)  ·  \(operation.symbol)")
                        .font(.headline)
                }
            }
        }
        .onTapGesture { answerFocused = false }
        .onChange(of: viewModel.sessionComplete) { completed in
            guard completed else { return }
            router.navigate(to: .summary(
                grade: grade,
                correct: viewModel.correctCount,
                incorrect: viewModel.incorrectCount
            ))
        }
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

    private var progressBar: some View {
        VStack(spacing: 6) {
            HStack {
                Text("Problem \(min(viewModel.completedProblems + 1, problemCount)) of \(problemCount)")
                    .font(.caption.bold())
                    .foregroundStyle(.secondary)
                Spacer()
                Text("\(Int(progressValue * 100))%")
                    .font(.caption2.bold())
                    .foregroundStyle(.secondary)
            }

            ProgressView(value: progressValue)
                .progressViewStyle(.linear)
                .tint(operation.color)
                .frame(maxWidth: .infinity)
        }
        .padding(.top, 8)
    }

    private var progressValue: Double {
        guard problemCount > 0 else { return 0 }
        return min(1, Double(viewModel.completedProblems) / Double(problemCount))
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
            Color.clear.frame(height: 88)
        case .retry:
            feedbackBanner(
                mood: .determined,
                text: "Try one more time!",
                color: .orange
            )
        case .correct:
            feedbackBanner(mood: .excited, text: correctFeedbackText, color: .green)
        case .incorrect:
            feedbackBanner(
                mood: .calm,
                text: "Not quite — the answer is \(viewModel.currentProblem.correctAnswer)",
                color: .red
            )
        }
    }

    private func feedbackBanner(mood: GradeMonsterMood, text: String, color: Color) -> some View {
        HStack(spacing: 10) {
            ZStack {
                if mood == .excited {
                    CorrectAnswerSparkleBurst(color: color)
                }

                GradeMonsterBadge(grade: grade, size: 48, mood: mood, showsIdleMotion: true)
            }
            .frame(width: 86, height: 86)

            VStack(alignment: .leading, spacing: 4) {
                Text(feedbackTitle(for: mood))
                    .font(.caption.bold())
                    .foregroundStyle(color)

                Text(text)
                    .font(.subheadline.bold())
                    .foregroundStyle(color)
            }

            Spacer(minLength: 0)
        }
        .frame(minHeight: 88)
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity)
        .background(color.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .transition(.scale(scale: 0.9).combined(with: .opacity))
        .animation(.spring(duration: 0.3), value: viewModel.answerState)
    }

    private func feedbackTitle(for mood: GradeMonsterMood) -> String {
        switch mood {
        case .calm:
            return "Keep Going"
        case .excited:
            return viewModel.consecutiveCorrectCount >= 3 ? "Streak Power" : "Monster Cheer"
        case .proud:
            return "Nice Work"
        case .determined:
            return "One More Try"
        }
    }

    private var correctFeedbackText: String {
        if viewModel.consecutiveCorrectCount >= 3 {
            return grade.streakCatchphrase(for: viewModel.consecutiveCorrectCount)
        }

        return "Correct!"
    }

    private struct CorrectAnswerSparkleBurst: View {
        let color: Color

        var body: some View {
            TimelineView(.animation(minimumInterval: 1.0 / 24.0)) { timeline in
                let time = timeline.date.timeIntervalSinceReferenceDate
                let pulse = 0.5 + 0.5 * sin(time * 5.4)
                let orbit = sin(time * 2.6)

                ZStack {
                    Circle()
                        .fill(RadialGradient(colors: [color.opacity(0.32), .clear], center: .center, startRadius: 4, endRadius: 30))
                        .frame(width: 72, height: 72)
                        .scaleEffect(0.88 + pulse * 0.2)

                    sparkle(x: -30 + orbit * 4, y: -26, size: 17, angle: -22, color: .yellow, pulse: pulse)
                    sparkle(x: 31, y: -25 - orbit * 3, size: 15, angle: 18, color: .white, pulse: 1 - pulse * 0.2)
                    sparkle(x: -28, y: 28 + orbit * 2, size: 13, angle: 10, color: color.opacity(0.9), pulse: 1 - pulse * 0.18)
                    sparkle(x: 30 - orbit * 3, y: 25, size: 16, angle: -14, color: .mint, pulse: pulse * 0.9)
                    sparkle(x: 0, y: -38, size: 12, angle: 0, color: .orange, pulse: 1 - pulse * 0.3)

                    confetti(x: -36, y: 4, color: .pink, rotation: pulse * 20)
                    confetti(x: 37, y: 2, color: .cyan, rotation: -pulse * 18)
                    confetti(x: -6, y: 35, color: .purple, rotation: pulse * 24)
                }
            }
        }

        private func sparkle(x: CGFloat, y: CGFloat, size: CGFloat, angle: Double, color: Color, pulse: Double) -> some View {
            Image(systemName: "sparkle")
                .font(.system(size: size, weight: .bold))
                .foregroundStyle(color)
                .rotationEffect(.degrees(angle + pulse * 10))
                .scaleEffect(0.82 + pulse * 0.28)
                .opacity(0.45 + pulse * 0.55)
                .offset(x: x, y: y)
        }

            private func confetti(x: CGFloat, y: CGFloat, color: Color, rotation: Double) -> some View {
                RoundedRectangle(cornerRadius: 3, style: .continuous)
                .fill(color)
                .frame(width: 8, height: 14)
                .rotationEffect(.degrees(rotation))
                .offset(x: x, y: y)
                .opacity(0.8)
            }
    }

    // MARK: - End Session

    private var endSessionButton: some View {
        Button {
            router.navigate(to: .summary(
                grade: grade,
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
