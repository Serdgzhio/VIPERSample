//
//  FilmRemoteRepository.swift
//  BestFilmForYou
//
//  Created by user on 26.11.2020.
//  Copyright © 2020 CHI software. All rights reserved.
//

import Foundation
class FilmRemoteRepository: FilmRepository {
  let dataSource: RemoteDataSource
  init(dataSource: RemoteDataSource) {
    self.dataSource = dataSource
  }
  func getRecomendations(page: Int, completion: @escaping  FetchClosure<(lastPage: Int, films: [Film])>) {
    getFavourites(page: page, completion: completion)
  }
  func getFavourites(page: Int, completion: @escaping  FetchClosure<(lastPage: Int, films: [Film])>) {
    let request = FilmListRequest(listType: .favourite, page: page)
    dataSource.execute(request: request) { response in
      switch response {
      case let .success(result):
        let results = result.results
        let films = results.compactMap({ element -> Film? in
          guard var entity = element.toEntity() as? Film else { return nil }
          entity.state = .favourite
          return entity
        })
        completion(.success((lastPage: result.totalPages, films: films)))
      case let .failure(error):
        completion(.failure(error))
      }
    }
  }
  func getWatchlist(page: Int, completion: @escaping  FetchClosure<(lastPage: Int, films: [Film])>) {
    completion(.failure(NSError(domain: ".com", code: 1, userInfo: [:])))
  }
  func getDisliked(page: Int, completion: @escaping  FetchClosure<(lastPage: Int, films: [Film])>) {
    completion(.failure(NSError(domain: ".com", code: 1, userInfo: [:])))
  }
  func addToWatchlist(filmId: Int, completion: @escaping  FetchClosure<Void>) {
    completion(.success(()))
  }
  func addToFavourite(filmId: Int, completion: @escaping  FetchClosure<Void>) {
    completion(.success(()))
  }
  func dislike(filmId: Int, completion: @escaping  FetchClosure<Void>) {
    completion(.failure(NSError(domain: ".com", code: 111, userInfo: [:])))
  }
  
  func removeFromWatchlist(filmId: Int, completion: @escaping FetchClosure<Void>){
    completion(.success(()))
  }
  func removeFromFavourite(filmId: Int, completion: @escaping FetchClosure<Void>){
    completion(.success(()))
  }
  func removeDislike(filmId: Int, completion: @escaping FetchClosure<Void>){
    completion(.failure(NSError(domain: ".com", code: 111, userInfo: [:])))
  }
}
