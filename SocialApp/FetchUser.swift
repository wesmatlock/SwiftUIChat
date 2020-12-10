import SwiftUI
import Firebase

struct Fetch {
  static func user(uid: String, completion: @escaping (UserModel) -> ()) {

    Firestore.firestore().collection("Users").document(uid).getDocument { (snapshot, error) in
      guard let user = snapshot else { return }

      let username = user.data()?["username"] as! String
      let picture = user.data()?["imageurl"] as! String
      let bio = user.data()?["bio"] as! String
      let uid = user.documentID

      DispatchQueue.main.async {
        completion(UserModel(username: username, picture: picture, bio: bio, uid: uid))
      }
    }
  }
}
