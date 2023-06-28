//
//  CustomCellTableViewCell.swift
//  ToDoMoviles
//
//  Created by Mac 13 on 28/06/23.
//

import UIKit

class CustomCellTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var lblFecha: UILabel!
    @IBOutlet weak var lblTitulo: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
