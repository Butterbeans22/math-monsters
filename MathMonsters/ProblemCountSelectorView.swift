import SwiftUI

struct ProblemCountSelectorView: View {
    let grade: GradeLevel
    let operation: MathOperation

    @EnvironmentObject private var router: AppRouter
    @State private var problemCountText: String = "10"

    private var parsedCount: Int? {
        guard let value = Int(problemCountText.trimmingCharacters(in: .whitespaces)) else { return nil }
        guard value > 0, value <= 100 else { return nil }
        return value
    }

    var body: some View {
        VStack(spacing: 24) {
            headerCard
            inputCard
            quickPickButtons
            Spacer(minLength: 0)
            startButton
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationTitle("How Many Problems?")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var headerCard: some View {
        HStack(spacing: 12) {
            GradeMonsterBadge(grade: grade, size: 44)

            VStack(alignment: .leading, spacing: 3) {
                Text("\(grade.displayName) · \(operation.rawValue)")
                    .font(.subheadline.bold())
                Text("Enter how many practice problems you want")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding(12)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var inputCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Number of Problems")
                .font(.caption.bold())
                .foregroundStyle(.secondary)

            TextField("Enter a number (1-100)", text: $problemCountText)
                .keyboardType(.numberPad)
                .font(.title2.bold())
                .padding(14)
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(parsedCount == nil ? Color.red.opacity(0.5) : Color.secondary.opacity(0.25), lineWidth: 1.5)
                )

            if parsedCount == nil {
                Text("Please enter a whole number from 1 to 100")
                    .font(.caption2)
                    .foregroundStyle(.red)
            }
        }
    }

    private var quickPickButtons: some View {
        HStack(spacing: 10) {
            quickPickButton(5)
            quickPickButton(10)
            quickPickButton(20)
        }
    }

    private func quickPickButton(_ value: Int) -> some View {
        Button {
            problemCountText = "\(value)"
        } label: {
            Text("\(value)")
                .font(.subheadline.bold())
                .foregroundStyle(.primary)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(Color(.systemBackground))
                .clipShape(Capsule())
                .overlay(
                    Capsule().stroke(Color.secondary.opacity(0.3), lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }

    private var startButton: some View {
        Button {
            guard let count = parsedCount else { return }
            router.navigate(to: .practice(grade, operation, count))
        } label: {
            Label("Start Practice", systemImage: "play.fill")
                .font(.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(parsedCount == nil ? Color.gray : operation.color)
                )
        }
        .disabled(parsedCount == nil)
        .buttonStyle(.plain)
    }
}
