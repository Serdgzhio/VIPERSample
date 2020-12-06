//
//  BestFilmForYouTests.swift
//  BestFilmForYouTests
//
//  Created by user on 10.10.2020.
//  Copyright © 2020 CHI software. All rights reserved.
//

import XCTest
@testable import BestFilmForYou

class MainPresenterTests: XCTestCase {
  var routerMock: RouterMock?
  var interactorMock: InteractorMock?
  var viewMock: ViewMock?
  var sut: MainPresenter?
  
  override func setUpWithError() throws {
    let routerMock = RouterMock()
    let interactorMock = InteractorMock()
    let viewMock = ViewMock()
    self.viewMock = viewMock
    self.interactorMock = interactorMock
    self.routerMock = routerMock
    self.sut = MainPresenter(routerInput: routerMock, interactorInput: interactorMock)
    sut?.viewInput = viewMock
  }
  
  class InteractorMock: MainInteractorInput {
    func saveReaction(id: String, reaction: UserReaction) {
      self.idSignal = id
      self.reactionSignal = reaction
    }
    func loadData() {
      self.loadDataSignal = true
    }
    var loadDataSignal: Bool = false
    var idSignal: String?
    var reactionSignal: UserReaction?
  }
  
  class RouterMock: MainRouterInput{
    func didTapRedo(film: FilmCardViewData, reaction: UserReaction) {
      self.filmSignal = film
      self.reactionSignal = reaction
    }
    func routeToResult(title: String, message: String) {
      self.titleSignal = title
      self.messageSignal = message
    }
    var filmSignal: FilmCardViewData?
    var reactionSignal: UserReaction?
    var titleSignal: String?
    var messageSignal: String?
  }
  
  class ViewMock: MainViewInput {
    var newDataSignal: [FilmCardViewData]?
    var isRedoHiddenSignal: Bool?
    var finishReactionSignal: UserReaction?
    var displayHintReactionSignal: UserReaction?
    var isLoadingSignal: Bool?
    var dataEndTextSignal: String?
    func applyState(_ state: MainViewState) {
      switch state {
      case let .setRedoHidden(isHidden: isHidden):
        self.isRedoHiddenSignal = isHidden
      case let .newData(data):
        newDataSignal = data
      case let .finishGesture(reaction):
        finishReactionSignal = reaction
      case let .displayHint(reaction):
        displayHintReactionSignal = reaction
      case .loading:
        isLoadingSignal = true
      case let .dataEnd(text):
        dataEndTextSignal = text
      default: return
      }
    }
  }
  
  enum ErrorStub: LocalizedError {
    case text(String)
    case empty
    
    public var errorDescription: String? {
      switch self {
      case let .text(descr):
        return NSLocalizedString(descr, comment: "")
      case .empty:
        return NSLocalizedString("", comment: "")
      }
    }
  }
  
  override func tearDownWithError() throws {
    self.routerMock = nil
    self.interactorMock = nil
    self.viewMock = nil
    self.sut?.viewInput = nil
    self.sut = nil
  }
  
  func testInitialization() throws {
    XCTAssert(sut?.interactorInput as AnyObject === self.interactorMock)
    XCTAssert(sut?.viewInput === viewMock)
    XCTAssert(sut?.routerInput as AnyObject === self.routerMock)
  }
  
  func testInitState() throws {
    self.sut?.readyForInitState()
    XCTAssertNotNil(self.interactorMock?.loadDataSignal)
    XCTAssert(self.interactorMock!.loadDataSignal)
  }
  
  func testSwipeSuccessfulEnd() {
    let filmStub = FilmCardViewData(id: "111", title: "TestTitle", rating: "5.0", image: "TestImage", description: "TestDescription")
    sut?.films = [filmStub]
    let reactionStub =  UserReaction.favourite
    self.sut?.swipeDidEnd(direction: reactionStub, rate: 0.3)
    XCTAssertEqual(viewMock?.finishReactionSignal, reactionStub)
    XCTAssertEqual(interactorMock?.idSignal, filmStub.id)
    XCTAssertEqual(interactorMock?.reactionSignal, reactionStub)
    XCTAssertEqual(sut?.lastReactedFilm?.film.id, filmStub.id)
    XCTAssertEqual(viewMock?.isRedoHiddenSignal, false)
    XCTAssertNil(viewMock?.newDataSignal?.first)
    XCTAssertEqual(viewMock?.newDataSignal?.count, 0)
    XCTAssertEqual(viewMock?.isLoadingSignal, true)
    XCTAssertEqual(interactorMock?.loadDataSignal, true)
  }
  
