//
//  AQHomeVC.swift
//  AQMonitoring
//
//  Created by Kajal Nasit  on 08/01/22.
//

import UIKit

class AQHomeVC: UIViewController {

    @IBOutlet weak var tblCityList: UITableView!
    var aqViewModel = AirQualityViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Air Quality Index"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        self.tblCityList.register(UINib.init(nibName: "AQICityCell", bundle: nil), forCellReuseIdentifier: "AQICityCell")
        self.tblCityList.delegate = self
        self.tblCityList.dataSource = self
        aqViewModel.connect()
        aqViewModel.aqiCallback = { [weak self] in
            self?.tblCityList.reloadData()
        }
        // Do any additional setup after loading the view.
    }

}
extension AQHomeVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aqViewModel.airQualityData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AQICityCell", for: indexPath as IndexPath) as! AQICityCell
        cell.cellConfiguration(data: aqViewModel.airQualityData[indexPath.row])
            return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Num: \(indexPath.row)")
//        print("Value: \(airQualityViewModel.airQualityData[indexPath.row])")
//
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AQChartVC") as! AQChartVC
        let viewModel = AQIChartViewModel()
        vc.viewModel = viewModel
        aqViewModel.aqiDelegate = viewModel
        aqViewModel.selectedCity = aqViewModel.airQualityData[indexPath.row].city ?? ""
        viewModel.city = aqViewModel.selectedCity
        self.navigationController?.pushViewController(vc, animated: false)
    }
}
