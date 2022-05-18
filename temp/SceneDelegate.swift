//
//  SceneDelegate.swift
//  temp
//
//  Created by 余柠 on 2022/5/15.
//

import UIKit
import AVFoundation
import BackgroundTasks

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    // With vibration
    let systemSoundID: SystemSoundID = 1013


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "lsl.lemonhall.temp.mqttGetData", using: nil) { task in
             self.handleAppRefresh(task: task as! BGAppRefreshTask)
        }
        
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        print("I am in sceneDidEnterBackground..............")
        scheduleAppRefresh()
    }
    
    func scheduleAppRefresh() {
        print("I am scheduleAppRefresh....")
       let request = BGAppRefreshTaskRequest(identifier: "lsl.lemonhall.temp.mqttGetData")
       // Fetch no earlier than 15 minutes from now.
       request.earliestBeginDate = Date(timeIntervalSinceNow: 1 * 60)
       do {
          try BGTaskScheduler.shared.submit(request)
       } catch {
          print("Could not schedule app refresh: \(error)")
       }
    }

    // MARK: - Handling Launch for Tasks
    // Fetch the latest feed entries from server.
    func handleAppRefresh(task: BGAppRefreshTask) {
        scheduleAppRefresh()
        print("I am handleAppRefresh....")
        AudioServicesPlaySystemSound(self.systemSoundID)
        
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        
        let lastOperation = AddEntriesToStoreOperation()
        
        task.expirationHandler = {
            // After all operations are cancelled, the completion block below is called to set the task to complete.
            queue.cancelAllOperations()
        }

        lastOperation.completionBlock = {
            task.setTaskCompleted(success: !lastOperation.isCancelled)
        }
        queue.addOperation {
            print("queue.addOperation")
        }
    }
    
    // Add entries returned from the server to the Core Data store.
    class AddEntriesToStoreOperation: Operation {
        override func main() {
            print("I am in AddEntriesToStoreOperation")
        }
    }

}

