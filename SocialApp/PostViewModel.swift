import SwiftUI
import Firebase

//TODO: - Move this
struct PostModel: Identifiable {
  var id: String

  var title: String
  var picture: String
  var date: Date
  var user: UserModel
}

//TODO: - Move this
struct UserModel {
  var username: String
  var picture: String
  var bio: String
  var uid: String
}

class PostViewModel: ObservableObject {

  @Published var posts: [PostModel] = []
  @Published var noPosts = false
  @Published var newPost = false
  @Published var updateId = ""

  let firestore = Firestore.firestore()

  init() {
    getAllPosts()
  }

  func getAllPosts() {

    firestore.collection("Posts").addSnapshotListener{ [weak self] snapshot, error in
      guard let docs = snapshot, docs.documentChanges.isEmpty else {
        self?.noPosts = true
        return
      }

      docs.documentChanges.forEach { doc in

        let title = doc.document.data()["title"] as! String
        let time = doc.document.data()["time"] as! Timestamp
        let picture = doc.document.data()["url"] as! String
        let userRef = doc.document.data()["ref"] as! String

//        Fetch.user(uid: userRef.documentID) { user in
//
//        }
      }
    }
  }
}
