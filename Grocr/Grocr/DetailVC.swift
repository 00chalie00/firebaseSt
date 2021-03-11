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
  var productIMG: UIImage = UIImage()
  
  @IBOutlet weak var nameLbl: UILabel!
  @IBOutlet weak var priceLbl: UILabel!
  @IBOutlet weak var detailIMG: UIImageView!
  @IBOutlet weak var chartView: BarChartView!
  
  var months: [String] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    nameLbl.text = name!
    priceLbl.text = price!
    detailIMG.image = productIMG
    
    months = ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"]
    let unitsSold = [50.3, 68.3, 113.3, 115.7, 160.8, 214.0, 220.4, 132.1, 176.2, 120.9, 71.3, 48.0]
    
    chartView.animate(yAxisDuration: 2.0)
    chartView.pinchZoomEnabled = false
    chartView.drawBarShadowEnabled = false
    chartView.drawBordersEnabled = true
    
    
    setChart(dataPoints: months, values: unitsSold)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
  }
  
  func setChart(dataPoints: [String], values: [Double]) {
    chartView.noDataText = "You need to provide data for the chart."
    
    var dataEntries: [BarChartDataEntry] = []
    
    for i in 0..<dataPoints.count {
      //let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
      let dataEnrty = BarChartDataEntry(x: Double(dataPoints[i]) ?? 1, y: Double(values[i]))
      dataEntries.append(dataEnrty)
    }
    
    let chartDataSet = BarChartDataSet(entries: dataEntries, label: "降水量")
    let chartData = BarChartData(dataSet: chartDataSet)
    chartView.data = chartData
  }
  
  
  
}//End Of The Class

