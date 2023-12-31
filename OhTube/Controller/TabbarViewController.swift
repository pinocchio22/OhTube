//
//  ViewController.swift
//  OhTube
//
//  Created by t2023-m0056 on 2023/09/04.
//

import UIKit

class TabbarViewController: UITabBarController {
    enum TabBarMenu: Int {
        case Main = 0
        case MyPage
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTabControllers()
        self.delegate = self
    }
    
    func setTabControllers() {
        let mainVC = MainViewController(nibName: "MainViewController", bundle: nil)
        let naviMainVC = UINavigationController(rootViewController: mainVC)
        let MyPageVC = MyPageViewController(nibName: "MyPageViewController", bundle: nil)
        let naviMyPageVC = UINavigationController(rootViewController: MyPageVC)
       
        // init tabbar controller
        let controllers = [naviMainVC, naviMyPageVC]
        self.viewControllers = controllers
        
        self.tabBar.layer.borderWidth = 1
        self.tabBar.layer.borderColor = #colorLiteral(red: 0.9176470588, green: 0.9176470588, blue: 0.9176470588, alpha: 1)
        
        self.tabBar.tintColor = .red

        // Main
        self.tabBar.items![0].imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        self.tabBar.items![0].image = UIImage(systemName: "video")?.withRenderingMode(.alwaysOriginal).withTintColor(.black)
        self.tabBar.items![0].selectedImage = UIImage(systemName: "video.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.systemRed)
        self.tabBar.items![0].title = "동영상"
        
        // MyPage
        self.tabBar.items![1].imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        self.tabBar.items![1].image = UIImage(systemName: "person.crop.circle")?.withRenderingMode(.alwaysOriginal)
        self.tabBar.items![1].selectedImage = UIImage(systemName: "person.crop.circle.fill")?.withRenderingMode(.alwaysOriginal)
        self.tabBar.items![1].title = "마이페이지"
    }
}

extension TabbarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let fromView = selectedViewController?.view, let toView = viewController.view else {
            return false
        }

        if fromView != toView {
            UIView.transition(from: fromView, to: toView, duration: 0.3, options: [.transitionCrossDissolve], completion: nil)
        }

        return true
    }
}
