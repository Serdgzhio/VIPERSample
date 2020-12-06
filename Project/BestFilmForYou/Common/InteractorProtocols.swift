//
//  InteractorProtocols.swift
//  BestFilmForYou
//
//  Created by user on 13.10.2020.
//  Copyright © 2020 CHI software. All rights reserved.
//

protocol Interactable {
  associatedtype Output
  var output: Output! { get set }
}
