//
//  ViewController.swift
//  CityAirportSearch
//
//  Created by ktrade on 2021/1/11.
//

// 課程來源：
// https://www.youtube.com/watch?v=LqCX85XPrJc&list=PLpvpznviFFFIpbUxcDQtDnAbDNP-uIR6R&index=21

import UIKit
import SnapKit
import RxSwift
import RxDataSources

class SearchCityViewController: UIViewController, Storyboarable {
    
    private let roundedView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.1434410512, green: 0.1434628069, blue: 0.1434309781, alpha: 1)
        return view
    }()
    
    private let searchTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Search City"
        tf.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return tf
    }()
    
    private let tableView = UITableView()
    
    private var viewModel: SearchCityViewPresentable!
    var viewModelBuilder: SearchCityViewPresentable.ViewModelBuilder!
    
//    private static let CellId = "CityCellId"
    private let bag = DisposeBag()
    
    private lazy var datasource = RxTableViewSectionedReloadDataSource<CityItemsSection>(configureCell: { _, tableView, indexPath, item in
        
        let cityCell = tableView.dequeueReusableCell(withIdentifier: CityCell.identifier, for: indexPath) as! CityCell
        cityCell.configure(model: item)
        
        return cityCell
    })

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.navigationBar.tintColor = .red

        view.backgroundColor = .white
        
        viewModel = viewModelBuilder((
            searchText: searchTextField.rx.text.orEmpty.asDriver(), (),
            citySelect: tableView.rx.modelSelected(CityViewModel.self).asDriver()
        ))
        
        setupUI()
        setupTitle()
        setupBinding()
    }

    func setupUI() {
        tableView.register(CityCell.self, forCellReuseIdentifier: CityCell.identifier)
        tableView.rowHeight = 100
        
        view.addSubviews(roundedView,
                         tableView)
        
        roundedView.addSubviews(searchTextField)
        
        roundedView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(120)
        }
        
        searchTextField.snp.makeConstraints { make in
            make.centerY.equalTo(roundedView.snp.centerY)
            make.left.right.equalTo(roundedView).inset(20)
            make.height.equalTo(roundedView).multipliedBy(0.5)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(roundedView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    
}

private extension SearchCityViewController {
    
    func setupTitle() -> Void {
        self.title = "Airport"
    }
    
    func setupBinding() -> Void {
        
        self.viewModel.output.cities
            .drive(tableView.rx.items(dataSource: self.datasource))
            .disposed(by: bag)
    }
    
}

extension SearchCityViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension UIView {
    func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
}

