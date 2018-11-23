//
//  HomeViewController.swift
//  Glovo
//
//  Created by Arnaldo on 11/20/18.
//  Copyright © 2018 Arnaldo. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import PKHUD
import ReactiveKit

class HomeViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var informationView: CityDetaiView!
    private var mapView: GMSMapView?
    private var cityMarker: GMSMarker?
    private var locationManager: CLLocationManager?
    private var currentLocation: CLLocationCoordinate2D?
    var service: SearchCityServiceProtocol?
    private var cities = [City]()
    private var workingAreas = [String: [GMSPath]]()
    fileprivate var bounds = GMSCoordinateBounds()
    var selectedCode: Property<String> = Property("")
    
    private var currentCityCode: String? {
        didSet {
            guard let code = currentCityCode else { return }
            loadCity(code: code)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupObservers()
        setupLocationManager()
        setupViews()
        loadCities()
    }
    
    private func setupObservers() {
        _ = selectedCode.observeNext { (value) in
            print(value)
        }
    }
    
    private func loadCity(code: String) {
        selectedCode.value = code
        HUD.show(.progress)
        service?.fetch(name: code, completion: { [unowned self] (response, error) in
            HUD.hide()
            guard let city = response, let mapView = self.mapView else { return }
            self.informationView.configure(with: CityDataModel(city: city))
            self.bounds = MapUtils.drawPolygon(mapView, areas: city.workingArea) ?? GMSCoordinateBounds()
            mapView.animate(with: GMSCameraUpdate.fit(self.bounds, with: UIEdgeInsets(top: 50.0, left: 50.0, bottom: 50.0, right: 50.0)))
            guard let location = self.currentLocation else { return }
            self.cityMarker = MapUtils.marker(mapView, location: location)
        })
    }
    
    private func loadCities() {
        HUD.show(.progress)
        service?.fetch(completion: { [unowned self] (response, error) in
            HUD.hide()
            guard let response = response else { return }
            self.cities = response
            self.workingAreas = response.reduce([:], { (result, city) -> [String: [GMSPath]] in
                var result = result
                result[city.code] = city.workingArea.compactMap { GMSPath(fromEncodedPath: $0) }
                return result
            })
            self.updateLocationIfPossible()
        })
    }
    
    private func updateLocationIfPossible() {
        if CLLocationManager.locationServicesEnabled(), CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            self.locationManager?.startUpdatingLocation()
        } else {
            self.showCitySelector(cities: self.cities)
        }
    }
    
    private func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
    }
    
    private func setupViews() {
        edgesForExtendedLayout = []
        title = "Glovo"
        informationView.roundCorners(corners: [.topLeft, .topRight], radius: 20)
        mapView = GMSMapView()
        mapView?.delegate = self
        guard let map = mapView else { return }
        map.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(map, belowSubview: informationView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        guard let mapView = mapView else { return }
        let views: [String : Any] = ["mapView": mapView]
        view.addConstraints(NSLayoutConstraint.constraints("H:|[mapView]|", views: views))
        mapView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.75).isActive = true
    }
    
    private func showCitySelector(cities: [City]) {
        let citySelector = DependencyManager.resolve(interface: CitySelectorController.self)!
        citySelector.cities = cities
        citySelector.delegate = self
        present(citySelector, animated: true)
    }
    
    private func setupCurrentCityIfPossible(from location: CLLocationCoordinate2D) {
        workingAreas.keys.forEach {
            if let values = workingAreas[$0] {
                for value in values {
                    if GMSGeometryContainsLocation(location, value, false) {
                        currentCityCode = $0
                        return
                    }
                }
            }
        }
    }
}

extension HomeViewController: CLLocationManagerDelegate {
    private func updateLocation() {
        guard let userLocation: CLLocationCoordinate2D = locationManager?.location?.coordinate
            else {
                showCitySelector(cities: cities)
                return
        }
        setupCurrentCityIfPossible(from: userLocation)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager?.stopUpdatingLocation()
        updateLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

extension HomeViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        cityMarker?.opacity =  mapView.camera.zoom < 10 ? 1 : 0
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        mapView.animate(with: GMSCameraUpdate.fit(bounds, with: UIEdgeInsets(top: 50.0, left: 50.0, bottom: 50.0, right: 50.0)))
        return true
    }
}

extension HomeViewController: CitySelectorControllerDelegate {
    func didSelectCity(_ city: City) {
        dismiss(animated: true)
        bounds = GMSCoordinateBounds()
        LocationUtils.getCityCoordinates(name: city.name) { [unowned self] (location) in
            self.currentLocation = location
            self.currentCityCode = city.code
        }
    }
}
