//
//  ViewControllerInvernaderos.swift
//  GreenHouse Assistant
//
//  Created by Mac19 on 12/07/22.
//

import UIKit

class ViewControllerInvernaderos: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var invernaderos = [InvernaderosClass]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        downloadJSON {
            self.tableView.reloadData()
            print("success")
        }
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invernaderos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        
        let invernadero = invernaderos[indexPath.row]
        cell.textLabel?.text = String(invernadero.id)
        cell.detailTextLabel?.text = invernadero.nombre.capitalized
        
        return cell
    }
    
    func downloadJSON(completed: @escaping () -> ()){
        let url = URL(string: myConection + "users_invernaderos/getInvernadero_Usuario")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        let tk:String = UserDefaults.standard.string(forKey: "Token")!
        request.addValue(tk, forHTTPHeaderField: "Authorization")
        print(tk)
        
        URLSession.shared.dataTask(with: request){ data, response, err in
            if err == nil {
                do {
                    print("hola")
                    print(response)
                    print(data)
                    self.invernaderos = try JSONDecoder().decode([InvernaderosClass].self, from: data!)
                    
                    DispatchQueue.main.async {
                        print("Hola2")
                        completed()
                    }
                }
                catch {
                    print("Error api")
                }
            }
        }.resume()
    }
}
