//
//  MKMapKit.swift
//  GBens
//
//  Created by Alexandre de Sousa Albuquerque on 16/09/17.
//  Copyright © 2017 Alexandre de Sousa Albuquerque. All rights reserved.
//

import MapKit

extension MKMapView {

    func addCoord(_ coord : CLLocationCoordinate2D) -> MKAnnotation {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coord
        self.addAnnotation(annotation)

        return annotation
    }

}
