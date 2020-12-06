//
//  LibraryLibraryRouter.swift
//  BestFilmForYou
//
//  Created by Azarenkov Sergey on 21/10/2020.
//  Copyright 2020 CHISW. All rights reserved.
//

final class LibraryRouter: BaseRouter, LibraryRouterInput {
    func addViewController(type: LibraryViewState.Item) {
        let list = resolver?.resolve(ListModule.self)
        list?.input.tabBarItemType = type
        list?.start(transition: .childTab, from: origin, completion: nil)
    }
}
