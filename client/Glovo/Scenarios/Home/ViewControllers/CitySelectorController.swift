//
//  CitySelectorController.swift
//  Glovo
//
//  Created by Arnaldo on 11/20/18.
//  Copyright © 2018 Arnaldo. All rights reserved.
//

import UIKit
import PKHUD

protocol CitySelectorControllerDelegate: class {
    func didSelectCity(_ city: City)
}

class CitySelectorController: UIViewController {
    var cities: [City]?
    private var service: SearchCountryServiceProtocol?
    private var tableView = UITableView()
    private var countryDictionary = [String: [City]]()
    private var countrySectionTitles = [String]()
    weak var delegate: CitySelectorControllerDelegate?
    private let header = UIView()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Please select your city"
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        return label
    }()
    private lazy var closeBtn: UIButton = {
        let button = UIButton()
        button.setTitle("X", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(closeSelector), for: .touchUpInside)
        return button
    }()
    
    init(service: SearchCountryServiceProtocol) {
        self.service = service
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func closeSelector() {
        dismiss(animated: true)
    }
    
    private func setupViews() {
        edgesForExtendedLayout = []
        tableView.tableFooterView = UIView()
        view.backgroundColor = .white
        header.backgroundColor = .mainYellow
        header.addSubviewsForAutolayout(titleLabel, closeBtn)
        view.addSubviewsForAutolayout(header, tableView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        let views = ["header": header,
                     "tableView": tableView]
        view.addConstraints(
            NSLayoutConstraint.constraints("H:|[header]|", views: views),
            NSLayoutConstraint.constraints("H:|[tableView]|", views: views),
            NSLayoutConstraint.constraints("V:[header(50)][tableView]|", views: views))
        
        header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: header.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: header.centerYAnchor).isActive = true
        closeBtn.trailingAnchor.constraint(equalTo: header.trailingAnchor, constant: -10).isActive = true
        closeBtn.centerYAnchor.constraint(equalTo: header.centerYAnchor).isActive = true
    }
    
    override func viewDidLoad() {
        setupViews()
        loadCountries()
    }
    
    private func loadCountries() {
        HUD.show(.progress)
        service?.fetch(completion: { [unowned self] (countries, cerror) in
            self.sortCities(by: countries)
            HUD.hide()
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.reloadData()
        })
    }
    
    private func sortCities(by countries: [Country]?) {
        countries?.forEach { country in
            cities?.forEach { city in
                if city.countryCode == country.code {
                    if var countryValues = countryDictionary[country.name] {
                        countryValues.append(city)
                        countryDictionary[country.name] = countryValues
                    } else {
                        countryDictionary[country.name] = [city]
                    }
                }
            }
        }
        countrySectionTitles = [String](countryDictionary.keys)
        countrySectionTitles = countrySectionTitles.sorted(by: { $0 < $1 })
    }
}

extension CitySelectorController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return countrySectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        }
        let countryKey = countrySectionTitles[indexPath.section]
        if let countryValues = countryDictionary[countryKey] {
            let country = countryValues[indexPath.row]
            cell?.textLabel?.text = country.name
        }
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return countrySectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let countryKey = countrySectionTitles[section]
        if let countryValues = countryDictionary[countryKey] {
            return countryValues.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let countryKey = countrySectionTitles[indexPath.section]
        if let countryValues = countryDictionary[countryKey] {
            let city = countryValues[indexPath.row]
            delegate?.didSelectCity(city)
        }
    }
}
