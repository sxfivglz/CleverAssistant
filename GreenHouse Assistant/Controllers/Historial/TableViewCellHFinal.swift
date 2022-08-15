//
//  TableViewCellHFinal.swift
//  GreenHouse Assistant
//
//  Created by Mac19 on 14/08/22.
//

import UIKit

class TableViewCellHFinal: UITableViewCell {

    @IBOutlet weak var labelEstacion: UILabel!
    @IBOutlet weak var labelSensor: UILabel!
    @IBOutlet weak var labelValor: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
