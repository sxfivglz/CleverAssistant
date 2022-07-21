import UIKit
import Foundation

class ViewControllerPerfil: UIViewController {

    @IBOutlet weak var telefonoTextField: UITextField!
    @IBOutlet weak var lastname2TextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var birthTextField: UIDatePicker!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var pinTextField: UITextField!
    @IBOutlet weak var editarBtn: UIButton!
    
    var usuarios = [UsuariosClass]()
    override func viewDidLoad() {
        super.viewDidLoad()
        editarBtn.layer.cornerRadius = 15
        editarBtn.layer.masksToBounds = true
        downloadJSON {
            print("success")
        }
        telefonoTextField.isUserInteractionEnabled = false
        lastnameTextField.isUserInteractionEnabled = false
        lastname2TextField.isUserInteractionEnabled = false
        birthTextField.isUserInteractionEnabled = false
        nameTextField.isUserInteractionEnabled = false
        passTextField.isUserInteractionEnabled = false
        pinTextField.isUserInteractionEnabled = false
        emailTextField.isUserInteractionEnabled = false
    }
    
    @IBAction func updateUser(_ sender: Any) {
    
    }

    /*------------------------------------------------------------------------------------------------------*/
   
    func downloadJSON(completed: @escaping () -> ()){
        let x:String = myConection + "getUser"
        guard let url = URL(string: x) else { return }
        var request = URLRequest(url:url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let tk:String = UserDefaults.standard.string(forKey: "Token")!
        request.addValue(tk, forHTTPHeaderField: "Authorization")
                
        let task = URLSession.shared.dataTask(with: request){
            data, _, error in
            guard let data = data, error == nil else{
                return
            }
            
            do{
                let response = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                if let nombre = (response as AnyObject)["nombre"]! as? String
                {
                    DispatchQueue.main.async {
                        self.nameTextField.text = nombre
                        let id_user = (response as AnyObject)["id"]! as? Int
                        let defaults = UserDefaults.standard
                        let usu = id_user
                        defaults.setValue(usu, forKey: "idUsuario")
                        self.emailTextField.text = (response as AnyObject)["email"]! as? String
                        self.lastnameTextField.text = (response as AnyObject)["apellido_paterno"]! as? String
                        self.lastname2TextField.text = (response as AnyObject)["apellido_materno"]! as? String
                        self.telefonoTextField.text = (response as AnyObject)["telefono"]! as? String
                        let pin:Int16 = ((response as AnyObject)["pin_acceso"]! as? Int16)!
                        let f = ((response as AnyObject)["fecha_nacimiento"]! as? String)!
                        let formato = DateFormatter()
                        formato.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                        formato.timeZone = NSTimeZone(name: "UTC")! as TimeZone
                        formato.formatterBehavior = .default
                        let dataU:Date = formato.date(from: f)!
                        self.birthTextField.date = dataU
                        self.pinTextField.text = String(pin)
                        
                    }
                }
                else{
                   var x:Int = 0
                   if let r = (response as AnyObject)["code"]! as? Int{
                        print(response)
                        x = r
                   }
                   OperationQueue.main.addOperation{
                                                
                   switch x {
                   case 410:
                       let dialogMessage = UIAlertController(title: "Error", message: "El Pin no coincide.", preferredStyle: .alert)
                       let ok = UIAlertAction(title: "Ok", style: .default, handler: {(action)-> Void in print("Ok button tapped")})
                       dialogMessage.addAction(ok)
                       self.present(dialogMessage, animated: true, completion: nil)
                   default:
                       let dialogMessage = UIAlertController(title: "Error", message: "No se que chuchas paso.", preferredStyle: .alert)
                       let ok = UIAlertAction(title: "Ok", style: .default, handler: {(action)-> Void in print("Ok button tapped")})
                       dialogMessage.addAction(ok)
                       self.present(dialogMessage, animated: true, completion: nil)
                   }
                }
                }
            }
            catch{
                print(error)
            }
        }.resume()
    }
}
    
