import SwiftUI

struct GradeSelectorView: View {
    @EnvironmentObject private var router: AppRouter
    private let tileSpacing: CGFloat = 6

    var body: some View {
        GeometryReader { proxy in
            let isCompact = proxy.size.height < 760
            let isUltraCompact = proxy.size.height < 690
            let stackSpacing: CGFloat = isUltraCompact ? 6 : 10
            let horizontalPadding: CGFloat = isUltraCompact ? 10 : 14
            let topPadding: CGFloat = isUltraCompact ? 4 : 8
            let bottomPadding: CGFloat = isUltraCompact ? 6 : 10
            let showInstruction = proxy.size.height >= 680
            let tileSize = gradeTileSize(for: proxy.size.width, horizontalPadding: horizontalPadding)

            VStack(spacing: stackSpacing) {
                headerView(isCompact: isCompact, isUltraCompact: isUltraCompact)
                if showInstruction {
                    instructionText(isCompact: isCompact)
                }
                gradeRow(tileSize: tileSize, isCompact: isCompact)
                Spacer(minLength: 0)
            }
            .padding(.horizontal, horizontalPadding)
            .padding(.top, topPadding)
            .padding(.bottom, bottomPadding)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationTitle("Math Monsters")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
    }

    // MARK: - Header

    private func headerView(isCompact: Bool, isUltraCompact: Bool) -> some View {
        VStack(spacing: isUltraCompact ? 2 : 4) {
            Text("🧮 👾 🧮")
                .font(.system(size: isUltraCompact ? 22 : (isCompact ? 24 : 28)))
            Text("Let's Practice Math!")
                .font((isCompact ? Font.caption : Font.subheadline).bold())
                .foregroundStyle(.primary)
        }
    }

    private func instructionText(isCompact: Bool) -> some View {
        Text("Choose your grade level to get started")
            .font(isCompact ? .caption2 : .caption)
            .foregroundStyle(.secondary)
    }

    // MARK: - Grade Row

    private func gradeRow(tileSize: CGFloat, isCompact: Bool) -> some View {
        HStack(spacing: tileSpacing) {
            ForEach(GradeLevel.allCases) { grade in
                gradeTile(grade, tileSize: tileSize, isCompact: isCompact)
            }
        }
    }

    private func gradeTile(_ grade: GradeLevel, tileSize: CGFloat, isCompact: Bool) -> some View {
        Button {
            router.navigate(to: .operationSelector(grade))
        } label: {
            VStack(spacing: 2) {
                Text(grade.emoji)
                    .font(.system(size: isCompact ? 18 : 20))

                Text("G\(grade.rawValue)")
                    .font(.system(size: isCompact ? 10 : 11, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
            }
            .frame(width: tileSize, height: tileSize)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(grade.color.gradient)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.white.opacity(0.25), lineWidth: 1)
            )
            .shadow(color: grade.color.opacity(0.18), radius: 3, x: 0, y: 2)
        }
        .buttonStyle(.plain)
    }

    private func gradeTileSize(for width: CGFloat, horizontalPadding: CGFloat) -> CGFloat {
        let count = CGFloat(GradeLevel.allCases.count)
        let available = width - (horizontalPadding * 2) - (tileSpacing * (count - 1))
        let calculated = floor(available / count)
        return max(48, min(68, calculated))
    }
}
