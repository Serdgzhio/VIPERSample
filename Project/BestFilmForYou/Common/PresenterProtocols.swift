//
//  PresenterProtocols.swift
//  BestFilmForYou
//
//  Created by user on 13.10.2020.
//  Copyright © 2020 CHI software. All rights reserved.
//

import Foundation

protocol Presentable: AnyObject  {
}

protocol RouterInputable {
  associatedtype RouterInput
  var routerInput: RouterInput { get set }
}

protocol InteractorInputable {
  associatedtype InteractorInput
  var interactorInput: InteractorInput { get set }
}

protocol ViewInputable {
  associatedtype ViewInput
  var viewInput: ViewInput! { get set }
}

protocol Preparable {
  func readyForInitState()
}
