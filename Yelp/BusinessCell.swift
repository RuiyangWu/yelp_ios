//
//  BusinessCell.swift
//  Yelp
//
//  Created by ruiyang_wu on 8/8/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {

  @IBOutlet weak var thumbImageView: UIImageView!
  @IBOutlet weak var ratingImageView: UIImageView!

  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var distanceLabel: UILabel!
  @IBOutlet weak var reviewsCountLabel: UILabel!
  @IBOutlet weak var addressLabel: UILabel!
  @IBOutlet weak var categoryLabel: UILabel!

  var business: Business! {
    didSet {
      nameLabel.text = business.name
      distanceLabel.text = business.distance
      reviewsCountLabel.text = "\(business.reviewCount!) Reviews"
      addressLabel.text = business.address
      categoryLabel.text = business.categories
      thumbImageView.setImageWithURL(business.imageURL!)
      ratingImageView.setImageWithURL(business.ratingImageURL!)
    }
  }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      thumbImageView.layer.cornerRadius = 5
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
