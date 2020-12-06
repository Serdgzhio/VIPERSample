//
//  View+.swift
//  BestFilmForYou
//
//  Created by user on 13.10.2020.
//  Copyright © 2020 CHI software. All rights reserved.
//

import UIKit
import SwiftUI

protocol Viewable {
  associatedtype Output
  var output: Output! { get set }
}

protocol Constructable: Viewable {
  static func construct(output: Output) -> Self
}

protocol Closable {
  var onClose: (() -> Void)? { get set }
  var isMovingFromParent: Bool { get }
  var isBeingDismissed: Bool { get }
}

extension Closable where Self:UIViewController {
  func checkClosing() {
    if isMovingFromParent || isBeingDismissed {
      onClose?()
    }
  }
}

extension Constructable where Self: Storyboardable {
  static func construct(output: Output) -> Self {
    var controller = Self.fromStoryboard()
    controller.output = output
    return controller
  }
}

protocol Origin: AnyObject {
}

extension Origin {
  @discardableResult
  func start(transition: Transition, destination: Origin, animated: Bool = true, completion: ((Any?) -> Void)? = nil) -> Origin? {
    if let self = self as? UIWindow, let destination = destination as? UIViewController {
      switch transition {
      case .push:
        let nc = UINavigationController(rootViewController: destination)
        self.rootViewController = nc
        return nc
      case .present, .rootView, .container:
        self.rootViewController = destination
        return nil
      case .childTab:
        let tc = UITabBarController()
        tc.viewControllers = (tc.viewControllers ?? []) + [destination]
        self.rootViewController = tc
        return tc
      }
    }
    guard let destination = destination as? UIViewController,
          let self = self as? UIViewController else { return nil }
    switch transition {
    case .push:
      let nc = self as? UINavigationController ?? self.navigationController
      nc?.pushViewController(destination, animated: animated)
    case .present:
      self.present(destination, animated: animated, completion: { completion?(nil) })
    case .rootView:
      let nc = self as? UINavigationController
      nc?.viewControllers = [destination]
      return nc
    case .childTab:
      let tc = self as? UITabBarController ?? self.tabBarController ?? self.navigationController?.tabBarController ?? UITabBarController()
      tc.viewControllers = (tc.viewControllers ?? []) + [destination]
      return tc
    case .container:
      completion?(destination.view)
      self.addChild(destination)
      destination.didMove(toParent: self)
    }
    return nil
  }
}

extension Origin {
  func end(backwardTransition: BackwardTransition, animated: Bool = true, completion: (() -> ())? = nil ) {
    switch backwardTransition {
    case .pop:
      guard let self = self as? UIViewController,
            let nc = self.navigationController
      else { return }
      nc.popViewController(animated: animated)
    case .dismiss:
      guard let self = self as? UIViewController else { return }
      self.dismiss(animated: animated, completion: completion)
    default:
      return
    }
  }
}

extension UIWindow: Origin {}
extension UINavigationController: Origin {}
extension UITabBarController: Origin {}
extension UIHostingController: Origin {}
