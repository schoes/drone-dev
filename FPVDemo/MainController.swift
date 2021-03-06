//
//  FPVViewController.swift
//  iOS-FPVDemo-Swift
//

import UIKit
import MapKit
import DJISDK
import VideoPreviewer


class MainController: UIViewController, DJISDKManagerDelegate,MKMapViewDelegate {
    var flightController: DJIFlightController!;
    var mapController = MapController();
    var aircraft:DJIAircraft!;
    
    
    @IBOutlet weak var mkMapView: MKMapView!
    
    @IBAction func takeOff(_ sender: UIButton) {
        if(flightController !== nil){
            flightController.startTakeoff();
        }
    }
    
    @IBAction func tapedOnMap(_ sender: UITapGestureRecognizer) {
        let point = sender.location(in:mkMapView );
        let addedPoint = mapController.addPoint(point: point, mapView: mkMapView);
        let pin = MKPointAnnotation();
        pin.coordinate = addedPoint;
        pin.title = String(addedPoint.latitude)
        
        mkMapView.addAnnotation(pin);
    }
    @IBAction func clearWaypoints(_ sender: UIButton) {
        self.mapController.cleanAllPointsWithMapView(mapView: mkMapView)
    }

    
    @IBOutlet var fpvView: UIView!
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        DJISDKManager.registerApp(with: self);

        
    }
    
    func addStaticPoints(mapView:MKMapView){
        let pin = MKPointAnnotation();
        pin.coordinate = CLLocationCoordinate2D(latitude: 46.961588, longitude: 7.37184768);
        
        
        
        mapView.addAnnotation(pin);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        if(annotation.isKind(of: MKPointAnnotation.self)){
            let pin = MKPinAnnotationView.init(annotation: annotation, reuseIdentifier: "Pin_Annotation");
            pin.pinTintColor = UIColor.cyan;
            return pin;
        }
        return nil;
    }
    
    func showAlertViewWithTitle(title: String, withMessage message: String) {
        
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction.init(title:"OK", style: UIAlertActionStyle.default, handler: nil)
        
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    // DJISDKManagerDelegate Methods
    func productConnected(_ product: DJIBaseProduct?) {
        
        NSLog("Product Connected")
        
        
        if (product != nil) {
            aircraft = DJISDKManager.product() as! DJIAircraft;
            flightController = aircraft.flightController!;
        }
        
        //If this demo is used in China, it's required to login to your DJI account to activate the application. Also you need to use DJI Go app to bind the aircraft to your DJI account. For more details, please check this demo's tutorial.
        DJISDKManager.userAccountManager().logIntoDJIUserAccount(withAuthorizationRequired: false) { (state, error) in
            if(error != nil){
                NSLog("Login failed: %@" + String(describing: error))
            }
        }
        
    }
    
    func productDisconnected() {
        NSLog("Product Disconnected")
    }
    
    func appRegisteredWithError(_ error: Error?) {
        
        var message = "Register App Successed!"
        if (error != nil) {
            message = "Register app failed! Please enter your app key and check the network."
        } else {
            DJISDKManager.enableBridgeMode(withBridgeAppIP: "192.168.1.54")
            DJISDKManager.startConnectionToProduct()
        }
        
        self.showAlertViewWithTitle(title:"Register App", withMessage: message)
    }
    
}
