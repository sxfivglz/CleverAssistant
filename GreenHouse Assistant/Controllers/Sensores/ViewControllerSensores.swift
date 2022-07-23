import UIKit
import Foundation

class ViewControllerSensores: UIViewController{
    @IBOutlet weak var labelDato: UILabel!
    @IBOutlet weak var pickerSensores: UIPickerView!
    @IBOutlet weak var labelNombreSensor: UILabel!
    @IBOutlet weak var labelTipoSensor: UILabel!
    var ArraySens = ["-----------------","Humedad","Caudal","Temperatura"]
    var datos = [DatoSensorClass]()
    
    /*Humedad,Caudal,Temperatura*/
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerSensores.dataSource = self
        pickerSensores.delegate = self
        labelNombreSensor.isHidden = true
        labelTipoSensor.isHidden = true
        pickerSensores.selectRow(0, inComponent: 0, animated: true)
    }
}

extension ViewControllerSensores: UIPickerViewDataSource, UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ArraySens.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
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
        labelTipoSensor.isHidden = false
        labelNombreSensor.text = (myString)
        recuperaSensor {
            print("success")
        }
        
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

    func recuperaSensor(completed: @escaping () -> ()){
        let tk:String = UserDefaults.standard.string(forKey: "Token")!
        let Id_Invernadero:String = UserDefaults.standard.string(forKey: "Id_Invernadero")!
        let Id_Estacion:String = UserDefaults.standard.string(forKey: "Id_Estacion")!
        let Tipo_Sensor:String = labelNombreSensor.text!
        let x:String = (myConection + "sensores/getSensoresTiempoReal")
        guard let url = URL(string: x) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(tk, forHTTPHeaderField: "Authorization")
        let body: [String: AnyHashable] = [
            "invernadero": Id_Invernadero,
            "estacion": Id_Estacion,
            "tipo": Tipo_Sensor
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        let task = URLSession.shared.dataTask(with: request){
            data, _, error in
            guard let data = data, error == nil else{
                return
            }
            do {
                
                let response = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                self.datos = try JSONDecoder().decode([DatoSensorClass].self, from: data)
                                
                if self.datos.count != 0{
                    OperationQueue.main.addOperation {
                        self.labelDato.text = String(self.datos[0].Valor)
                        let f:String = self.datos[0].Fecha
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                        let date = dateFormatter.date(from: f)
                        dateFormatter.dateFormat = "dd-MM-yyyy, HH:mm:ss"
                        dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
                        let resultString = dateFormatter.string(from: date!)
                        print(resultString)
                        self.labelTipoSensor.text = resultString
                    }
                } else {
                    OperationQueue.main.addOperation{
                        
                            let dialogMessage = UIAlertController(title: "Error", message: "El Correo Electronico que ha ingresado no existe, verifiquelo.", preferredStyle: .alert)
                            let ok = UIAlertAction(title: "Ok", style: .default, handler: {(action)-> Void in print("Ok button tapped")})
                            dialogMessage.addAction(ok)
                            self.present(dialogMessage, animated: true, completion: nil)
                    }
                }
            }
            catch{
                print(error)
            }
        }
        task.resume()
    }
}
