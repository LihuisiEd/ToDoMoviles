//
//  ToDoTableViewController.swift
//  ToDoMoviles
//
//  Created by Aldo on 23/06/23.
//

import UIKit
import FirebaseCore
import FirebaseDatabase
import FirebaseAuth

class ToDoTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tareas:[Tarea] = []
    
    @IBOutlet weak var tablaTareas: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tablaTareas.delegate = self
        tablaTareas.dataSource = self
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        setEditing(true, animated: true)
        
        Database.database().reference().child("usuarios").child("1").child("tareas").observe(DataEventType.childAdded, with: {
            (tarea) in
            print(tarea)
            let t = Tarea()
            t.titulo = (tarea.value as! NSDictionary)["titulo"] as! String
            t.fecha = (tarea.value as! NSDictionary)["fecha"] as! String
            t.contenido = (tarea.value as! NSDictionary)["contenido"] as! String
            t.id = tarea.key
            print(t)
            self.tareas.append(t)
            self.tablaTareas.reloadData()
        })
    }
    
    func deleteItem(id: String){
        let dataRef  = Database.database().reference().child("usuarios").child("1").child("tareas").child(id)
        dataRef.removeValue { error, _ in
            if let error = error {
                print("Error al eliminar el dato: \(error.localizedDescription)")
            } else {
                print("Dato eliminado correctamente.")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let objMov = tareas[sourceIndexPath.row]
        tareas.remove(at: sourceIndexPath.row)
        tareas.insert(objMov, at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tareas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for:indexPath) as! CustomCellTableViewCell
        cell.lblTitulo.text = tareas[indexPath.row].titulo
        cell.lblFecha.text = tareas[indexPath.row].fecha
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //print(indexPath.row.id)
            self.deleteItem(id: tareas[indexPath.row].id)
            tareas.remove(at: indexPath.row)
            tablaTareas.reloadData()
        } 
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if (self.isEditing){
            self.editButtonItem.title = "Editar"
            self.tablaTareas.isEditing = false
        } else {
            self.editButtonItem.title = "Hecho"
            self.tablaTareas.isEditing = true
        }
    }

}
