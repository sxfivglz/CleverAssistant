//
//  TableViewCell.swift
//  GreenHouse Assistant
//
//  Created by Mac19 on 23/07/22.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var tituloLabel: UILabel!
    @IBOutlet weak var subtituloLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
        
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
            
        // Configure the view for the selected state
       
    }
    
}
