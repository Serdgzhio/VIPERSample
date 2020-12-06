//
//  MainMainViewState.swift
//  BestFilmForYou
//
//  Created by Azarenkov Sergey on 10/11/2020.
//  Copyright 2020 CHISW. All rights reserved.
//

enum MainViewState {
  case displayHint(UserReaction)
  case finishGesture(UserReaction)
  case error(String)
  case loading
  case initial
  case newData([FilmCardViewData])
  case displayPromo(String)
  case dataEnd(String)
  case setRedoHidden(isHidden: Bool)
}
