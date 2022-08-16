import UIKit
import PusherSwift

class ViewControllerHistorial: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate, PusherDelegate {
    var pusher: Pusher!
    //TextFields
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var invernaderoTextField: UITextField!
    @IBOutlet weak var estacionTextField: UITextField!
    @IBOutlet weak var tipoestacionTextField: UITextField!
    @IBOutlet weak var usuarioTextField: UITextField!
    @IBOutlet weak var fechainicioTextField: UITextField!
    @IBOutlet weak var fechafinTextField: UITextField!
    @IBOutlet weak var buscarBtn: UIButton!
    @IBOutlet weak var labelActualizacion: UILabel!
    //Pickers
    var invernaderoPickerView = UIPickerView()
    var estacionPickerView = UIPickerView()
    var tipoestacionPickerView = UIPickerView()
    var usuarioPickerView = UIPickerView()
    var fechainicioPickerView = UIDatePicker()
    var fechafinPickerView = UIDatePicker()
    //Arreglos
    var invernaderos = [InvernaderosClass]()
    var estaciones = [EstacionesClass]()
    var tipoestArray = ["Todos", "Automatica","Manual"]
    var usuarios = [UsuarioClass]()
    var historial = [HistorialClass]()
    var idInv:Int = 0
    var Inv:String = ""
    var idEst:Int = 0
    var Est:String = ""
    var TipoAct:String = ""
    var idUser:Int = 0
    var FechaInicio:String = ""
    var FechaFin:String = ""
    //Datos
    var _id:String?
    var indHist:Int?
    var inver:String?
    var esta:String?
    var usua:String?
    var fecha:String?
    var tpa:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rellenaInvernadero{
            print("success")
        }
        let options = PusherClientOptions(
                host: .cluster("us2")
              )

        pusher = Pusher(
            key: "0277d6e251d4f4b4a6d9",
            options: options
        )

        pusher.delegate = self
        
        let pushEstacion:String = UserDefaults.standard.string(forKey: "nombreEstacion")!
        
        // subscribe to channel
        let channel = pusher.subscribe(pushEstacion)

