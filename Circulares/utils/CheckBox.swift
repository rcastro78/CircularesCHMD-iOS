//
//  CheckBox.swift
//  Circulares
//
//  Created by Rafael David Castro Luna on 22/7/23.
//
import UIKit
class CheckBox: UIButton {
    // Images
    let checkedImage = UIImage(named: "check_lleno")! as UIImage
    let uncheckedImage = UIImage(named: "check_vacio")! as UIImage

    // Bool property
    var isChecked: Bool = false {
        didSet {
            if isChecked == true {
                self.setImage(checkedImage, for: UIControl.State.normal)
            } else {
                self.setImage(uncheckedImage, for: UIControl.State.normal)
            }
        }
    }

    override func awakeFromNib() {
        self.addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControl.Event.touchUpInside)
        self.isChecked = false
    }

    @objc func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
        }
    }
}

