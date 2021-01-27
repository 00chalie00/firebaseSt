//
//  PopUpController.swift
//  Grocr
//
//  Created by chalie on 2021/01/21.
//  Copyright © 2021 Razeware LLC. All rights reserved.
//

import UIKit

class PopUController: UIViewController {
  
  //Outlet
  @IBOutlet weak var productIMG: UIImageView!
  @IBOutlet weak var productTxtFLD: UITextView!
  @IBOutlet weak var productName: UITextField!
  @IBOutlet weak var productPrice: UITextField!
  @IBOutlet weak var poupView: UIView!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    productName.delegate = self
    productPrice.delegate = self
    productTxtFLD.delegate = self
    
    view.backgroundColor = UIColor.white
    poupView.backgroundColor = UIColor.lightGray
    
    productName.attributedPlaceholder = NSAttributedString(string: "name", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
    productPrice.attributedPlaceholder = NSAttributedString(string: "price", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
    
    productTxtFLD.backgroundColor = UIColor.white
    
    productTxtFLD.text = "Please Fill in product Information"
    productTxtFLD.textColor = .black
    productIMG.backgroundColor = UIColor.white
    productIMG.image = UIImage(named: "users.png")
    
  }
  
  @IBAction func imgBTNPressed(_ sender: UIButton) {
    print("Button Pressed")
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
