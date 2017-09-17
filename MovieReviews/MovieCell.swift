//
//  MovieCell.swift
//  MovieReviews
//
//  Created by drishi on 9/14/17.
//  Copyright © 2017 Droan Rishi. All rights reserved.
//

import UIKit
import Cosmos

class MovieCell: UITableViewCell {

    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var movieRatingLabel: CosmosView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
