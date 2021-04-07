//
//  MainViewController.swift
//  LyEditImageView
//
//  Created by Chang-Hong on 2021/3/23.
//  Copyright © 2021 Li,Yan(MMS). All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var cropView: UIImageView!
    private var sideMenuManager: SideMenuManager?
    private let titleTableView = TitleTableView()
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
    
    @IBAction func button(_ sender: Any) {
        let vc = LyEditImageViewController(type: 0)
        vc.delegate = self
        vc.imagePickerController.modalPresentationStyle = .fullScreen
        navigationController?.navigationBar.isTranslucent = true
        extendedLayoutIncludesOpaqueBars = false
        navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func Btn(_ sender: Any) {
        let vc = LyEditImageViewController(type: 1)
        vc.delegate = self
        navigationController?.navigationBar.isTranslucent = true
        extendedLayoutIncludesOpaqueBars = false
        navigationController?.pushViewController(vc, animated: false)
    }
}

extension MainViewController: TitleViewItemDelegate {
    func addNavBarButton() {
        let titleViewItem = TitleViewItem(frame: CGRect(x: 0, y: 0, width: view.frame.width / 4, height: navigationController?.navigationBar.frame.width ?? 0))
        titleViewItem.delegate = self
        self.navigationItem.titleView = titleViewItem
    }
    
    func initTableView() {
        titleTableView.frame = CGRect(x: 0, y: -(view.frame.height), width: view.frame.width, height: view.frame.height)
        view.addSubview(titleTableView)
    }
    
    func buttonTap() {
        if !viewModel.status {
            UIView.animate(withDuration: 0.3, animations: {
                self.titleTableView.frame = self.view.frame
            }, completion: { _ in
                self.titleTableView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
            })
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.titleTableView.backgroundColor = .clear
                self.titleTableView.frame = CGRect(x: 0, y: -(self.view.frame.height), width: self.view.frame.width, height: self.view.frame.height)
            })
        }
        viewModel.status.toggle()
    }
}

//sideMenuManager
extension MainViewController: MenuItemDelegate {
    func setUpMenuButton() {
        sideMenuManager = SideMenuManager(menuView: meunViewController, targetView: view)
        let menuBarButtonItem = MenuBarButtonItem()
        menuBarButtonItem.delegate = self
        self.navigationItem.leftBarButtonItem = menuBarButtonItem
    }
    
    func leftButtonTapped() {
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

extension MainViewController: RightBarButtonItemDelegate {
    func initAlertButton() {
        let rightBarButtonItem = RightBarButtonItem()
        rightBarButtonItem.delegate = self
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    func rightButtonTapped() {
        if !alertView.status {
            self.view.addSubview(alertView)
        } else {
            alertView.removeFromSuperview()
        }
        alertView.status.toggle()
    }
}

