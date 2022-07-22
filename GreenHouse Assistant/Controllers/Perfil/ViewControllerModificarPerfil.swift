//
//  ViewControllerModificarPerfil.swift
//  GreenHouse Assistant
//
//  Created by Mac19 on 21/07/22.
//

import UIKit

class ViewControllerModificarPerfil: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var lastName2TextField: UITextField!
    @IBOutlet weak var telefonoTextField: UITextField!
    @IBOutlet weak var birthPicker: UIDatePicker!
    @IBOutlet weak var pinTextField: UITextField!
    @IBOutlet weak var guardarBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        guardarBtn.layer.cornerRadius = 15
        guardarBtn.layer.masksToBounds = true
    }
 
    @IBAction func guardarCambios(_ sender: Any) {
  
        let nombre:String? = String(nameTextField.text!)
        let apellido_paterno:String? = String(lastNameTextField.text!)
        let apellido_materno:String? = String(lastName2TextField.text!)
        let telefono:String? = String(telefonoTextField.text!)
        birthPicker.datePickerMode = UIDatePicker.Mode.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let fechaNac = dateFormatter.string(from: birthPicker.date)
        print("----")
        print(fechaNac)
        print("----")
        let codigo:String? = String(pinTextField.text!)
        
        if nombre == ""{
            let dialogMessage = UIAlertController(title: "Campo vacío", message: "Verifique que el campo de nombre no esté vacío", preferredStyle: .alert)
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
                "nombre": nombre,
                "apellido_paterno": apellido_paterno,
                "apellido_materno": apellido_materno,
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
                            self.mostrarAlerta()
                        }
                        
                       }else{
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
    func mostrarAlerta() {
        let alert = UIAlertController(title: "Usuario", message: "El usuario se ha editado exitosamente",         preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Ok",
                                          style: UIAlertAction.Style.default,
                                          handler: {(_: UIAlertAction!) in
                                            self.performSegue(withIdentifier: "unwindPerfil", sender: self)
            }))
            self.present(alert, animated: true, completion: nil)
        }
}
