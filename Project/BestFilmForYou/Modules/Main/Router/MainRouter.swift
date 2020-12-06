//
//  MainMainRouter.swift
//  BestFilmForYou
//
//  Created by Azarenkov Sergey on 10/11/2020.
//  Copyright 2020 CHISW. All rights reserved.
//

import Swinject
  
final class MainRouter: Routable, MainRouterInput{
  let locator: ApplicationLocator
  weak var origin: Origin?
  weak var output: MainRouterOutput?
  
  init(locator: ApplicationLocator) {
    self.locator = locator
  }

  func didTapRedo(film: FilmCardViewData, reaction: UserReaction) {
    guard let origin = origin,
          let module = locator.assembler.resolver.resolve(DetailModule.self)
    else { return }
    module.inputListener.film = film
    module.inputListener.reaction = reaction
    module.inputListener.onClose = { [weak self] result in
      self?.output?.didReceiveResult(result)
    }
    origin.start(transition: .push, destination: module.view)
  }
  
  func routeToResult(title: String, message: String) {
    guard let origin = origin,
          let module = locator.assembler.resolver.resolve(ResultModule.self)
    else { return }
    let action = ResultAction(title: "OK", handler: {})
    module.inputListener.passData(title: title, message: message, actions: [action])
    origin.start(transition: .present, destination: module.view)
  }
}
