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
        if txtTitulo.text != nil{
            let selectedDate = self.txtFecha.date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-mm-yyyy HH:mm:ss"
            let dateString = dateFormatter.string(from: selectedDate)
            let tareaData: [String: Any] = [
                "titulo": self.txtTitulo ?? "",
                "contenido": self.txtContenido ?? "",
                "fecha": dateString
            ]
            let tareaRef = self.database.child("tareas").childByAutoId()
            tareaRef.setValue(tareaData)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    @IBAction func putTarea(_ sender: Any) {
        
    }
    

}
