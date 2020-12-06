//
//  ReuseDataProtocols.swift
//  BestFilmForYou
//
//  Created by user on 13.10.2020.
//  Copyright © 2020 CHI software. All rights reserved.
//

import UIKit

protocol ReuseDataDisplayable {
    associatedtype DataManager
    var dataDisplayManager: DataManager! { get set }
}

protocol TableDisplayManager {
    var tableView: UITableView! { get set }
    var sections: [TableSectionViewModel]! { get set }
    var header: TableHeaderFooterViewModel? { get set }
    var footer: TableHeaderFooterViewModel? { get set }
}

protocol Unique {
    var uId: String { get }
}

protocol TableSectionViewModel: Unique{
    var header: TableHeaderFooterViewModel? { get }
    var rows: [TableRowViewModel] { get }
    var footer: TableHeaderFooterViewModel? { get }
}

protocol TableRowViewModel: ReusableItem, Unique {
    init<Data>(dataObject: Data)
}

protocol TableHeaderFooterViewModel: ReusableItem, Unique {
    var title: String { get }
}

protocol ReusableItem {
    var reuseIdentifier: String { get }
    func didSelect()
}

protocol Configurable {
    func configure(item: ReusableItem)
}

protocol EndReachable {
    var endDidReach: (() -> Void)? { get set }
}
