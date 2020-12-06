//
//  FilmRepository.swift
//  BestFilmForYou
//
//  Created by user on 26.11.2020.
//  Copyright © 2020 CHI software. All rights reserved.
//
//
import Foundation

protocol FilmRepository {
  typealias FetchClosure<Type> = (Result<Type, Error>) -> Void

  func getRecomendations(page: Int, completion: @escaping  FetchClosure<(lastPage: Int, films: [Film])>)
  func getFavourites(page: Int, completion: @escaping  FetchClosure<(lastPage: Int, films: [Film])>)
  func getWatchlist(page: Int, completion: @escaping  FetchClosure<(lastPage: Int, films: [Film])>)
  func getDisliked(page: Int, completion: @escaping  FetchClosure<(lastPage: Int, films: [Film])>)
  func addToWatchlist(filmId: Int, completion: @escaping  FetchClosure<Void>)
  func addToFavourite(filmId: Int, completion: @escaping  FetchClosure<Void>)
  func dislike(filmId: Int, completion: @escaping  FetchClosure<Void>)
  
  func removeFromWatchlist(filmId: Int, completion: @escaping FetchClosure<Void>)
  func removeFromFavourite(filmId: Int, completion: @escaping FetchClosure<Void>)
  func removeDislike(filmId: Int, completion: @escaping FetchClosure<Void>)
}
