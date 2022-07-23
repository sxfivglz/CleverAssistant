//
//  ViewControllerSensores.swift
//  GreenHouse Assistant
//
//  Created by Mac19 on 19/07/22.
//

import UIKit

class ViewControllerSensores: UIViewController{
    @IBOutlet weak var labelDato: UILabel!
    @IBOutlet weak var pickerSensores: UIPickerView!
    @IBOutlet weak var labelNombreSensor: UILabel!
    @IBOutlet weak var labelTipoSensor: UILabel!
    var ArraySens = ["Humedad","Caudal","Temperatura"]

    /*Humedad,Caudal,Temperatura*/
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerSensores.dataSource = self
        pickerSensores.delegate = self
        labelNombreSensor.isHidden = true
        labelTipoSensor.isHidden = true
        
    }
    

}

extension ViewControllerSensores: UIPickerViewDataSource, UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ArraySens.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
       {
           return ArraySens[row]
       }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60.0
    }
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 250.0
    }
       

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let myString = ArraySens[row]
        
        labelNombreSensor.isHidden = false
        labelNombreSensor.text = (myString)
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let pickerLabel: UILabel
        if let label = view as? UILabel {
                  pickerLabel = label
        } else {
        pickerLabel = UILabel()
        // Customize text
        pickerLabel.font = pickerLabel.font.withSize(40)
        pickerLabel.textAlignment = .center
        pickerLabel.textColor = UIColor.black
                  // Create a paragraph with custom style
                  // We only need indents to prevent text from being cut off
        let paragraphStyle = NSMutableParagraphStyle()
                  paragraphStyle.firstLineHeadIndent = 20 // May vary
                  // Create a string and append style to it
        let attributedString = NSMutableAttributedString(string: ArraySens[row])
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
                  // Update label's text
        pickerLabel.attributedText = attributedString
              }
              
        return pickerLabel
    }
}
