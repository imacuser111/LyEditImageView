//
//  MenuView.swift
//  LyEditImageView
//
//  Created by Chang-Hong on 2021/3/26.
//  Copyright © 2021 Li,Yan(MMS). All rights reserved.
//

import UIKit

class MenuView: UIView {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func layoutSubviews() {
        initTableView()
    }
}

extension MenuView: UITableViewDelegate, UITableViewDataSource {
    func initTableView() {
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.isHidden = true
        tableView.backgroundColor = .clear
        tableView.register(TitleTableViewCell.loadFromNib(), forCellReuseIdentifier: "TitleTableViewCell")
//        tableView.isScrollEnabled = false
        //禁止滑動
//        tableView.alwaysBounceVertical = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewTitle.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TitleTableViewCell") as! TitleTableViewCell
        let index = tableViewTitle(rawValue: indexPath.row)
        cell.titleTableViewCellModel = TitleTableViewCellModel(labelText: index?.title.0 ?? "", image: index?.title.1 ?? "")
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}
