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
    
    @IBOutlet weak var signOutBtn: UIButton!
    
    var usuarios = [UsuariosClass]()
    override func viewDidLoad() {
        super.viewDidLoad()
        editarBtn.layer.cornerRadius = 15
        editarBtn.layer.masksToBounds = true
        signOutBtn.layer.cornerRadius = 15
        signOutBtn.layer.masksToBounds = true
        recuperaDatos {
            print("Datos Recuperados")
        }
    }
    
    @IBAction func cerrarSesion(_ sender: Any) {
            let x:String = myConection + "logout"
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
                       let msg = (response as AnyObject)["revoked"]! as? Int
                       if msg == 1
                        {
                           OperationQueue.main.addOperation {
                               self.mostrarAlerta()
                           }
                        
                        }
                        else{
                           print("error -----")
                           print(response)
                           print("error -----")
                           var x:Int = 0
                           if let r = (response as AnyObject)["code"]! as? Int{
                               x = r
                           }
                           OperationQueue.main.addOperation{
                                                        
                           switch x {
                           case 1:
                               let dialogMessage = UIAlertController(title: "Error", message: "Verifique su conexion a interne.", preferredStyle: .alert)
                               let ok = UIAlertAction(title: "Ok", style: .default, handler: {(action)-> Void in print("Ok button tapped")})
                               dialogMessage.addAction(ok)
                               self.present(dialogMessage, animated: true, completion: nil)
                           default:
                               let dialogMessage = UIAlertController(title: "Error", message: "Error del servidor", preferredStyle: .alert)
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
                }
                task.resume()
}
    
    @IBAction func updateUser(_ sender: Any) {
        let email:String? = String(emailTextField.text!)
        let pass:String? = String(passTextField.text!)
        let nombre:String? = String(nameTextField.text!)
        let apellido_paterno:String? = String(lastnameTextField.text!)
        let apellido_materno:String? = String(lastname2TextField.text!)
        let telefono:String? = String(telefonoTextField.text!)
        birthTextField.datePickerMode = UIDatePicker.Mode.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let fechaNac = dateFormatter.string(from: birthTextField.date)
        
        let codigo:String? = String(pinTextField.text!)
        
        if nombre == ""{
            let dialogMessage = UIAlertController(title: "Campo vacío", message: "Verifique que el campo de nombre no esté vacío", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .default, handler: {(action)-> Void in print("Ok button tapped")})
            dialogMessage.addAction(ok)
            self.present(dialogMessage, animated: true, completion: nil)
        }else if email == ""{
            let dialogMessage = UIAlertController(title: "Campo vacío", message: "Verifique que el campo de Email no esté vacío", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .default, handler: {(action)-> Void in print("Ok button tapped")})
            dialogMessage.addAction(ok)
            self.present(dialogMessage, animated: true, completion: nil)
        }else if apellido_paterno == ""{
            let dialogMessage = UIAlertController(title: "Campo vacío", message: "Verifique que el campo de apellido paterno no esté vacío", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .default, handler: {(action)-> Void in print("Ok button tapped")})
            dialogMessage.addAction(ok)
            self.present(dialogMessage, animated: true, completion: nil)
        }else if apellido_materno == ""{
            let dialogMessage = UIAlertController(title: "Campo vacío", message: "Verifique que el campo de apellido materno no esté vacío", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .default, handler: {(action)-> Void in print("Ok button tapped")})
            dialogMessage.addAction(ok)
            self.present(dialogMessage, animated: true, completion: nil)
        }else if telefono == ""{
            let dialogMessage = UIAlertController(title: "Campo vacío", message: "Verifique que el campo de teléfono no esté vacío", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .default, handler: {(action)-> Void in print("Ok button tapped")})
            dialogMessage.addAction(ok)
            self.present(dialogMessage, animated: true, completion: nil)
        }else if codigo == ""{
            let dialogMessage = UIAlertController(title: "Campo vacío", message: "Verifique que el campo de pin de acceso no esté vacío", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .default, handler: {(action)-> Void in print("Ok button tapped")})
            dialogMessage.addAction(ok)
            self.present(dialogMessage, animated: true, completion: nil)
        }else{
            let Id_user:String = UserDefaults.standard.string(forKey: "idUsuario")!
            print(Id_user)
            let x:String = (myConection + "users/update/"+Id_user)
            guard let url = URL(string: x) else { return }
            print(url)
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let tk:String = UserDefaults.standard.string(forKey: "Token")!
            request.addValue(tk, forHTTPHeaderField: "Authorization")
            let body: [String: AnyHashable] = [
                "email": email,
                "password": pass,
                "nombre": nombre,
                "apellido_paterno": apellido_paterno,
                "apellido_materno": apellido_materno,
                "tipo_usuario": "Usuario",
                "estatus": "Activo",
                "telefono": telefono,
                "fecha_nacimiento": fechaNac,
                "pin_acceso":codigo
            ]
            
            request.httpBody = try?
                JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
            print(body)
            print(request)
                let task = URLSession.shared.dataTask(with: request){
                    data, _, error in
                    guard let data = data, error == nil else{
                        return
                    }
                    
                    do{
                        let response = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                        let msg = (response as AnyObject)["message"]! as? String
                        if msg == "ok"
                        {
                            OperationQueue.main.addOperation {
                                let dialogMessage = UIAlertController(title: "Usuario", message: "El usuario ha sido modificado con exito.", preferredStyle: .alert)
                                let ok = UIAlertAction(title: "Ok", style: .default, handler: {(action)-> Void in print("Ok button tapped")})
                                dialogMessage.addAction(ok)
                                self.present(dialogMessage, animated: true, completion: nil)
                            }
                        } else {
                            print("error -----")
                            print(response)
                            print("error -----")
                            var x:Int = 0
                            if let r = (response as AnyObject)["code"]! as? Int{
                                x = r
                            }
                            OperationQueue.main.addOperation{
                                switch x {
                                    case 1:
                                        let dialogMessage = UIAlertController(title: "Error", message: "El Correo Electronico que ha ingresado no existe, verifiquelo.", preferredStyle: .alert)
                                        let ok = UIAlertAction(title: "Ok", style: .default, handler: {(action)-> Void in print("Ok button tapped")})
                                        dialogMessage.addAction(ok)
                                        self.present(dialogMessage, animated: true, completion: nil)
                                    case 2:
                                        let dialogMessage = UIAlertController(title: "Error", message: "La contraseña no coincide, verifiquelo.", preferredStyle: .alert)
                                        let ok = UIAlertAction(title: "Ok", style: .default, handler: {(action)-> Void in print("Ok button tapped")})
                                        dialogMessage.addAction(ok)
                                        self.present(dialogMessage, animated: true, completion: nil)
                                    default:
                                        let dialogMessage = UIAlertController(title: "Error", message: "Algo anda mal", preferredStyle: .alert)
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
                }
                task.resume()
            }
    }
    
    func recuperaDatos(completed: @escaping () -> ()){
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
    
    
    func mostrarAlerta() {
        let alert = UIAlertController(title: "Cierre sesión", message: "La sesión se ha cerrado correctamente",         preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Ok",
                                          style: UIAlertAction.Style.default,
                                          handler: {(_: UIAlertAction!) in
                                            self.performSegue(withIdentifier: "unwindCerrarSesion", sender: self)
            }))
            self.present(alert, animated: true, completion: nil)
        }
}
