import SwiftUI
import Firebase

struct ChatUIApp: App {

  @Environment(\.scenePhase) var scenePhase

  var body: some Scene {
    WindowGroup {
      ContentView()
        .onOpenURL(perform: { url in
          Auth.auth().canHandle(url)
        })
    }
    .onChange(of: scenePhase) { newPhase in
      switch newPhase {

      case .background:
        break
      case .inactive:
        break
      case .active:
        FirebaseApp.configure()
      @unknown default:
        break
      }
    }
  }
}
