//
//  TaskTableViewCell.swift
//  To-DoWithPromodoro
//
//  Created by MYMACBOOK on 13.02.2021.
//  Copyright © 2021 ElifKorkmaz. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var labeltask: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
