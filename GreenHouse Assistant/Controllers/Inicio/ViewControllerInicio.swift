//
//  ViewControllerInicio.swift
//  GreenHouse Assistant
//
//  Created by Mac19 on 16/08/22.
//

import UIKit

class ViewControllerInicio: UIViewController {

    @IBOutlet weak var vistaBomba: UIView!
    @IBOutlet weak var vistaSensores: UIView!
    @IBOutlet weak var vistaHistorial: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            if vistaBomba == touch.view{
                self.performSegue(withIdentifier: "segueBomba", sender: self)
            }else if vistaSensores == touch.view{
                self.performSegue(withIdentifier: "segueSensor", sender: self)
            }else if vistaHistorial == touch.view{
                self.performSegue(withIdentifier: "segueFiltros", sender: self)
            }
        }
    }
}

