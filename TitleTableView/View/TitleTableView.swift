//
//  TitleTableView.swift
//  LyEditImageView
//
//  Created by Cheng-Hong on 2021/4/7.
//  Copyright © 2021 Li,Yan(MMS). All rights reserved.
//

import UIKit

class TitleTableView: UIView {

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.register(TitleTableViewCell.loadFromNib(), forCellReuseIdentifier: "TitleTableViewCell")
//        tableView.isScrollEnabled = false
        //禁止滑動
        tableView.alwaysBounceVertical = false
        return tableView
    }()

    override func layoutSubviews() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = frame
        backgroundColor = .clear
        addSubview(tableView)
    }
}

extension TitleTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewTitle.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TitleTableViewCell") as! TitleTableViewCell
        let index = tableViewTitle(rawValue: indexPath.row)
        cell.selectionStyle = .none
        cell.titleTableViewCellModel = TitleTableViewCellModel(labelText: index?.title.0 ?? "", image: index?.title.1 ?? "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
