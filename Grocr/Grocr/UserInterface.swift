//
//  UserInterface.swift
//  Grocr
//
//  Created by chalie on 2021/03/11.
//  Copyright © 2021 Razeware LLC. All rights reserved.
//

import Foundation
import UIKit

class UIVC {
  
  var loadView = UIView()
  var loadLabel = UILabel()
  var spinner = UIActivityIndicatorView()
  
  func setLoadingScreen(uiView: UIView) {
    print("Start Spinner")
    
    let width: CGFloat = 230
    let height: CGFloat = 30
    let x = (uiView.frame.width / 2) - (width / 2)
    let y = (uiView.frame.height / 2) - (height / 2)
    loadView.frame = CGRect(x: x, y: y, width: width, height: height)
    
    loadLabel.text = "Loading Please Wait"
    loadLabel.textColor = .black
    loadLabel.textAlignment = .center
    loadLabel.frame = CGRect(x: 30, y: 0, width: 200, height: 30)
    
    spinner.style = .medium
    spinner.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
    spinner.startAnimating()
    
    loadView.addSubview(loadLabel)
    loadView.addSubview(spinner)
    
    uiView.addSubview(loadView)
    
  }
  
  func spinnerOff() {
    spinner.stopAnimating()
    spinner.isHidden = true
    loadView.isHidden = true
  }
  
}//End Of The Class