  func testSwipeFailEnd() {
    let filmStub = FilmCardViewData(id: "111", title: "TestTitle", rating: "5.0", image: "TestImage", description: "TestDescription")
    sut?.films = [filmStub]
    let reactionStub =  UserReaction.favourite
    self.sut?.swipeDidEnd(direction: reactionStub, rate: 0.2)
    XCTAssertEqual(viewMock?.finishReactionSignal, UserReaction.none)
  }
  
  func testSwipeInProgress() {
    let reactionStub = UserReaction.watchlist
    sut?.swipeDidMove(direction: reactionStub, rate: 0.2)
    XCTAssertEqual(viewMock?.displayHintReactionSignal, UserReaction.none)
  }
  
  func testSwipeOverThreshold() {
    let reactionStub = UserReaction.watchlist
    sut?.swipeDidMove(direction: reactionStub, rate: 0.3)
    XCTAssertEqual(viewMock?.displayHintReactionSignal, reactionStub)
  }
  
  func didTapRedo() {
    let filmStub = FilmCardViewData(id: "111", title: "TestTitle", rating: "5.0", image: "TestImage", description: "TestDescription")
    let reactionStub = UserReaction.dislike
    sut?.lastReactedFilm = (film: filmStub, reaction: reactionStub)
    XCTAssertEqual(routerMock?.filmSignal?.id, filmStub.id)
    XCTAssertEqual(routerMock?.reactionSignal, reactionStub)
  }
  
  func testDisplayNewData() {
    let entity = Film(id: 111, internalId: 112, name: "TestName", info: "TestInfo", state: .none, rating: 5.0, year: "1994", actors: ["TestActior"], imageId: nil)
    let film = FilmCardPresentationData(entity: entity)
    sut?.displayNewData(data: [film, film, film, film])
    XCTAssertEqual(viewMock?.newDataSignal?.count, 3)
    XCTAssertEqual(viewMock?.newDataSignal?.first?.id, "\(film.internalId)")
  }
  
  func testDisplayError() {
    let textStub = "TestError"
    sut?.displayError(text: textStub)
    XCTAssertEqual(routerMock?.titleSignal, MainPresenter.Const.errorTitle)
    XCTAssertEqual(routerMock?.messageSignal, textStub)
  }
  
  func testDisplayDataEnd() {
    sut?.displayDataEnd()
    XCTAssertEqual(viewMock?.dataEndTextSignal, MainPresenter.Const.dataEndText)
  }
  
  func testDidReceiveResultWithSuccess() {
    let filmStub = FilmCardViewData(id: "111", title: "TestTitle", rating: "5.0", image: "TestImage", description: "TestDescription")
    let oldReactionStub = UserReaction.watchlist
    sut?.lastReactedFilm = (film: filmStub, reaction: oldReactionStub)
    let newReactionStub = UserReaction.favourite
    sut?.didReceiveResult(.success(newReactionStub))
    XCTAssertEqual(sut?.lastReactedFilm?.reaction, newReactionStub)
    XCTAssertEqual(routerMock?.titleSignal, MainPresenter.Const.successTitle)
    XCTAssertEqual(routerMock?.messageSignal, MainPresenter.Const.successDescr)
  }
  
  func testDidReceiveResultWithSuccessWithoutLast() {
    let newReactionStub = UserReaction.favourite
    sut?.didReceiveResult(.success(newReactionStub))
    XCTAssertNil(sut?.lastReactedFilm)
    XCTAssertNil(routerMock?.titleSignal)
    XCTAssertNil(routerMock?.messageSignal)
  }
  
  func testDidReceiveResultWithFailure() {
    let errorTextStub = "TestError"
    sut?.didReceiveResult(.failure(ErrorStub.text(errorTextStub)))
    XCTAssertEqual(routerMock?.messageSignal, errorTextStub)
    XCTAssertEqual(routerMock?.titleSignal, MainPresenter.Const.errorTitle)
    
  }
  func testDidReceiveResultWithEmptyFailure() {
    sut?.didReceiveResult(.failure(ErrorStub.empty))
    XCTAssertEqual(routerMock?.messageSignal, MainPresenter.Const.errorDescr)
    XCTAssertEqual(routerMock?.titleSignal, MainPresenter.Const.errorTitle)
  }
}
