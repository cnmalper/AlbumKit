//
//  StickerPackTableViewCell.swift
//  SticKit
//
//  Created by Alper Canımoğlu on 14.12.2023.
//

import UIKit

class StickerPackTableViewCell: UITableViewCell {

    @IBOutlet weak var stickerPackImage: UIImageView!
    @IBOutlet weak var stickerPackLabel: UILabel!
    @IBOutlet weak var stickerPackItemCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
