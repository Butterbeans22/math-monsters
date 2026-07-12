import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = GameViewModel()
    @State private var showSummary = false

    var body: some View {
        NavigationStack {
            GameView(viewModel: viewModel, showSummary: $showSummary)
                .navigationDestination(isPresented: $showSummary) {
                    SummaryView(
                        correctCount: viewModel.correctCount,
                        incorrectCount: viewModel.incorrectCount
                    ) {
                        viewModel.resetGame()
                        showSummary = false
                    }
                }
        }
    }
}
