//
//  CityCell.swift
//  CityAirportSearch
//
//  Created by ktrade on 2021/1/13.
//

import UIKit

class CityCell: UITableViewCell {
    
    static let identifier = "CityCell"
    
    private let cityLabel: UILabel = {
        let lab = UILabel()
        lab.font = .systemFont(ofSize: 20)
        return lab
    }()
    
    private let stateLabel: UILabel = {
        let lab = UILabel()
        lab.font = .systemFont(ofSize: 15)
        lab.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        return lab
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    func configure(model: CityViewPresentable) {
        self.cityLabel.text = model.city
        self.stateLabel.text = model.location
        self.selectionStyle = .none
    }
    
    private func setupUI() {
        addSubviews(cityLabel,
                    stateLabel)
        
        cityLabel.snp.makeConstraints { make in
            make.top.equalTo(snp.top)
            make.left.equalTo(snp.left).offset(10)
            make.width.equalTo(snp.width)
            make.height.equalTo(snp.height).multipliedBy(0.4)
        }
        
        stateLabel.snp.makeConstraints { make in
            make.top.equalTo(cityLabel.snp.bottom)
            make.left.equalTo(snp.left).offset(10)
            make.width.equalTo(snp.width)
            make.height.equalTo(snp.height).multipliedBy(0.4)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