        // bind a callback to handle an event
        let _ = channel.bind(eventName: "my-event", eventCallback: { (event: PusherEvent) in
            if let data = event.data {
                // you can parse the data as necessary
                self.downloadJSONPusher {
                    print("success")
            }
                
                        
                }
        })
        pusher.connect()
        
        
        labelActualizacion.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "TableViewCellH", bundle: nil), forCellReuseIdentifier: "tableIdentifierH")
        tableView.separatorColor = .green
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        buscarBtn.layer.cornerRadius = 15
        buscarBtn.layer.masksToBounds = true
        //Para que los textField sean pickers
        invernaderoTextField.inputView = invernaderoPickerView
        estacionTextField.inputView = estacionPickerView
        tipoestacionTextField.inputView = tipoestacionPickerView
        usuarioTextField.inputView = usuarioPickerView
        fechainicioTextField.inputView = fechainicioPickerView
        fechafinTextField.inputView = fechafinPickerView
        //App delegate y data source de los picker
        invernaderoPickerView.delegate = self
        invernaderoPickerView.dataSource = self
        estacionPickerView.delegate = self
        estacionPickerView.dataSource = self
        tipoestacionPickerView.delegate = self
        tipoestacionPickerView.dataSource = self
        usuarioPickerView.delegate = self
        usuarioPickerView.dataSource = self
        //Tags para identificar los pickers
        invernaderoPickerView.tag = 1
        estacionPickerView.tag = 2
        tipoestacionPickerView.tag = 3
        usuarioPickerView.tag = 4
        //Estilo del pickerdate
        fechainicioPickerView.preferredDatePickerStyle = .wheels
        fechafinPickerView.preferredDatePickerStyle = .wheels
        fechainicioPickerView.datePickerMode = .date
        fechafinPickerView.datePickerMode = .date
        fechainicioTextField.inputAccessoryView = createToolbar()
        fechafinTextField.inputAccessoryView = createToolbarFinal()
        let loc = Locale(identifier: "es_MX")
        var calendar = Calendar.current
        calendar.locale = loc
        fechainicioPickerView.locale = loc
        fechafinPickerView.locale = loc
    }
    
    
    // print Pusher debug messages
    func debugLog(message: String) {
        print(message)
    }
    
    @objc func showLabel() {
        self.labelActualizacion.isHidden = false
        }
    
    @IBAction func buscarHistorial(_ sender: Any) {
        downloadJSON {
            print("ok")
        }
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if historial.count == 0 {
            let emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
            emptyLabel.text = "No se encontraron resultados."
            emptyLabel.textColor = .darkGray
            emptyLabel.font = UIFont.systemFont(ofSize: 35)
            emptyLabel.numberOfLines =  0
            emptyLabel.textAlignment = NSTextAlignment.center
            self.tableView.backgroundView = emptyLabel
            self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
            return 0
        } else {
            self.tableView.backgroundView = nil
            return historial.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableIdentifierH", for: indexPath) as? TableViewCellH
        let hist = historial[indexPath.row]
        cell?.estacionLabel.text = "Estación: \(hist.Estacion)"
        cell?.invernaderoLabel.text = "Invernadero: \(hist.Invernadero)"
       // cell?.fechaLabel.text = hist.Fecha
        let f:String = hist.Fecha
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: f)
        dateFormatter.dateFormat = "dd-MM-yyyy, HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        let resultString = dateFormatter.string(from: date!)
        cell?.fechaLabel.text =  "Fecha y hora de activación: \(resultString)"
        cell?.usuarioLabel.text =  "Usuario: \(hist.Id_Usuario)"
        cell?.tipoactLabel.text = "Tipo de activación: \(hist.Tipo_Activacion)"
        let bgv = UIView()
        bgv.backgroundColor = UIColor.systemBlue
        cell?.selectedBackgroundView = bgv
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 300
        }
        return 300
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let hist = historial[indexPath.row]
        _id = hist._id
        inver = hist.Invernadero
        esta = hist.Estacion
        usua = hist.Id_Usuario
        fecha = hist.Fecha
        tpa = hist.Tipo_Activacion
        indHist = Int(indexPath.row)

        self.performSegue(withIdentifier: "HistSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HistSegue" {
            let destinationVC = segue.destination as! ViewControllerHistorialFinal
            destinationVC._idHist = _id!
            destinationVC.inv = inver!
            destinationVC.est = esta!
            destinationVC.usu = usua!
            destinationVC.fecha = fecha!
            destinationVC.ta = tpa!
            destinationVC.detalle.append(HistorialClass(_id: historial[indHist!]._id, Invernadero: historial[indHist!].Invernadero, Estacion: historial[indHist!].Estacion, Fecha: historial[indHist!].Fecha, Tipo_Activacion: historial[indHist!].Tipo_Activacion, Id_Usuario: historial[indHist!].Id_Usuario, Sensores: historial[indHist!].Sensores))
        }
    }
    
    //downloadJSONPusher
    func downloadJSONPusher(completed: @escaping () -> ()){
        let tk:String = UserDefaults.standard.string(forKey: "Token")!
        let url = URL(string: myConection + "sensores/getHistorial")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(tk, forHTTPHeaderField: "Authorization")
        let pushIdEstacion:String = UserDefaults.standard.string(forKey: "Id_Estacion")!
        let dateP = Date()
        let dateFormatterP = DateFormatter()
        dateFormatterP.dateFormat = "yyyy-MM-dd"
        let body: [String: AnyHashable] = [
            "invernadero": "0",
            "estacion": String(pushIdEstacion),
            "tipo_activacion": "Todos",
            "id_usuario": "0",
            "fecha_inicio": dateFormatterP.string(from: dateP),
            "fecha_fin": dateFormatterP.string(from: dateP)
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        
        URLSession.shared.dataTask(with: request){ data, response, err in
            if err == nil {
                do {
                    self.historial = try JSONDecoder().decode([HistorialClass].self, from: data!)
                    
                    DispatchQueue.main.async {
                        completed()
                        self.showToast(controller: self, message : "¡Tabla actualizada!", seconds: 3.0)
                    self.tableView.reloadData()
                    }
                }
                catch {
                    print("Error api")
                }
            }
        }.resume()
    }
    
    //JSON
    func downloadJSON(completed: @escaping () -> ()){
        let tk:String = UserDefaults.standard.string(forKey: "Token")!
        let url = URL(string: myConection + "sensores/getHistorial")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(tk, forHTTPHeaderField: "Authorization")
        
        let body: [String: AnyHashable] = [
            "invernadero": String(idInv),
            "estacion": String(idEst),
            "tipo_activacion": TipoAct,
            "id_usuario": String(idUser),
            "fecha_inicio": FechaInicio,
            "fecha_fin": FechaFin
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        
        URLSession.shared.dataTask(with: request){ data, response, err in
            if err == nil {
                do {
                    self.historial = try JSONDecoder().decode([HistorialClass].self, from: data!)
                    
                    DispatchQueue.main.async {
                        completed()
                    
                    self.tableView.reloadData()
                    }
                }
                catch {
                    print("Error api")
                }
            }
        }.resume()
    }

    //rellenaInvernadero
    func rellenaInvernadero(completed: @escaping () -> ()){
        let tk:String = UserDefaults.standard.string(forKey: "Token")!
        let url = URL(string: myConection + "users_invernaderos/getInvernadero_Usuario")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(tk, forHTTPHeaderField: "Authorization")
                
        URLSession.shared.dataTask(with: request){ data, response, err in
            if err == nil {
                do {
                    self.invernaderos = try JSONDecoder().decode([InvernaderosClass].self, from: data!)
                    self.invernaderos.append(InvernaderosClass(id: 0, nombre: "Todos", estatus: "Todos"))
                    self.invernaderos = self.invernaderos.sorted(by: { $0.id < $1.id })
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
    
    //rellenaEstaciones
    func rellenaEstaciones(completed: @escaping () -> ()){
        let Id_user:String = UserDefaults.standard.string(forKey: "idUsuario")!
        
        let tk:String = UserDefaults.standard.string(forKey: "Token")!
        let url = URL(string: myConection + "invernaderos_estaciones/getEstacionesFilter")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(tk, forHTTPHeaderField: "Authorization")
        var invX:String = ""
        if String(Inv) != "Todos"{
            invX = String(idInv)
        } else {
            invX = String(Inv)
        }
            
        let body: [String: AnyHashable] = [
            "userId": Id_user,
            "invernaderoId": invX
        ]
        
        request.httpBody = try?
            JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        
        URLSession.shared.dataTask(with: request){ data, response, err in
            if err == nil {
                do {
                    self.estaciones = try JSONDecoder().decode([EstacionesClass].self, from: data!)
                    self.estaciones.append(EstacionesClass(id: 0, nombre: "Todos", estatus: "Todos"))
                    self.estaciones = self.estaciones.sorted(by: { $0.id < $1.id })
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
    
    //rellenaUsuarios
    func rellenaUsuarios(completed: @escaping () -> ()){
        let tk:String = UserDefaults.standard.string(forKey: "Token")!
        let url = URL(string: myConection + "users_invernaderos/getUsuarios_Invernadero/" + String(idInv))
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(tk, forHTTPHeaderField: "Authorization")
                
        URLSession.shared.dataTask(with: request){ data, response, err in
            if err == nil {
                do {
                    self.usuarios = try JSONDecoder().decode([UsuarioClass].self, from: data!)
                    self.usuarios.append(UsuarioClass(id: 0, email: "Todos", nombre: "Todos", apellido_paterno: "Todos", apellido_materno: "Todos", tipo_usuario: "Todos", estatus: "Todos", telefono: "Todos", pin_acceso: 0, fecha_nacimiento: "Todos", fecha_activo: "Todos", created_at: "Todos", updated_at: "Todos"))
                    self.usuarios = self.usuarios.sorted(by: { $0.id < $1.id })
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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return self.invernaderos.count
        case 2:
            return self.estaciones.count
        case 3:
            return tipoestArray.count
        case 4:
            return usuarios.count
        default:
            return 1
            
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return self.invernaderos[row].nombre
        case 2:
            return self.estaciones[row].nombre
        case 3:
            return tipoestArray[row]
        case 4:
            return usuarios[row].nombre
        default:
            return "No se encontraron datos"
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            invernaderoTextField.text = self.invernaderos[row].nombre
            invernaderoTextField.resignFirstResponder()
            idInv = self.invernaderos[row].id
            Inv = self.invernaderos[row].nombre
            rellenaEstaciones {
                print("success")
            }
            rellenaUsuarios {
                print("Success")
            }
        case 2:
            idEst = self.estaciones[row].id
            Est = self.estaciones[row].nombre
            estacionTextField.text = self.estaciones[row].nombre
            estacionTextField.resignFirstResponder()
        case 3:
            tipoestacionTextField.text = tipoestArray[row]
            TipoAct = tipoestArray[row]
            tipoestacionTextField.resignFirstResponder()
        case 4:
            usuarioTextField.text = usuarios[row].nombre
            idUser = usuarios[row].id
            usuarioTextField.resignFirstResponder()
        default:
            return
        }
    }
    
    //Boton done para las fechas
    @objc func donePressed(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        self.fechainicioTextField.text  = dateFormatter.string(from: fechainicioPickerView.date)
        let x = self.fechainicioTextField.text
        let date = dateFormatter.date(from: x!)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        FechaInicio = dateFormatter.string(from: date!)
        self.view.endEditing(true)
    }
    
    func createToolbar() -> UIToolbar{
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolBar.setItems([doneBtn], animated: true)
        return toolBar
    }
    
    @objc func donePressedFinal(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        self.fechafinTextField.text = dateFormatter.string(from: fechafinPickerView.date)
        let x = self.fechafinTextField.text
        let date = dateFormatter.date(from: x!)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        FechaFin = dateFormatter.string(from: date!)
        self.view.endEditing(true)
    }
    
    func createToolbarFinal() -> UIToolbar{
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressedFinal))
        toolBar.setItems([doneBtn], animated: true)
        return toolBar
    }
}

extension UIViewController {

    func showToast(controller: UIViewController, message : String, seconds: Double) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = UIColor.black
        alert.view.alpha = 0.6
        alert.view.layer.cornerRadius = 15

        controller.present(alert, animated: true)

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
        }
    } }
