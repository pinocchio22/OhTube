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
    } // 페이지 수만큼 case 넣기
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTabControllers()
        self.delegate = self
    }
    
    func setTabControllers() {
        let mainVC = MainViewController()
        let naviMainVC = UINavigationController(rootViewController: mainVC) //네비게이션 컨트롤러 넣기
        let MyPageVC = MyPageViewController(nibName: "MyPageViewController", bundle: nil)
        let naviMyPageVC = UINavigationController(rootViewController: MyPageVC) //네비게이션 컨트롤러 넣기
       
        // init tabbar controller
        let controllers = [naviMainVC, naviMyPageVC]
        self.viewControllers = controllers //네비게이션 컨트롤러를 페이지에 넣기
        
        self.tabBar.layer.borderWidth = 1
        self.tabBar.layer.borderColor = #colorLiteral(red: 0.9176470588, green: 0.9176470588, blue: 0.9176470588, alpha: 1)
        
        self.tabBar.tintColor = .red //탭바 아이템 색

        // Main
        self.tabBar.items![0].imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        self.tabBar.items![0].image = UIImage(systemName: "video")?.withRenderingMode(.alwaysOriginal).withTintColor(.black)
        self.tabBar.items![0].selectedImage = UIImage(systemName: "video.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.systemRed)
        self.tabBar.items![0].title = "동영상"
        
        // MyPage
        self.tabBar.items![1].imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        self.tabBar.items![1].image = UIImage(systemName: "person.crop.circle")?.withRenderingMode(.alwaysOriginal)
        self.tabBar.items![1].selectedImage = UIImage(systemName: "person.crop.circle.fill")?.withRenderingMode(.alwaysOriginal) // 이미지의 색을 정한 색으로 나오게 하기 위해..
        self.tabBar.items![1].title = "마이페이지"
    }
}

extension TabbarViewController: UITabBarControllerDelegate {
    //이 코드를 사용하면 탭 바에서 다른 탭으로 전환할 때 부드러운 애니메이션 효과를 냄. 사용자가 탭을 선택할 때 화면이 깜빡이지 않고 부드럽게 전환
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let fromView = selectedViewController?.view, let toView = viewController.view else {
          
            return false
        }
        if fromView != toView {
            //UIView.transition: 전환 효과를 적용
            UIView.transition(from: fromView, to: toView, duration: 0.3, options: [.transitionCrossDissolve], completion: nil)
        }
        return true
    }
}
