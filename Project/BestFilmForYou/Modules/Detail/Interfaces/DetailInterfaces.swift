//
//  DetailDetailInterfaces.swift
//  BestFilmForYou
//
//  Created by Azarenkov Sergey on 04/12/2020.
//  Copyright 2020 CHISW. All rights reserved.
//


import Foundation

protocol DetailModuleInput {
  var onClose: ((Result<UserReaction, Error>) -> ())? { get set }
  var reaction: UserReaction? { get set }
  var film: FilmCardViewData? { get set }
}

protocol DetailRouterInput {
  func routeToMain()
}

protocol DetailRouterOutput: AnyObject {
  var onClose: ((Result<UserReaction, Error>) -> ())? { get set }
}

protocol DetailInteractorOutput: AnyObject {
  func saveSuccess(_ reaction: UserReaction)
  func saveFailure(_ error: Error)
}

protocol DetailInteractorInput {
  func changeReaction(for filmId: Int, oldReaction: UserReaction, newReaction: UserReaction)
}

protocol DetailViewInput: AnyObject {
    func applyState(_ state: DetailViewState)
}

protocol DetailViewOutput: Preparable {
  func segmentChanged(index: Int)
  func saveDidTap(selectedIndex: Int)
  func willAppear()
  func willDisappear()
}
