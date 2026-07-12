import SwiftUI

struct GameView: View {
    @ObservedObject var viewModel: GameViewModel
    @Binding var showSummary: Bool
    @FocusState private var answerFocused: Bool

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                headerView
                gradeSelectionView
                operationSelectionView
                problemView
                answerInputView
                feedbackView
                scoreView
                bottomButtons
            }
            .padding()
        }
        .navigationTitle("Math Monsters")
        .navigationBarTitleDisplayMode(.large)
        .background(Color(.systemGroupedBackground))
    }

    // MARK: - Header

    private var headerView: some View {
        HStack {
            Text("🧮")
                .font(.system(size: 48))
            Text("👾")
                .font(.system(size: 48))
            Text("🧮")
                .font(.system(size: 48))
        }
    }

    // MARK: - Grade Selection (mirrors uiGradeGroupBox)

    private var gradeSelectionView: some View {
        GroupBox("Grade Level") {
            HStack(spacing: 12) {
                ForEach(GradeLevel.allCases) { grade in
                    gradeButton(grade)
                }
            }
            .frame(maxWidth: .infinity)
        }
    }

    private func gradeButton(_ grade: GradeLevel) -> some View {
        Button {
            viewModel.selectedGrade = grade
            viewModel.gradeChanged()
        } label: {
            Text(grade.displayName)
                .font(.subheadline.bold())
                .foregroundStyle(viewModel.selectedGrade == grade ? .white : .primary)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(viewModel.selectedGrade == grade ? Color.indigo : Color(.systemBackground))
                )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Operation Selection (mirrors uiOperationGroupBox)

    private var operationSelectionView: some View {
        GroupBox("Operation") {
            HStack(spacing: 20) {
                ForEach(MathOperation.allCases) { op in
                    operationButton(op)
                }
            }
            .frame(maxWidth: .infinity)
        }
    }

    private func operationButton(_ op: MathOperation) -> some View {
        Button {
            viewModel.selectedOperation = op
            viewModel.generateProblem()
        } label: {
            HStack(spacing: 6) {
                Text(op.symbol)
                    .font(.title2.bold())
                Text(op.rawValue)
                    .font(.subheadline.bold())
            }
            .foregroundStyle(viewModel.selectedOperation == op ? .white : .primary)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(viewModel.selectedOperation == op ? Color.orange : Color(.systemBackground))
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Problem Display (mirrors uiProblemGroupBox with +/= picture boxes)

    private var problemView: some View {
        GroupBox("Problem") {
            Text(viewModel.currentProblem.displayString)
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .minimumScaleFactor(0.5)
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
        }
    }

    // MARK: - Answer Input (mirrors uiAnswerTextBox + uiCheckAnswerButton)

    private var answerInputView: some View {
        GroupBox("Your Answer") {
            HStack(spacing: 12) {
                TextField("?", text: $viewModel.answerText)
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .multilineTextAlignment(.center)
                    .keyboardType(.numberPad)
                    .focused($answerFocused)
                    .frame(width: 120, height: 60)
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.secondary, lineWidth: 1))
                    .disabled(viewModel.answerState != .unanswered)

                Button {
                    answerFocused = false
                    viewModel.checkAnswer()
                } label: {
                    Text("Check!")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(viewModel.answerText.isEmpty || viewModel.answerState != .unanswered
                                      ? Color.gray : Color.green)
                        )
                }
                .disabled(viewModel.answerText.isEmpty || viewModel.answerState != .unanswered)
            }
            .frame(maxWidth: .infinity)
        }
    }

    // MARK: - Feedback (mirrors uiAnswerPictureBox / uiHappyPictureBox / uiNeutralPictureBox)

    @ViewBuilder
    private var feedbackView: some View {
        switch viewModel.answerState {
        case .unanswered:
            EmptyView()
        case .correct:
            feedbackCard(
                emoji: "🎉",
                message: "Correct!",
                color: .green
            )
        case .incorrect:
            feedbackCard(
                emoji: "😬",
                message: "Not quite! The answer is \(viewModel.currentProblem.correctAnswer)",
                color: .red
            )
        }
    }

    private func feedbackCard(emoji: String, message: String, color: Color) -> some View {
        HStack(spacing: 12) {
            Text(emoji)
                .font(.system(size: 40))
            Text(message)
                .font(.title3.bold())
                .foregroundStyle(color)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(color.opacity(0.12))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .transition(.scale.combined(with: .opacity))
        .animation(.spring(duration: 0.3), value: viewModel.answerState)
    }

    // MARK: - Score (mirrors uiCorrectLabel / uiIncorrectLabel)

    private var scoreView: some View {
        GroupBox("Score") {
            HStack(spacing: 32) {
                VStack {
                    Text("\(viewModel.correctCount)")
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .foregroundStyle(.green)
                    Text("Correct")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Divider().frame(height: 50)
                VStack {
                    Text("\(viewModel.incorrectCount)")
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .foregroundStyle(.red)
                    Text("Incorrect")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(maxWidth: .infinity)
        }
    }

    // MARK: - Bottom Buttons (mirrors uiExitButton / next problem)

    private var bottomButtons: some View {
        HStack(spacing: 16) {
            Button {
                showSummary = true
            } label: {
                Label("Summary", systemImage: "chart.bar.fill")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.indigo))
            }

            if viewModel.answerState != .unanswered {
                Button {
                    viewModel.nextProblem()
                } label: {
                    Label("Next", systemImage: "arrow.right.circle.fill")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(RoundedRectangle(cornerRadius: 12).fill(Color.orange))
                }
                .transition(.move(edge: .trailing).combined(with: .opacity))
                .animation(.spring(duration: 0.3), value: viewModel.answerState)
            }
        }
    }
}
