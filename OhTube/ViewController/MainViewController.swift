//
//  MainViewController.swift
//  OhTube
//
//  Created by t2023-m0056 on 2023/09/04.
//
// 해야 할 일
// 1. 데이터를 컬렉션뷰에서 보여주기
// 2. 데이터 전달하기
// 3. 검색 구현
// 4. 페이지 네이션 구현
// 5. 카테고리 구현


import UIKit

final class MainViewController: UIViewController {
    
    
    var youtubeArray: [Video] = []
    
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
        NetworkManager.shared.fetchVideo { result in
            switch result {
            case .success(let tubedata):
                
                print("데이터 잘 받음")
                
                // 데이터(배열)을 받아오고 난 후
                self.youtubeArray = tubedata
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                // 테이블뷰 리로드
                
            case .failure(let error):
                print("데이터 받아오기 에러 ")
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    private func naviBarSetting() {
        self.title = "Video Search"
        let appearance = UINavigationBarAppearance()
        
        appearance.backgroundColor = .clear
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
        collectionView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: Cell.mainViewIdentifier)
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
        return youtubeArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.mainViewIdentifier, for: indexPath) as! MainCollectionViewCell
        
        let url = URL(string: youtubeArray[indexPath.row].thumbNail)
        cell.videoThumbnailImage.load(url: url!)
        cell.channelImage.load(url: url!)
        cell.videoTitleLabel.text = youtubeArray[indexPath.row].title
        cell.channelNameLabel.text = youtubeArray[indexPath.row].channelId
        cell.videoViewCountLabel.text = "\(youtubeArray[indexPath.row].formatViewCount) 조회"
        cell.videoDateLabel.text = youtubeArray[indexPath.row].uploadDateString
        return cell
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    
    // 셀 간의 위아래 간격을 10포인트로 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    // 셀 크기 수정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width
        let collectionViewHeight = collectionView.bounds.height
        return CGSize(width: collectionViewWidth, height: (collectionViewHeight - 40)/3)
    }
}

extension MainViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
            
        
        let selectedData = youtubeArray[indexPath.item]
        
        let detailViewController = DetailViewController()
        
        detailViewController.selectedVideo = selectedData
        self.navigationController?.pushViewController(detailViewController, animated: true)
        
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


extension UIImageView { 
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
