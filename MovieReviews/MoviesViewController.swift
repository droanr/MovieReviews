//
//  MoviesViewController.swift
//  MovieReviews
//
//  Created by drishi on 9/13/17.
//  Copyright © 2017 Droan Rishi. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD
import Foundation
import SystemConfiguration

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var parentView: UIView!
    @IBOutlet weak var movieTableView: UITableView!
    
    @IBOutlet weak var errorView: UIView!
    var movies: [NSDictionary]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !isInternetAvailable() {
            errorView.isHidden = false
            return
        }
        movieTableView.dataSource = self
        movieTableView.delegate = self
        errorView.isHidden = true
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate: nil,
            delegateQueue: OperationQueue.main
        )
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        movieTableView.insertSubview(refreshControl, at: 0)
        MBProgressHUD.showAdded(to: self.parentView, animated: true)
        let task: URLSessionDataTask = session.dataTask(with: request,
                                                        completionHandler: {(dataOrNil, response, error) in
                                                            if let data = dataOrNil {
                                                                if let responseDictionary = try! JSONSerialization.jsonObject(
                                                                    with: data, options: []) as? NSDictionary {
                                                                    NSLog("response: \(responseDictionary)")
                                                                    self.movies = responseDictionary["results"] as! [NSDictionary]
                                                                    self.movieTableView.reloadData()
                                                                    MBProgressHUD.hide(for: self.parentView, animated: true)
                                                                    
                                                                }
                                                                
                                                            }
        })
        task.resume()
        
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate: nil,
            delegateQueue: OperationQueue.main
        )
        let task: URLSessionDataTask = session.dataTask(with: request,
                                                        completionHandler: {(dataOrNil, response, error) in
                                                            if let data = dataOrNil {
                                                                if let responseDictionary = try! JSONSerialization.jsonObject(
                                                                    with: data, options: []) as? NSDictionary {
                                                                    NSLog("response: \(responseDictionary)")
                                                                    self.movies = responseDictionary["results"] as! [NSDictionary]
                                                                    self.movieTableView.reloadData()
                                                                    refreshControl.endRefreshing()
                                                                }
                                                            }
        })
        task.resume()
    }
    
    func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movie = movies {
            return (movies?.count)!
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        let movie = movies![indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        let posterPath = movie["poster_path"] as! String

        cell.movieTitle.text = title
        cell.overviewLabel.text = overview
        
        let baseUrl = "https://image.tmdb.org/t/p/w500/"
        let posterUrl = NSURL(string: baseUrl+posterPath)
        
        cell.posterView.setImageWith(posterUrl as! URL)        
        print ("Row \(indexPath.row)")
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMovieDetailsSegue" {
            let cell = sender as! MovieCell
            if let indexPath = movieTableView.indexPath(for: cell) {
                let movieDetailsController = segue.destination as! MovieDetailsViewController
                movieDetailsController.movie = (self.movies?[indexPath.row])!
                movieTableView.deselectRow(at: indexPath, animated: true)
            }
        }
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
