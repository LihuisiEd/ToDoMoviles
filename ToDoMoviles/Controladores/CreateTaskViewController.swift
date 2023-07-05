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
    var audioURL: Tarea?
    
    @IBOutlet weak var btnActualizar: UIButton!
    @IBOutlet weak var btbAgregar: UIButton!
    @IBOutlet weak var txtFecha: UIDatePicker!
    @IBOutlet weak var txtContenido: UITextField!
    @IBOutlet weak var txtTitulo: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if tareaPut == nil{
            btbAgregar.isEnabled = true
            btnActualizar.isEnabled = false
        } else {
            btnActualizar.isEnabled = true
            btbAgregar.isEnabled = false
            txtTitulo.text = tareaPut!.titulo
            txtContenido.text = tareaPut!.contenido
            txtFecha.date = convertStringtoDate(date: tareaPut!.fecha)
        }
    }
    
    func convertDatetoString(date:Date) -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd-mm-yyyy HH:mm:ss"
        return dateFormater.string(from: date)
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
        let ref = Database.database().reference().child("usuarios").child("1").child("tareas")
        tareaPut?.titulo = txtTitulo.text!
        tareaPut?.contenido = txtContenido.text!
        tareaPut?.fecha = convertDatetoString(date: txtFecha.date)
        ref.setValue(tareaPut) { error, _ in
            if let error = error {
                print("Error al agregar los datos: \(error.localizedDescription)")
            } else {
                print("OK")
            }
        }
    }


}
