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
    
    view.backgroundColor = UIColor.white
    poupView.backgroundColor = UIColor.lightGray
    productTxtFLD.text = "Please Fill in product Information"
    productTxtFLD.textColor = .black
    productIMG.backgroundColor = UIColor.green
    productIMG.image = UIImage(named: "users.png")
    
    
  }
  
  
}//End Of The Class

