//
//  Storyboardable.swift
//  BestFilmForYou
//
//  Created by user on 11.10.2020.
//  Copyright © 2020 CHI software. All rights reserved.
//

import UIKit

protocol Storyboardable{
    static func fromStoryboard() -> Self
}

extension Storyboardable  {
    static func fromStoryboard() -> Self {
        typealias Type = Self
        let name = String(describing: Type.self)
        for bundle in [Bundle.main] + Bundle.allFrameworks {
            guard bundle.path(
                forResource: name,
                ofType: "storyboardc"
                ) != nil else {
                continue
            }

            let storyboard = UIStoryboard(name: name, bundle: bundle)
            if let viewController = storyboard.instantiateInitialViewController() as? Self {
                return viewController
            }
        }

        fatalError("Failed to create viewController from storyboard \(name)")

    }
}
