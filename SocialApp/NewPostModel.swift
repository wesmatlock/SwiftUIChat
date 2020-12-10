import SwiftUI
import Firebase

class NewPostModel: ObservableObject {

  @Published var postText = ""
  @Published var picker = false
  @Published var imageData = Data(count: 0)

  @Published var isPosting = false

  let uid = Auth.auth().currentUser?.uid
  let firestore = Firestore.firestore()

  func post(updateId: String, present: Binding<Any>) {
    isPosting = true

    if !updateId.isEmpty {

      firestore.collection("Posts").document(updateId).updateData(["title": postText]) { [weak self] error in

        self?.isPosting = false

        if error != nil { return }

        (present.wrappedValue as AnyObject).dismiss()
      }
      return
    }

    if imageData.count == 0 {
      firestore.collection("Posts").document().setData([
        "title": self.postText,
        "url": "",
        "ref": firestore.collection("Users").document(self.uid ?? ""),   //FIXME: - UID need to be figured out
        "time": Date()
      ]) { error in
        self.isPosting = false

        if error != nil { return }

        (present.wrappedValue as AnyObject).dismiss()
      }
    }
    else {
      ImageService.uploadImage(imageData: imageData, path: "psot_Pics") { url in

        firestore.collection("Posts").document().setData([

          "title": self.postText,
          "url": url,
          "ref": firestore.collection("Users").document(self.uid ?? ""),   //FIXME: - UID need to be figured out
          "time": Date()
        ]) { error in
          self.isPosting = false

          if error != nil { return }

          present.wrappedValue.dismiss()
        }
      }
    }
  }
}
