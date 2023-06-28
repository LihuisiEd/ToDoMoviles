//
//  CreateTaskViewController.swift
//  ToDoMoviles
//
//  Created by Mac 13 on 28/06/23.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class CreateTaskViewController: UIViewController {

    
    
    
    @IBOutlet weak var btbAgregar: UIButton!
    @IBOutlet weak var txtFecha: UIDatePicker!
    @IBOutlet weak var txtContenido: UITextField!
    @IBOutlet weak var txtTitulo: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
	
    }
    

    @IBAction func agregarTarea(_ sender: Any) {
        //Database.database().reference().child(<#T##pathString: String##String#>)
    }


}
