//
//  AirportDetailsViewController.swift
//  CityAirportSearch
//
//  Created by ktrade on 2021/1/19.
//

import UIKit
import MapKit
import RxSwift

class AirportDetailsViewController: UIViewController, Storyboarable {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var airportNameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var runwayLabel: UILabel!
    
    private var viewModel: AirportDetailsViewPresentable!
    var viewModelBuilder: AirportDetailsViewPresentable.ViewModelBuilder!
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel = viewModelBuilder(())
        
        setupBinding()
        
        self.mapView.delegate = self
    }
    
}


extension AirportDetailsViewController {
    
    func setupUI(viewModel: AirportViewPresentable) {
        self.airportNameLabel.text = viewModel.name
        self.distanceLabel.text = viewModel.formattedDistance
        self.countryLabel.text = viewModel.address
        self.runwayLabel.text = viewModel.runwayLength
    }
    
    func setupMapUI(viewModel: AirportMapViewPresentable) -> Void {
//        let currentPoint = CLLocationCoordinate2D(latitude: viewModel.currentLocation.lat,
//                                                  longitude: viewModel.currentLocation.lon)
        // 當前地址先寫死
        let currentPoint = CLLocationCoordinate2D(latitude: 25.067417139999993,
                                                  longitude: 121.52365111999995)
        
        let airportPoint = CLLocationCoordinate2D(latitude: viewModel.airportLocation.lat,
                                                  longitude: viewModel.airportLocation.lon)
        
        let currentPin = AirportPin(name: "Current", coordinate: currentPoint)
        let airportPin = AirportPin(name: viewModel.airport.name, city: viewModel.airport.city, coordinate: airportPoint)
        
        mapView.addAnnotations([currentPin, airportPin])
//        25.067417139999993
//        121.52365111999995
        let currentPlacemark = MKPlacemark(coordinate: currentPoint)
        let destinationPlacemark = MKPlacemark(coordinate: airportPoint)
        
        let directionRequest = MKDirections.Request()
        
        directionRequest.source = MKMapItem(placemark: currentPlacemark)
        directionRequest.destination = MKMapItem(placemark: destinationPlacemark)
        
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate { [self] (response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let route = response?.routes.first else { return }
            
            self.mapView.addOverlay(route.polyline, level: .aboveRoads)
            
            UIView.animate(withDuration: 1.5) { [mapView, route] in
                let mapRect = route.polyline.boundingMapRect
                let region = MKCoordinateRegion(mapRect)
                mapView?.setRegion(region, animated: true)
            }
        }
    }
    
    func setupBinding() {
        
        self.viewModel.output.airportDetails
            .map { [weak self]  in
                self?.setupUI(viewModel: $0)
            }
            .drive()
            .disposed(by: bag)
        
        self.viewModel.output.mapDetails
            .map { [weak self] in
                self?.setupMapUI(viewModel: $0)
            }
            .drive()
            .disposed(by: bag)
    }
    
}


extension AirportDetailsViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .reddishPink
        renderer.lineWidth = 2.0
        return renderer
    }
    
}
