//
//  TableViewController.swift
//  TestFBAPI
//
//  Created by Richard Du on 4/8/17.
//  Copyright © 2017 Richard. All rights reserved.
//

import UIKit
import CoreLocation

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var locations: [NSDictionary]?
    var address: String?
    var coordinate: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        var latitude: Double = -33.8670522
        var longitude: Double = 151.1957362
        let radius: Double = 500
        let type: String = "restaurant"
        let keyword: String = "cruise"
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString("\(address!)") {
            placemarks, error in
            let placemark = placemarks?.first
            self.coordinate = placemark?.location?.coordinate
            
            
        
        latitude = self.coordinate!.latitude
        longitude = self.coordinate!.longitude
        let apiKey = "AIzaSyBPbfAd6wHPyyuJVUVtF7Rtx98W1eIS7cc"
        
        let url = URL(string: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(latitude),\(longitude)&radius=\(radius)&type=\(type)&keyword=\(keyword)&key=\(apiKey)")
        let request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            if let data = data {
                if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    
                    print(dataDictionary)
                    self.locations = (dataDictionary["results"] as![NSDictionary])
                    self.tableView.reloadData()
                    
                }
            }
        }
        task.resume()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return locations?.count ?? 0
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationTableViewCell
        
        let location = locations![indexPath.row]
        let geometry = location["geometry"] as! NSDictionary
        let coordinates = geometry["location"] as! NSDictionary
        
        let lng = coordinates["lng"] as! NSNumber
        let lat = coordinates["lat"] as! NSNumber
        cell.longitudeLabel.text = "\(lng)"
        cell.latitudeLabel.text = "\(lat)"
        cell.nameLabel.text = (location["name"] as! String)
        
        if let coordinate = self.coordinate {
        let coordinate₀ = CLLocation(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(lng))
        let coordinate₁ = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        let distanceInMeters = coordinate₀.distance(from: coordinate₁)
        cell.distanceLabel.text = "\(distanceInMeters)"
        }
        return cell
    }
    

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
