//
//  MainViewController.swift
//  OhTube
//
//  Created by t2023-m0056 on 2023/09/04.

import UIKit

final class MainViewController: UIViewController {
    
    // MARK: - 프로퍼티

    //api를 받을 데이터 배열
    private var youtubeArray: [Video] = []
    //결과값을 저장할 데이터 배열
    private var searchResultArray: [Video] = []
    // 카테고리 배열
    private let category: [String] = ["전체", "예능", "스포츠", "음악", "게임", "영화", "재미"]
    //카테고리를 받을 변수
    private var currentCategory: String = "전체"
    //페이징네이션에 쓰기 위한 변수
    private var current = 0
    //검색창에서 카테고리컬렉션뷰를 없앨 때 사용하기 위한 변수
    var isSearching = false
    
    //검색창 누르면 카테고리 사라지게 하기 위한 제약 설정 변수
    private var categoryCollectionViewHeightConstraint: NSLayoutConstraint!
    private var collectionViewTopConstraint: NSLayoutConstraint!
    
    //서치바
    private let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "검색어를 입력해주세요"
        searchController.searchBar.setValue("취소", forKey: "cancelButtonText")
        searchController.searchBar.tintColor = UIColor.black
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.autocapitalizationType = .none
        return searchController
    }()
    
    //컬렉션뷰
    private var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    // 카테고리 수평(가로)으로 하기 위함
    private let categoryCollectionHorizontal = UICollectionViewFlowLayout()
    
    
    //카테고리 컬렉션뷰
    private lazy var categoryCollectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.showsHorizontalScrollIndicator = false // 스크롤바 삭제
        collection.backgroundColor = .clear
        categoryCollectionHorizontal.scrollDirection = .horizontal
        collection.collectionViewLayout = categoryCollectionHorizontal //수평으로 바꿈
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    //리프레쉬컨트롤: 테이블뷰도는 컬렉션뷰 상단 스와이프 시 새로 고침
    private let refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.tintColor = UIColor.lightGray
        refresh.translatesAutoresizingMaskIntoConstraints = false
        refresh.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return refresh
    }()
    
    @objc private func refreshData() {
        youtubeArray.shuffle() //배열 랜덤
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing() // 스와이프 끝내기
            self.collectionView.reloadData()
        }
    }
    
    // MARK: - viewdidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewSetting()
        naviBarSetting()
        searchBarSetting()
        collectionMakeUI()
        networkingMakeUI(categoryId: YouTubeApiVideoCategoryId.all)
    }
    
    
    // MARK: - viewWillAppear

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        categoryCollectionView.reloadData()
    }
    
    
    // MARK: - 메서드

    
    //네비게이션바 세팅
    private func naviBarSetting() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .clear
        appearance.shadowColor = .none
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.tintColor = .red
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        let logoButton = UIBarButtonItem(image: UIImage(named: "logo")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(homeButtonTapped))
        navigationItem.leftBarButtonItem = logoButton
    }
    
    @objc func homeButtonTapped() {
        youtubeArray.shuffle()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    //서치바 세팅
    private func searchBarSetting() {
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.largeTitleDisplayMode = .always
    }
    
    //컬렉션뷰 세팅
    private func collectionViewSetting() {
        collectionView.dataSource = self
        collectionView.delegate = self
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        collectionView.tag = 1
        categoryCollectionView.tag = 2
        collectionView.refreshControl = refreshControl
    }
    
    //제약 설정
    private func collectionMakeUI() {
        view.addSubview(categoryCollectionView)
        view.addSubview(collectionView)
        
        collectionViewTopConstraint = collectionView.topAnchor.constraint(equalTo: categoryCollectionView.bottomAnchor, constant: 0)
        categoryCollectionViewHeightConstraint = categoryCollectionView.heightAnchor.constraint(equalToConstant: 40.0)
        
        NSLayoutConstraint.activate([
            categoryCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            categoryCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            categoryCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            categoryCollectionViewHeightConstraint,
            
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            collectionViewTopConstraint,
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
    }

    // MARK: - NetworkManager.shared.fetchVideo(category: String, maxResult: Int, completion: ([video])-> void)

    //api 네트워크 통신
    private func networkingMakeUI(categoryId: String) {
        let next = current + 3
        NetworkManager.shared.fetchVideo(category: categoryId, maxResult: next) { result in
            switch result {
            case .success(let tubedata):
                self.youtubeArray.removeAll()
                self.youtubeArray += tubedata
                self.current = next
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                    self.collectionView.reloadData()
                }
            case .failure: break
            }
        }
    }

    // 서치바 비어있으면 true
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    // 서치바 활성화 되어있으면 true
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    


}



extension MainViewController: UICollectionViewDataSource {
    
    //셀 몇개?
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1 {
            return isFiltering() ? searchResultArray.count : youtubeArray.count
        } else {
            return category.count
        }
    }
    
    //셀 어떤 식으로 보여줘? -> 컬렉션뷰가 2개면 여기서 셀을 등록해야 한다⭐️⭐️⭐️⭐️⭐️
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 2 { // 2: 카테고리 컬렉션
            categoryCollectionView.register(MainViewCategoryCollectionViewCell.self, forCellWithReuseIdentifier: "MainViewCategoryCollectionViewCell")
            
            let categoryCell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: Cell.mainViewCategoryIdentifier, for: indexPath) as! MainViewCategoryCollectionViewCell
            
            categoryCell.categoryLabel.text = category[indexPath.row]
            return categoryCell
            
        } else if collectionView.tag == 1 { // 1: 유튜브 컬렉션
            collectionView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: Cell.mainViewIdentifier)
            
            let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: Cell.mainViewIdentifier, for: indexPath) as! MainCollectionViewCell
            
            if isFiltering() { // 검색 시
                let url = URL(string: searchResultArray[indexPath.row].thumbNail)
                cell.videoThumbnailImage.load(url: url!)
                cell.channelImage.load(url: url!)
                cell.videoTitleLabel.text = searchResultArray[indexPath.row].title
                cell.channelNameLabel.text = searchResultArray[indexPath.row].channelName
                cell.videoViewCountLabel.text = "\(searchResultArray[indexPath.row].formatViewCount) 조회"
                cell.videoDateLabel.text = searchResultArray[indexPath.row].uploadDateString
                return cell
            } else if !isFiltering() { //검색 시가 아니면
                let url = URL(string: youtubeArray[indexPath.row].thumbNail)
                cell.videoThumbnailImage.load(url: url!)
                cell.channelImage.load(url: url!)
                cell.videoTitleLabel.text = youtubeArray[indexPath.row].title
                cell.channelNameLabel.text = youtubeArray[indexPath.row].channelName
                cell.videoViewCountLabel.text = "\(youtubeArray[indexPath.row].formatViewCount) 조회"
                cell.videoDateLabel.text = youtubeArray[indexPath.row].uploadDateString
                return cell
            }
        }
        return UICollectionViewCell()
    }
}

