//
//  EntityProtocols.swift
//  BestFilmForYou
//
//  Created by user on 05.12.2020.
//  Copyright © 2020 CHI software. All rights reserved.
//

import Foundation

protocol EntityIdentifiable {
  var internalId: AnyHashable? { get }
}

protocol EntityConvertable: ToEntityConvertable, ByEntityConvertable {}

protocol ToEntityConvertable {
  @discardableResult func toEntity() -> EntityIdentifiable?
}

protocol ByEntityConvertable {
  @discardableResult func fromEntity(_ entity: EntityIdentifiable) -> Self
}

protocol FromEntityConvertable {
  init(entity: EntityIdentifiable)
}
