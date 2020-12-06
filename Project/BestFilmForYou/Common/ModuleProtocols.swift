//
//  Modulable.swift
//  BestFilmForYou
//
//  Created by user on 11.10.2020.
//  Copyright © 2020 CHI software. All rights reserved.
//

import UIKit

protocol Modulable {
  associatedtype InputListener
  var transition: Transition? { get set }
  var view: Origin { get }
  var inputListener: InputListener { get set }
}
