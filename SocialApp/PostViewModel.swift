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
        let userRef = doc.document.data()["ref"]  as! DocumentReference

        Fetch.user(uid: userRef.documentID) { [weak self] user in
          self?.posts.append(PostModel(id: doc.document.documentID,
                                       title: title, picture: picture, date: time.dateValue(), user: user))
          self?.posts.sort { (p1, p2) -> Bool in
            return p1.date > p2.date
          }
        }

        if doc.type == .removed {
          let id = doc.document.documentID
          self?.posts.removeAll { post -> Bool in
            return post.id == id
          }
        }

        if doc.type == .modified {
          let id = doc.document.documentID
          let title = doc.document.data()["title"] as! String

          let index = self?.posts.firstIndex { post -> Bool in
            return post.id == id
          } ?? -1  //FIXME: - Should not do this

          if index != -1 {
            self?.posts[index].title = title
            self?.updateId = ""
          }
        }
      }
    }
  }

  func delete(post id: String) {
    firestore.collection("Posts").document(id).delete() { error in
      if error != nil {
        print(error?.localizedDescription ?? "\(#function) - Unknown Error")
      }
    }
  }

  func edit(post id: String) {
    updateId = id
    newPost.toggle()
  }
}
