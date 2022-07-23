import UIKit

class ViewControllerBomba: UIViewController {
    @IBOutlet weak var btnOn: UIButton!
    @IBOutlet weak var btnOff: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        btnOn.layer.cornerRadius = btnOn.bounds.size.height/2
        btnOff.layer.cornerRadius = btnOff.bounds.size.height/2
    
    }
}
