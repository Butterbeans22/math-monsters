import SwiftUI

struct OperationSelectorView: View {
    let grade: GradeLevel
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                gradeHeader
                operationList
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationTitle(grade.displayName)
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Grade Header

    private var gradeHeader: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 10) {
                GradeMonsterBadge(grade: grade, size: 40, mood: .proud)

                VStack(alignment: .leading, spacing: 4) {
                    Text(grade.displayName)
                        .font(.subheadline.bold())
                    Text(grade.monsterLabel)
                        .font(.caption.bold())
                        .foregroundStyle(grade.color)
                    Text(grade.operationSummary)
                        .font(.caption.bold())
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }

            Text(grade.monsterCatchphrase)
                .font(.caption.bold())
                .foregroundStyle(.primary)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(grade.color.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
        .padding(10)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - Operation List

    private var operationList: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            ForEach(grade.availableOperations) { operation in
                operationRow(operation)
            }
        }
    }

    private func operationRow(_ operation: MathOperation) -> some View {
        Button {
            router.navigate(to: .problemCountSelector(grade, operation))
        } label: {
            operationRowContent(operation, isPressed: false)
        }
        .buttonStyle(InteractiveMonsterCardStyle { configuration in
            operationRowContent(operation, isPressed: configuration.isPressed)
        })
    }

    private func operationRowContent(_ operation: MathOperation, isPressed: Bool) -> some View {
        VStack(spacing: 10) {
            HStack(spacing: 8) {
                GradeMonsterBadge(grade: grade, size: 24, mood: isPressed ? .excited : .calm)

                VStack(alignment: .leading, spacing: 1) {
                    Text(grade.monsterName)
                        .font(.caption.bold())
                        .foregroundStyle(grade.color)
                    Text(grade.monsterFamily)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }

                Spacer(minLength: 0)
            }

            ZStack {
                RoundedRectangle(cornerRadius: 18)
                    .fill(operation.color.opacity(isPressed ? 0.28 : 0.18))
                    .frame(width: 88, height: 88)
                Text(operation.emoji)
                    .font(.system(size: 42))
            }

            Text(operation.rawValue)
                .font(.subheadline.bold())
                .foregroundStyle(.primary)
                .multilineTextAlignment(.center)

            Text(isPressed ? operation.cheerLine : grade.operationCatchphrase(for: operation))
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, minHeight: 150)
        .padding(.horizontal, 12)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(operation.color.opacity(isPressed ? 0.4 : 0.12), lineWidth: isPressed ? 1.5 : 1)
        )
    }
}
