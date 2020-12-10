import SwiftUI

struct NewPost: View {

  @StateObject var newPostData = NewPostModel()
  @Environment(\.presentationMode) var present
  @Binding var updateId: String

  var body: some View {

    LazyVStack {

      LazyHStack(spacing: 15) {
        Button(action: {
          self.updateId = ""
          present.wrappedValue.dismiss()
        }) {
          Text("Cancel")
            .fontWeight(.bold)
            .foregroundColor(.blue)
        }

        Spacer(minLength: 0)

        if updateId == "" {
          Button(action: {newPostData.picker.toggle()}) {
            Image(systemName: "photo.fill")
              .font(.title)
              .foregroundColor(.blue)
          }
        }
        
      }
    }
  }
}
