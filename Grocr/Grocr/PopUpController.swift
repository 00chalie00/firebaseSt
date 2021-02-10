//
//  PopUpController.swift
//  Grocr
//
//  Created by chalie on 2021/01/21.
//  Copyright © 2021 Razeware LLC. All rights reserved.
//

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
  
  var compressionQueue = OperationQueue()
  
  var firebaseRef = Database.database().reference()
  var childRef = Database.database().reference(withPath: "Market Price")
  var storageRef = Storage.storage().reference()
  
  
  override func viewDidLoad() {
    productIMG.image = UIImage(named: "users.png")
    productName.delegate = self
    productPrice.delegate = self
    productTxtFLD.delegate = self
    
    defaultValue()
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
//    super.viewDidAppear(animated)
    print("viewDidAppear")
    updateIMG()
    self.poupView.setNeedsLayout()
    self.poupView.layoutIfNeeded()
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
    view.backgroundColor = UIColor.white
    poupView.backgroundColor = UIColor.lightGray
    
    productName.attributedPlaceholder = NSAttributedString(string: "name", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
    productPrice.attributedPlaceholder = NSAttributedString(string: "price", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
    
    productTxtFLD.backgroundColor = UIColor.yellow
    productTxtFLD.text = "Please Fill in product Information"
    productTxtFLD.textColor = .black
    
    productIMG.backgroundColor = UIColor.white
    productIMG.image = UIImage(named: "users.png")
    
    cancelBtn.layer.borderColor = UIColor.white.cgColor
    cancelBtn.layer.borderWidth = 2
    cancelBtn.layer.cornerRadius = 10
    updateBtn.layer.borderColor = UIColor.white.cgColor
    updateBtn.layer.borderWidth = 2
    updateBtn.layer.cornerRadius = 10
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
    let uploadRef = storageRef.child("\(name!).jpeg")
    uploadRef.putData(image_Data!, metadata: nil){
      meta, error in
      if error != nil {
        print(error?.localizedDescription as Any)
      }
    }
  }
  
  func compressJPEG(_ originalIMG: UIImage, complete: @escaping () -> Void){
    self.compressionQueue.addOperation {
      if let data = originalIMG.jpegData(compressionQuality: 0.9) {
        self.tempIMG?.image = UIImage(data: data)
        complete()
      }
    }
  }
  
  
  func updateIMG() {
    print("updateIMG")
    productIMG.image = tempIMG?.image
  }
  
  
}//End Of The Class


extension PopUController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
  
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    if let selectedIMG = info[.originalImage] as? UIImage {
      compressJPEG(selectedIMG) {
        print("compress")
      }
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
