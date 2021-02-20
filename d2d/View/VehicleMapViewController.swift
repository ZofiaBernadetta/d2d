//
//  ViewController.swift
//  d2d
//
//  Created by Zofia Drabek on 13/02/2021.
//

import UIKit
import Starscream
import MapKit

class VehicleMapViewController: UIViewController {
    @IBOutlet private var mapView: MKMapView!
    @IBOutlet private var infoView: UIView!
    @IBOutlet private var statusLabel: UILabel!
    @IBOutlet private var fromLabel: UILabel!
    @IBOutlet private var toLabel: UILabel!

    let waypointAnnotationIdentifier = "Pin"
    let vehicleAnnotationIdentifier = "Vehicle"

    private var vehicleAnnotation: MKPointAnnotation?
    private var intermediateStopAnnotations: [MKPointAnnotation]?
    private var pickupAnnotation: MKPointAnnotation?
    private var dropOffAnnotation: MKPointAnnotation?

    private var keyAnnotations: [MKAnnotation] {
        ([vehicleAnnotation, dropOffAnnotation] + (intermediateStopAnnotations ?? [])).compactMap { $0 }
    }

    private var allAnnotations: [MKAnnotation] {
        mapView.annotations
    }

    var viewModel: VehicleMapViewModelProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        viewModel.viewStateUpdated = { [weak self] eventType in
            self?.updateView(eventType: eventType)
        }
        viewModel.errorOccurred = { [weak self] error in
            self?.presentErrorAlert(message: error.localizedDescription)
        }

        mapView.directionalLayoutMargins = .init(top: 0, leading: 0, bottom: 130, trailing: 0)
    }

    private func presentErrorAlert(message: String) {
        let controller = UIAlertController(
            title: "Error occurred",
            message: message,
            preferredStyle: .alert)
        let dismissAction = UIAlertAction(
            title: "Okay",
            style: .default,
            handler: { [weak self] _ in self?.dismiss(animated: true, completion: nil) })
        controller.addAction(dismissAction)
        present(
            controller,
            animated: true,
            completion: nil)
    }
}

extension VehicleMapViewController {
    private func updateView(eventType: Event) {
        switch eventType {
        case .bookingOpened:
            guard let viewState = viewModel.viewState else { return }
            setupView(viewState)
        case .vehicleLocationUpdated:
            guard let viewState = viewModel.viewState else { return }
            updateVehicleLocationOnTheMap(viewState)
        case .intermediateStopLocationsChanged:
            guard let viewState = viewModel.viewState else { return }
            changeIntermediateStopLocations(viewState)
        case .statusUpdated:
            guard let viewState = viewModel.viewState else { return }
            updateVehicleStatus(viewState)
        case .bookingClosed:
            closeBooking()
        }
    }

    private func setupView(_ state: ViewState) {
        updateAnnotationLocation(to: state.vehicleLocation, annotationKeyPath: \.vehicleAnnotation)
        updateAnnotationLocation(to: state.pickupLocation, annotationKeyPath: \.pickupAnnotation)
        updateAnnotationLocation(to: state.dropoffLocation, annotationKeyPath: \.dropOffAnnotation)

        updateIntermediateStopAnnotations(to: state.intermediateStopLocations)
        updateMapRegion(for: state.vehicleStatus)

        fromLabel.text = "FROM: " + (state.pickupLocation.address ?? "")
        toLabel.text = "TO: " + (state.dropoffLocation.address ?? "")
        updateVehicleStatus(state)
    }

    private func updateVehicleLocationOnTheMap(_ state: ViewState) {
        guard let vehicleAnnotation = vehicleAnnotation else { return }
        vehicleAnnotation.coordinate = state.vehicleLocation.locationCoordinate2D
    }

    private func changeIntermediateStopLocations(_ state: ViewState) {
        updateIntermediateStopAnnotations(to: state.intermediateStopLocations)
        updateMapRegion(for: state.vehicleStatus)
    }

    private func updateVehicleStatus(_ state: ViewState) {
        statusLabel.text = state.vehicleStatus.description
        updateMapRegion(for: state.vehicleStatus)
    }

    private func closeBooking() {
        mapView.removeAnnotations(mapView.annotations)
    }
}

extension VehicleMapViewController {
    private func updateMapRegion(for status: VehicleStatus) {
        if status == .waitingForPickup {
            mapView.showAnnotations(allAnnotations, animated: true)
        } else {
            mapView.showAnnotations(keyAnnotations, animated: true)
        }
    }

    private func updateIntermediateStopAnnotations(to locations: [Location]) {
        if let intermediateStopAnnotations = intermediateStopAnnotations {
            mapView.removeAnnotations(intermediateStopAnnotations)
        }

        intermediateStopAnnotations = []
        for location in locations {
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.locationCoordinate2D
            mapView.addAnnotation(annotation)
            intermediateStopAnnotations?.append(annotation)
        }
    }

    private func updateAnnotationLocation(
        to location: Location,
        annotationKeyPath: ReferenceWritableKeyPath<VehicleMapViewController, MKPointAnnotation?>
    ) {
        if self[keyPath: annotationKeyPath] == nil {
            let annotation = MKPointAnnotation()
            mapView.addAnnotation(annotation)
            self[keyPath: annotationKeyPath] = annotation
        }
        self[keyPath: annotationKeyPath]?.coordinate = location.locationCoordinate2D
    }
}

extension VehicleMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }

        if annotation === vehicleAnnotation {
            return vehicleAnnotationView(for: annotation, in: mapView)
        } else if annotation === pickupAnnotation {
            return pinAnnotationView(for: annotation, in: mapView, color: .green)
        } else if annotation === dropOffAnnotation {
            return pinAnnotationView(for: annotation, in: mapView, color: .red)
        } else {
            return pinAnnotationView(for: annotation, in: mapView, color: .blue)
        }
    }

    func pinAnnotationView(
        for annotation: MKAnnotation,
        in mapView: MKMapView,
        color: UIColor
    ) -> MKPinAnnotationView {
        let annotationView: MKPinAnnotationView
        if let reusableAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: waypointAnnotationIdentifier) as? MKPinAnnotationView {
            annotationView = reusableAnnotationView
            annotationView.annotation = annotation
        } else {
            annotationView = MKPinAnnotationView(
                annotation: annotation,
                reuseIdentifier: waypointAnnotationIdentifier)
        }

        annotationView.canShowCallout = false
        annotationView.pinTintColor = color
        return annotationView
    }

    func vehicleAnnotationView(
        for annotation: MKAnnotation,
        in mapView: MKMapView
    ) -> MKAnnotationView {
        let annotationView: MKAnnotationView
        if let reusableAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: vehicleAnnotationIdentifier) {
            annotationView = reusableAnnotationView
            annotationView.annotation = annotation
        } else {
            annotationView = MKAnnotationView(
                annotation: annotation,
                reuseIdentifier: vehicleAnnotationIdentifier)
        }
        annotationView.canShowCallout = true
        annotationView.image = UIImage(systemName: "bus")
        return annotationView
    }
}
