import Foundation

enum MenuOption {
    case home, insertData, selectData, serverSync

    var title: String {
        switch self {
        case .home: return "Home"
        case .insertData: return "Insert Data"
        case .selectData: return "Select Data"
        case .serverSync: return "Server Sync"
        }
    }
}
