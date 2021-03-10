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
  @IBOutlet weak var detailIMG: UIImageView!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    nameLbl.text = name!
    priceLbl.text = price!
    detailIMG.image = productIMG
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
 
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
  }
  
  
}//End Of The Class

