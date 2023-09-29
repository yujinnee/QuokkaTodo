//
//  SceneDelegate.swift
//  QoukkaTodo
//
//  Created by 이유진 on 2023/09/27.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene:  scene)
        
        let nav1 = UINavigationController(rootViewController: TodoViewController())
        nav1.tabBarItem = UITabBarItem(title: "투두", image: UIImage(systemName: "checkmark.square"), selectedImage: UIImage(systemName: "checkmark.square.fill"))
//        let vc1 = TodoViewController()
//        vc1.tabBarItem = UITabBarItem(title: "투두", image: UIImage(systemName: "checkmark.square"), selectedImage: UIImage(systemName: "checkmark.square.fill"))
        let nav2 = UINavigationController(rootViewController: TimerViewController())
        nav2.tabBarItem = UITabBarItem(title: "타이머", image: UIImage(systemName: "timer"), selectedImage: UIImage(systemName: "timer"))
        let nav3 = UINavigationController(rootViewController: QuokkaViewController())
        nav3.tabBarItem = UITabBarItem(title: "쿼카", image: UIImage(systemName: "leaf"), selectedImage: UIImage(systemName: "leaf.fill"))
    

        let tabbarController = UITabBarController()
        tabbarController.viewControllers = [nav1,nav2,nav3]
        tabbarController.tabBar.backgroundColor = QColor.backgroundColor
        tabbarController.tabBar.tintColor = QColor.accentColor
        
        window?.rootViewController = tabbarController
        window?.makeKeyAndVisible()
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
    }


}

