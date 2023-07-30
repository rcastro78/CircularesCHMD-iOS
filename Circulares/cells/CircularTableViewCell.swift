//
//  CircularTableViewCell.swift
//  Circulares
//
//  Created by Rafael David Castro Luna on 22/7/23.
//

import UIKit

class CircularTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitulo: UILabel!
    @IBOutlet weak var lblPara: UILabel!
    @IBOutlet weak var imgLectura: UIImageView!
    @IBOutlet weak var imgFavorito: UIButton!
    @IBOutlet weak var imgAdjunto: UIImageView!
    @IBOutlet weak var imgCalendario: UIImageView!
    @IBOutlet weak var chkSeleccionar: CheckBox!
    
    @IBOutlet weak var imgEstrella: UIImageView!
    @IBOutlet weak var lblFecha: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    

}
