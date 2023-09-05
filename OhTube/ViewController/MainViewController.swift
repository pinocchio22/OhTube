//
//  MainViewController.swift
//  OhTube
//
//  Created by t2023-m0056 on 2023/09/04.
//

import UIKit

final class MainViewController: UIViewController {
    
    
    private let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "검색어를 입력해주세요"
        searchController.searchBar.setValue("취소", forKey: "cancelButtonText")
        searchController.searchBar.tintColor = .black
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        return searchController
    }()
    
    var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewSetting()
        naviBarSetting()
        searchBarSetting()
        makeUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
 
    }

    private func naviBarSetting() {
        self.title = "Video Search"
        let appearance = UINavigationBarAppearance()

        //appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .white
        appearance.shadowColor = .none
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func searchBarSetting() {
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.largeTitleDisplayMode = .always
    }
    
    private func collectionViewSetting() {
        collectionView.dataSource = self
        collectionView.delegate = self
        //셀 등록
        collectionView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: MainCollectionViewCell.identifier)
    }
    
    private func makeUI() {
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
}

extension MainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10 //셀 몇개?
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.identifier, for: indexPath) as! MainCollectionViewCell

        
        return cell
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    
    // 셀 간의 양옆 간격을 10포인트로 설정
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 10 // 셀 간의 양옆 간격을 10포인트로 설정
//    }
    
    // 셀 간의 위아래 간격을 10포인트로 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20 // 셀 간의 위아래 간격을 10포인트로 설정
    }
    
    // 셀 크기 수정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width
        let collectionViewHeight = collectionView.bounds.height
        return CGSize(width: collectionViewWidth, height: (collectionViewHeight - 40)/3)
    }
}

extension MainViewController: UICollectionViewDelegate {
    //데이터 주고 싶을 때 (디테일 페이지로 이동할 때)
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 셀 선택에 대한 처리
        
        // 선택한 셀의 데이터 또는 인덱스를 얻을 수 있음.
        //let selectedData = 데이터모델에서 받은배열변수[indexPath.item]
        
        // 새로운 뷰 컨트롤러를 생성하거나 스토리보드에서 식별자로 가져옴.
        //let 디테일페이지컨트롤러변수 = 디테일페이지컨트롤러()
        
        // 새로운 뷰 컨트롤러에 선택한 데이터를 전달. (선택한 데이터에 맞게 구현)
        // 디테일페이지컨트롤러변수.디테일페이지컨트롤러의 데이터 전달받을 변수 = selectedData
        
        // UINavigationController를 사용하여 새로운 뷰 컨트롤러로 이동.
        //self.navigationController?.pushViewController(디테일페이지컨트롤러변수, animated: true)
        
        // 또는 모달 방식으로 표시 가능
        // self.present(디테일페이지컨트롤러변수, animated: true, completion: nil)
    }
}



extension MainViewController: UISearchBarDelegate, UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    //검색창 클릭 시 키보드 올리기
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(true, animated: true)
    }
    // 캔슬 버튼
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    // 캔슬버튼 보이게 하기
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    //검색 결과를 업데이트하는 코드
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        updateSearchResults(for: searchController)
    }
}
