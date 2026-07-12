import SwiftUI

struct OperationSelectorView: View {
    let grade: GradeLevel
    @EnvironmentObject private var router: AppRouter

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        GeometryReader { proxy in
            let isCompact = proxy.size.height < 760
            let isUltraCompact = proxy.size.height < 690

            VStack(spacing: isUltraCompact ? 8 : 12) {
                gradeHeader(isCompact: isCompact)
                if !isUltraCompact {
                    instructionText(isCompact: isCompact)
                }
                operationGrid(isCompact: isCompact)
                Spacer(minLength: 0)
            }
            .padding(.horizontal, isUltraCompact ? 10 : 14)
            .padding(.top, isUltraCompact ? 4 : 8)
            .padding(.bottom, isUltraCompact ? 6 : 10)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationTitle(grade.displayName)
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Grade Header

    private func gradeHeader(isCompact: Bool) -> some View {
        HStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(grade.color.gradient)
                    .frame(width: isCompact ? 38 : 46, height: isCompact ? 38 : 46)
                Text(grade.emoji)
                    .font(.system(size: isCompact ? 18 : 22))
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(grade.displayName)
                    .font((isCompact ? Font.subheadline : Font.headline).bold())
                Text(grade.skillDescription)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .lineSpacing(1)
                    .lineLimit(2)
            }
            Spacer()
        }
        .padding(isCompact ? 8 : 10)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private func instructionText(isCompact: Bool) -> some View {
        Text("Choose an operation to practice")
            .font(isCompact ? .caption2 : .caption)
            .foregroundStyle(.secondary)
    }

    // MARK: - Operation Grid

    private func operationGrid(isCompact: Bool) -> some View {
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(grade.availableOperations) { operation in
                operationCard(operation, isCompact: isCompact)
            }
        }
    }

    private func operationCard(_ operation: MathOperation, isCompact: Bool) -> some View {
        Button {
            router.navigate(to: .practice(grade, operation))
        } label: {
            VStack(spacing: 8) {
                Text(operation.emoji)
                    .font(.system(size: isCompact ? 24 : 28))

                Text(operation.symbol)
                    .font(.system(size: isCompact ? 20 : 24, weight: .black, design: .rounded))
                    .foregroundStyle(.white)

                Text(operation.rawValue)
                    .font((isCompact ? Font.caption : Font.subheadline).bold())
                    .foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, isCompact ? 10 : 14)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(operation.color.gradient)
            )
            .shadow(color: operation.color.opacity(0.2), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(.plain)
    }
}
