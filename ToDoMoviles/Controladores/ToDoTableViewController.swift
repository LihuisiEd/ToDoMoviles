//
//  ToDoTableViewController.swift
//  ToDoMoviles
//
//  Created by Aldo on 23/06/23.
//

import UIKit
import FirebaseCore
import FirebaseDatabase

class ToDoTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tareas:[Tarea] = []
    
    @IBOutlet weak var tablaTareas: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tablaTareas.delegate = self
        tablaTareas.delegate = self
        
        Database.database().reference().child("tareas").observe(DataEventType.childAdded, with: {
            (tarea) in
            let ta = Tarea()
            ta.titulo = (tarea.value as! NSDictionary)["titulo"] as! String
            ta.contenido = (tarea.value as! NSDictionary)["contenido"] as! String
            ta.fecha = (tarea.value as! NSDictionary)["fecha"] as! Date
            self.tareas.append(ta)
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
