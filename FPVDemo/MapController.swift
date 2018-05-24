//
//  MapController.swift
//  FPVDemo
//
//  Created by Sven Schoeni on 23.05.18.
//  Copyright © 2018 DJI. All rights reserved.
//

import Foundation
import MapKit

class MapController{
    var waypoints:Array<CLLocation> = [];


    func addPoint(point:CGPoint,mapView:MKMapView){
        let coordinate = mapView.convert(point, toCoordinateFrom: mapView);
        let location =  CLLocation.init(latitude: coordinate.latitude, longitude: coordinate.longitude);
        
        waypoints.append(location);
        NSLog("Location added:",location);
      
    }
    
    func cleanAllPointsWithMapView(mapView:MKMapView){
        waypoints.removeAll();
    }
    
    func getWayPoints()->Array<CLLocation>{
        return self.waypoints;
    }
}
