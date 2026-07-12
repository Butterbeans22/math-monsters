import SwiftUI

struct GradeSelectorView: View {
    @EnvironmentObject private var router: AppRouter

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]
    private let gridSpacing: CGFloat = 10

    var body: some View {
        GeometryReader { proxy in
            let isCompact = proxy.size.height < 760
            let isUltraCompact = proxy.size.height < 690
            let stackSpacing: CGFloat = isUltraCompact ? 8 : 12
            let horizontalPadding: CGFloat = isUltraCompact ? 10 : 14
            let topPadding: CGFloat = isUltraCompact ? 4 : 8
            let bottomPadding: CGFloat = isUltraCompact ? 6 : 10
            let showInstruction = !isUltraCompact

            let cardHeight = equalCardHeight(
                for: proxy,
                isCompact: isCompact,
                isUltraCompact: isUltraCompact,
                stackSpacing: stackSpacing,
                topPadding: topPadding,
                bottomPadding: bottomPadding,
                showInstruction: showInstruction
            )

            VStack(spacing: stackSpacing) {
                headerView(isCompact: isCompact, isUltraCompact: isUltraCompact)
                if showInstruction {
                    instructionText(isCompact: isCompact)
                }
                gradeGrid(cardHeight: cardHeight, isCompact: isCompact)
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
                .font(.system(size: isUltraCompact ? 28 : (isCompact ? 30 : 34)))
            Text("Let's Practice Math!")
                .font((isCompact ? Font.subheadline : Font.headline).bold())
                .foregroundStyle(.primary)
        }
    }

    private func instructionText(isCompact: Bool) -> some View {
        Text("Choose your grade level to get started")
            .font(isCompact ? .caption2 : .caption)
            .foregroundStyle(.secondary)
    }

    // MARK: - Grade Grid

    private func gradeGrid(cardHeight: CGFloat, isCompact: Bool) -> some View {
        LazyVGrid(columns: columns, spacing: gridSpacing) {
            ForEach(GradeLevel.allCases) { grade in
                gradeCard(grade, cardHeight: cardHeight, isCompact: isCompact)
            }
        }
    }

    private func gradeCard(_ grade: GradeLevel, cardHeight: CGFloat, isCompact: Bool) -> some View {
        Button {
            router.navigate(to: .operationSelector(grade))
        } label: {
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(grade.emoji)
                        .font(.system(size: isCompact ? 22 : 26))
                    Spacer()
                    Image(systemName: "chevron.right.circle.fill")
                        .font(.system(size: isCompact ? 14 : 16, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.7))
                }

                Text(grade.displayName)
                    .font((isCompact ? Font.subheadline : Font.headline).bold())
                    .foregroundStyle(.white)

                Text(grade.skillDescription)
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.85))
                    .multilineTextAlignment(.leading)
                    .lineSpacing(1)
                    .lineLimit(2)
            }
            .padding(isCompact ? 9 : 12)
            .frame(minHeight: cardHeight, maxHeight: cardHeight)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(grade.color.gradient)
            )
            .shadow(color: grade.color.opacity(0.2), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(.plain)
    }

    private func equalCardHeight(
        for proxy: GeometryProxy,
        isCompact: Bool,
        isUltraCompact: Bool,
        stackSpacing: CGFloat,
        topPadding: CGFloat,
        bottomPadding: CGFloat,
        showInstruction: Bool
    ) -> CGFloat {
        let rows = Int(ceil(Double(GradeLevel.allCases.count) / 2.0))
        let safeAdjustedHeight = proxy.size.height - proxy.safeAreaInsets.top - proxy.safeAreaInsets.bottom

        // Conservative fixed-height estimates so cards always fit without clipping.
        let headerHeight: CGFloat = isUltraCompact ? 46 : (isCompact ? 52 : 58)
        let instructionHeight: CGFloat = showInstruction ? (isCompact ? 12 : 14) : 0

        let stackGapCount: CGFloat = showInstruction ? 2 : 1
        let rowGaps = CGFloat(max(rows - 1, 0))

        let remaining = safeAdjustedHeight
            - topPadding
            - bottomPadding
            - headerHeight
            - instructionHeight
            - (stackGapCount * stackSpacing)
            - (rowGaps * gridSpacing)

        let calculated = floor(remaining / CGFloat(rows))
        return max(84, calculated)
    }
}
