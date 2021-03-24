//
//  MainViewController.swift
//  LyEditImageView
//
//  Created by Chang-Hong on 2021/3/23.
//  Copyright © 2021 Li,Yan(MMS). All rights reserved.
//

import UIKit

private enum tableViewTitle: Int, CaseIterable {
    case all = 0, creat, outPut, into
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
        }
    }
}

class MainViewController: UIViewController {
    let imagePickerController = UIImagePickerController()
    let tableView = UITableView()
    var type = 0
    var status = false
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerController.delegate = self
        addNavBarImage()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.frame
        tableView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        tableView.isHidden = true
        tableView.register(UINib(nibName: "TitleTableViewCell", bundle: nil), forCellReuseIdentifier: "TitleTableViewCell")
//        tableView.isScrollEnabled = false
        tableView.alwaysBounceVertical = false
        view.addSubview(tableView)
    }
    
    func addNavBarImage() {
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
            UIView.animate(withDuration: 0.3) {
                self.tableView.isHidden = self.status
                self.tableView.reloadData()
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.tableView.isHidden = self.status
                self.tableView.reloadData()
            }
        }
        status.toggle()
    }
    
    @IBAction func button(_ sender: Any) {
        type = 1
        openPhotoLibrary()
    }
    @IBAction func Btn(_ sender: Any) {
        type = 2
        openPhotoLibrary()
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
        cell.alpha = 0

        UIView.animate(
            withDuration: 0.5,
            delay: 0.05 * Double(indexPath.row),
            animations: {
                cell.alpha = 1
        })
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}

extension MainViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // info 用來取得不同類型的圖片，此 Demo 的型態為 originaImage，其它型態有影片、修改過的圖片等等
        if let image = info[.originalImage] as? UIImage {
            let vc = ViewController()
            vc.image = image
            vc.type = type
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        picker.dismiss(animated: true)
    }
    
    /// 開啟圖庫
    func openPhotoLibrary() {
        imagePickerController.sourceType = .photoLibrary
        self.present(imagePickerController, animated: true)
    }
}

extension MainViewController: UINavigationControllerDelegate { }
