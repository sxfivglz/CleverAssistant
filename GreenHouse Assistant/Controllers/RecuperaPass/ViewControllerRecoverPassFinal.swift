//
//  ViewControllerRecoverPassFinal.swift
//  GreenHouse Assistant
//
//  Created by Mac19 on 20/07/22.
//

import UIKit

class ViewControllerRecoverPassFinal: UIViewController {

    @IBOutlet weak var codeField: UITextField!
    
    @IBOutlet weak var passField: UITextField!
    
    @IBOutlet weak var passFieldDos: UITextField!
    @IBOutlet weak var passBtn: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        passBtn.layer.cornerRadius = 15
        passBtn.layer.masksToBounds = true
        // Do any additional setup after loading the view.
        
    }
    @IBAction func cambiarPass(_ sender: Any) {
        let codigo:String? = String(codeField.text!)
        let passuno:String? = String(passField.text!)
        let passdos:String? = String(passFieldDos.text!)
        if codigo == ""{
            let dialogMessage = UIAlertController(title: "Campo vacío", message: "Verifique que el campo de correo no esté vacío", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .default, handler: {(action)-> Void in print("Ok button tapped")})
            dialogMessage.addAction(ok)
            self.present(dialogMessage, animated: true, completion: nil)
        } else if passuno == ""{
            let dialogMessage = UIAlertController(title: "Campo vacío", message: "Verifique que el campo de contraseña no esté vacío", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .default, handler: {(action)-> Void in print("Ok button tapped")})
            dialogMessage.addAction(ok)
            self.present(dialogMessage, animated: true, completion: nil)
        }else if passdos == ""{
            let dialogMessage = UIAlertController(title: "Campo vacío", message: "Verifique que el campo de confirmar contraseña no esté vacío", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .default, handler: {(action)-> Void in print("Ok button tapped")})
            dialogMessage.addAction(ok)
            self.present(dialogMessage, animated: true, completion: nil)
        }else if passdos != passuno{
            let dialogMessage = UIAlertController(title: "Contraseña fallida", message: "Las contraseñas no coinciden", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .default, handler: {(action)-> Void in print("Ok button tapped")})
            dialogMessage.addAction(ok)
            self.present(dialogMessage, animated: true, completion: nil)
        }else{
            let x:String = myConection + "cambiarPass"
            guard let url = URL(string: x) else { return }
            var request = URLRequest(url:url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let correo:String = UserDefaults.standard.string(forKey: "usuariopass")!
            let body: [String: AnyHashable] = [
                "email": correo,
                "pin": codigo,
                "password": passuno
            ]
            
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
            let task = URLSession.shared.dataTask(with: request){
                data, _, error in
                guard let data = data, error == nil else{
                    return
                }
                
                do{
                    let response = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    if let token = (response as AnyObject)["message"]! as? String
                    {
                        let dialogMessage = UIAlertController(title: "UWU", message: "El Correo Electronico que ha ingresado no existe, verifiquelo.", preferredStyle: .alert)
                        let ok = UIAlertAction(title: "Ok", style: .default, handler: {(action)-> Void in print("Ok button tapped")})
                        dialogMessage.addAction(ok)
                        self.present(dialogMessage, animated: true, completion: nil)
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
            }
            task.resume()
        }
        }
    }
    
