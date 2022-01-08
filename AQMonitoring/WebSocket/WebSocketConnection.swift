//
//  WebSocketConnection.swift
//  AQMonitoring
//
//  Created by Kajal Nasit  on 08/01/22.
//

import Foundation

protocol WebSocketConnection {
    func connect()
    func disconnect()
    func send(text: String)
    func send(data: Data)
    var delegate: WebSocketConnectionDelegate? {
        get
        set
    }
}

protocol WebSocketConnectionDelegate {
    func onConnected(connection: WebSocketConnection)
    func onDisconnected(connection: WebSocketConnection, error: Error?)
    func onError(connection: WebSocketConnection, error: Error)
    func onMessage(connection: WebSocketConnection, text: String)
    func onMessage(connection: WebSocketConnection, data: Data)
}

class WebSocketTaskConnection: NSObject,WebSocketConnection{
    
    var webSocketTask: URLSessionWebSocketTask!
    let delegateQueue = OperationQueue()
    var dataTimer: Timer?
    var delegate: WebSocketConnectionDelegate?
    
    init(socketUrl : URL) {
        super.init()
        let urlSession = URLSession(configuration: .default)
        webSocketTask = urlSession.webSocketTask(with: socketUrl)
        dataTimer = Timer.scheduledTimer(timeInterval: Constants.aqiTimer, target: self, selector: #selector(aqiTimer), userInfo: nil, repeats: true)
    }
    @objc func aqiTimer() {
        getResponse()
    }
    func getResponse(){
        webSocketTask.receive { result in
            switch result {
            case .failure(let error):
                self.delegate?.onError(connection: self, error: error)
            case .success(let message):
                switch message {
                case .string(let text):
                    
                    self.delegate?.onMessage(connection: self, text: text)
                case .data(let data):
                    self.delegate?.onMessage(connection: self, data: data)
                @unknown default:
                    fatalError()
                }
            }
        }
    }
    func connect() {
        webSocketTask.resume()
        getResponse()
    }
    func disconnect() {
        webSocketTask.cancel(with: .goingAway, reason: nil)
    }
    func send(text: String) {
        webSocketTask.send(URLSessionWebSocketTask.Message.string(text)) { error in
            if let error = error {
                self.delegate?.onError(connection: self, error: error)
            }
        }
    }
    func send(data: Data) {
        webSocketTask.send(URLSessionWebSocketTask.Message.data(data)) { error in
            if let error = error {
                self.delegate?.onError(connection: self, error: error)
            }
        }
    }
}

extension WebSocketTaskConnection : URLSessionWebSocketDelegate{
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        self.delegate?.onConnected(connection: self)
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        self.delegate?.onDisconnected(connection: self, error: nil)
    }
}
