//
//  ResultResultAssembly.swift
//  BestFilmForYou
//
//  Created by Azarenkov Sergey on 06/12/2020.
//  Copyright 2020 CHISW. All rights reserved.
//


import Swinject

final class ResultAssembly: Assembly {
    func assemble(container: Container) {
        container.register(ResultModule.self) { (resolver) -> ResultModule in
            let presenter = ResultPresenter()
            let viewController = ResultViewController.construct(output: presenter)
            presenter.viewInput = viewController
            let module = ResultModule(view: viewController, inputListener: presenter)
            return module
        }

    }
}
