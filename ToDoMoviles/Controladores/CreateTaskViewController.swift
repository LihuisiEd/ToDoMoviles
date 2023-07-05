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

    
    var tareaPut: Tarea?
    
    @IBOutlet weak var btnActualizar: UIButton!
    @IBOutlet weak var btbAgregar: UIButton!
    @IBOutlet weak var txtFecha: UIDatePicker!
    @IBOutlet weak var txtContenido: UITextField!
    @IBOutlet weak var txtTitulo: UITextField!
    
    let database = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    func convertDatetoString(date:UIDatePicker) -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd-mm-yyyy HH:mm:ss"
        return dateFormater.string(from: date.date)
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
                    "fecha": dateString
                ]
                
            let tareaRef = self.database.child("usuarios").child("1").child("tareas").childByAutoId()
                tareaRef.setValue(tareaData) { error, _ in
                    if let error = error {
                        print("Error uploading task to Firebase: \(error.localizedDescription)")
                    } else {
                        print("Task uploaded successfully to Firebase")
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
    }
    
    
    @IBAction func putTarea(_ sender: Any) {
        if let tareaId = tareaPut?.id {
                let updatedData: [String: Any] = [
                    "titulo": "Nuevo título",
                    "contenido": "Nuevo contenido",
                    "fecha": "Nueva fecha"
                ]
                
                let tareaRef = self.database.child("tareas").child(tareaId)
                tareaRef.setValue(updatedData) { (error, _) in
                    if let error = error {
                        print("Error updating task in Firebase: \(error.localizedDescription)")
                    } else {
                        print("Task updated successfully in Firebase")
                    }
                }
            }
    }
    

}
