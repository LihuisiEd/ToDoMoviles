import UIKit
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth

import SDWebImage

class TareasViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var titulo: UITextField!
    var imagenPicker = UIImagePickerController()
    let storage = Storage.storage()
    var tareaPut: Tarea?
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
            let selectedDate = self.txtFecha.date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
            let dateString = dateFormatter.string(from: selectedDate)

            imageRef.putData(imageData, metadata: nil) { (metadata, error) in
                if let error = error {
                    print("Ocurrió un error al subir la imagen: \(error)")
                } else {
                    imageRef.downloadURL { (url, error) in
                        if let imageUrl = url?.absoluteString {
                            let tareaData: [String: Any] = [
                                "titulo": self.titulo.text ?? "",
                                "contenido": self.descripcion.text ?? "",
                                "imagenUrl": imageUrl,
                                "fecha": dateString,
                                "tipo" : "imagen"

                            ]
                            let tareaRef = Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("tareas").childByAutoId()

                            tareaRef.setValue(tareaData)
                            
                            print("Tarea guardada exitosamente.")
                            let alerta = UIAlertController(title: "Tarea de imagen agregada", message: "Acabas de agregar una nueva nota de imagen", preferredStyle: .alert)
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
    }
    
    @IBOutlet weak var btnActualizar: UIButton!
    @IBOutlet weak var txtFecha: UIDatePicker!
    @IBOutlet weak var descripcion: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var btnGuardar: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    
    
    @IBAction func btnActualizarTapped(_ sender: Any) {
        guard let tareaPut = tareaPut else {
                return
            }
            
            if let image = imageView.image,
               let imageData = image.jpegData(compressionQuality: 0.5) {
                let imagesFolder = storage.reference().child("imagenes")
                let imageRef = imagesFolder.child("\(UUID().uuidString).jpg")
                let selectedDate = self.txtFecha.date
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
                let dateString = dateFormatter.string(from: selectedDate)
                
                indicator.startAnimating()

                imageRef.putData(imageData, metadata: nil) { (metadata, error) in
                    self.indicator.stopAnimating()
                    if let error = error {
                        print("Ocurrió un error al subir la imagen: \(error)")
                    } else {
                        imageRef.downloadURL { (url, error) in
                            if let imageUrl = url?.absoluteString {
                                let updatedData: [String: Any] = [
                                    "titulo": self.titulo.text ?? "",
                                    "contenido": self.descripcion.text ?? "",
                                    "imagenUrl": imageUrl,
                                    "fecha": dateString,
                                    "tipo": "imagen"
                                ]
                                let tareaRef = Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("tareas").child(tareaPut.id)

                                tareaRef.updateChildValues(updatedData) { (error, _) in
                                    if let error = error {
                                        print("Ocurrió un error al actualizar la tarea: \(error)")
                                    } else {
                                        print("Tarea actualizada exitosamente.")
                                        let alerta = UIAlertController(title: "Tarea de imagen modificada", message: "Acabas de agregar una nueva nota de imagen", preferredStyle: .alert)
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
                }
            }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indicator.center = view.center
        imagenPicker.delegate = self
        if tareaPut == nil{
            indicator.isHidden = true
            btnGuardar.isEnabled = true
            btnActualizar.isEnabled = false
            btnActualizar.isHidden = true
        } else {
            btnActualizar.isEnabled = true
            btnGuardar.isEnabled = false
            btnGuardar.isHidden = true
            imageView.sd_setImage(with: URL(string: tareaPut!.archivoURL), completed: { (image, error, cacheType, url) in
                self.indicator.isHidden = true
            })
            titulo.text = tareaPut!.titulo
            descripcion.text = tareaPut!.contenido
            txtFecha.date = convertStringtoDate(date: tareaPut!.fecha)
        }
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
    
    func convertStringtoDate(date:String) -> Date {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd-mm-yyyy HH:mm:ss"
        if let d = dateFormater.date(from: date){
            return d
        }
        return Date()
    }
}

