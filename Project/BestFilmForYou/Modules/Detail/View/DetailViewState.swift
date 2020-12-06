//
//  DetailDetailViewState.swift
//  BestFilmForYou
//
//  Created by Azarenkov Sergey on 04/12/2020.
//  Copyright 2020 CHISW. All rights reserved.
//


import Foundation
enum DetailViewState {
  case initial(segments: [String], image: ImageWrapper, viewModel: FilmCardViewData, reactionIndex: Int)
  case saveButtonEnable(String?)
  case setNavBarHidden(Bool)
}
