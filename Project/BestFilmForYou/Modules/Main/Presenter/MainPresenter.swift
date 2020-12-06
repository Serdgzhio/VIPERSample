//
//  MainMainPresenter.swift
//  BestFilmForYou
//
//  Created by Azarenkov Sergey on 10/11/2020.
//  Copyright 2020 CHISW. All rights reserved.
//

final class MainPresenter: RouterInputable, ViewInputable, InteractorInputable {
  typealias ViewInput = MainViewInput
  typealias InteractorInput = MainInteractorInput
  typealias RouterInput = MainRouterInput
  var routerInput: RouterInput
  var interactorInput: InteractorInput
  unowned var viewInput: ViewInput!
  var films: [FilmCardViewData] = []
  var lastReactedFilm: (film: FilmCardViewData, reaction: UserReaction)?
  
  enum Const {
    static let stackSize = 3
    static let promoTitle = "Welcome"
    static let errorTitle = "Error"
    static let dataEndText = "Seems like the end of the recommendations"
    static let errorDescr = "Something went wrong..."
    static let successDescr = "Successfully updated"
    static let successTitle = "Success"
  }
    
  init(routerInput: RouterInput, interactorInput: InteractorInput) {
    self.routerInput = routerInput
    self.interactorInput = interactorInput
  }
}

extension MainPresenter: Preparable {
  func readyForInitState() {
    applyInitialData()
  }
  
  func applyInitialData() {
    interactorInput.loadData()
  }
}

extension MainPresenter: MainViewOutput {
  func swipeDidEnd(direction: UserReaction, rate: Float) {
    if rate >= 0.25 {
      guard let first = films.first else { return }
      lastReactedFilm = (film: first, reaction: direction)
      viewInput.applyState(.finishGesture(direction))
      interactorInput.saveReaction(id: first.id, reaction: direction)
      didDismissCard()
      return
    }
    viewInput.applyState(.finishGesture(.none))
  }
  func swipeDidMove(direction: UserReaction, rate: Float) {
    if rate >= 0.25 {
      viewInput.applyState(.displayHint(direction))
      return
    }
    viewInput.applyState(.displayHint(.none))
  }
    
  func didDismissCard() {
    viewInput.applyState(.setRedoHidden(isHidden: false))
    films.remove(at: 0)
    viewInput.applyState(.newData(Array(films.prefix(Const.stackSize))))
    if films.count == 0 {
      viewInput.applyState(.loading)
    }
    if films.count <= Const.stackSize {
      interactorInput.loadData()
    }
  }
  
  func didTapRedo() {
    guard let first = lastReactedFilm else { return }
    routerInput.didTapRedo(film: first.film, reaction: first.reaction)
  }
}

extension MainPresenter: MainModuleInput {
  func didPushFirst(promo: String) {
    routerInput.routeToResult(title: Const.promoTitle, message: promo)
  }
  
}

extension MainPresenter: MainInteractorOutput {
  func displayNewData(data: [FilmCardPresentationData]) {
    let films = data.map({ $0.toViewData() })
    self.films += films
    viewInput.applyState(.newData(Array(self.films.prefix(3))))
  }
  func displayError(text: String) {
    routerInput.routeToResult(title: Const.errorTitle, message: text)
  }
  func displayDataEnd() {
    viewInput.applyState(.dataEnd(Const.dataEndText))
  }
}

extension MainPresenter: MainRouterOutput {
  func didReceiveResult(_ result: Result<UserReaction, Error>) {
    switch result {
    case let .success(newReaction):
      guard let film = lastReactedFilm else { return }
      self.lastReactedFilm = (film: film.film, reaction: newReaction)
      routerInput.routeToResult(title: Const.successTitle, message: Const.successDescr)
    case let .failure(error):
      routerInput.routeToResult(title: Const.errorTitle, message: error.localizedDescription.isEmpty ? Const.errorDescr : error.localizedDescription)
    }
  }
}



