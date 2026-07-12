import SwiftUI

struct OperationSelectorView: View {
    let grade: GradeLevel
    @EnvironmentObject private var router: AppRouter

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        ScrollView {
            VStack(spacing: 28) {
                gradeHeader
                instructionText
                operationGrid
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 24)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(grade.displayName)
        .navigationBarTitleDisplayMode(.large)
    }

    // MARK: - Grade Header

    private var gradeHeader: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(grade.color.gradient)
                    .frame(width: 64, height: 64)
                Text(grade.emoji)
                    .font(.system(size: 32))
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(grade.displayName)
                    .font(.title.bold())
                Text(grade.skillDescription)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineSpacing(2)
            }
            Spacer()
        }
        .padding(16)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var instructionText: some View {
        Text("Choose an operation to practice")
            .font(.subheadline)
            .foregroundStyle(.secondary)
    }

    // MARK: - Operation Grid

    private var operationGrid: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(grade.availableOperations) { operation in
                operationCard(operation)
            }
        }
    }

    private func operationCard(_ operation: MathOperation) -> some View {
        Button {
            router.navigate(to: .practice(grade, operation))
        } label: {
            VStack(spacing: 12) {
                Text(operation.emoji)
                    .font(.system(size: 44))

                Text(operation.symbol)
                    .font(.system(size: 36, weight: .black, design: .rounded))
                    .foregroundStyle(.white)

                Text(operation.rawValue)
                    .font(.headline)
                    .foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 24)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(operation.color.gradient)
            )
            .shadow(color: operation.color.opacity(0.35), radius: 6, x: 0, y: 4)
        }
        .buttonStyle(.plain)
    }
}
