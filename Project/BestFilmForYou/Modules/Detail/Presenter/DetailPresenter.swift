//
//  DetailDetailPresenter.swift
//  BestFilmForYou
//
//  Created by Azarenkov Sergey on 04/12/2020.
//  Copyright 2020 CHISW. All rights reserved.
//
import Foundation

final class DetailPresenter: RouterInputable, ViewInputable, InteractorInputable {
  typealias ViewInput = DetailViewInput
  typealias InteractorInput = DetailInteractorInput
  typealias RouterInput = DetailRouterInput
  
  enum Const {
    static let favouriteText = "Favourite"
    static let watchlistText = "Watchlist"
    static let dislikeText = "Dislike"
    static let saveButtonTitle = "Save"
  }
  
  var routerInput: RouterInput
  var interactorInput: InteractorInput
  unowned var viewInput: ViewInput!
  var viewModel: FilmCardViewData?
  var onClose: ((Result<UserReaction, Error>) -> ())?
  var reaction: UserReaction?
  var film: FilmCardViewData?
  var reactions = [UserReaction.dislike, UserReaction.favourite, UserReaction.watchlist]
  
  init(routerInput: RouterInput, interactorInput: InteractorInput) {
    self.routerInput = routerInput
    self.interactorInput = interactorInput
  }
}

extension DetailPresenter: Preparable {
  func readyForInitState() {
    guard let film = film, let reaction = reaction else { return }
    let segments = reactions.compactMap({ reaction -> String? in
      switch reaction {
      case .dislike:
        return Const.dislikeText
      case .favourite:
        return Const.favouriteText
      case .watchlist:
        return Const.watchlistText
      default: return nil
      }
    })
    guard let index = reactions.firstIndex(of: reaction) else { return }
    viewInput.applyState(.initial(segments: segments, image: ImageWrapper(with: film.image), viewModel: film, reactionIndex: index))
  }
}

extension DetailPresenter: DetailViewOutput {
  func segmentChanged(index: Int) {
    viewInput.applyState(.saveButtonEnable(reactions[index] != reaction ? Const.saveButtonTitle : nil))
  }
  
  func saveDidTap(selectedIndex: Int) {
    guard let id = film?.id, let idInt = Int(id), let reaction = reaction else { return }
    interactorInput.changeReaction(for: idInt, oldReaction: reaction, newReaction: reactions[selectedIndex])
  }
  
  func willAppear() {
    viewInput.applyState(.setNavBarHidden(false))
  }
  
  func willDisappear() {
    viewInput.applyState(.setNavBarHidden(true))
  }
}


extension DetailPresenter: DetailModuleInput {
  
}

extension DetailPresenter: DetailRouterOutput {
  
}

extension DetailPresenter: DetailInteractorOutput {
  func saveSuccess(_ reaction: UserReaction) {
    routerInput.routeToMain()
    onClose?(.success(reaction))
  }
  func saveFailure(_ error: Error) {
    routerInput.routeToMain()
    onClose?(.failure(error))
  }
  
}
