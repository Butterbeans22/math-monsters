import SwiftUI

struct GradeSelectorView: View {
    @EnvironmentObject private var router: AppRouter

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        GeometryReader { proxy in
            let isCompact = proxy.size.height < 760
            let isUltraCompact = proxy.size.height < 690

            VStack(spacing: isUltraCompact ? 8 : 12) {
                headerView(isCompact: isCompact, isUltraCompact: isUltraCompact)
                if !isUltraCompact {
                    instructionText(isCompact: isCompact)
                }
                gradeGrid(cardHeight: cardHeight(for: proxy.size.height), isCompact: isCompact)
                Spacer(minLength: 0)
            }
            .padding(.horizontal, isUltraCompact ? 10 : 14)
            .padding(.top, isUltraCompact ? 4 : 8)
            .padding(.bottom, isUltraCompact ? 6 : 10)
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
        LazyVGrid(columns: columns, spacing: 10) {
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

    private func cardHeight(for availableHeight: CGFloat) -> CGFloat {
        if availableHeight < 690 { return 92 }
        if availableHeight < 700 { return 106 }
        if availableHeight < 780 { return 114 }
        return 124
    }
}
