import SwiftUI

struct GradeSelectorView: View {
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                headerView
                gradeList
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationTitle("Math Monsters")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
    }

    // MARK: - Header

    private var headerView: some View {
        VStack(spacing: 4) {
            Text("🧮 👾 🧮")
                .font(.system(size: 28))
            Text("Let's Practice Math!")
                .font(.subheadline.bold())
                .foregroundStyle(.primary)
        }
    }

    // MARK: - Grade List

    private var gradeList: some View {
        VStack(spacing: 10) {
            ForEach(GradeLevel.allCases) { grade in
                gradeRow(grade)
            }
        }
    }

    private func gradeRow(_ grade: GradeLevel) -> some View {
        Button {
            router.navigate(to: .operationSelector(grade))
        } label: {
            gradeRowContent(grade, isPressed: false)
        }
        .buttonStyle(InteractiveMonsterCardStyle { configuration in
            gradeRowContent(grade, isPressed: configuration.isPressed)
        })
    }

    private func gradeRowContent(_ grade: GradeLevel, isPressed: Bool) -> some View {
        HStack(spacing: 12) {
            GradeMonsterBadge(grade: grade, size: 52, mood: isPressed ? .excited : .calm)

            VStack(alignment: .leading, spacing: 2) {
                Text(grade.displayName)
                    .font(.subheadline.bold())
                    .foregroundStyle(.primary)
                Text(grade.monsterLabel)
                    .font(.caption)
                    .foregroundStyle(grade.color)
                Text(isPressed ? grade.pressedCatchphrase : grade.monsterCatchphrase)
                    .font(.caption2.bold())
                    .foregroundStyle(.primary)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(grade.color.opacity(isPressed ? 0.22 : 0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                HStack(spacing: 6) {
                    ForEach(grade.availableOperations) { operation in
                        Text(operation.symbol)
                            .font(.caption.bold())
                            .foregroundStyle(operation.color)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(operation.color.opacity(0.14))
                            .clipShape(Capsule())
                    }
                }
            }
            Spacer()

            Image(systemName: "chevron.right")
                .foregroundStyle(.secondary)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(grade.color.opacity(isPressed ? 0.35 : 0.12), lineWidth: isPressed ? 1.5 : 1)
        )
    }
}

struct InteractiveMonsterCardStyle<Content: View>: ButtonStyle {
    let content: (Configuration) -> Content

    func makeBody(configuration: Configuration) -> some View {
        content(configuration)
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.spring(response: 0.22, dampingFraction: 0.72), value: configuration.isPressed)
    }
}
