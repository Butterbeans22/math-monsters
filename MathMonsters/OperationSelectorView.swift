import SwiftUI

struct OperationSelectorView: View {
    let grade: GradeLevel
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                gradeHeader
                instructionText
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
        HStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(grade.color.gradient)
                    .frame(width: 36, height: 36)
                Text(grade.emoji)
                    .font(.system(size: 17))
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(grade.displayName)
                    .font(.subheadline.bold())
                Text(grade.skillDescription)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .lineSpacing(1)
                    .lineLimit(2)
            }
            Spacer()
        }
        .padding(10)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var instructionText: some View {
        Text("Choose an operation to practice")
            .font(.caption)
            .foregroundStyle(.secondary)
    }

    // MARK: - Operation List

    private var operationList: some View {
        VStack(spacing: 10) {
            ForEach(grade.availableOperations) { operation in
                operationRow(operation)
            }
        }
    }

    private func operationRow(_ operation: MathOperation) -> some View {
        Button {
            router.navigate(to: .problemCountSelector(grade, operation))
        } label: {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(operation.color.opacity(0.18))
                        .frame(width: 44, height: 44)
                    Text(operation.emoji)
                        .font(.system(size: 22))
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(operation.rawValue)
                        .font(.subheadline.bold())
                        .foregroundStyle(.primary)
                    Text("Symbol: \(operation.symbol)")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
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
                    .stroke(Color.secondary.opacity(0.12), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}
