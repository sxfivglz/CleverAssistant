//
//  ViewControllerBomba.swift
//  GreenHouse Assistant
//
//  Created by Mac19 on 20/07/22.
//

import UIKit

class ViewControllerBomba: UIViewController {

    @IBOutlet weak var btnOn: UIButton!
    @IBOutlet weak var btnOff: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        btnOn.frame = CGRect(x: 360, y: 300, width: 304, height: 160)
          btnOn.layer.cornerRadius = 0.5 * btnOn.bounds.size.width
          btnOn.clipsToBounds = true
        
        btnOff.frame = CGRect(x: 360, y: 300, width: 304, height: 160)
          btnOff.layer.cornerRadius = 0.5 * btnOff.bounds.size.width
          btnOff.clipsToBounds = true
    
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
