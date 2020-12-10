import SwiftUI
import PhotosUI

struct ImagePicker: UIViewControllerRepresentable {

  @Binding var picker: Bool
  @Binding var imageData: Data

  func makeCoordinator() -> Coordinator {
    return ImagePicker.Coordinator(parent: self)
  }

  func makeUIViewController(context: Context) -> some UIViewController {

    var config = PHPickerConfiguration()
    config.selectionLimit = 1

    let controller = PHPickerViewController(configuration: config)
    controller.delegate = context.coordinator

    return controller
  }

  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }

  class Coordinator: NSObject, PHPickerViewControllerDelegate {

    var parent: ImagePicker

    init(parent: ImagePicker) {
      self.parent = parent
    }

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {

      if results.isEmpty {
        parent.picker.toggle()
        return
      }

      if let item = results.first?.itemProvider {

        if item.canLoadObject(ofClass: UIImage.self) {
          item.loadObject(ofClass: UIImage.self) { (image, error) in
            if error != nil { return }

            let imageData = image as! UIImage

            DispatchQueue.main.async {
              guard let jpgData = imageData.jpegData(compressionQuality: 0.5) else { return }
              self.parent.imageData = jpgData
              self.parent.picker.toggle()
            }
          }
        }
      }

    }
  }
}
