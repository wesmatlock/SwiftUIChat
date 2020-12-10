import SwiftUI
import Firebase

struct ImageService {

  static func uploadImage(imageData: Data, path: String, completion: @escaping (String) -> ()) {

    let storage = Storage.storage().reference()
    guard let uid = Auth.auth().currentUser?.uid else {
      return
    }

    storage.child(path).child(uid).downloadURL { (url, error) in
      if error != nil {
        completion("")
        return
      }

      completion("\(String(describing: url))")
    }
  }
}
