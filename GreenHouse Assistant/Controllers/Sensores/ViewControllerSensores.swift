import UIKit
import Foundation

class ViewControllerSensores: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{
    @IBOutlet weak var labelDato: UILabel!
    @IBOutlet weak var sensoresTextField: UITextField!
    @IBOutlet weak var labelNombreSensor: UILabel!
    @IBOutlet weak var labelTipoSensor: UILabel!
    @IBOutlet weak var NombreSensor: UILabel!
    @IBOutlet weak var Fecha: UILabel!
    var pickerSensores = UIPickerView()
    var datos = [DatoSensorClass]()
    var sensores = [SensoresClass]()
    var id_sensor = ""
    /*Humedad,Caudal,Temperatura*/
    override func viewDidLoad() {
        super.viewDidLoad()
        rellenaSensores {
            print("success")
        }
        labelNombreSensor.isHidden = true
        labelTipoSensor.isHidden = true
        labelDato.isHidden = true
        NombreSensor.isHidden = true
        Fecha.isHidden = true
        pickerSensores.dataSource = self
        pickerSensores.delegate = self
        sensoresTextField.inputView = pickerSensores
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.sensores.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.sensores[row].Nombre
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40.0
    }

    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 250.0
    }


    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        sensoresTextField.text = sensores[row].Nombre
        id_sensor = sensores[row]._id
        labelNombreSensor.isHidden = false
        labelTipoSensor.isHidden = false
        labelDato.isHidden = false
        NombreSensor.isHidden = false
        Fecha.isHidden = false
        labelNombreSensor.text = ""
        labelTipoSensor.text = ""
        labelDato.text = ""
        NombreSensor.text = ""
        Fecha.text = ""
        sensoresTextField.resignFirstResponder()
        recuperaSensor {
            print("sensores success")
        }
    }

    func recuperaSensor(completed: @escaping () -> ()){
        let tk:String = UserDefaults.standard.string(forKey: "Token")!
        let x:String = (myConection + "sensores/getSensoresTiempoReal/" + id_sensor)
        guard let url = URL(string: x) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(tk, forHTTPHeaderField: "Authorization")
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
                        print(response)
                        self.NombreSensor.text = "Nombre del sensor:"
                        self.Fecha.text = "Fecha y hora de actividad:"
                        self.labelNombreSensor.text = String(self.datos[0].Nombre)
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
                        if (String(self.datos[0].Tipo) == "Temperatura"){
                            
                            self.labelDato.text = String(self.datos[0].Valor)+"°C"
                        }else if (String(self.datos[0].Tipo) == "Caudal"){
                            
                            self.labelDato.text = String(self.datos[0].Valor)+"L/Mn"
                        }else if (String(self.datos[0].Tipo) == "Gas"){
                            self.labelDato.text = String(self.datos[0].Valor)+"ppm"
                        }
                        else if(String(self.datos[0].Tipo) == "Humedad"){
                            
                            self.labelDato.text = String(self.datos[0].Valor)+" kPa"
                        }else if(String(self.datos[0].Tipo) == "Fotoresistencia"){
                            
                            self.labelDato.text = String(self.datos[0].Valor)+"kΩ"
                        }
                    }
                    }else {
                    OperationQueue.main.addOperation{
                            let dialogMessage = UIAlertController(title: "Dato Sensor", message: "No existen datos registrados del sensor seleccionado para la estación indicada.", preferredStyle: .alert)
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
    
    func rellenaSensores(completed: @escaping () -> ()){
        let tk:String = UserDefaults.standard.string(forKey: "Token")!
        let nombreEstacion:String = UserDefaults.standard.string(forKey: "nombreEstacion")!
        let url = URL(string: myConection + "sensores/getSensoresByEstacionNombre/" + nombreEstacion)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(tk, forHTTPHeaderField: "Authorization")
                
        URLSession.shared.dataTask(with: request){ data, response, err in
            if err == nil {
                do {
                    self.sensores = try JSONDecoder().decode([SensoresClass].self, from: data!)
                    DispatchQueue.main.async {
                        completed()
                    }
                }
                catch {
                    print("Error api")
                }
            }
        }.resume()
    }
}
