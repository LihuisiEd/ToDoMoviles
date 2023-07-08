//
//  CreateTaskViewController.swift
//  ToDoMoviles
//
//  Created by Mac 13 on 28/06/23.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class CreateTaskViewController: UIViewController, UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
            if textView.text == "Escribe aquí..." {
                textView.text = ""
                textView.textColor = UIColor.darkGray
            }
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            if textView.text.isEmpty {
                textView.text = "Escribe aquí..."
                textView.textColor = UIColor.lightGray
            } else {
                textView.textColor = UIColor.darkGray
            }
        }

    var tareaPut: Tarea?
    let database = Database.database().reference()

    
    @IBOutlet weak var btnActualizar: UIButton!
    @IBOutlet weak var btbAgregar: UIButton!
    @IBOutlet weak var txtFecha: UIDatePicker!
    
    @IBOutlet weak var txtContenido: UITextView!
    
    @IBOutlet weak var txtTitulo: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        txtContenido.text = "Escribe aquí..."
        txtContenido.delegate = self
        if tareaPut == nil{
                    btbAgregar.isEnabled = true
                    btnActualizar.isEnabled = false
                    btnActualizar.isHidden = true
                } else {
                    btnActualizar.isEnabled = true
                    btbAgregar.isEnabled = false
                    btbAgregar.isHidden = true
                    txtTitulo.text = tareaPut!.titulo
                    txtContenido.text = tareaPut!.contenido
                    txtFecha.date = convertStringtoDate(date: tareaPut!.fecha)
        }
    }
    
    func convertStringtoDate(date:String) -> Date {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd-mm-yyyy HH:mm:ss"
        if let d = dateFormater.date(from: date){
            return d
        }
        return Date()
    }
    

    @IBAction func agregarTarea(_ sender: Any) {
        if let titulo = txtTitulo.text, let contenido = txtContenido.text {
                        let selectedDate = self.txtFecha.date
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
                        let dateString = dateFormatter.string(from: selectedDate)
                        
                        let tareaData: [String: Any] = [
                            "titulo": titulo,
                            "contenido": contenido,
                            "fecha": dateString,
                            "tipo": "nota"
                        ]
                        
                    let tareaRef = self.database.child("usuarios").child((Auth.auth().currentUser?.uid)!).child("tareas").childByAutoId()
                        tareaRef.setValue(tareaData) { error, _ in
                            if let error = error {
                                print("Error uploading task to Firebase: \(error.localizedDescription)")
                            } else {
                                print("Task uploaded successfully to Firebase")
                                let alerta = UIAlertController(title: "Tarea agregada", message: "Acabas de agregar una nueva nota", preferredStyle: .alert)
                                let btnOK = UIAlertAction(title: "Aceptar", style: .cancel) { (UIAlertAction) in
                                    alerta.dismiss(animated: true, completion: nil)
                                    self.navigationController?.popViewController(animated: true)
                                    }
                                alerta.addAction(btnOK)
                                self.present(alerta, animated: true, completion: nil)
                                
                            }
                        }
                    }
    }
    @IBAction func actualizarTarea(_ sender: Any) {
        if let tareaId = tareaPut?.id {
            let selectedDate = self.txtFecha.date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
            let dateString = dateFormatter.string(from: selectedDate)
            let updatedData: [String: Any] = [
                "titulo": txtTitulo.text,
                "contenido": txtContenido.text,
                "fecha": dateString,
                "tipo" : "nota"
            ]
            let tareaRef = self.database.child("usuarios").child((Auth.auth().currentUser?.uid)!).child("tareas").child(tareaId)
                        tareaRef.setValue(updatedData) { (error, _) in
                            if let error = error {
                                print("Error updating task in Firebase: \(error.localizedDescription)")
                            } else {
                                print("Task updated successfully in Firebase")
                                let alerta = UIAlertController(title: "Tarea modificada", message: "Nota modificada exitosamente", preferredStyle: .alert)
                                let btnOK = UIAlertAction(title: "Aceptar", style: .cancel) { (UIAlertAction) in
                                    alerta.dismiss(animated: true, completion: nil)
                                    self.navigationController?.popViewController(animated: true)
                                    }
                                alerta.addAction(btnOK)
                                self.present(alerta, animated: true, completion: nil)
                                
                            }
                        }
                    }
    }
    
}
