//
//  SSListCell.swift
//  SongStudio
//
//  Created by Karthi on 17/11/19.
//  Copyright © 2019 Karthi. All rights reserved.
//

import UIKit

class SSListCell: UITableViewCell {

    @IBOutlet weak var songArtists: UILabel!
    @IBOutlet weak var songTitle: UILabel!
    
    @IBOutlet weak var songImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
