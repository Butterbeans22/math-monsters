import SwiftUI

struct GradeSelectorView: View {
    @EnvironmentObject private var router: AppRouter

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        ScrollView {
            VStack(spacing: 28) {
                headerView
                instructionText
                gradeGrid
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 24)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Math Monsters")
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(true)
    }

    // MARK: - Header

    private var headerView: some View {
        VStack(spacing: 8) {
            Text("🧮 👾 🧮")
                .font(.system(size: 48))
            Text("Let's Practice Math!")
                .font(.title2.bold())
                .foregroundStyle(.primary)
        }
    }

    private var instructionText: some View {
        Text("Choose your grade level to get started")
            .font(.subheadline)
            .foregroundStyle(.secondary)
    }

    // MARK: - Grade Grid

    private var gradeGrid: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(GradeLevel.allCases) { grade in
                gradeCard(grade)
            }
        }
    }

    private func gradeCard(_ grade: GradeLevel) -> some View {
        Button {
            router.navigate(to: .operationSelector(grade))
        } label: {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(grade.emoji)
                        .font(.system(size: 36))
                    Spacer()
                    Image(systemName: "chevron.right.circle.fill")
                        .font(.title3)
                        .foregroundStyle(.white.opacity(0.7))
                }

                Text(grade.displayName)
                    .font(.title2.bold())
                    .foregroundStyle(.white)

                Text(grade.skillDescription)
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.85))
                    .multilineTextAlignment(.leading)
                    .lineSpacing(2)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(grade.color.gradient)
            )
            .shadow(color: grade.color.opacity(0.35), radius: 6, x: 0, y: 4)
        }
        .buttonStyle(.plain)
    }
}
