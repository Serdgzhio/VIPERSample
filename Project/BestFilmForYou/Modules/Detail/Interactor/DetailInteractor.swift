//
//  DetailDetailInteractor.swift
//  BestFilmForYou
//
//  Created by Azarenkov Sergey on 04/12/2020.
//  Copyright 2020 CHISW. All rights reserved.
//
import Foundation

final class DetailInteractor:  DetailInteractorInput, Interactable {
  typealias Output = DetailInteractorOutput
  weak var output: Output!
  var repository: FilmRepository
  var semaphore: DispatchSemaphore?
  var shouldTerminate: Bool = false
  
  init(repository: FilmRepository) {
    self.repository = repository
  }
  
  func changeReaction(for filmId: Int, oldReaction: UserReaction, newReaction: UserReaction) {
    guard self.semaphore == nil else { return }
    let semaphore = DispatchSemaphore(value: 0)
    self.semaphore = semaphore
    weak var weakSelf = self
    DispatchQueue.global().async {
      switch oldReaction {
      case .dislike:
        self.repository.removeDislike(filmId: filmId) { result in
          weakSelf?.handleResult(result)
        }
      case .favourite:
        self.repository.removeFromFavourite(filmId: filmId) { result in
          weakSelf?.handleResult(result)
        }
      case .watchlist:
        self.repository.removeFromWatchlist(filmId: filmId) { result in
          weakSelf?.handleResult(result)
        }
      case .none: return
      }
      
      if semaphore.wait(timeout: .now() + 10) == .timedOut {
        semaphore.signal()
        self.handleError()
        self.prepareForTerminate()
      }
      guard !self.checkShouldTerminate() else {
        return
      }
      
      switch newReaction {
      case .dislike:
        self.repository.dislike(filmId: filmId) { result in
          weakSelf?.handleResult(result)
        }

      case .favourite:
        self.repository.addToFavourite(filmId: filmId) { result in
          weakSelf?.handleResult(result)
        }

      case .watchlist:
        self.repository.addToWatchlist(filmId: filmId) { result in
          weakSelf?.handleResult(result)
        }
      case .none:
        return
      }
      
      if semaphore.wait(timeout: .now() + 10) == .timedOut {
        semaphore.signal()
        self.handleError()
        self.prepareForTerminate()
      }
      guard !self.checkShouldTerminate() else {
        return
      }
      self.handleSuccess(newReaction)
    }
  }
  
  func handleSuccess(_ reaction: UserReaction) {
    DispatchQueue.main.async {
      self.output.saveSuccess(reaction)
    }
  }
  
  func handleError() {
    DispatchQueue.main.async {
      self.output.saveFailure(NSError(domain: ".com", code: 25, userInfo: [:]))
    }
  }
  
  func checkShouldTerminate() -> Bool{
    var shouldTerminate = false
    DispatchQueue.main.sync {
      shouldTerminate = self.shouldTerminate
    }
    return shouldTerminate
  }
  
  func prepareForTerminate() {
    DispatchQueue.main.sync {
      self.shouldTerminate = true
    }
  }
  
  func handleResult(_ result: Result<Void, Error>) {
    switch result {
    case .success:
      break
    case .failure:
      prepareForTerminate()
      handleError()
    }
    semaphore?.signal()
  }
}
