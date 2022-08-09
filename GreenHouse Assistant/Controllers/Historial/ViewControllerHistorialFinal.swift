import UIKit

class ViewControllerHistorialFinal: UIViewController {
  
    @IBOutlet weak var invernaderoLabel: UILabel!
    @IBOutlet weak var estacionLabel: UILabel!
    @IBOutlet weak var usuarioLabel: UILabel!
    @IBOutlet weak var fechaLabel: UILabel!
    @IBOutlet weak var tipoactLabel: UILabel!
    @IBOutlet weak var valor1Label: UILabel!
    @IBOutlet weak var valor2Label: UILabel!
    @IBOutlet weak var valor3Label: UILabel!
    @IBOutlet weak var valor4Label: UILabel!
    @IBOutlet weak var valor5Label: UILabel!
    @IBOutlet weak var valor6Label: UILabel!
    
    var inv:String = ""
    var est:String = ""
    var usu:String = ""
    var fecha:String = ""
    var ta:String = ""
    var v1:Double = 0.00
    var v2:Double = 0.00
    var v3:Double = 0.00
    var v4:Double = 0.00
    var v5:Double = 0.00
    var v6:Double = 0.00

    override func viewDidLoad() {
        super.viewDidLoad()
        invernaderoLabel.text = "Invernadero: \(inv)"
        estacionLabel.text = "Estación: \(est)"
        let formato = DateFormatter()
        formato.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formato.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        formato.formatterBehavior = .default
        let dataU:Date = formato.date(from: fecha)!
        fechaLabel.text = "Fecha: \(dataU)"
        usuarioLabel.text = "Usuario: \(usu)"
        tipoactLabel.text = "Tipo de activación: \(ta)"
        valor1Label.text = "Valor 1: \(v1)"
        valor2Label.text = "Valor 2: \(v2)"
        valor3Label.text = "Valor 3: \(v3)"
        valor4Label.text = "Valor 4: \(v4)"
        valor5Label.text = "Valor 5: \(v5)"
        valor6Label.text = "Valor 6: \(v6)"
    }
}
