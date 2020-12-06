//
//  LibraryLibraryInterfaces.swift
//  BestFilmForYou
//
//  Created by Azarenkov Sergey on 21/10/2020.
//  Copyright 2020 CHISW. All rights reserved.
//


import Foundation

protocol LibraryInteractorOutput {

}

protocol LibraryInteractorInput {
    
}

protocol LibraryModuleInput {

}

protocol LibraryRouterInput {
    func addViewController(type: FilmListType)
}

protocol LibraryViewInput {
    func applyState(_ stateL LibraryViewState)
}

protocol LibraryViewOutput {
    func addControlllers()
}

