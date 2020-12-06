//
//  DetailDetailRouter.swift
//  BestFilmForYou
//
//  Created by Azarenkov Sergey on 04/12/2020.
//  Copyright 2020 CHISW. All rights reserved.
//


final class DetailRouter: Routable, DetailRouterInput{
 	weak var output: DetailRouterOutput?
    weak var origin: Origin?
  
  func routeToMain() {
    origin?.end(backwardTransition: .pop)
  }

}
