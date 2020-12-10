import SwiftUI
import Firebase

class RegisterViewModel: ObservableObject {

  @Published var name = ""
  @Published var bio = ""

  @Published var imageData = Data(count: 0)
  @Published var picker = false

  @Published var isLoading = false

  @AppStorage("current_status") var status = false

  let firestore = Firestore.firestore()

  func register() {
    isLoading = true

    guard let uid = Auth.auth().currentUser?.uid else {
      isLoading = false
      return
    }

    ImageService.uploadImage(imageData: imageData, path: "profile_Photos") { [weak self] url in
      self?.firestore.collection("Users").document(uid).setData(
        [
          "uid": uid,
          "imageurl": url,
          "username": self?.name ?? "",
          "bio": self?.bio ?? "",
          "dateCreated": Date()
        ]) { error in
        self?.isLoading = false

        if error != nil {
          return
        }

        self?.status = true
      }
    }
  }
}
