import SwiftUI
import Firebase

class LoginViewModel: ObservableObject {

  @Published var code = ""
  @Published var number = ""

  @Published var errorMsg = ""
  @Published var error = false

  @Published var registerUser = false
  @AppStorage("current_status") var status = false

  @Published var isLoading = false

  func verifyUser() {

    isLoading = true

    Auth.auth().settings?.isAppVerificationDisabledForTesting = true

    let phoneNumber = "+" + code + number
    PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { [weak self] ID, error in

      if let err = error {
        self?.handleError(err)
        return
      }

      ChatAlert.alertView(msg: "Enter Verification Code") { code in
        guard let verifcationID = ID else { return }
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verifcationID, verificationCode: code)

        Auth.auth().signIn(with: credential) { result, error in

          if let err = error {
            self?.handleError(err)
            return
          }

          self?.checkUser()
        }
      }
    }
  }

  private func checkUser() {
    let reference = Firestore.firestore()
    guard let uid = Auth.auth().currentUser?.uid else { return }

    reference.collection("Users").whereField("uid", isEqualTo: uid).getDocuments { [unowned self] snapshot, error in
      if error != nil {
        self.registerUser = false
        self.isLoading = false
        return
      }

      guard let snap = snapshot, snap.documents.isEmpty else {
        registerUser = false
        isLoading = false
        return
      }
      self.status = true
    }
  }

  private func handleError(_ err: Error) {
    errorMsg = err.localizedDescription
    error.toggle()
    isLoading = false
  }
}
