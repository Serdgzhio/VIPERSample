//
//  BaseDataDisplayManager.swift
//  BestFilmForYou
//
//  Created by user on 13.10.2020.
//  Copyright © 2020 CHI software. All rights reserved.
//

import UIKit


struct BaseTableSectionViewModel: TableSectionViewModel {
    var header: TableHeaderFooterViewModel?
    var footer: TableHeaderFooterViewModel?
    var rows: [TableRowViewModel]
    var uId: String = UUID().uuidString
}

class BaseTableDataDisplayManager: NSObject, UITableViewDelegate, UITableViewDataSource, TableDisplayManager, EndReachable {
    enum Consts {
        enum Sizes {
            static let defaultRowEstimate: CGFloat = 60.0
            static let defaultHeaderEstimate: CGFloat = 20.0
            static let defaultFooterEstimate: CGFloat = 0.0
        }
    }

    init(tableView: UITableView) {
        super.init()
        self.tableView = tableView
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.sectionFooterHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = Consts.Sizes.defaultRowEstimate
        tableView.estimatedSectionFooterHeight = Consts.Sizes.defaultFooterEstimate
        tableView.estimatedSectionHeaderHeight = Consts.Sizes.defaultHeaderEstimate
        sections = []
    }
    
    unowned var tableView: UITableView!
    var header: TableHeaderFooterViewModel?
    var footer: TableHeaderFooterViewModel?
    var sections: [TableSectionViewModel]! {
        didSet {
            registerSectionItems()
        }
    }
    var endDidReach: (() -> Void)?

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].rows.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let item = sections[indexPath.section].rows[indexPath.row]
        item.didSelect()
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerItem = sections[section].header,
            let header = tableView
                .dequeueReusableHeaderFooterView(withIdentifier: headerItem.reuseIdentifier)
                as? UITableViewHeaderFooterView & Configurable
            else { return nil }
        header.configure(item: headerItem)
        return header
        
    }
  
  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    return nil
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return .zero
  }
  
  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return .zero
  }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = sections[indexPath.section].rows[indexPath.row]
        let identifier = item.reuseIdentifier
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? UITableViewCell & Configurable
            else { return UITableViewCell() }
        cell.configure(item: sections[indexPath.section].rows[indexPath.row])
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if
            sections.count == indexPath.section + 1,
            sections[indexPath.section].rows.count == indexPath.row + 1 {
            endDidReach?()
        }
    }

}

extension TableDisplayManager where Self == BaseTableDataDisplayManager {
    func registerSectionItems() {
        let types = sections.reduce((rows: [], headers: []), { (result, section) -> (rows: [TableRowViewModel], headers: [TableHeaderFooterViewModel]) in
            guard
                let rows = section.rows.merge(with: result.rows) as? [TableRowViewModel],
                let headers = ([section.header] + [section.footer]).merge(with: result.headers) as? [TableHeaderFooterViewModel]
                else { return result }
            return (rows, headers)
        })
        types.rows.forEach {
            self.tableView.register(UINib(nibName: $0.reuseIdentifier, bundle: Bundle.main), forCellReuseIdentifier: $0.reuseIdentifier)
        }
        types.headers.forEach {
            self.tableView.register(UINib(nibName: $0.reuseIdentifier, bundle: Bundle.main), forHeaderFooterViewReuseIdentifier: $0.reuseIdentifier)
        }
    }
    
}
