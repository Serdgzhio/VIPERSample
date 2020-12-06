//
//  ResultResultInterfaces.swift
//  BestFilmForYou
//
//  Created by Azarenkov Sergey on 06/12/2020.
//  Copyright 2020 CHISW. All rights reserved.
//


import Foundation
struct ResultAction {
  let title: String
  let handler: (() -> Void)?
}

protocol ResultModuleInput {
  func passData(title: String, message: String, actions: [ResultAction])
}

protocol ResultRouterInput {
}

protocol ResultViewInput: AnyObject {
    func applyState(_ state: ResultViewState)
}

protocol ResultViewOutput {
}
