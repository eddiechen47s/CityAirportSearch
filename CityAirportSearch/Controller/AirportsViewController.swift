//
//  AirportsViewController.swift
//  CityAirportSearch
//
//  Created by ktrade on 2021/1/14.
//

import UIKit
import RxSwift
import RxDataSources

class AirportsViewController: UIViewController, Storyboarable {
    
    private let tableView = UITableView()
    
    private var viewModel: AirportsViewPresentable!
    var viewModelBuilder:  AirportsViewPresentable.ViewModelBuilder!
    private let bag = DisposeBag()
    
    private lazy var datasource = RxTableViewSectionedReloadDataSource<AirportItemsSection>(configureCell: { _, tableView, indexPath, item in
        
        let cell = tableView.dequeueReusableCell(withIdentifier: AirportsCell.identifier, for: indexPath) as! AirportsCell
        cell.configure(usingModel: item)
        
        return cell
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel = viewModelBuilder((
            selectAirport: self.tableView.rx
                .modelSelected(AirportViewPresentable.self)
                .asDriver(onErrorDriveWith: .empty()), ()
        ))
        
        setupUI()
        
        setupBinding()
    }
    
    private func setupUI() {
        tableView.register(AirportsCell.self, forCellReuseIdentifier: AirportsCell.identifier)
        tableView.rowHeight = 180
        
        view.addSubviews(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
}

private extension AirportsViewController {
    
    func setupBinding() {
        
        self.viewModel.output.airports
            .drive(tableView.rx.items(dataSource: self.datasource))
            .disposed(by: bag)
        
        self.viewModel.output.title
            .drive(self.rx.title)
            .disposed(by: bag)
    }

    
}
