import SwiftUI

struct ContentView: View {

  @AppStorage("current_status") var status = false

  var body: some View {

    NavigationView {

      VStack {
        if status{
          Home()
        } else {
          Login()
        }
      }
    }
    
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
