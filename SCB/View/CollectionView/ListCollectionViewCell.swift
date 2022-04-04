//
//  ListCollectionViewCell.swift
//  SCB
//
//  Created by Mac on 02/04/22.
//

import UIKit
import SDWebImage

class ListCollectionViewCell: UICollectionViewCell {

    //MARK: - Properties

    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setUpCell()
    }

    //MARK: - setUpCell

    func setUpCell() {

        HELPER.setCardView(cardView: baseView)
        HELPER.setCardView(cardView: posterImageView)

    }

    //MARK: - updateDetails

    func updateDetails(details: ListResponseSearch) {

        if let imgStr = details.poster, imgStr != "", let url = imgStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
            posterImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            posterImageView.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "placeholder"), options: .refreshCached)
            posterImageView.clipsToBounds = true

        } else {
            posterImageView.image = UIImage (named: "placeholder")
        }

        movieTitleLabel.text = details.title ?? ""
    }

}
