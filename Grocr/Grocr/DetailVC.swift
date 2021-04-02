//
//  DetailVC.swift
//  Grocr
//
//  Created by chalie on 2021/03/08.
//  Copyright © 2021 Razeware LLC. All rights reserved.
//

import UIKit
import Charts
import Firebase

class DetailViewController: UIViewController {
  
  var name: String?
  var price: String?
  var priceS: [String]?
  var currentDate: [NSDate]?
  var productIMG: UIImage = UIImage()
  
  var storageRef = Storage.storage().reference(withPath: "Market Price")
  
  lazy var modifyBarBtn: UIBarButtonItem = {
    let button = UIBarButtonItem(title: "Modify", style: .plain, target: self, action: #selector(modifyBtnPressed( _:)))
    return button
  }()
  
  @IBOutlet weak var nameLbl: UILabel!
  @IBOutlet weak var priceLbl: UILabel!
  @IBOutlet weak var detailIMG: UIImageView!
  @IBOutlet weak var chartView: BarChartView!
  
  var modifyDate:NSDate?
  var modifyPrice: String?
  
  weak var asixFormatDelegate: IAxisValueFormatter?
  
  var months: [String] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.asixFormatDelegate = self
    
    self.navigationItem.rightBarButtonItem = self.modifyBarBtn
    
    nameLbl.text = name!
    //conver Price Type
    let numberFormat = NumberFormatter()
    numberFormat.numberStyle = .decimal
    priceLbl.text = numberFormat.string(for: Int(price!))
    detailIMG.image = productIMG
    
    months = createItem(objectArr: priceS!, time: currentDate!)
    print(months)
    
    chartView.animate(yAxisDuration: 2.0)
    chartView.pinchZoomEnabled = false
    chartView.drawBarShadowEnabled = false
    chartView.drawBordersEnabled = true
    
    var doublePrice:[Double] = []
    print(priceS as Any)
    for i in 0..<priceS!.count {
      doublePrice.append(Double(priceS![i])!)
    }
    
    setChart(dataPoints: months, values: doublePrice)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
  }
  
