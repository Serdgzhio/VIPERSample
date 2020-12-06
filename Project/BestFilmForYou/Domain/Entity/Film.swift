//
//  Film.swift
//  BestFilmForYou
//
//  Created by user on 14.10.2020.
//  Copyright © 2020 CHI software. All rights reserved.
//

import Foundation
struct Film {
  enum State: Int16 {
    case watched
    case dislike
    case favourite
    case undefined
  }
  let id: Int
  let internalId: AnyHashable?
  let name: String
  let info: String?
  var state: State?
  let rating:Float?
  let year: String?
  var actors: [String]
  let imageId: String?
}

extension Film: EntityIdentifiable {}
