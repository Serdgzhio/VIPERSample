//
//  Transition.swift
//  BestFilmForYou
//
//  Created by user on 12.10.2020.
//  Copyright © 2020 CHI software. All rights reserved.
//

import Foundation
enum Transition {
    case push
    case present
    case childTab
    case rootView
    case container
}

enum BackwardTransition {
  case pop
  case dismiss
  case remove
}
