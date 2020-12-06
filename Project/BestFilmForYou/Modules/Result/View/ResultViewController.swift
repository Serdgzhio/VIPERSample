//
//  ResultResultViewController.swift
//  BestFilmForYou
//
//  Created by Azarenkov Sergey on 06/12/2020.
//  Copyright 2020 CHISW. All rights reserved.
//


import UIKit

final class ResultViewController: UIAlertController, Viewable, Origin {
  typealias State = ResultViewState
  typealias Output = ResultViewOutput
  var output: Output!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  func applyState(_ state: State) {
    switch state{
    case let .initial(title: title, message: message, actions: actions):
      self.title = title
      self.message = message
      actions.forEach({ action in
        let alertAction = UIAlertAction(title: action.title, style: .default) { _ in
          action.handler?()
        }
        self.addAction(alertAction)
      })
    }
  }
}

extension ResultViewController: Constructable {
  static func construct(output: Output) -> ResultViewController {
    return ResultViewController(title: nil, message: nil, preferredStyle: .alert)
  }
}

extension ResultViewController: ResultViewInput {}

extension ResultViewController: Storyboardable {}
