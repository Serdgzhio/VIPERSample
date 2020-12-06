//
//  MainViewModel.swift
//  BestFilmForYou
//
//  Created by user on 22.11.2020.
//  Copyright © 2020 CHI software. All rights reserved.
//

import Combine
import SwiftUI

class MainViewModel: ObservableObject, Viewable  {
  typealias State = MainViewState
  typealias Output = MainViewOutput

  private enum Consts {
    static let favouriteText = "Favourite"
    static let dislikeText = "Dislike"
    static let watchlistText = "Watchlist"
    static let buttonTitle = "Redo"
    static let cardSize = CGSize(width: 400, height: 400)
  }

  init(output: MainViewOutput) {
    self.output = output
    self.favouriteText = Consts.favouriteText
    self.dislikeText = Consts.dislikeText
    self.watchlistText = Consts.watchlistText
    self.buttonTitle = Consts.buttonTitle
    self.cardSize = Consts.cardSize
    cancellables = Set<AnyCancellable>()
  }
  
  var output: Output!
  let favouriteText: String
  let dislikeText: String
  let watchlistText: String
  let buttonTitle: String
  let cardSize: CGSize

  var cancellables: Set<AnyCancellable>

  @Published var films: [FilmCardViewData] = []
  @Published var state: MainViewState = .initial
  @Published var actionTextAlignment: Alignment = .bottomTrailing
  @Published var actionText: String?
  @Published var actionTextColor: UIColor = .red
  @Published var redoIsHidden: Bool = true

  func gestureDidMove(offset: CGSize) {
    let value = self.findDestination(translation: offset)
    self.output.swipeDidMove(direction: value.direction, rate: value.rate)
  }
  
  func gestureDidEnd(offset: CGSize) {
    let value = self.findDestination(translation: offset)
    self.output.swipeDidEnd(direction: value.direction, rate: value.rate)
  }
  
  func didTapRedo() {
    output.didTapRedo()
  }
  
  func didDismissCard() {
    output.didDismissCard()
  }
  
  func bindState() {
    $state.sink { [weak self] state in
      guard let self = self else { return }
      switch state{
      case .initial:
        break
      case let .displayHint(type):
        switch type {
        case .favourite:
          self.actionTextAlignment = .topLeading
          self.actionText = self.favouriteText
          self.actionTextColor = .green
        case .dislike:
          self.actionTextAlignment = .topTrailing
          self.actionText = self.dislikeText
          self.actionTextColor = .red
        case .watchlist:
          self.actionTextAlignment = .bottom
          self.actionText = self.watchlistText
          self.actionTextColor = .blue
        case .none:
          self.actionText = nil
        }
      case let .finishGesture(type):
        self.actionText = nil
        if type == .none {
          break
        }
        self.films.remove(at: 0)
      case let .newData(films):
        self.films = films
      case let .setRedoHidden(isHidden):
        self.redoIsHidden = isHidden
      default: break
      }
    }.store(in: &cancellables)
    
    self.output.readyForInitState()
  }
      
  func findDestination(translation: CGSize) -> (direction: UserReaction, rate: Float){
    guard -translation.height < abs(translation.width) else {
      return(.watchlist, Float(abs(translation.height) / cardSize.height))
    }
    return(translation.width > 0 ? .favourite : .dislike, abs(Float(translation.width / cardSize.width)))

  }
  
  func getCardWidth(_ geometry: GeometryProxy, id: Int) -> CGFloat {
    let offset = getCardOffset(id: id)
    return geometry.size.width - 2 * offset
  }
  
  func getCardOffset(id: Int) -> CGFloat {
    return  CGFloat(id) * 10
  }
}

extension MainViewModel: MainViewInput {
  func applyState(_ state: State) {
    self.state = state
  }
}


