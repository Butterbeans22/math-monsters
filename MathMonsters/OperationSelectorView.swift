import SwiftUI

struct OperationSelectorView: View {
    let grade: GradeLevel
    @EnvironmentObject private var router: AppRouter

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        GeometryReader { _ in
            VStack(spacing: 12) {
                gradeHeader
                instructionText
                operationGrid
                Spacer(minLength: 0)
            }
            .padding(.horizontal, 14)
            .padding(.top, 8)
            .padding(.bottom, 10)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
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
                    .frame(width: 46, height: 46)
                Text(grade.emoji)
                    .font(.system(size: 22))
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(grade.displayName)
                    .font(.headline.bold())
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

    // MARK: - Operation Grid

    private var operationGrid: some View {
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(grade.availableOperations) { operation in
                operationCard(operation)
            }
        }
    }

    private func operationCard(_ operation: MathOperation) -> some View {
        Button {
            router.navigate(to: .practice(grade, operation))
        } label: {
            VStack(spacing: 8) {
                Text(operation.emoji)
                    .font(.system(size: 28))

                Text(operation.symbol)
                    .font(.system(size: 24, weight: .black, design: .rounded))
                    .foregroundStyle(.white)

                Text(operation.rawValue)
                    .font(.subheadline.bold())
                    .foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(operation.color.gradient)
            )
            .shadow(color: operation.color.opacity(0.2), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(.plain)
    }
}
