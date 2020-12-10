import SwiftUI
import Firebase

class SettingsViewModel: ObservableObject {

  @Published var userInfo = UserModel(username: "", picture: "", bio: "", uid: "")
  @AppStorage("current_status") var status = false


  @Published var picker = false
  @Published var imageData = Data(count: 0)

  @Published var isLoading = false

  let firestore = Firestore.firestore()
  let uid = Auth.auth().currentUser?.uid

  init() {
    Fetch.user(uid: uid!) { user in
      self.userInfo = user
    }
  }

  func logout() throws {
    try Auth.auth().signOut()
    status = false
  }

  func updateImage() {

    isLoading = true

    ImageService.uploadImage(imageData: imageData, path: "profile_Photos") { url in

      self.firestore.collection("Users").document(self.uid!).updateData( ["imageurl": url] ) { error in
        self.isLoading = false

        if error != nil { return }

        Fetch.user(uid: self.uid!) { (user) in
          self.userInfo = user
        }
      }
    }
  }

  func updateDetails(field: String) {

    ChatAlert.alertView(msg: "Update: \(field)") { (text) in
      self.updateBio(id: field == "Name" ? "username" : "bio", value: text)
    }
  }

  func updateBio(id: String, value: String) {
    firestore.collection("Users").document(uid!).updateData( [id: value]) { error in
      if error != nil { return }

      Fetch.user(uid: self.uid!) { (user) in
        self.userInfo = user
      }
    }
  }
}
