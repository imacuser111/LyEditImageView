//
//  MainViewController.swift
//  LyEditImageView
//
//  Created by Chang-Hong on 2021/3/23.
//  Copyright © 2021 Li,Yan(MMS). All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    let tableView = UITableView()
    @IBOutlet weak var cropView: UIImageView!
    private var sideMenuManager: SideMenuManager?
    private let meunViewController = MenuView.initFromNib()
    private let alertView = AlertView.initFromNib()
    lazy var viewModel: MainViewModel = {
        return MainViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        addNavBarButton()
        initTableView()
        setUpMenuButton()
        initAlertButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //關閉透明
        navigationController?.navigationBar.isTranslucent = false
        //layout包含不透明的bar
        extendedLayoutIncludesOpaqueBars = true
    }
    
    func initVM() {
        
    }
    
    func addNavBarButton() {
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: (navigationController?.navigationBar.frame.width ?? 0) / 2, height: navigationController?.navigationBar.frame.height ?? 0))
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: titleView.frame.width, height: titleView.frame.height))
        button.center.x = titleView.center.x
        button.setTitle("Button", for: .normal)
        button.backgroundColor = .lightGray
        button.addTarget(self, action: #selector(buttonTap), for: .touchUpInside)
        
        titleView.addSubview(button)
        self.navigationItem.titleView = titleView
    }
    
    @objc func buttonTap() {
        if !viewModel.status {
            UIView.animate(withDuration: 0.3, animations: {
                self.tableView.frame = self.view.frame
            }, completion: { _ in
                self.tableView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
            })
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.tableView.backgroundColor = .clear
                self.tableView.frame = CGRect(x: 0, y: -(self.view.frame.height), width: self.view.frame.width, height: self.view.frame.height)
            })
        }
        viewModel.status.toggle()
    }
    
    @IBAction func button(_ sender: Any) {
        let vc = LyEditImageViewController()
        vc.type = 1
        vc.delegate = self
        vc.imagePickerController.modalPresentationStyle = .fullScreen
        navigationController?.navigationBar.isTranslucent = true
        extendedLayoutIncludesOpaqueBars = false
        navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func Btn(_ sender: Any) {
        let vc = LyEditImageViewController()
        vc.type = 2
        vc.delegate = self
        navigationController?.navigationBar.isTranslucent = true
        extendedLayoutIncludesOpaqueBars = false
        navigationController?.pushViewController(vc, animated: false)
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func initTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = CGRect(x: 0, y: -(view.frame.height), width: view.frame.width, height: view.frame.height)
//        tableView.isHidden = true
        tableView.backgroundColor = .clear
        tableView.register(TitleTableViewCell.loadFromNib(), forCellReuseIdentifier: "TitleTableViewCell")
//        tableView.isScrollEnabled = false
        //禁止滑動
        tableView.alwaysBounceVertical = false
        view.addSubview(tableView)
    }
    
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

//sideMenuManager
extension MainViewController {
    func setUpMenuButton() {
        sideMenuManager = SideMenuManager(menuView: meunViewController, targetView: view)
        let menuBtn = UIButton(type: .custom)
        menuBtn.frame = CGRect(x: 0.0, y: 0.0, width: 30, height: 30)
        menuBtn.setImage(UIImage(named:"rotate"), for: .normal)
        menuBtn.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)

        let menuBarItem = UIBarButtonItem(customView: menuBtn)
        let currWidth = menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 30)
        currWidth?.isActive = true
        let currHeight = menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 30)
        currHeight?.isActive = true
        self.navigationItem.leftBarButtonItem = menuBarItem
    }
    
    
    func initSideMenu() {
        let menuButton = UIBarButtonItem(image: UIImage(named: "rotate")?.withRenderingMode(.alwaysOriginal),
                                         style: .done,
                                         target: self,
                                         action: #selector(leftButtonTapped(_:)))
//        menuButton.tintColor = .white
        navigationItem.leftBarButtonItem = menuButton
        sideMenuManager = SideMenuManager(menuView: meunViewController, targetView: view)
    }
    
    @objc private func leftButtonTapped(_ button: UIBarButtonItem) {
        if viewModel.status {
            viewModel.status = !viewModel.status
        } else {
            sideMenuManager?.showSettings()
        }
    }
    
}

extension MainViewController: ViewControllerDelegate {
    func getCropImage(image: UIImage) {
        cropView.image = image
    }
}

extension MainViewController {
    func initAlertButton() {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.backgroundColor = .red
        button.addTarget(self, action: #selector(showAlert), for: .touchUpInside)
        
        let menuBarItem = UIBarButtonItem(customView: button)
        let currWidth = menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 30)
        currWidth?.isActive = true
        let currHeight = menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 30)
        currHeight?.isActive = true
        
        navigationItem.rightBarButtonItem = menuBarItem
    }
    
    @objc func showAlert() {
        if !alertView.status {
            self.view.addSubview(alertView)
        } else {
            alertView.removeFromSuperview()
        }
        alertView.status.toggle()
    }
}

