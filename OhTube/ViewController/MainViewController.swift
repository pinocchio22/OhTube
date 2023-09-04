//
//  MainViewController.swift
//  OhTube
//
//  Created by t2023-m0056 on 2023/09/04.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        naviBarSetting()
        // Do any additional setup after loading the view.
    }

    private func naviBarSetting() {
        let appearance = UINavigationBarAppearance()

        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .blue
        appearance.shadowColor = .none
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.topItem?.title = "Video Search"
//        navigationController?.navigationItem.searchController = searchController
        navigationController?.navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationItem.largeTitleDisplayMode = .always
    }
}
