import SwiftUI

// MARK: - Route

enum Route: Hashable {
    case operationSelector(GradeLevel)
    case problemCountSelector(GradeLevel, MathOperation)
    case practice(GradeLevel, MathOperation, Int)
    case summary(grade: GradeLevel, correct: Int, incorrect: Int)
}

// MARK: - AppRouter

@MainActor
final class AppRouter: ObservableObject {
    @Published var path = NavigationPath()

    func navigate(to route: Route) {
        path.append(route)
    }

    func popToRoot() {
        path = NavigationPath()
    }
}
