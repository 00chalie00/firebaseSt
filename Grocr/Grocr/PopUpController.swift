import UIKit
import AVFoundation
import Firebase

class PopUController: UIViewController {
  
  //MARK: Outlet
  @IBOutlet weak var productIMG: UIImageView!
  @IBOutlet weak var productTxtFLD: UITextView!
  @IBOutlet weak var productName: UITextField!
  @IBOutlet weak var productPrice: UITextField!
  @IBOutlet weak var poupView: UIView!
  @IBOutlet weak var cancelBtn: UIButton!
  @IBOutlet weak var updateBtn: UIButton!
  
  //MARK: Properties
  var items:[GroceryItem] = []
  var user: User!
  var tempIMG: UIImageView?
  
  var firebaseRef = Database.database().reference()
  var childRef = Database.database().reference(withPath: "Market Price")
  var storageRef = Storage.storage().reference(withPath: "Market Price")
  
  override func viewDidLoad() {
    super.viewDidLoad()
    productName?.delegate = self
    productPrice?.delegate = self
    productTxtFLD?.delegate = self
    
    defaultValue()
  }
  
  @IBAction func imgBTNPressed(_ sender: UIButton) {
    print("Image Button Pressed")
    let alert = UIAlertController(title: "Photo", message: "Please select Image Souce", preferredStyle: .alert)
    let actionCamrea = UIAlertAction(title: "Camera", style: .default) { action in
      print("Camera Pressed")
      let picker = UIImagePickerController()
      picker.sourceType = .camera
      picker.delegate = self
      self.present(picker, animated: true, completion: nil)
    }
    let actionLibrary = UIAlertAction(title: "Library", style: .default) { action in
      print("Library Pressed")
      let picker = UIImagePickerController()
      picker.sourceType = .photoLibrary
      picker.delegate = self
      self.present(picker, animated: true, completion: nil)
    }
    
    alert.addAction(actionCamrea)
    alert.addAction(actionLibrary)
    present(alert, animated: true, completion: nil)
  }
  
  func defaultValue() {
    //view.backgroundColor = #colorLiteral(red: 0.9921568627, green: 1, blue: 0.737254902, alpha: 1)
    poupView.backgroundColor = #colorLiteral(red: 1, green: 0.9333333333, blue: 0.7333333333, alpha: 1)
    
    productName.attributedPlaceholder = NSAttributedString(string: "name", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
    productPrice.attributedPlaceholder = NSAttributedString(string: "price", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
    
    productIMG.backgroundColor = #colorLiteral(red: 1, green: 0.862745098, blue: 0.7215686275, alpha: 1)
    productName.backgroundColor = #colorLiteral(red: 1, green: 0.862745098, blue: 0.7215686275, alpha: 1)
    productPrice.backgroundColor = #colorLiteral(red: 1, green: 0.862745098, blue: 0.7215686275, alpha: 1)
    productTxtFLD.backgroundColor = #colorLiteral(red: 1, green: 0.862745098, blue: 0.7215686275, alpha: 1)
    productTxtFLD.text = "Please Fill in product Information"
    productTxtFLD.textColor = .black
    
    productIMG.image = UIImage(named: "users.png")
    
    cancelBtn.layer.borderColor = UIColor.white.cgColor
    cancelBtn.layer.borderWidth = 2
    cancelBtn.layer.cornerRadius = 10
    updateBtn.layer.borderColor = UIColor.white.cgColor
    updateBtn.layer.borderWidth = 2
    updateBtn.layer.cornerRadius = 10
    cancelBtn.backgroundColor = #colorLiteral(red: 1, green: 0.7568627451, blue: 0.7137254902, alpha: 1)
    updateBtn.backgroundColor = #colorLiteral(red: 1, green: 0.7568627451, blue: 0.7137254902, alpha: 1)
  }
  
  @IBAction func cancelBtnPressed(_ sender: UIButton) {
    dismiss(animated: true, completion: nil)
  }
  
  
  @IBAction func updateBtnPressed(_ sender: UIButton) {
    print("update BTN Pressed")
    let name = productName.text
    let price = productPrice.text
    let description = productTxtFLD.text
    let local_IMG = productIMG.image
    let image_Data = local_IMG!.jpegData(compressionQuality: 1.0)
    //let uploadPhotoRef = storageRef.child("\(name!).jpeg")
    let uploadProductData = storageRef.child("Market Price/\(name!)")
    var uploadDoc:[String:Any] =
      ["name": name!,
       "price": price!,
       "desc": description!,
       "complete": false] 
    
    //UpLoad the Picture and Data to FireStore
    if (image_Data) != nil {
      print("image convert")
      let metaData = StorageMetadata()
      uploadProductData.putData(image_Data!, metadata: metaData) {
        metaData, error in
        if let _ = metaData {
          uploadProductData.downloadURL {
            url, error in
            if error != nil {
              print(error?.localizedDescription as Any)
            }
            let downUrlStr = url?.absoluteString
            uploadDoc.updateValue(downUrlStr!, forKey: "Image URL")
            print(uploadDoc)
            Firestore.firestore().collection("Market Price").document().setData(uploadDoc) {
              error in
              if error != nil {
                print("Failed upload the Data")
              }
              print("Success upload the Data")
              self.dismiss(animated: true) {
                NotificationCenter.default.post(name: NSNotification.Name("newDataNoti"), object: nil)
              }
            }
          }
        }
      }
    }
    
    if (self.productName.isFirstResponder || self.productPrice.isFirstResponder || self.productTxtFLD.isFirstResponder) {
      self.productName.resignFirstResponder()
      self.productPrice.resignFirstResponder()
      self.productTxtFLD.resignFirstResponder()
    }
  }
  
}//End Of The Class


extension PopUController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
  
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    if let selectedIMG = info[.originalImage] as? UIImage {
      productIMG.image = selectedIMG
      self.dismiss(animated: true, completion: nil)
    }
  }
}

extension PopUController: UITextFieldDelegate {
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    textField.placeholder = ""
    textField.textColor = UIColor.black
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if (self.productName.isFirstResponder || self.productPrice.isFirstResponder) {
      self.productName.resignFirstResponder()
      self.productPrice.resignFirstResponder()
    }
  }
}

extension PopUController: UITextViewDelegate {
  
  func textViewDidBeginEditing(_ textView: UITextView) {
    textView.text = ""
    textView.textColor = .black
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    if (self.productTxtFLD.isFirstResponder) {
      self.productTxtFLD.resignFirstResponder()
    }
  }
}
