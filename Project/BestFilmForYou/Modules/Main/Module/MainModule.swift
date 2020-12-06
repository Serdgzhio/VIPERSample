//
//  MainMainModule.swift
//  BestFilmForYou
//
//  Created by Azarenkov Sergey on 10/11/2020.
//  Copyright 2020 CHISW. All rights reserved.
//


import UIKit

final class MainModule : Modulable {
  typealias InputListener = MainModuleInput
  let view: Origin
  var transition: Transition?
  var inputListener: InputListener

  init(view: Origin, inputListener: InputListener){
    self.view = view
    self.inputListener = inputListener
  }
}
