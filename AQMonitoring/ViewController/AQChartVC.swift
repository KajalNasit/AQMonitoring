//
//  AQChartVC.swift
//  AQMonitoring
//
//  Created by Kajal Nasit  on 08/01/22.
//

import UIKit
import Charts

class AQChartVC: UIViewController {
    @IBOutlet var lineChartView: LineChartView!
    var viewModel = AQIChartViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = .white
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.updateChartCallabck = { [weak self] in
            self?.lineChartUpdate()
        }
    }
    override func viewDidLayoutSubviews() {

        lineChartUpdate()
    }
   
    @objc func lineChartUpdate() {
        let dataSet = LineChartDataSet(entries: viewModel.arrAQI)
        let data = LineChartData(dataSets: [dataSet])
        lineChartView.data = data
        lineChartView.chartDescription.text = "Updated Air Quality Index"
        lineChartView.notifyDataSetChanged()
    }
}
