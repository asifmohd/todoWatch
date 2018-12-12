//
//  WatchSessionManager.swift
//  todoWApp Extension
//
//  Created by Asif on 12/12/18.
//  Copyright © 2018 Asif. All rights reserved.
//

import WatchConnectivity

protocol DataSourceChangedDelegate {
    func dataSourceDidUpdate(dataSource: [String: [String]])
}

class WatchSessionManager: NSObject, WCSessionDelegate {

    static let shared = WatchSessionManager()

    private let session: WCSession = WCSession.default

    private var dataSourceChangedDelegates: [DataSourceChangedDelegate] = []

    func startSession() {
        session.delegate = self
        session.activate()
    }


    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        print(applicationContext)
        guard let todoList = applicationContext as? [String: [String]] else {
            return
        }
        DispatchQueue.main.async {
            self.dataSourceChangedDelegates.forEach({
                $0.dataSourceDidUpdate(dataSource: todoList)
            })
        }
    }

    // required delegate method
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("Activation completed")
    }

    // adds / removes dataSourceChangedDelegates from the array
    func addDataSourceChangedDelegate<T: DataSourceChangedDelegate & Equatable>(delegate: T) {
        dataSourceChangedDelegates.append(delegate)
    }

    func removeDataSourceChangedDelegate<T: DataSourceChangedDelegate & Equatable>(delegate: T) {
        for (index, dataSourceDelegate) in dataSourceChangedDelegates.enumerated() {
            if let dataSourceDelegate = dataSourceDelegate as? T, dataSourceDelegate == delegate {
                dataSourceChangedDelegates.remove(at: index)
                break
            }
        }
    }
}
