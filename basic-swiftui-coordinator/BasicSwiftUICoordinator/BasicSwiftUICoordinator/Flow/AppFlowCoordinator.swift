import SwiftUI

enum Page: String {
    case parent
    case firstChild
    case secondChild
}

class AppFlowCoordinator: ObservableObject {
    
    // The AppFlowCoordinator controls a navigation flow so, in this case we are
    // going to us a path
    @Published var path = NavigationPath()
    
    func push(_ page: Page) {
        path.append(page)
    }
    
    func backToRoot() {
        path.removeLast(path.count)
    }
    
    // MARK: - Builders
    @ViewBuilder
    func build(page: Page) -> some View {
        switch page {
        case .parent: ParentView()
        case .firstChild: FirstChildView()
        case .secondChild: SecondChildView()
        }
    }
}
