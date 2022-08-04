import UIKit

class ViewControllerRegistro: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastName1TextField: UITextField!
    @IBOutlet weak var lastName2TextField: UITextField!
    @IBOutlet weak var birthPicker: UIDatePicker!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var pinTextField: UITextField!
    @IBOutlet weak var registerBtn: UIButton!
    var maxLength:Int
        = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        registerBtn.layer.cornerRadius = 15
        registerBtn.layer.masksToBounds = true
        pinTextField.delegate = self
        
        
    }
    
    @IBAction func Registrar(_ sender: Any) {
        let nombre:String? = String(nameTextField.text!)
        let apellido_paterno:String? = String(lastName1TextField.text!)
        let apellido_materno:String? = String(lastName2TextField.text!)
        let telefono:String? = String(phoneTextField.text!)
        let correo:String? = String(emailTextField.text!)
        let contra:String? = String(passTextField.text!)
        let pin_acceso:String? = String(pinTextField.text!)
        
        birthPicker.datePickerMode = UIDatePicker.Mode.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let fechaNac = dateFormatter.string(from: birthPicker.date)
        print("----")
        print(fechaNac)
        print("----")
        
         if correo == ""{
             let dialogMessage = UIAlertController(title: "Campo vacío", message: "Verifique que el campo de correo no esté vacío", preferredStyle: .alert)
             let ok = UIAlertAction(title: "Ok", style: .default, handler: {(action)-> Void in print("Ok button tapped")})
             dialogMessage.addAction(ok)
             self.present(dialogMessage, animated: true, completion: nil)
         }
         else if contra == "" {
             let dialogMessage = UIAlertController(title: "Campo vacío", message: "Verifique que el campo de contraseña no esté vacío", preferredStyle: .alert)
             let ok = UIAlertAction(title: "Ok", style: .default, handler: {(action)-> Void in print("Ok button tapped")})
             dialogMessage.addAction(ok)
             self.present(dialogMessage, animated: true, completion: nil)
         }
         else{
            let x:String = myConection + "registerUsers"
            guard let url = URL(string: x) else { return }
             
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
             
            let body: [String: AnyHashable] = [
                "email": correo,
                "password": contra,
                "nombre": nombre,
                "apellido_paterno": apellido_paterno,
                "apellido_materno": apellido_materno,
                "tipo_usuario": "Usuario",
                "estatus": "Activo",
                "telefono": telefono,
                "pin_acceso": pin_acceso,
                "fecha_nacimiento": fechaNac,
                "fecha_activo": "2030-01-01"
             ]
             /* */
             request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
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
                           /* let dialogMessage = UIAlertController(title: "Usuario", message: "Usuario registrado con exito!", preferredStyle: .alert)
                            let ok = UIAlertAction(title: "Ok", style: .default, handler: {(action)-> Void in print("Ok button tapped")})
                            dialogMessage.addAction(ok)
                            self.present(dialogMessage, animated: true, completion: nil)*/
                            self.mostrarAlerta()
                            /*let alertController = UIAlertController(title: "Congratulation", message: "You have successfully signed up", preferredStyle: .alert)
                             alertController.addAction(UIAlertAction(title: "Get Started", style: .default, handler: { (action:UIAlertAction) in

                                 self.performSegue(withIdentifier: "back2SignPage", sender: self)
                             }))*/
                        
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
       
    }
    func mostrarAlerta() {
        let alert = UIAlertController(title: "Usuario", message: "El usuario se ha registrado exitosamente",         preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Ok",
                                          style: UIAlertAction.Style.default,
                                          handler: {(_: UIAlertAction!) in
                                            self.performSegue(withIdentifier: "unwindInicioSesion", sender: self)
            }))
            self.present(alert, animated: true, completion: nil)
        }
   
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool
    {
        let maxLength = 6
        let currentString: NSString = pinTextField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
}
