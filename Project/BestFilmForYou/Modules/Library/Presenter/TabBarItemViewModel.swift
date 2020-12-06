//
//  TabBarItemViewModel.swift
//  BestFilmForYou
//
//  Created by user on 22.10.2020.
//  Copyright © 2020 CHI software. All rights reserved.
//

import Foundation
enum FilmListType: Int, CaseIterable {
    case disliked = 1
    case watchlist
    case favourite
}

struct TabBarItemViewModel<T> {
    var type: T
    var title: String
    var image: Image!
}
