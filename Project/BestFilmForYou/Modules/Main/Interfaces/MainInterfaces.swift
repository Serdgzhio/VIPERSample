//
//  MainMainInterfaces.swift
//  BestFilmForYou
//
//  Created by Azarenkov Sergey on 10/11/2020.
//  Copyright 2020 CHISW. All rights reserved.
//


import Foundation

protocol MainModuleInput {
  func didPushFirst(promo: String)
}

protocol MainRouterInput {
  func didTapRedo(film: FilmCardViewData, reaction: UserReaction)
  func routeToResult(title: String, message: String)
}

protocol MainRouterOutput: AnyObject {
  func didReceiveResult(_ result: Result<UserReaction, Error>)
  
}

protocol MainViewInput: AnyObject {
    func applyState(_ state: MainViewState)
}

protocol MainViewOutput: Preparable {
  func swipeDidEnd(direction: UserReaction, rate: Float)
  func swipeDidMove(direction: UserReaction, rate: Float)
  func didTapRedo()
  func didDismissCard()
}

protocol MainInteractorInput {
  func saveReaction(id: String, reaction: UserReaction)
  func loadData()
}

protocol MainInteractorOutput: AnyObject {
  func displayNewData(data: [FilmCardPresentationData])
  func displayError(text: String)
  func displayDataEnd()
}