  @objc func modifyBtnPressed( _: UIBarButtonItem){
    print("barbtnPressed")
//    let alertCon = UIAlertController(title: "Please Input Product Information", message: "Information Modify", preferredStyle: .alert)
//    let txtFld = alertCon.textFields
//    let alertModify = UIAlertAction(title: "Confirm Modify", style: .default) {
//      modify in
//      let modifyDate = txtFld?[0].text
//      let modifyPrice = txtFld?[1].text
//    }
//    let alertCancel = UIAlertAction(title: "Cancel", style: .default) {
//      cancel in
//      self.dismiss(animated: true, completion: nil)
//    }
//
//    alertCon.addTextField { txtFld in
//      txtFld.placeholder = "Date"
//    }
//    alertCon.addTextField { txtFld in
//      txtFld.placeholder = "Price"
//    }
//
//    alertCon.addAction(alertModify)
//    alertCon.addAction(alertCancel)
//    self.present(alertCon, animated: true, completion: nil)
    let popUpView = UIView()
    let currentTimeTxtFd = UITextField()
    let priceTxtFd = UITextField()
    let notiLbl = UILabel()
    let modifyBtn = UIButton()
    let cancelBtn = UIButton()
    
    let width: CGFloat = 300
    let height: CGFloat = 240
    let x = (view.frame.width / 2) - (width / 2)
    let y = (view.frame.height / 2) - (height / 2)
    popUpView.backgroundColor = .green
    popUpView.frame = CGRect(x: x, y: y, width: width, height: height)
    
    notiLbl.text = "Input The Information"
    notiLbl.adjustsFontSizeToFitWidth = true
    notiLbl.textAlignment = .center
    notiLbl.backgroundColor = .lightGray
    notiLbl.frame = CGRect(x: 10, y: 10, width: 280, height: 40)
    
    let currentTime = NSDate()
    let formatter = DateFormatter()
    formatter.dateFormat = "dd.mm.yyyy"
    
    currentTimeTxtFd.placeholder = "\(formatter.string(from: currentTime as Date))"
    currentTimeTxtFd.textAlignment = .center
    currentTimeTxtFd.backgroundColor = .brown
    currentTimeTxtFd.frame = CGRect(x: 50, y: 60, width: 200, height: 50)
    let dateFromStr = formatter.date(from: (currentTimeTxtFd.text ?? currentTimeTxtFd.placeholder)!)
    
    priceTxtFd.placeholder = "Price"
    priceTxtFd.textAlignment = .center
    priceTxtFd.backgroundColor = .brown
    priceTxtFd.frame = CGRect(x: 50, y: 110, width: 200, height: 50)
    modifyPrice = priceTxtFd.text
    print(modifyPrice)
    
    modifyBtn.setTitle("Modify", for: .normal)
    modifyBtn.titleLabel?.textAlignment = .center
    modifyBtn.setTitleColor(.black, for: .normal)
    modifyBtn.backgroundColor = .white
    modifyBtn.frame = CGRect(x: 60, y: 170, width: 80, height: 50)
    modifyBtn.addTarget(self, action: #selector(modifyPressed(sender:)), for: .touchUpInside)
    
    
    cancelBtn.setTitle("Cancel", for: .normal)
    cancelBtn.titleLabel?.textAlignment = .center
    cancelBtn.backgroundColor = .white
    cancelBtn.setTitleColor(.black, for: .normal)
    cancelBtn.frame = CGRect(x: 160, y: 170, width: 80, height: 50)
    cancelBtn.addTarget(self, action: #selector(cancelPressed(_:)), for: .touchUpInside)
    
    
    popUpView.addSubview(notiLbl)
    popUpView.addSubview(currentTimeTxtFd)
    popUpView.addSubview(priceTxtFd)
    popUpView.addSubview(modifyBtn)
    popUpView.addSubview(cancelBtn)
    
    self.view.addSubview(popUpView)
  }
  
  @objc func modifyPressed(sender: UIButton) {
    print("modify Pressed")
    sender.setTitleColor(.green, for: .highlighted)
    if (modifyPrice != nil){
      print("Ready To Update")
      var dateArr:[String] = []
      var priceArr:[String] = []
      
      Firestore.firestore().collection("Market Price").getDocuments {
        (snap, error) in
        if error != nil {
          print("\(error?.localizedDescription as Any)")
        }
        
      }
      
    } else {
      print("modify Price and Date is nil")
    }
    
  }
  
  @objc func cancelPressed( _: UIButton) {
    print("Cancel Pressed")
    dismiss(animated: true, completion: nil)
  }
  
  func setChart(dataPoints: [String], values: [Double]) {
    chartView.noDataText = "You need to provide data for the chart."
    var dataEntries: [BarChartDataEntry] = []
    for i in 0..<dataPoints.count {
      let dataEnrty = BarChartDataEntry(x: Double(i), y: Double(values[i]), data: months as AnyObject?)
      dataEntries.append(dataEnrty)
    }
    
    let chartDataSet = BarChartDataSet(entries: dataEntries, label: "\(String(describing: name!)) Price")
    chartView.xAxis.labelCount = priceS!.count
    let chartData = BarChartData(dataSet: chartDataSet)
    chartView.data = chartData
    let xAxisValue = chartView.xAxis
    xAxisValue.valueFormatter = asixFormatDelegate
  }
  
  func createItem(objectArr :[Any], time: [NSDate]) -> [String] {
    var stringArr:[String] = []
    for i in 0..<objectArr.count {
      let format = DateFormatter()
      //format.dateFormat = "dd.mm"
      format.dateStyle = .short
      let resultTime = format.string(from: time[i] as Date)
      
      let combineStr = "\(i + 1)\(resultTime)"
      print(combineStr)
      stringArr.append(combineStr)
    }
    return stringArr
  }
   
}//End Of The Class


//MARK: IAxisValueFormatter Delegate
extension DetailViewController: IAxisValueFormatter {
  func stringForValue(_ value: Double, axis: AxisBase?) -> String {
    
    return months[Int(value)]
  }
}
