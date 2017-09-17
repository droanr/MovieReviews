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

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet var parentView: UIView!
    @IBOutlet weak var movieTableView: UITableView!
    @IBOutlet weak var movieCollectionView: UICollectionView!
    
    @IBOutlet weak var errorView: UIView!
    var movies: [NSDictionary]?
    var filteredMovies: [NSDictionary]?
    var endpoint = NSString()
    var searchBar: UISearchBar!
    var gridView: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !isInternetAvailable() {
            errorView.isHidden = false
            return
        }
        //let margins = view.layoutMarginsGuide
        
        movieTableView.dataSource = self
        movieTableView.delegate = self
        movieCollectionView.dataSource = self
        movieCollectionView.delegate = self
        movieCollectionView.isHidden = true
        //movieCollectionView.heightAnchor.constraint(equalTo: movieCollectionView.heightAnchor, multiplier: 0).constant = 0
        
        errorView.isHidden = true
        self.gridView = false
        self.searchBar = UISearchBar()
        self.searchBar.sizeToFit()
        self.searchBar.delegate = self
        navigationItem.titleView = self.searchBar
        let layoutButton = UIBarButtonItem(image: UIImage(named: "grid-icon"), style: .plain, target: self, action: #selector(changeLayout))
        
        navigationItem.leftBarButtonItem = layoutButton

        let textFieldSearchBar = self.searchBar.value(forKey: "searchField") as? UITextField
        textFieldSearchBar?.textColor = UIColor.red
        textFieldSearchBar?.backgroundColor = UIColor.black
        textFieldSearchBar?.tintColor = UIColor.red
        textFieldSearchBar?.attributedPlaceholder = NSAttributedString(string: "Search for a movie",
                                                               attributes: [NSForegroundColorAttributeName: UIColor.red])
        let glassIconView = textFieldSearchBar?.leftView as? UIImageView
        glassIconView?.image = glassIconView?.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        glassIconView?.tintColor = UIColor.red

        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(self.endpoint)?api_key=\(apiKey)")
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
                                                                    self.movies = responseDictionary["results"] as? [NSDictionary]
                                                                    self.filteredMovies = responseDictionary["results"] as? [NSDictionary]
                                                                    self.movieTableView.reloadData()
                                                                    self.movieCollectionView.reloadData()
                                                                    MBProgressHUD.hide(for: self.parentView, animated: true)
                                                                    
                                                                }
                                                                
                                                            }
        })
        task.resume()
        
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange textSearched: String)
    {
        self.filteredMovies = textSearched.isEmpty ? self.movies: self.movies?.filter{ (item: NSDictionary) -> Bool in
            
            title = item["title"] as! String
            if title != nil {
                return (title!.range(of: textSearched, options: .caseInsensitive, range: nil, locale: nil) != nil)
            }
            return false
        }
        self.movieTableView.reloadData()
    }
    
    func changeLayout(_ layoutButton: UIBarButtonItem) {
        if self.gridView {
            layoutButton.image = UIImage(named: "grid-icon")
            self.movieCollectionView.isHidden = true
            self.movieTableView.isHidden = false
            self.gridView = false
        } else {
            self.movieTableView.isHidden = true
            self.movieCollectionView.isHidden = false
            self.gridView = true
            layoutButton.image = UIImage(named: "list-icon")
            self.movieCollectionView.reloadData()
        }
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
        if let movie = filteredMovies {
            return (filteredMovies?.count)!
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let movie = filteredMovies {
            return (filteredMovies?.count)!
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionCell", for: indexPath) as! MovieCollectionViewCell
        
        let movie = filteredMovies![indexPath.row]
        let title = movie["title"] as! String
        let posterPath = movie["poster_path"] as! String
        
        let baseUrl = "https://image.tmdb.org/t/p/w500/"
        let posterUrl = NSURL(string: baseUrl+posterPath)
        let posterUrlRequest = NSURLRequest(url: (posterUrl as URL?)!)
        cell.posterView.setImageWith(posterUrlRequest as URLRequest, placeholderImage: nil,
                                     success: { (imageRequest, imageResponse, image) -> Void in
                                        
                                        // imageResponse will be nil if the image is cached
                                        if imageResponse != nil {
                                            cell.posterView.alpha = 0.0
                                            cell.posterView.image = image
                                            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                                                cell.posterView.alpha = 1.0
                                            }, completion: nil)
                                        } else {
                                            cell.posterView.image = image
                                        }
        }, failure: { (imageRequest, imageResponse, error) -> Void in
            // do something for the failure condition
        })
        print ("Row \(indexPath.row)")
        cell.isSelected = false
        return cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        let movie = filteredMovies![indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        let posterPath = movie["poster_path"] as! String
        var rating = movie["vote_average"] as! Float
        rating = rating / 2

        cell.movieTitle.text = title
        cell.overviewLabel.text = overview
        //cell.movieRatingLabel.updateOnTouch = false
        cell.movieRatingLabel.rating = Double(rating)
        let baseUrl = "https://image.tmdb.org/t/p/w500/"
        let posterUrl = NSURL(string: baseUrl+posterPath)
        let posterUrlRequest = NSURLRequest(url: (posterUrl as URL?)!)
        cell.posterView.setImageWith(posterUrlRequest as URLRequest, placeholderImage: nil,
                                    success: { (imageRequest, imageResponse, image) -> Void in
            
            // imageResponse will be nil if the image is cached
            if imageResponse != nil {
                cell.posterView.alpha = 0.0
                cell.posterView.image = image
                UIView.animate(withDuration: 0.5, animations: { () -> Void in
                    cell.posterView.alpha = 1.0
                }, completion: nil)
            } else {
                cell.posterView.image = image
            }
        }, failure: { (imageRequest, imageResponse, error) -> Void in
            // do something for the failure condition
        })
        print ("Row \(indexPath.row)")
        cell.selectionStyle = .none
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
                movieDetailsController.movie = (self.filteredMovies?[indexPath.row])!
                movieTableView.deselectRow(at: indexPath, animated: true)
            }
        } else if segue.identifier == "showMovieDetailsSegue2" {
            let cell = sender as! MovieCollectionViewCell
            if let indexPath = movieCollectionView.indexPath(for: cell) {
                let movieDetailsController = segue.destination as! MovieDetailsViewController
                movieDetailsController.movie = (self.filteredMovies?[indexPath.row])!
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
