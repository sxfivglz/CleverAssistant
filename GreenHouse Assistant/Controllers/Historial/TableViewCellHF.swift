//
//  TableViewCellHF.swift
//  GreenHouse Assistant
//
//  Created by Mac19 on 25/07/22.
//

import UIKit

class TableViewCellHF: UITableViewCell {

    @IBOutlet weak var invernaderoLabel: UILabel!
    @IBOutlet weak var estacionLabel: UILabel!
    @IBOutlet weak var usuarioLabel: UILabel!
    @IBOutlet weak var fechaLabel: UILabel!
    @IBOutlet weak var tipoactLabel: UILabel!
    @IBOutlet weak var valorunoLabel: UILabel!
    @IBOutlet weak var valordosLabel: UILabel!
    @IBOutlet weak var valortresLabel: UILabel!
    @IBOutlet weak var valorcuatroLabel: UILabel!
    @IBOutlet weak var valorcincoLabel: UILabel!
    @IBOutlet weak var valorseisLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
