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
  
  func setLoadingScreen(tableView: UITableView, loadView: UIView, loadLabel: UILabel, spinner: UIActivityIndicatorView) {
    print("Start Spinner")
    
    let width: CGFloat = 230
    let height: CGFloat = 30
    let x = (tableView.frame.width / 2) - (width / 2)
    let y = (tableView.frame.height / 2) - (height / 2)
    loadView.frame = CGRect(x: x, y: y, width: width, height: height)
    
    loadLabel.text = "Loading Please Wait"
    loadLabel.textAlignment = .center
    loadLabel.frame = CGRect(x: 30, y: 0, width: 200, height: 30)
    
    spinner.style = .medium
    spinner.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
    spinner.startAnimating()
    
    loadView.addSubview(loadLabel)
    loadView.addSubview(spinner)
    
    tableView.addSubview(loadView)
    
  }
  
  func spinnerOff(spinner: UIActivityIndicatorView, loadView: UIView) {
    spinner.stopAnimating()
    spinner.isHidden = true
    loadView.isHidden = true
  }
  
}//End Of The Class
