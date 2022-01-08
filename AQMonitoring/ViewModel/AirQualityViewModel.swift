//
//  AirQualityViewModel.swift
//  AQMonitoring
//
//  Created by Kajal Nasit  on 08/01/22.
//

import Foundation

typealias AQICallback = () -> ()

protocol AQIChartDelegate {
    func updateAQIForCity(aqi : Double)
}

class AirQualityViewModel {
    var webSocketConnection : WebSocketConnection!
    var airQualityData = [AirQualityModel]()
    var aqiCallback : AQICallback?
    var aqiDelegate : AQIChartDelegate?
    var selectedCity = ""
    
    func connect() {
        if let url  = URL(string: Constants.AQICityUrl) {
            webSocketConnection = WebSocketTaskConnection(socketUrl: url)
            webSocketConnection.delegate = self
            webSocketConnection.connect()
        } else {
            print("Invalid URL")
        }
    }
    
    func updateData(serverData: [AirQualityModel]) {
        var tempDict = [String: AirQualityModel]()
        for obj in airQualityData {
            tempDict[obj.city ?? ""] = obj
        }
        
        for obj in serverData {
            tempDict[obj.city ?? ""] = obj
            
            if obj.city == selectedCity {
                self.aqiDelegate?.updateAQIForCity(aqi: obj.aqi ?? 0.0)
            }
        }
        
        airQualityData = Array(tempDict.values)
        airQualityData = airQualityData.sorted { $0.city ?? "" < $1.city ?? "" }
//        print("airQualityData : \(airQualityData)")
        DispatchQueue.main.async {
            //Comment this callback to see if connection test case fails
            self.aqiCallback?()
        }
    }
    
    
    
    
}
extension AirQualityViewModel : WebSocketConnectionDelegate {
    func onConnected(connection: WebSocketConnection) {
        print("Connected")
    }
    
    func onDisconnected(connection: WebSocketConnection, error: Error?) {
        if let error = error {
            print("Disconnected error:\(error)")
        } else {
            print("Disconnected")
        }
    }
    
    func onError(connection: WebSocketConnection, error: Error) {
        print("Connection error:\(error)")
    }
    
    func onMessage(connection: WebSocketConnection, text: String) {
        let jsonData = Data(text.utf8)
        do{
            let data = try JSONDecoder().decode([AirQualityModel].self, from: jsonData)
            print("data : \(data)")
            self.updateData(serverData: data)
        }catch let err{
            print(err)
        }
    }
    
    func onMessage(connection: WebSocketConnection, data: Data) {
        print("Data message: \(data)")
    }
    
}
