//
//  MovieDetailsViewController.swift
//  MovieReviews
//
//  Created by drishi on 9/14/17.
//  Copyright © 2017 Droan Rishi. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    @IBOutlet var movieDetailsView: MovieDetails!
    var movie: NSDictionary = [:]
    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("Movie: \(movie)")
        let posterPath = movie["poster_path"] as! String
        let baseUrl = "https://image.tmdb.org/t/p/w500/"
        let posterUrl = NSURL(string: baseUrl+posterPath)
        let posterUrlRequest = NSURLRequest(url: (posterUrl as URL?)!)
        self.movieDetailsView.backdropImageView.setImageWith(posterUrlRequest as URLRequest, placeholderImage: nil,
                                     success: { (imageRequest, imageResponse, image) -> Void in
                                        
                                        // imageResponse will be nil if the image is cached
                                        if imageResponse != nil {
                                            self.movieDetailsView.backdropImageView.alpha = 0.0
                                            self.movieDetailsView.backdropImageView.image = image
                                            UIView.animate(withDuration: 1.0, animations: { () -> Void in
                                                self.movieDetailsView.backdropImageView.alpha = 1.0
                                            }, completion: nil)
                                        } else {
                                            self.movieDetailsView.backdropImageView.image = image
                                        }
        }, failure: { (imageRequest, imageResponse, error) -> Void in
            // do something for the failure condition
        })
        self.movieDetailsView.titleLabel.text = movie["title"] as? String
        let releaseDate = movie["release_date"] as! String
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.date(from: releaseDate)
        formatter.dateStyle = DateFormatter.Style.long
        let dateString = formatter.string(for: date)
        
        self.movieDetailsView.releaseDateLabel.text = dateString
        self.movieDetailsView.overviewLabel.text = movie["overview"] as? String
        var rating = movie["vote_average"] as! Float
        rating = rating / 2
        self.movieDetailsView.ratingLabel.rating = Double(rating)
        self.movieDetailsView.ratingLabel.settings.updateOnTouch = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
