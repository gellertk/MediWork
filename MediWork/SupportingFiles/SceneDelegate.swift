//
//  SceneDelegate.swift
//  MediWork
//
//  Created by Kirill Gellert on 28.05.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    private let factory: Factory = .init()

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = .init(windowScene: windowScene)
        window?.rootViewController = UINavigationController(rootViewController: self.factory.makePatientsViewController()) 
        window?.makeKeyAndVisible()
    }

}

