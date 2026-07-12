import SwiftUI

struct OperationSelectorView: View {
    let grade: GradeLevel
    @EnvironmentObject private var router: AppRouter
    private let tileSpacing: CGFloat = 8

    var body: some View {
        GeometryReader { proxy in
            let isCompact = proxy.size.height < 760
            let isUltraCompact = proxy.size.height < 690
            let horizontalPadding: CGFloat = isUltraCompact ? 10 : 14
            let tileSize = operationTileSize(
                for: proxy.size.width,
                horizontalPadding: horizontalPadding,
                operationCount: grade.availableOperations.count
            )

            VStack(spacing: isUltraCompact ? 8 : 12) {
                gradeHeader(isCompact: isCompact)
                if !isUltraCompact {
                    instructionText(isCompact: isCompact)
                }
                operationRow(tileSize: tileSize, isCompact: isCompact)
                Spacer(minLength: 0)
            }
            .padding(.horizontal, horizontalPadding)
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
                    .frame(width: isCompact ? 32 : 36, height: isCompact ? 32 : 36)
                Text(grade.emoji)
                    .font(.system(size: isCompact ? 15 : 17))
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(grade.displayName)
                    .font((isCompact ? Font.caption : Font.subheadline).bold())
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

    // MARK: - Operation Row

    private func operationRow(tileSize: CGFloat, isCompact: Bool) -> some View {
        HStack(spacing: tileSpacing) {
            ForEach(grade.availableOperations) { operation in
                operationTile(operation, tileSize: tileSize, isCompact: isCompact)
            }
        }
    }

    private func operationTile(_ operation: MathOperation, tileSize: CGFloat, isCompact: Bool) -> some View {
        Button {
            router.navigate(to: .practice(grade, operation))
        } label: {
            VStack(spacing: 2) {
                Text(operation.emoji)
                    .font(.system(size: isCompact ? 18 : 20))

                Text(operation.symbol)
                    .font(.system(size: isCompact ? 14 : 16, weight: .black, design: .rounded))
                    .foregroundStyle(.white)

                Text(operation.rawValue)
                    .font(.system(size: isCompact ? 8 : 9, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
            .frame(width: tileSize, height: tileSize)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(operation.color.gradient)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.white.opacity(0.25), lineWidth: 1)
            )
            .shadow(color: operation.color.opacity(0.18), radius: 3, x: 0, y: 2)
        }
        .buttonStyle(.plain)
    }

    private func operationTileSize(for width: CGFloat, horizontalPadding: CGFloat, operationCount: Int) -> CGFloat {
        let count = CGFloat(max(1, operationCount))
        let available = width - (horizontalPadding * 2) - (tileSpacing * (count - 1))
        let calculated = floor(available / count)
        return max(56, min(84, calculated))
    }
}
