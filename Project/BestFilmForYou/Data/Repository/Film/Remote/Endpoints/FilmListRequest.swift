//
//  FilmListRequest.swift
//  BestFilmForYou
//
//  Created by user on 26.11.2020.
//  Copyright © 2020 CHI software. All rights reserved.
//

import Foundation

struct FilmListRequest: RemoteRequest {
  var description: String {
    listType.rawValue
  }
  enum ListType: String {
    case favourite
    case watchlist
    case dislike
  }
  typealias ResultType = Result
  let listType: ListType
  let page: Int
}

extension FilmListRequest {
  struct Result: Decodable {
    struct FilmData: Decodable {
      let identifier: Int
      let overview: String?
      let releaseDate: String?
      let imageUrl: String?
      let title: String
      let rating: Double?
      
      enum CodingKeys: String, CodingKey {
        case overview, title, rating
        case identifier = "id"
        case releaseDate = "release_date"
        case imageUrl = "poster_path"
      }
    }
    let page: Int
    let results: [FilmData]
    let totalPages: Int
    enum CodingKeys: String, CodingKey {
      case totalPages = "total_pages"
      case page, results
    }
  }
}

extension FilmListRequest.Result.FilmData: ToEntityConvertable {
  @discardableResult func toEntity() -> EntityIdentifiable? {
    let floatRating = rating != nil ? Float(rating!) : nil
    return Film(id: identifier, internalId: nil, name: title, info: overview, state: nil, rating: floatRating, year: releaseDate, actors: [], imageId: imageUrl)
  }
}
