//
//  HeaderImageTableViewCell.swift
//  SCB
//
//  Created by Mac on 03/04/22.
//

import UIKit
import SDWebImage

class HeaderImageTableViewCell: UITableViewCell {

    //MARK: - Properties
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!

    @IBOutlet weak var synopsisLabel: UILabel!

    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var popularityLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!

    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var actorsLabel: UILabel!
    @IBOutlet weak var writerLabel: UILabel!

    @IBOutlet weak var yearLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    //MARK: - setUpCell

    func setupView() {
        HELPER.setCardView(cardView: posterImageView)
    }

    //MARK: - updateDetails
    func updateDetails(_ details:MovieDetailsResponse?) {
        if let imgStr = details?.poster, imgStr != "", let url = imgStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
            posterImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            posterImageView.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "placeholder"), options: .refreshCached)
            posterImageView.clipsToBounds = true

        } else {
            posterImageView.image = UIImage (named: "placeholder")
        }

        titleLabel.text =  (details?.title ?? "")
        yearLabel.text =  (details?.year ?? "")

        ratingLabel.text =  (details?.imdbRating ?? "")
        categoryLabel.text =  (details?.type ?? "")
        durationLabel.text =  (details?.runtime ?? "")

        synopsisLabel.attributedText = HELPER.attributedString(labelType: "Synopsis : ", labelText: (details?.plot ?? ""), isNext: true)

        scoreLabel.attributedText = HELPER.attributedString(labelType: "Score", labelText: (details?.imdbRating ?? ""), isNext: true)
        reviewLabel.attributedText = HELPER.attributedString(labelType: "Language", labelText: (details?.language ?? ""), isNext: true)
        popularityLabel.attributedText = HELPER.attributedString(labelType: "Popularity", labelText: (details?.imdbVotes ?? ""), isNext: true)

        directorLabel.attributedText = HELPER.attributedString(labelType: "Director : ", labelText: (details?.director ?? ""), isNext: false)
        writerLabel.attributedText = HELPER.attributedString(labelType: "Writer : ", labelText: (details?.writer ?? ""), isNext: false)
        actorsLabel.attributedText = HELPER.attributedString(labelType: "Actors : ", labelText: (details?.actors ?? ""), isNext: false)

    }
    
}
