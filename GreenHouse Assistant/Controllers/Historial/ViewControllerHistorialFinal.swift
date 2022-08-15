import UIKit
class ViewControllerHistorialFinal: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
    @IBOutlet weak var invernaderoLabel: UILabel!
    @IBOutlet weak var estacionLabel: UILabel!
    @IBOutlet weak var usuarioLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var fechaLabel: UILabel!
    @IBOutlet weak var tipoactLabel: UILabel!
    var detalle = [HistorialClass]()
    var _idHist:String = ""
    var inv:String = ""
    var est:String = ""
    var usu:String = ""
    var fecha:String = ""
    var ta:String = ""
    let sens: [HistorialClass.Sensores] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        print(detalle)
        invernaderoLabel.text = "Invernadero: \(inv)"
        estacionLabel.text = "Estación: \(est)"
        let f:String = fecha
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: f)
        dateFormatter.dateFormat = "dd-MM-yyyy, HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        let resultString = dateFormatter.string(from: date!)
        fechaLabel.text = "Fecha y hora: \(resultString)"
        usuarioLabel.text = "Usuario: \(usu)"
        tipoactLabel.text = "Tipo de activación: \(ta)"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "TableViewCellHFinal", bundle: nil), forCellReuseIdentifier: "tableIdentifierHF")
        tableView.separatorColor = .green
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if detalle[section].Sensores.count == 0 {
            let emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
            emptyLabel.text = "No se encontraron resultados."
            emptyLabel.textColor = .white
            emptyLabel.font = UIFont.systemFont(ofSize: 35)
            emptyLabel.numberOfLines =  0
            emptyLabel.textAlignment = NSTextAlignment.center
            self.tableView.backgroundView = emptyLabel
            self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
            return 0
        } else {
            self.tableView.backgroundView = nil
            return detalle[section].Sensores.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableIdentifierHF", for: indexPath) as? TableViewCellHFinal
        let dh = detalle[indexPath.section].Sensores[indexPath.row]
        print("---------------------------------------------")
    if(dh.tipo == "Temperatura"){
        cell?.labelSensor.text = "Nombre del sensor: " + (dh.nombre)
        cell?.labelValor.text = "Valor del sensor: " + (String(dh.valor))+"°C"
    }else if (dh.tipo == "Caudal"){
        cell?.labelSensor.text = "Nombre del sensor: " + (dh.nombre)
        cell?.labelValor.text = "Valor del sensor: " + (String(dh.valor))+"L/Mn"
    }else if (dh.tipo == "Gas"){
        cell?.labelSensor.text = "Nombre del sensor: " + (dh.nombre)
        cell?.labelValor.text = "Valor del sensor: " + (String(dh.valor))+"ppm"
    }else if (dh.tipo == "Humedad"){
        cell?.labelSensor.text = "Nombre del sensor: " + (dh.nombre)
        cell?.labelValor.text = "Valor del sensor: " + (String(dh.valor))+"kPa"
    }else if (dh.tipo == "Fotoresistencia"){
        cell?.labelSensor.text = "Nombre del sensor: " + (dh.nombre)
        cell?.labelValor.text = "Valor del sensor: " + (String(dh.valor))+"kΩ"
    }
        return cell!
}
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 200
        }
        return 200
    }
    
}


