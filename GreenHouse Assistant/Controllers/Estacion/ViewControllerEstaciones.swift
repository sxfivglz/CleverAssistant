import UIKit

class ViewControllerEstaciones: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    
    var estaciones = [EstacionesClass]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadJSON {
            self.tableView.reloadData()
            print("success")
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "tableIdentifier")
        tableView.separatorColor = .green
        tableView.separatorStyle = .singleLine
       tableView.separatorInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return estaciones.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableIdentifier", for: indexPath) as? TableViewCell
        let estacion = estaciones[indexPath.row]
        cell?.tituloLabel.text = String(estacion.id)
        cell?.subtituloLabel.text = estacion.nombre.capitalized
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 150
        }
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let estacion = estaciones[indexPath.row]
        let defaults = UserDefaults.standard
        defaults.setValue(estacion.id, forKey: "Id_Estacion")
        
        OperationQueue.main.addOperation {
             [weak self] in
            self?.performSegue(withIdentifier: "principalSegue", sender: self)
        }
    }
     
    func downloadJSON(completed: @escaping () -> ()){
        let Id_inv:String = UserDefaults.standard.string(forKey: "Id_Invernadero")!
        let url = URL(string: myConection + "invernaderos_estaciones/getEstaciones/" + Id_inv)
        print(url)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        let tk:String = UserDefaults.standard.string(forKey: "Token")!
        request.addValue(tk, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request){ data, response, err in
            if err == nil {
                do {
                    print("hola")
                    print (response)
                    print(data)
                    self.estaciones = try JSONDecoder().decode([EstacionesClass].self, from: data!)
                    DispatchQueue.main.async {
                        completed()
                    }
                }
                catch {
                    print("hola2")
                    print(response)
                    print(err)
                }
            }
        }.resume()
    }
}
