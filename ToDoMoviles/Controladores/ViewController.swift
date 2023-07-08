//
//  ViewController.swift
//  ToDoMoviles
//
//  Created by Eduardo Lihuisi on 15/06/23.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import GoogleSignIn
import FirebaseCore

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
                UserDefaults.standard.set(self.txtEmail.text, forKey: "email")
                UserDefaults.standard.set(self.txtPassword.text, forKey: "password")
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                self.performSegue(withIdentifier: "iniciarsesionSegue", sender: nil)
            }
        }
    }
    
    @IBAction func btnRegister(_ sender: Any) {
        self.performSegue(withIdentifier: "registroSegue", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let email = UserDefaults.standard.string(forKey: "email"),
               let password = UserDefaults.standard.string(forKey: "password") {
                txtEmail.text = email
                txtPassword.text = password
            }
        if UserDefaults.standard.bool(forKey: "isLoggedIn") {
            autenticarUsuario()
        }
        
    }
    
    @IBAction func btnGoogle(_ sender: Any) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
          guard error == nil else {
            return
          }

          guard let user = result?.user,
            let idToken = user.idToken?.tokenString
          else {
            return
          }

          let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                         accessToken: user.accessToken.tokenString)

            Auth.auth().signIn(with: credential) { result, error in
                self.performSegue(withIdentifier: "iniciarsesionSegue", sender: nil)
            }

        }
                    
    }
    
    func autenticarUsuario() {
        // Obtener las credenciales guardadas en UserDefaults
        guard let email = UserDefaults.standard.string(forKey: "email"),
              let password = UserDefaults.standard.string(forKey: "password") else {
            // No se encontraron las credenciales en UserDefaults, mostrar pantalla de inicio de sesión
            return
        }
        
        // Autenticar al usuario con las credenciales guardadas
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                // Error al autenticar al usuario, mostrar pantalla de inicio de sesión
            } else {
                // Autenticación exitosa, realizar la transición a la pantalla principal de la app
                self.performSegue(withIdentifier: "iniciarsesionSegue", sender: nil)
            }
        }
    }
    

}

