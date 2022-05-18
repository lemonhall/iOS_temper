//
//  AppDelegate.swift
//  temp
//
//  Created by 余柠 on 2022/5/15.
//

import UIKit
import MQTTNIO
import AVFoundation
import BackgroundTasks

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    // With vibration
    let systemSoundID: SystemSoundID = 1013
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let client = MQTTClient(
            host: "192.168.50.232",
            port: 1883,
            identifier: "My Client",
            eventLoopGroupProvider: .createNew
        )
        let subscription = MQTTSubscribeInfo(
            topicFilter: "tempSensor",
            qos: .atLeastOnce
        )
        client.connect().whenComplete { result in
            switch result {
            case .success:
                print("Succesfully connected")
                client.subscribe(to: [subscription]).whenComplete { result in
                    switch result {
                    case .success:
                        print("Succesfully subscribed")
                        client.addPublishListener(named: "my lister"){result in
                            switch result {
                            case .success:
                                var payload = try! result.get().payload
                                print(payload.readString(length:payload.readableBytes)!)
                                //AudioServicesPlaySystemSound(self.systemSoundID)
                            case .failure(_):
                                print("Error while recive msg")
                            }
                        }
                    case .failure(let error):
                        print("Error while subscribe...... \(error)")
                    }
                }
            case .failure(let error):
                print("Error while connecting \(error)")
            }
        }
        print("I am ahhahhahah....")
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("I am in applicationDidEnterBackground..............")
        //scheduleAppRefresh()
    }

    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}
