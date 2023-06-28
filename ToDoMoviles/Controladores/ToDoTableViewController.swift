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
        tablaTareas.delegate = self
        
        Database.database().reference().child("usuarios").child("tareas").observe(DataEventType.childAdded, with: {
            (tarea) in
            let t = Tarea()
            t.titulo = (tarea.value as! NSDictionary)["titulo"] as! String
            t.fecha = (tarea.value as! NSDictionary)["fecha"] as! String
            t.contenido = (tarea.value as! NSDictionary)["contenido"] as! String
            self.tareas.append(t)
            self.tablaTareas.reloadData()
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tareas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for:indexPath)
        cell.textLabel?.text = tareas[indexPath.row].titulo
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Acciones para eliminar la celda
        } 
    }

}
