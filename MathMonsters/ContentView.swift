import SwiftUI

struct ContentView: View {
    @StateObject private var router = AppRouter()

    var body: some View {
        NavigationStack(path: $router.path) {
            GradeSelectorView()
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .operationSelector(let grade):
                        OperationSelectorView(grade: grade)
                    case .practice(let grade, let operation):
                        PracticeView(grade: grade, operation: operation)
                    case .summary(let correct, let incorrect):
                        SummaryView(correctCount: correct, incorrectCount: incorrect)
                    }
                }
        }
        .environmentObject(router)
    }
}

