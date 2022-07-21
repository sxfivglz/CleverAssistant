//
//  ViewControllerRecoverPass.swift
//  GreenHouse Assistant
//
//  Created by Mac19 on 06/07/22.
//

import UIKit

class ViewControllerRecoverPass: UIViewController {

    @IBOutlet weak var codeBtn: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        codeBtn.layer.cornerRadius = 15
        codeBtn.layer.masksToBounds = true
    }
   
    @IBAction func enviarCodigo(_ sender: Any) {
        let correo:String? = String(emailTextField.text!)
        if correo == ""{
            let dialogMessage = UIAlertController(title: "Campo vacío", message: "Verifique que el campo de correo no esté vacío", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .default, handler: {(action)-> Void in print("Ok button tapped")})
            dialogMessage.addAction(ok)
            self.present(dialogMessage, animated: true, completion: nil)
        }else{
            let x:String = myConection + "recuperaPass"
            guard let url = URL(string: x) else { return }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let body: [String: AnyHashable] = [
                "email": correo,
            ]
            
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
            let task = URLSession.shared.dataTask(with: request){
                data, _, error in
                guard let data = data, error == nil else{
                    return
                }
                
                do{
                    let response = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    if let email = (response as AnyObject)["usuario"]! as? String
                    {
                        let defaults = UserDefaults.standard
                        let mail = email
                        defaults.setValue(mail, forKey: "usuariopass")
                        
                       
                  /* OperationQueue.main.addOperation {
                           [weak self] in
                       self?.performSegue(withIdentifier: "InvSegue", sender: self)
                       }*/
                       DispatchQueue.main.async {
                           self.performSegue(withIdentifier: "recover2Segue", sender: self)

                       }
                     
                    }
                    else{
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

    
