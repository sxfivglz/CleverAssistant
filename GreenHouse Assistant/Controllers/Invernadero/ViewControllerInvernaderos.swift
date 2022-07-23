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
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "tableIdentifier")
        tableView.separatorColor = .green
        tableView.separatorStyle = .singleLine
       tableView.separatorInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if invernaderos.count == 0{
              let emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
              emptyLabel.text = "No se te ha asignado ningún invernadero. \n Por favor pide a tu administrador asignarte uno."
            emptyLabel.font = UIFont.systemFont(ofSize: 35)
            emptyLabel.numberOfLines =  0
            emptyLabel.textAlignment = NSTextAlignment.center
              self.tableView.backgroundView = emptyLabel
              self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
              return 0
          } else {
              self.tableView.backgroundView = nil
            return invernaderos.count
          }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableIdentifier", for: indexPath) as? TableViewCell
        let invernadero = invernaderos[indexPath.row]
        cell?.tituloLabel.text = String(invernadero.id)
        cell?.subtituloLabel.text = invernadero.nombre.capitalized
       
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 120
        }
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let invernadero = invernaderos[indexPath.row]
        let defaults = UserDefaults.standard
        defaults.setValue(invernadero.id, forKey: "Id_Invernadero")
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "EstSegue", sender: self)

        }
    }
    
    func downloadJSON(completed: @escaping () -> ()){
        let url = URL(string: myConection + "users_invernaderos/getInvernadero_Usuario")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        let tk:String = UserDefaults.standard.string(forKey: "Token")!
        request.addValue(tk, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request){ data, response, err in
            if err == nil {
                do {
                    self.invernaderos = try JSONDecoder().decode([InvernaderosClass].self, from: data!)
                    
                    DispatchQueue.main.async {
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
