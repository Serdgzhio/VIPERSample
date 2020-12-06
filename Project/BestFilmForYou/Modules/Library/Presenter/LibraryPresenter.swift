//
//  LibraryLibraryPresenter.swift
//  BestFilmForYou
//
//  Created by Azarenkov Sergey on 21/10/2020.
//  Copyright 2020 CHISW. All rights reserved.
//


class LibraryPresenter: BasePresenter<LibraryViewInput, LibraryInteractorInput, LibraryRouterInput> {
    enum Consts {
        enum Images {
            static let favourite = "Favourite"
            static let watchlist = "Watchlist"
            static let disliked = "Disliked"
        }

    }

    var tabs: [TabBarItemViewModel<FilmListType>]!
}

extension LibraryPresenter: LibraryViewOutput {
    func addControlllers() {
        let tabBarItems = [Consts.Images.disliked, Consts.Images.watchlist, Consts.Images.favourite]
        tabs = FilmListType.allCases
        tabs.forEach({ routerInput.addViewController(type: $0) })
    }
}

extension LibraryPresenter: LibraryModuleInput {
}

extension LibraryPresenter: LibraryInteractorOutput {
}
