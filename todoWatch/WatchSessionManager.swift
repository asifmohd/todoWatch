//
//  WatchSessionManager.swift
//  todoWatch
//
//  Created by Asif on 12/12/18.
//  Copyright © 2018 Asif. All rights reserved.
//

import WatchConnectivity

class WatchSessionManager: NSObject, WCSessionDelegate {

    static let shared = WatchSessionManager()

    private let session: WCSession? = WCSession.isSupported() ? WCSession.default : nil

    // Add a validSession variable to check that the Watch is paired
    // and the Watch App installed to prevent extra computation
    // if these conditions are not met.
    // This is a computed property, since the user can pair their device and / or
    // install your app while using your iOS app, so this can become valid
    private var validSession: WCSession? {
        // paired - the user has to have their device paired to the watch
        // watchAppInstalled - the user must have your watch app installed
        if let sessionU = session,
            sessionU.isPaired && sessionU.isWatchAppInstalled {
            return session
        }
        return nil
    }

    // Live messaging! App has to be reachable
    private var validReachableSession: WCSession? {
        // check for validSession on iOS only (see above)
        // in your Watch App, you can just do an if session.reachable check
        if let sessionU = validSession,
            sessionU.isReachable {
            return session
        }
        return nil
    }

    func startSession() {
        session?.delegate = self
        session?.activate()
    }

    func update(context: [String : Any]) {
        guard let session = validSession else {
            return
        }
        do {
            try session.updateApplicationContext(context)
        } catch let error {
            print("Error occurred while updating context \(error.localizedDescription)")
        }
    }

    // required delegate methods
    func sessionDidDeactivate(_ session: WCSession) {
        print("Session became active")
    }

    func sessionDidBecomeInactive(_ session: WCSession) {
        print("Session became inactive")
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("Activation completed")
    }
}
