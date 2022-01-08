//
//  AQICityCell.swift
//  AQMonitoring
//
//  Created by Kajal Nasit  on 08/01/22.
//

import UIKit

class AQICityCell: UITableViewCell {
    
    @IBOutlet weak var viewMain: shadowView!
   
    @IBOutlet weak var lblCityName: UILabel!
    @IBOutlet weak var lblAQI: UILabel!
    @IBOutlet weak var lblLastUpdate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewMain.layer.cornerRadius = 10
        viewMain.dropshadow(color: UIColor.gray, opacity: 0.3, offSet: .zero, radius: 3, scale: true, cornerRadius: 10)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func cellConfiguration(data: AirQualityModel) {
        let aqGrade = AQIGrade.getAQIFor(aqi: data.aqi ?? 0.0)
        lblCityName.text = data.city ?? "" + ": \(aqGrade.getAQIColorAndLevel().1)"
        lblAQI.text = String(format: "%.2f", data.aqi!)
        let date = Date(timeIntervalSince1970: (Double(Date().currentTimeMillis()) / 1000.0))
        lblLastUpdate.text = "Updated \(Date().timeAgoSince(date))"
//        lblCityName.textColor = aqGrade.getAQIColorAndLevel().0
//        lblAQI.textColor = aqGrade.getAQIColorAndLevel().0
//        lblLastUpdate.textColor = aqGrade.getAQIColorAndLevel().0
        viewMain.backgroundColor = aqGrade.getAQIColorAndLevel().0
        
        lblCityName.textColor = .black
        lblAQI.textColor = .black
        lblLastUpdate.textColor = .black
        
        
    }
}
