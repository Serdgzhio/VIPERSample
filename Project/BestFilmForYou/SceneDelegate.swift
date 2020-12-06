//
//  SceneDelegate.swift
//  BestFilmForYou
//
//  Created by user on 10.10.2020.
//  Copyright © 2020 CHI software. All rights reserved.
//

import UIKit
import Swinject

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  var window: UIWindow?
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = scene as? UIWindowScene else { return }
    let window = UIWindow(windowScene: windowScene)
    self.window = window
    window.makeKeyAndVisible()
    
    let mainModuleView = ApplicationLocator.shared.mainScreen.view
    window.start(transition: .push, destination: mainModuleView, animated: true, completion: nil)
  }
}
