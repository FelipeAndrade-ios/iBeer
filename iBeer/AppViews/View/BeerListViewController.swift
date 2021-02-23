//
//  BeerListViewController.swift
//  iBeer
//
//  Created by Felipe Andrade on 22/02/21.
//

import UIKit

class BeerListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let viewModel = BeerListViewModel()
    var data: [BeerModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        getData()
    }
    
    func setup() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(BeerItemTableViewCell.self)
        tableView.tableFooterView = UIView()
    }
    
    func getData() {
        viewModel.requestObervable.didChange = { value in
            self.data = value ?? []
            self.tableView.reloadData()
        }
        viewModel.getListOfBeers()
    }
}

extension BeerListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BeerItemTableViewCell.className,
                                                 for: indexPath) as? BeerItemTableViewCell
        cell?.setup(data[indexPath.row])
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
}
