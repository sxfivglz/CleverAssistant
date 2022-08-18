import UIKit

class ViewControllerBomba: UIViewController {
    @IBOutlet weak var btnOn: UIButton!
    @IBOutlet weak var btnOff: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        btnOn.layer.cornerRadius = btnOn.bounds.size.height/2
        btnOff.layer.cornerRadius = btnOff.bounds.size.height/2

    
    }
    
    @IBAction func Encender(_ sender: Any) {
        btnOff.isUserInteractionEnabled = false
        let x:String = myConection + "bomba/create"
        guard let url = URL(string: x) else { return }
        let Id_estacion:String = UserDefaults.standard.string(forKey: "Id_Estacion")!
        let Id_user:String = UserDefaults.standard.string(forKey: "idUsuario")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let tk:String = UserDefaults.standard.string(forKey: "Token")!
        request.addValue(tk, forHTTPHeaderField: "Authorization")
        let body: [String: AnyHashable] = [
            "estacion": Id_estacion,
            "id_usuario": Id_user
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        let task = URLSession.shared.dataTask(with: request){
            data, _, error in
            guard let data = data, error == nil else{
                return
            }
            do{
                print(2)
                let response = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                print(response)
                print(3)
                if let token = (response as AnyObject)["_id"]! as? String
                {
                    
                    DispatchQueue.main.async {
                        self.showToastEncendido(controller: self, message: "La bomba de la estación \(Id_estacion) se ha encendido.", seconds: 2.0)
                        self.btnOff.isUserInteractionEnabled = true
                        self.btnOn.isUserInteractionEnabled = false
                        self.btnOff.isEnabled = true
                        self.btnOn.isEnabled = false
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
                                let dialogMessage = UIAlertController(title: "Error", message: "Revisa tu conexión a internet e intenta de nuevo.", preferredStyle: .alert)
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
    
    @IBAction func Apagar(_ sender: Any) {
        btnOn.isUserInteractionEnabled = false
        let Id_user:String = UserDefaults.standard.string(forKey: "idUsuario")!
        let Id_estacion:String = UserDefaults.standard.string(forKey: "Id_Estacion")!
        let x:String = (myConection + "bomba/apagar")
        guard let url = URL(string: x) else { return }
        print(url)
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let tk:String = UserDefaults.standard.string(forKey: "Token")!
        request.addValue(tk, forHTTPHeaderField: "Authorization")
        let body: [String: AnyHashable] = [
            "estacion": Id_estacion
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
                            self.showToastApagado(controller: self, message: "La bomba de la estación \(Id_estacion) se ha apagado.", seconds: 2.0)
                            self.btnOn.isUserInteractionEnabled = true
                            self.btnOff.isUserInteractionEnabled = false
                            self.btnOn.isEnabled = true
                            self.btnOff.isEnabled = false
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
                                    let dialogMessage = UIAlertController(title: "Error", message: "Revisa tu conexión a internet e intenta de nuevo.", preferredStyle: .alert)
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
    

extension UIViewController {

        func showToastEncendido(controller: UIViewController, message : String, seconds: Double) {
        let alert = UIAlertController(title: "¡Aviso!", message: message, preferredStyle: .alert)
        alert.view.backgroundColor = UIColor.systemGreen
        alert.view.alpha = 0.6
        alert.view.layer.cornerRadius = 15

        controller.present(alert, animated: true)

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
        }
    }
    
    
    func showToastApagado(controller: UIViewController, message : String, seconds: Double) {
    let alert = UIAlertController(title: "¡Aviso!", message: message, preferredStyle: .alert)
    alert.view.backgroundColor = UIColor.systemRed
    alert.view.alpha = 0.6
    alert.view.layer.cornerRadius = 15

    controller.present(alert, animated: true)

    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
        alert.dismiss(animated: true)
    }
}

    
}