// 셀 크기 조정
extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 1 {
            if isFiltering() {
                let collectionViewWidth = collectionView.bounds.width
                let collectionViewHeight = collectionView.bounds.height
                return CGSize(width: collectionViewWidth, height: collectionViewHeight/2)
            } else {
                let collectionViewWidth = collectionView.bounds.width
                let collectionViewHeight = collectionView.bounds.height
                return CGSize(width: collectionViewWidth, height: (collectionViewHeight + 40)/2)
            }
        } else if collectionView.tag == 2 {
            let category = category[indexPath.item]
            let label = UILabel()
            label.text = category
            label.sizeToFit()// 라벨안에 있는 텍스트 크기에 맞춰 셀크기 조정⭐️⭐️⭐️⭐️⭐️
            let labelSize = label.frame.size
            return CGSize(width: labelSize.width + 20, height: labelSize.height + 10)
        }
        return CGSize(width: 0, height: 0)
    }
}

extension MainViewController: UICollectionViewDelegate {
    
    //셀을 클릭하면
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 1 {
            if isFiltering() { //검색 시
                let selectedData = searchResultArray[indexPath.item]
                let detailViewController = DetailViewController()
                detailViewController.selectedVideo = selectedData
                detailViewController.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(detailViewController, animated: true)
            } else { // 검색이 아닐 시
                let selectedData = youtubeArray[indexPath.item]
                let detailViewController = DetailViewController()
                detailViewController.selectedVideo = selectedData
                detailViewController.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(detailViewController, animated: true)
            }
        } else if collectionView.tag == 2 { //카테고리
            if isFiltering() { //검색시
                switch currentCategory {
                case "전체":
                    networkingMakeUI(categoryId: YouTubeApiVideoCategoryId.all)
                case "예능":
                    networkingMakeUI(categoryId: YouTubeApiVideoCategoryId.entertainment)
                case "스포츠":
                    networkingMakeUI(categoryId: YouTubeApiVideoCategoryId.sport)
                case "음악":
                    networkingMakeUI(categoryId: YouTubeApiVideoCategoryId.music)
                case "게임":
                    networkingMakeUI(categoryId: YouTubeApiVideoCategoryId.gaming)
                case "영화":
                    networkingMakeUI(categoryId: YouTubeApiVideoCategoryId.filmAndAnimation)
                case "재미":
                    networkingMakeUI(categoryId: YouTubeApiVideoCategoryId.comedy)
                default:
                    break
                }
            } else {
                current = 0
                currentCategory = category[indexPath.item]
                let indexPath = IndexPath(item: 0, section: 0) // indexPath을 0섹션에 0번째 셀로 만들어 클릭 시 맨 위로 이동
                self.collectionView.scrollToItem(at: indexPath, at: .top, animated: true)
                switch currentCategory {
                case "전체":
                    networkingMakeUI(categoryId: YouTubeApiVideoCategoryId.all)
                case "예능":
                    networkingMakeUI(categoryId: YouTubeApiVideoCategoryId.entertainment)
                case "스포츠":
                    networkingMakeUI(categoryId: YouTubeApiVideoCategoryId.sport)
                case "음악":
                    networkingMakeUI(categoryId: YouTubeApiVideoCategoryId.music)
                case "게임":
                    networkingMakeUI(categoryId: YouTubeApiVideoCategoryId.gaming)
                case "영화":
                    networkingMakeUI(categoryId: YouTubeApiVideoCategoryId.filmAndAnimation)
                case "재미":
                    networkingMakeUI(categoryId: YouTubeApiVideoCategoryId.comedy)
                default:
                    break
                }
            }
        }
    }
    //willDisplay: 페이징네이션을 위함
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == youtubeArray.count - 1 && current < 50 {
            switch currentCategory {
            case "전체":
                networkingMakeUI(categoryId: YouTubeApiVideoCategoryId.all)
            case "예능":
                networkingMakeUI(categoryId: YouTubeApiVideoCategoryId.entertainment)
            case "스포츠":
                networkingMakeUI(categoryId: YouTubeApiVideoCategoryId.sport)
            case "음악":
                networkingMakeUI(categoryId: YouTubeApiVideoCategoryId.music)
            case "게임":
                networkingMakeUI(categoryId: YouTubeApiVideoCategoryId.gaming)
            case "영화":
                networkingMakeUI(categoryId: YouTubeApiVideoCategoryId.filmAndAnimation)
            case "재미":
                networkingMakeUI(categoryId: YouTubeApiVideoCategoryId.comedy)
            default:
                break
            }
        }
    }
}

extension MainViewController: UISearchBarDelegate, UISearchResultsUpdating {
    
    //검색 구현 함수
    func updateSearchResults(for searchController: UISearchController) {
       
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        isSearching = searchController.isActive && !searchBarIsEmpty() // false이면 카테고리보임
        categoryCollectionViewHeightConstraint.constant = isSearching ? 0 : 40
        searchResultArray = youtubeArray.filter { $0.title.lowercased().contains(searchText) }
        
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
            self.collectionView.reloadData()
        }
    }
    
    // 검색버튼을 클릭했을 때
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(true, animated: true) // 캔슬버튼 나옴
        categoryCollectionViewHeightConstraint.constant = 0
        categoryCollectionView.isHidden = true //컬렉션뷰 숨김
        collectionViewTopConstraint.constant = 0
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
            self.collectionView.reloadData()
        }
    }
    //서치바텍스트에 입력하면
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    // 서치바 캔슬 버튼 클릭 시
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        isSearching = false //false 이면 카테고리컬렉션뷰 보임
        categoryCollectionView.isHidden = false //컬렉션뷰 보임
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
            self.collectionView.reloadData()
        }
    }
    // 검색 결과를 업데이트하는 코드
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        updateSearchResults(for: searchController)
    }
}
