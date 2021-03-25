//
//  MainViewController.swift
//  LyEditImageView
//
//  Created by Chang-Hong on 2021/3/23.
//  Copyright © 2021 Li,Yan(MMS). All rights reserved.
//

import UIKit

private enum tableViewTitle: Int, CaseIterable {
    case all = 0, creat, outPut, into, upload, download, shopOutPut, shopInto, delete, use
    var title: (String, String) {
        switch self {
        case .all:
            return ("全部", "icon_57")
        case .creat:
            return ("創建", "icon_54")
        case .outPut:
            return ("移出", "icon_55")
        case .into:
            return ("移入", "icon_56")
        case .upload:
            return ("上架", "icon_56")
        case .download:
            return ("下架", "icon_56")
        case .shopOutPut:
            return ("市集移出", "icon_56")
        case .shopInto:
            return ("市集移入", "icon_56")
        case .delete:
            return ("已丟棄", "icon_56")
        case .use:
            return("使用", "icon_56")
        }
    }
}

class MainViewController: UIViewController {
    let tableView = UITableView()
    @IBOutlet weak var cropView: UIImageView!
    var type = 0
    var status = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        addNavBarButton()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = CGRect(x: 0, y: -(view.frame.height), width: view.frame.width, height: view.frame.height)
//        tableView.isHidden = true
        tableView.backgroundColor = .clear
        tableView.register(UINib(nibName: "TitleTableViewCell", bundle: nil), forCellReuseIdentifier: "TitleTableViewCell")
//        tableView.isScrollEnabled = false
        //禁止滑動
        tableView.alwaysBounceVertical = false
        view.addSubview(tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //關閉透明
        navigationController?.navigationBar.isTranslucent = false
        extendedLayoutIncludesOpaqueBars = true
    }
    
    func addNavBarButton() {
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: navigationController?.navigationBar.frame.width ?? 0, height: navigationController?.navigationBar.frame.height ?? 0))
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: titleView.frame.height))
        button.center.x = titleView.center.x
        button.setTitle("Button", for: .normal)
        button.backgroundColor = .lightGray
        button.addTarget(self, action: #selector(buttonTap), for: .touchUpInside)
        
        titleView.addSubview(button)
        self.navigationItem.titleView = titleView
    }
    
    @objc func buttonTap() {
        if !status {
            UIView.animate(withDuration: 0.3, animations: {
                self.tableView.frame = self.view.frame
            }, completion: { _ in
                self.tableView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
            })
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.tableView.backgroundColor = .clear
                self.tableView.frame = CGRect(x: 0, y: -(self.view.frame.height), width: self.view.frame.width, height: self.view.frame.height)
            })
        }
        status.toggle()
    }
    
    @IBAction func button(_ sender: Any) {
        let vc = ViewController()
        vc.type = 1
        vc.delegate = self
        vc.imagePickerController.modalPresentationStyle = .fullScreen
        navigationController?.navigationBar.isTranslucent = true
        extendedLayoutIncludesOpaqueBars = false
        navigationController?.pushViewController(vc, animated: false)
    }
    @IBAction func Btn(_ sender: Any) {
        let vc = ViewController()
        vc.type = 2
        vc.delegate = self
        navigationController?.navigationBar.isTranslucent = true
        extendedLayoutIncludesOpaqueBars = false
        navigationController?.pushViewController(vc, animated: false)
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewTitle.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TitleTableViewCell") as! TitleTableViewCell
        let index = tableViewTitle(rawValue: indexPath.row)
        cell.selectionStyle = .none
        cell.tableViewImage.image = #imageLiteral(resourceName: "accept.png")
        cell.label.text = index?.title.0
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}

extension MainViewController: ViewControllerDelegate {
    func getCropImage(image: UIImage) {
        cropView.image = image
    }
}
