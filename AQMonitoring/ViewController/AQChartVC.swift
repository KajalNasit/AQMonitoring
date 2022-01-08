//
//  AQChartVC.swift
//  AQMonitoring
//
//  Created by Kajal Nasit  on 08/01/22.
//

import UIKit
import Charts

class AQChartVC: UIViewController {
    @IBOutlet var pieChartView: PieChartView!
    var viewModel = AQIChartViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        setup(pieChartView: self.pieChartView)
        pieChartUpdate()
    }
    func setup(pieChartView chartView: PieChartView) {
        chartView.usePercentValuesEnabled = true
        chartView.drawSlicesUnderHoleEnabled = false
        chartView.holeRadiusPercent = 0.58
        chartView.transparentCircleRadiusPercent = 0.61
        chartView.chartDescription.enabled = false
        chartView.setExtraOffsets(left: 5, top: 10, right: 5, bottom: 5)
        
        chartView.drawCenterTextEnabled = true
        
        chartView.drawHoleEnabled = true
        chartView.rotationAngle = 0
        chartView.rotationEnabled = true
        chartView.highlightPerTapEnabled = true
        
        let l = chartView.legend
        l.horizontalAlignment = .right
        l.verticalAlignment = .top
        l.orientation = .vertical
        l.drawInside = false
        l.xEntrySpace = 7
        l.yEntrySpace = 0
        l.yOffset = 0
//        chartView.legend = l
    }
    @objc func pieChartUpdate() {
        let dataSet = LineChartDataSet(entries: viewModel.arrAQI)
        let data = LineChartData(dataSets: [dataSet])
        pieChartView.data = data
        pieChartView.chartDescription.text = "Updated Air Quality Index"
        pieChartView.notifyDataSetChanged()
    }
}
