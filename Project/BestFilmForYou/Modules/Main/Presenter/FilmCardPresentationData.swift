//
//  FilmCardPresentationData.swift
//  BestFilmForYou
//
//  Created by user on 27.11.2020.
//  Copyright © 2020 CHI software. All rights reserved.
//

import Foundation
struct FilmCardPresentationData: FromEntityConvertable {
  var name: String
  var description: String?
  var rating: Float?
  var year: String?
  var imageId: String?
  var internalId: Int
  
  init(entity: EntityIdentifiable) {
    guard let entity = entity as? Film else { preconditionFailure() }
    name = entity.name
    description = entity.info
    rating = entity.rating
    year = entity.year
    imageId = entity.imageId
    internalId = entity.id
  }
  
  func toViewData() -> FilmCardViewData {
    return FilmCardViewData(id: "\(internalId)", title: name, rating: rating == nil ? "" : "\(rating!)", image: imageId ?? "default", description: description ?? "")
  }
}
