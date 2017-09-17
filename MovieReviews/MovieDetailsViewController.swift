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
        self.movieDetailsView.releaseDateLabel.text = movie["release_date"] as? String
        self.movieDetailsView.overviewLabel.text = movie["overview"] as? String
        
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
