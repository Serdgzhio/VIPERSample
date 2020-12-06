//
//  ResultResultPresenter.swift
//  BestFilmForYou
//
//  Created by Azarenkov Sergey on 06/12/2020.
//  Copyright 2020 CHISW. All rights reserved.
//


final class ResultPresenter:  ViewInputable {
  typealias ViewInput = ResultViewInput
  unowned var viewInput: ViewInput!
}

extension ResultPresenter: ResultViewOutput {
  
}

extension ResultPresenter: ResultModuleInput {
  func passData(title: String, message: String, actions: [ResultAction]) {
    viewInput.applyState(.initial(title: title, message: message, actions: actions))
  }
}
