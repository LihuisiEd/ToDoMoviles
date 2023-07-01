//
//  RegisterViewController.swift
//  ToDoMoviles
//
//  Created by Eduardo Lihuisi on 28/06/23.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class RegisterViewController: UIViewController {
    
    
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBAction func btnRegister(_ sender: Any) {
        Auth.auth().createUser(withEmail: self.txtEmail.text!, password: self.txtPassword.text!, completion: {(user, error) in
            print("Intentando crear un usuario")
            if error != nil{
                print("Se presentó un error")
            }else{
                print("El usuario fue creado exitosamente")
                Database.database().reference().child("usuarios").child("email").setValue(user!.user.email)
                
                let alerta = UIAlertController(title: "Creación de Usuario", message: "Usuario \(self.txtUsername.text!) se creó correctamente", preferredStyle: .alert)
                let btnOK = UIAlertAction(title: "Aceptar", style: .default) { (UIAlertAction) in
                    self.performSegue(withIdentifier: "inicioSesionSegue", sender: nil)
                    }
                alerta.addAction(btnOK)
                self.present(alerta, animated: true, completion: nil)
            }
        })
    }
    
    @IBAction func btnIniciarSesion(_ sender: Any) {
        self.performSegue(withIdentifier: "iniciarsesionSegue", sender: nil)
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
}
    


