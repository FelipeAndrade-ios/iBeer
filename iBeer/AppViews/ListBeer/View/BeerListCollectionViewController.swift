//
//  BeerListCollectionViewController.swift
//  iBeer
//
//  Created by Felipe Andrade on 23/02/21.
//

import UIKit

class BeerListCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let viewModel: BeerListViewModel
    var isSearching = false
    private let search = UISearchController(searchResultsController: nil)
    private let layout: UICollectionViewFlowLayout
    private var dataFiltered: [BeerModel] = []
    private var data: [BeerModel] = [] {
        didSet {
            dataFiltered = data
        }
    }
    
    init(_ viewModel: BeerListViewModel) {
        self.viewModel = viewModel
        layout = UICollectionViewFlowLayout()
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        layout = UICollectionViewFlowLayout()
        viewModel = BeerListViewModel()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        configureNavigation()
        configureSearchBar()
        getData()
    }
    
    func setupCollectionView() {
        setLayoutConfig()
        collectionView.register(BeerItemCollectionViewCell.self)
        collectionView.setCollectionViewLayout(collectionViewLayout, animated: true)
        collectionView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 0.9019607843, alpha: 1)
        collectionView.accessibilityIdentifier = "beerCollectionView"
        
    }
    
    func configureNavigation() {
        title = "iBeer"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.isTranslucent = true
        definesPresentationContext = true
    }
    
    func configureSearchBar() {
        if MainData.staticToggleForSearch {
            navigationItem.searchController = search
            search.searchBar.barTintColor = .lightGray
            search.obscuresBackgroundDuringPresentation = false
            search.searchResultsUpdater = self
            navigationController?.navigationItem.hidesSearchBarWhenScrolling = true
        }
    }
    
    func setLayoutConfig() {
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 1
        layout.sectionInset = UIEdgeInsets(top: 7, left: 8, bottom: 7, right: 8)
    }
    
    func getData() {
        setObervables()
        viewModel.getListOfBeers()
    }
    
    func setObervables() {
        viewModel.requestObervable.didChange = { value in
            self.data = value ?? []
            self.collectionView.reloadData()
        }
        
        viewModel.searchObservable.didChange = { value in
            self.dataFiltered = value ?? []
            self.collectionView.reloadData()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataFiltered.count
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BeerItemCollectionViewCell.className,
                                                      for: indexPath) as? BeerItemCollectionViewCell
        cell?.setup(dataFiltered[indexPath.row])
        if indexPath.row == dataFiltered.count - 1, !isSearching, MainData.staticToggleForPagination {
            viewModel.getNextBeers()
        }
        cell?.accessibilityIdentifier = "BeerCell\(indexPath.row)"
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: view.frame.width/2.1, height: 200)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.goToBeerDetails(model: dataFiltered[indexPath.row])
    }
}

extension BeerListCollectionViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let textSearched = searchController.searchBar.text ?? ""
        if textSearched.isEmpty {
            dataFiltered = data
            isSearching = false
        } else {
            isSearching = true
            viewModel.searchBeers(name: textSearched)
        }
        collectionView.reloadData()
    }
}
