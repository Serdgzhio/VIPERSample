//
//  ResultResultViewState.swift
//  BestFilmForYou
//
//  Created by Azarenkov Sergey on 06/12/2020.
//  Copyright 2020 CHISW. All rights reserved.
//


import Foundation
enum ResultViewState {
  case initial(title: String, message: String, actions: [ResultAction])
}
