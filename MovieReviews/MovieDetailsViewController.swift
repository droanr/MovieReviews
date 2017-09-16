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
        self.movieDetailsView.backdropImageView.setImageWith(posterUrl! as URL)
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
