//
//  DetailVC.swift
//  Grocr
//
//  Created by chalie on 2021/03/08.
//  Copyright © 2021 Razeware LLC. All rights reserved.
//

import UIKit
import Charts

class DetailViewController: UIViewController {
  
  var name: String?
  var price: String?
  var priceS: [String]?
  var currentDate: [NSDate]?
  var productIMG: UIImage = UIImage()
  
  lazy var modifyBarBtn: UIBarButtonItem = {
    let button = UIBarButtonItem(title: "Modify", style: .plain, target: self, action: #selector(modifyBtnPressed( _:)))
    return button
  }()
  
  @IBOutlet weak var nameLbl: UILabel!
  @IBOutlet weak var priceLbl: UILabel!
  @IBOutlet weak var detailIMG: UIImageView!
  @IBOutlet weak var chartView: BarChartView!
  
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
  
  @objc func modifyBtnPressed( _: UIBarButtonItem) {
    print("barbtnPressed")
  }
  
  func setChart(dataPoints: [String], values: [Double]) {
    chartView.noDataText = "You need to provide data for the chart."
    var dataEntries: [BarChartDataEntry] = []
    for i in 0..<dataPoints.count {
      let dataEnrty = BarChartDataEntry(x: Double(i), y: Double(values[i]), data: months as AnyObject?)
      dataEntries.append(dataEnrty)
    }
    
    let chartDataSet = BarChartDataSet(entries: dataEntries, label: "\(String(describing: name!)) Price")
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
