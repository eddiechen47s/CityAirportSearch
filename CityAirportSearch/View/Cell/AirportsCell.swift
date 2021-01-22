//
//  AirportsCell.swift
//  CityAirportSearch
//
//  Created by Keita on 2021/1/17.
//

import UIKit

class AirportsCell: UITableViewCell {
    
    static let identifier = "AirportsCell"
    
    private let airportsNameLabel: UILabel = {
        let lab = UILabel()
        lab.text = "Airport Name"
        lab.font = .boldSystemFont(ofSize: 30)
        lab.textColor = .systemRed
        lab.textAlignment = .center
        
        return lab
    }()
    
    private let distanceLabel: UILabel = {
        let lab = UILabel()
        lab.text = "Distance"
        lab.textAlignment = .center
        return lab
    }()
    
    private let countryLabel: UILabel = {
        let lab = UILabel()
        lab.text = "Country"
        lab.textAlignment = .center
        lab.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        return lab
    }()
    
    let runwayLengthLabel: UILabel = {
        let lab = UILabel()
        lab.text = "Runway Length"
        lab.textAlignment = .center
        lab.textColor = .systemFill
        return lab
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    func configure(usingModel viewModel: AirportViewPresentable) {
        airportsNameLabel.text = viewModel.name
        distanceLabel.text = viewModel.formattedDistance
        countryLabel.text = viewModel.address
        runwayLengthLabel.text = viewModel.runwayLength
        self.selectionStyle = .none
    }

    
    private func setupUI() {
        addSubviews(airportsNameLabel,
                    distanceLabel,
                    countryLabel,
                    runwayLengthLabel)
        
        airportsNameLabel.snp.makeConstraints { make in
            make.top.equalTo(snp.top).offset(5)
            make.centerX.equalTo(snp.centerX)
            make.width.equalTo(snp.width)
            make.height.equalTo(snp.height).multipliedBy(0.3)
        }
        
        distanceLabel.snp.makeConstraints { make in
            make.top.equalTo(airportsNameLabel.snp.bottom).offset(5)
            make.centerX.equalTo(snp.centerX)
            make.width.equalTo(snp.width)
            make.height.equalTo(snp.height).multipliedBy(0.2)
        }
        
        countryLabel.snp.makeConstraints { make in
            make.top.equalTo(distanceLabel.snp.bottom).offset(5)
            make.centerX.equalTo(snp.centerX)
            make.width.equalTo(snp.width)
            make.height.equalTo(snp.height).multipliedBy(0.2)
        }
        
        runwayLengthLabel.snp.makeConstraints { make in
            make.top.equalTo(countryLabel.snp.bottom).offset(5)
            make.centerX.equalTo(snp.centerX)
            make.width.equalTo(snp.width)
            make.height.equalTo(snp.height).multipliedBy(0.2)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
