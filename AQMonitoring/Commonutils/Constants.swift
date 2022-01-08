//
//  Constants.swift
//  AQMonitoring
//
//  Created by Kajal Nasit  on 08/01/22.
//

import Foundation
import UIKit

struct Constants {
    
    static let AQICityUrl = "ws://city-ws.herokuapp.com/"
    
    static let aqiTimer = 30.0
    
}

enum AQIGrade {
    case good, satisfactory, moderate, poor, veryPoor, severe
    
    func getAQIColorAndLevel() -> (UIColor,String) {
        switch self {
        case .good:
            //469B3E
            return (UIColor.init(named: "good")!, "Good")
        case .satisfactory:
            //#94C042
            return (UIColor.init(named: "satisfactory")!, "Satisfactory")
        case .moderate:
            //FEFA28
            return (UIColor.init(named: "moderate")!, "Moderate")
        case .poor:
            //EC8A28
            return (UIColor.init(named: "poor")!, "Poor")
        case .veryPoor:
            //E12827
            return (UIColor.init(named: "veryPoor")!, "Very Poor")
        case .severe:
            //9D1C1B
            return (UIColor.init(named: "severe")!, "Severe")
        }
    }
    static func getAQIFor(aqi : Double) -> AQIGrade {
        if aqi < 51 {
            return .good
        }
        else if aqi < 101 {
            return .satisfactory
        }
        else if aqi < 201 {
            return .moderate
        }
        else if aqi < 301 {
            return .poor
        }
        else if aqi < 401 {
            return .veryPoor
        }
        else {
            return .severe
        }
    }
    
    
}
extension Date {
    func currentTimeMillis() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
        
    func timeAgoSince(_ date: Date) -> String {
       let calendar = Calendar.current
       let unitFlags: NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfYear, .month, .year]
       let components = (calendar as NSCalendar).components(unitFlags, from: date, to: self, options: [])
       
       if let year = components.year, year >= 2 {
           return "\(year) years ago"
       }
       
       if let year = components.year, year >= 1 {
           return "Last year"
       }
       
       if let month = components.month, month >= 2 {
           return "\(month) months ago"
       }
       
       if let month = components.month, month >= 1 {
           return "Last month"
       }
       
       if let week = components.weekOfYear, week >= 2 {
           return "\(week) weeks ago"
       }
       
       if let week = components.weekOfYear, week >= 1 {
           return "Last week"
       }
       
       if let day = components.day, day >= 2 {
           return "\(day) days ago"
       }
       
       if let day = components.day, day >= 1 {
           return "Yesterday"
       }
       
       if let hour = components.hour, hour >= 2 {
           return "\(hour) hours ago"
       }
       
       if let hour = components.hour, hour >= 1 {
           return "An hour ago"
       }
       
       if let minute = components.minute, minute >= 2 {
           return "\(minute) minutes ago"
       }
       
       if let minute = components.minute, minute >= 1 {
           return "A minute ago"
       }
       
       if let second = components.second, second >= 3 {
           return "\(second) seconds ago"
       }
       
       return "Just now"
   }

}
class shadowView : UIView{
    var shadowcolor : UIColor = UIColor.clear
    var shadowopacity : Float = 0
    var shadowoffset : CGSize = .zero
    var shadowradius : CGFloat =  0
    var cornerradius : CGFloat = 0
    var rasterscale : Bool = false
    override var bounds: CGRect{
        didSet{
            updateLayout()
        }
    }
    
    func dropshadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true, cornerRadius : CGFloat=0) {
        shadowcolor = color
        shadowopacity = opacity
        shadowoffset = offSet
        shadowradius = radius
        rasterscale = scale
        cornerradius = cornerRadius
    }
    
    func updateLayout() {
        layer.masksToBounds = false
        layer.shadowColor = shadowcolor.cgColor
        layer.shadowOpacity = shadowopacity
        layer.shadowOffset = shadowoffset
        layer.shadowRadius = shadowradius
        layer.cornerRadius = cornerradius
        layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerradius).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = rasterscale ? UIScreen.main.scale : 1
    }
}
