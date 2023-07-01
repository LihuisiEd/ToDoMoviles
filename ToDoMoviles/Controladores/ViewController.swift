//
//  ViewController.swift
//  ToDoMoviles
//
//  Created by Eduardo Lihuisi on 15/06/23.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBAction func btnLogin(_ sender: Any) {
        Auth.auth().signIn(withEmail: txtEmail.text!, password: txtPassword.text!) { (user, error) in
            print("Intentando Iniciar Sesión")
            if error != nil{
                print("Se presentó el siguiente error \(error)")
                let alerta = UIAlertController(title: "Creación de Usuario", message: "Usuario no registrado, ¿desea registrarlo?", preferredStyle: .alert)
                let btnOK = UIAlertAction(title: "Crear", style: .default) { (UIAlertAction) in
                    self.performSegue(withIdentifier: "registroSegue", sender: nil)
                    }
                let btnCANCEL = UIAlertAction(title: "Cancelar", style: .cancel) { (UIAlertAction) in
                    alerta.dismiss(animated: true, completion: nil)
                    }
                alerta.addAction(btnOK)
                alerta.addAction(btnCANCEL)
                self.present(alerta, animated: true, completion: nil)
            }else{
                print("Inicio de sesión exitoso")
                self.performSegue(withIdentifier: "iniciarsesionSegue", sender: nil)
            }
        }
    }
    
    @IBAction func btnRegister(_ sender: Any) {
        self.performSegue(withIdentifier: "registroSegue", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }


}

