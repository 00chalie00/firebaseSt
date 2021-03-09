//
//  DetailVC.swift
//  Grocr
//
//  Created by chalie on 2021/03/08.
//  Copyright © 2021 Razeware LLC. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
  
  var name: String?
  var price: String?
  var productIMG: UIImage = UIImage()
  
  @IBOutlet weak var nameLbl: UILabel!
  @IBOutlet weak var priceLbl: UILabel!
  @IBOutlet weak var imageView: UIImageView!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    print("detail Did")
    
    nameLbl.text = name!
    priceLbl.text = price!
    imageView.image = productIMG
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    print("detail Will")
    nameLbl.text = name!
    priceLbl.text = price!
    imageView.image = productIMG
    
  }
  
  
}//End Of The Class

