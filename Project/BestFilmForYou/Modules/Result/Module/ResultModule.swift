//
//  ResultResultModule.swift
//  BestFilmForYou
//
//  Created by Azarenkov Sergey on 06/12/2020.
//  Copyright 2020 CHISW. All rights reserved.
//


import Foundation

final class ResultModule : Modulable {
    typealias InputListener = ResultModuleInput
	let view: Origin
	var transition: Transition?
	var inputListener: InputListener

	init(view: Origin, inputListener: InputListener){
    	self.view = view
	    self.inputListener = inputListener
	}
}
