import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func IniciarSesion(_ sender: Any) {
        let x:String = myConection + "login"
        guard let url = URL(string: x) else { return }
        
        var request = URLRequest(url: url)
        
        let email = emailField.text
        let password = passField.text
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: AnyHashable] = [
            "email": email,
            "password": password
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
}
