import UIKit
class ViewControllerHistorial: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate {
    //TextFields
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var invernaderoTextField: UITextField!
    @IBOutlet weak var estacionTextField: UITextField!
    @IBOutlet weak var tipoestacionTextField: UITextField!
    @IBOutlet weak var usuarioTextField: UITextField!
    @IBOutlet weak var fechainicioTextField: UITextField!
    @IBOutlet weak var fechafinTextField: UITextField!
    @IBOutlet weak var buscarBtn: UIButton!
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
    var usuarioArray = ["u1","u2","u3"]
    var historial = [HistorialClass]()
    var idInv:Int = 0
    var Inv:String = ""
    var idEst:Int = 0
    var Est:String = ""
    var TipoAct:String = ""
    var FechaInicio:String = ""
    var FechaFin:String = ""
    //Datos
    var inver:String?
    var esta:String?
    var usua:String?
    var fecha:String?
    var tpa:String?
    var va1:Double?
    var va2:Double?
    var va3:Double?
    var va4:Double?
    var va5:Double?
    var va6:Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rellenaInvernadero{
            print("success")
        }
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
        cell?.estacionLabel.text = hist.Estacion
        cell?.invernaderoLabel.text = hist.Invernadero
        cell?.fechaLabel.text = hist.Fecha
        cell?.usuarioLabel.text = hist.Id_Usuario
        cell?.tipoactLabel.text = hist.Tipo_Activacion
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 280
        }
        return 280
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let hist = historial[indexPath.row]
        inver = hist.Invernadero
        esta = hist.Estacion
        usua = hist.Id_Usuario
        fecha = hist.Fecha
        tpa = hist.Tipo_Activacion
        va1 = hist.Valor1
        va2 = hist.Valor2
        va3 = hist.Valor3
        va4 = hist.Valor4
        va5 = hist.Valor5
        va6 = hist.Valor6
        
        self.performSegue(withIdentifier: "HistSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HistSegue" {
            let destinationVC = segue.destination as! ViewControllerHistorialFinal
            destinationVC.inv = inver!
            destinationVC.est = esta!
            destinationVC.usu = usua!
            destinationVC.fecha = fecha!
            destinationVC.ta = tpa!
            destinationVC.v1 = va1!
            destinationVC.v2 = va2!
            destinationVC.v3 = va3!
            destinationVC.v4 = va4!
            destinationVC.v5 = va5!
            destinationVC.v6 = va6!
        }
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
            "invernadero": Inv,
            "estacion": Est,
            "tipo_activacion": TipoAct,
            "id_usuario": "Todos",
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
            return usuarioArray.count
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
            return usuarioArray[row]
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
            usuarioTextField.text = usuarioArray[row]
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
