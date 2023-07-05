import UIKit
import FirebaseStorage
import FirebaseDatabase

class TareasViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var titulo: UITextField!
    
    var imagenPicker = UIImagePickerController()
    let storage = Storage.storage()
    let database = Database.database().reference()
    
    @IBAction func camaraTapped(_ sender: Any) {
        imagenPicker.sourceType = .savedPhotosAlbum
        imagenPicker.allowsEditing = false
        present(imagenPicker, animated: true, completion: nil)
    }
    
    @IBAction func btnGuardar(_ sender: Any) {
        if let image = imageView.image,
           let imageData = image.jpegData(compressionQuality: 0.5) {
            let imagesFolder = storage.reference().child("imagenes")
            let imageRef = imagesFolder.child("\(UUID().uuidString).jpg")
            
            imageRef.putData(imageData, metadata: nil) { (metadata, error) in
                if let error = error {
                    print("Ocurrió un error al subir la imagen: \(error)")
                } else {
                    // Obtenemos la URL de descarga de la imagen
                    imageRef.downloadURL { (url, error) in
                        if let imageUrl = url?.absoluteString {
                            // Creamos un diccionario con los datos de la tarea
                            let tareaData: [String: Any] = [
                                "titulo": self.titulo.text ?? "",
                                "descripcion": "",
                                "imagenUrl": imageUrl
                            ]
                            
                            // Generamos una nueva referencia en la base de datos y guardamos los datos de la tarea
                            let tareaRef = Database.database().reference().child("usuarios").child("1").child("tareas").childByAutoId()
                            tareaRef.setValue(tareaData)
                            
                            print("Tarea guardada exitosamente.")
                            
                            // Puedes realizar alguna acción adicional después de guardar la tarea, como mostrar un mensaje de éxito o actualizar tu interfaz de usuario.
                            
                            // Asegúrate de regresar a la vista principal después de guardar la tarea
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            }
        }
    }
    
    @IBOutlet weak var fecha: UIDatePicker!
    @IBOutlet weak var descripcion: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagenPicker.delegate = self
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
            imageView.backgroundColor = UIColor.clear
        }
        
        imagenPicker.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "putSegue" {
            if let tarea = sender as? Tarea {
                let siguienteVC = segue.destination as! CreateTaskViewController
                siguienteVC.tareaPut = tarea
            }
        }
    }
}

