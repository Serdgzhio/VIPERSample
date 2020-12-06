//
//  MainMainInteractor.swift
//  BestFilmForYou
//
//  Created by Azarenkov Sergey on 10/11/2020.
//  Copyright 2020 CHISW. All rights reserved.
//


final class MainInteractor:  MainInteractorInput, Interactable {
  typealias Output = MainInteractorOutput
  weak var output: Output!
  var page = 0
  var lastPage: Int?
  var isLoadingData = false
  
  var repository: FilmRepository
  init(repository: FilmRepository) {
    self.repository = repository
  }
  
  func saveReaction(id: String, reaction: UserReaction) {
    guard let id = Int(id) else { return }
    switch reaction {
    case .favourite:
      repository.addToFavourite(filmId: id) { [weak self] result in
        self?.handleReactionResponse(result)
      }
    case .dislike:
      repository.dislike(filmId: id) { [weak self] result in
        self?.handleReactionResponse(result)
      }
    case .watchlist:
      repository.addToWatchlist(filmId: id) { [weak self] result in
        self?.handleReactionResponse(result)
      }
    default:
      return
    }
  }
  
  func handleReactionResponse(_ result:Result<Void, Error>) {
    switch result{
    case let .failure(error):
      self.output.displayError(text: error.localizedDescription)
    case .success:
      return
    }
  }
    
  func loadData() {
    if let lastPage = lastPage, lastPage < page {
      self.output.displayDataEnd()
      return
    }
    guard !isLoadingData else { return }
    isLoadingData = true
    repository.getRecomendations(page: page) { [weak self] result in
      switch result {
      case let .success(data):
        guard let self = self else { return }
        self.output.displayNewData(data: data.films.map{ FilmCardPresentationData(entity: $0) } )
        self.lastPage = data.lastPage
        self.page += 1
      case let .failure(error):
        self?.output.displayError(text: error.localizedDescription)
      }
      self?.isLoadingData = false
    }

  }

}

