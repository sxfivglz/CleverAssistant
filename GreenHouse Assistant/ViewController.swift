import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func IniciarSesion(_ sender: Any) {
        let correo:String? = String(emailField.text!)
        let contra:String? = String(passField.text!)
        
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
            let x:String = myConection + "login"
            guard let url = URL(string: x) else { return }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let body: [String: AnyHashable] = [
                "email": correo,
                "password": contra
            ]
            
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
            let task = URLSession.shared.dataTask(with: request){
                data, _, error in
                guard let data = data, error == nil else{
                    return
                }
                
                do{
                    let response = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    if let token = (response as AnyObject)["token"]! as? String
                    {
                        let defaults = UserDefaults.standard
                        let tk = "Bearer " + token
                        defaults.setValue(tk, forKey: "Token")
                        print(tk)
                    }
                }
                catch{
                    print(error)
                }
            }
            task.resume()
        }
        
        //let email = emailField.text
        //let password = passField.text
        /*request.httpMethod = "POST"
         request.setValue("application/json", forHTTPHeaderField: "Content-Type")
         
         let body: [String: AnyHashable] = [
             "email": correo,
             "password": contra
         ]
         
         request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)*/
        /*let dialogMessage = UIAlertController(title: "Campos vacíos", message: "Verifique que ambos campos estén llenos", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: {(action)-> Void in print("Ok button tapped")})
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)*/
        
       
    }
}
