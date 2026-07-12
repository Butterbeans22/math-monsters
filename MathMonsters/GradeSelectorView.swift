import SwiftUI

struct GradeSelectorView: View {
    @EnvironmentObject private var router: AppRouter

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        GeometryReader { proxy in
            VStack(spacing: 14) {
                headerView
                instructionText
                gradeGrid(cardHeight: cardHeight(for: proxy.size.height))
                Spacer(minLength: 0)
            }
            .padding(.horizontal, 14)
            .padding(.top, 8)
            .padding(.bottom, 10)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
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
                .font(.system(size: 34))
            Text("Let's Practice Math!")
                .font(.headline.bold())
                .foregroundStyle(.primary)
        }
    }

    private var instructionText: some View {
        Text("Choose your grade level to get started")
            .font(.caption)
            .foregroundStyle(.secondary)
    }

    // MARK: - Grade Grid

    private func gradeGrid(cardHeight: CGFloat) -> some View {
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(GradeLevel.allCases) { grade in
                gradeCard(grade, cardHeight: cardHeight)
            }
        }
    }

    private func gradeCard(_ grade: GradeLevel, cardHeight: CGFloat) -> some View {
        Button {
            router.navigate(to: .operationSelector(grade))
        } label: {
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(grade.emoji)
                        .font(.system(size: 26))
                    Spacer()
                    Image(systemName: "chevron.right.circle.fill")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.7))
                }

                Text(grade.displayName)
                    .font(.headline.bold())
                    .foregroundStyle(.white)

                Text(grade.skillDescription)
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.85))
                    .multilineTextAlignment(.leading)
                    .lineSpacing(1)
                    .lineLimit(2)
            }
            .padding(12)
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
        if availableHeight < 700 { return 106 }
        if availableHeight < 780 { return 114 }
        return 124
    }
}
