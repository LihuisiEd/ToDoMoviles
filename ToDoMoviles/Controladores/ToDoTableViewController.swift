import UIKit
import FirebaseCore
import FirebaseDatabase
import FirebaseAuth

class ToDoTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tareas: [Tarea] = []
    
    @IBOutlet weak var tablaTareas: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tablaTareas.delegate = self
        tablaTareas.dataSource = self
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        setEditing(true, animated: true)
        
        Database.database().reference().child("usuarios").child("1").child("tareas").observe(DataEventType.childAdded, with: { (snapshot) in
            if let tareaDict = snapshot.value as? [String: Any] {
                let tarea = Tarea()
                tarea.titulo = tareaDict["titulo"] as? String ?? ""
                tarea.fecha = tareaDict["fecha"] as? String ?? ""
                tarea.contenido = tareaDict["contenido"] as? String ?? ""
                tarea.id = snapshot.key
                self.tareas.append(tarea)
                self.tablaTareas.reloadData()
            }
        })
    }
    
    func deleteItem(id: String) {
        let dataRef = Database.database().reference().child("usuarios").child("1").child("tareas").child(id)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomCellTableViewCell
        cell.lblTitulo.text = tareas[indexPath.row].titulo
        cell.lblFecha.text = tareas[indexPath.row].fecha
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.deleteItem(id: tareas[indexPath.row].id)
            tareas.remove(at: indexPath.row)
            tablaTareas.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tarea = tareas[indexPath.row]
        performSegue(withIdentifier: "putSegue", sender: tarea)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "putSegue" {
            if let tarea = sender as? Tarea {
                let siguienteVC = segue.destination as! CreateTaskViewController
                siguienteVC.tareaPut = tarea
            }
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if self.isEditing {
            self.editButtonItem.title = "Editar"
            self.tablaTareas.isEditing = false
        } else {
            self.editButtonItem.title = "Hecho"
            self.tablaTareas.isEditing = true
        }
    }
    
}

