//
//  LibraryLibraryViewController.swift
//  BestFilmForYou
//
//  Created by Azarenkov Sergey on 21/10/2020.
//  Copyright 2020 CHISW. All rights reserved.
//


import UIKit

class LibraryViewController: UITabBarController, LibraryViewInput, Closable, Viewable{
    typealias State = LibraryViewState
    typealias Output = LibraryViewOutput
    enum Consts {
        
    }
    var output: Output!
    var onClose: (() -> Void)?
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let preparator = output as? Preparable
        preparator?.readyForInitState()
        self.delegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isMovingFromParent || isBeingDismissed {
            onClose?()
        }
    }
    
    func applyState(_ state: State) {
        switch state {
        case .initial:
            output.addControllers()
        }
    }
    
}

extension LibraryViewController: UITabBarControllerDelegate {
    func tabbar
}

extension LibraryViewController: Storyboardable {}

