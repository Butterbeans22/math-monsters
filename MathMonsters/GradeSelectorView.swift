import SwiftUI

struct GradeSelectorView: View {
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                headerView
                instructionText
                gradeList
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
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
                .font(.system(size: 28))
            Text("Let's Practice Math!")
                .font(.subheadline.bold())
                .foregroundStyle(.primary)
        }
    }

    private var instructionText: some View {
        Text("Choose your grade level to get started")
            .font(.caption)
            .foregroundStyle(.secondary)
    }

    // MARK: - Grade List

    private var gradeList: some View {
        VStack(spacing: 10) {
            ForEach(GradeLevel.allCases) { grade in
                gradeRow(grade)
            }
        }
    }

    private func gradeRow(_ grade: GradeLevel) -> some View {
        Button {
            router.navigate(to: .operationSelector(grade))
        } label: {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(grade.color.opacity(0.18))
                        .frame(width: 44, height: 44)
                    Text(grade.emoji)
                        .font(.system(size: 22))
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(grade.displayName)
                        .font(.subheadline.bold())
                        .foregroundStyle(.primary)
                    Text(grade.skillDescription.replacingOccurrences(of: "\n", with: " • "))
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
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
