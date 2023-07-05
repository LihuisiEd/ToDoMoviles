//
//  AudioViewController.swift
//  ToDoMoviles
//
//  Created by Gonzalo Vargas on 5/07/23.
//

import UIKit
import AVFoundation
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class AudioViewController: UIViewController {
    
    var grabarAudio:AVAudioRecorder?
    var reproducirAudio:AVAudioPlayer?
    var audioURL:URL?
    var archivoID = NSUUID().uuidString
    
    @IBOutlet weak var grabarAudioButton: UIButton!
    @IBOutlet weak var descripcionInput: UITextField!
    @IBOutlet weak var enviaaudio: UIButton!
    @IBOutlet weak var playAudio: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurarGrabacion()
        playAudio.isEnabled = false
    }
    
    @IBAction func playAudioTapped(_ sender: Any) {
        do {
            try reproducirAudio = AVAudioPlayer(contentsOf: audioURL!)
            reproducirAudio!.play()
            print("REPRODUCIENDO")
                
        } catch {}
    }
    
    @IBAction func grabarAudioTapped(_ sender: Any) {
        if grabarAudio?.isRecording == true{
            grabarAudio?.stop()
            grabarAudioButton.setTitle("GRABAR", for:  .normal)
            playAudio.isEnabled = true
        } else {
            grabarAudio?.record()
            grabarAudioButton.setTitle("DETENER", for:  .normal)
            playAudio.isEnabled = false
        }
    }
    
    @IBAction func enviarAudio(_ sender: Any) {
        guard let audioURL = audioURL else {
            print("URL del archivo de audio no válido")
            return
        }
        
        let storageRef = Storage.storage().reference().child("audios").child("\(archivoID).m4a")
        let metadata = StorageMetadata()
        metadata.contentType = "audio/m4a"
        
        let uploadTask = storageRef.putFile(from: audioURL, metadata: metadata) { metadata, error in
            if let error = error {
                print("Error al cargar el archivo de audio: \(error.localizedDescription)")
                return
            }
            print("Archivo de audio cargado exitosamente")
            
            // Aquí puedes guardar la URL del audio en tu base de datos, si es necesario
            
            // Procede a seleccionar el contacto y enviar la URL del audio
            self.performSegue(withIdentifier: "putSegue", sender: audioURL.absoluteString)
        }
        
        uploadTask.observe(.progress) { snapshot in
            // Calcula el porcentaje completado de la carga
            guard let progress = snapshot.progress else {
                return
            }
            let percentComplete = 100.0 * Double(progress.completedUnitCount) / Double(progress.totalUnitCount)
            print("Porcentaje completado de carga: \(percentComplete)%")
            
            let databaseRef = Database.database().reference().child("usuarios").child("1").child("tareas")
            let tareaData: [String: Any] = [
                "titulo": self.descripcionInput.text ?? "",
                "audio": "\(audioURL).m4a",
                // Agrega otros campos de la tarea si los tienes, como fecha o contenido
            ]
            let tareaRef = databaseRef.childByAutoId()
            tareaRef.setValue(tareaData) { error, _ in
                if let error = error {
                    print("Error al guardar la tarea en la base de datos: \(error.localizedDescription)")
                } else {
                    print("Tarea guardada correctamente en la base de datos.")
                }
            }

        }
    }
    
    /*import UIKit
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
    }*/

    
    func configurarGrabacion(){
        do{
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSession.Category.playAndRecord, mode:AVAudioSession.Mode.default, options: [])
            try session.overrideOutputAudioPort(.speaker)
            try session.setActive(true)
                
            let basePAth:String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let pathComponents = [basePAth,"audio.m4a"]
            audioURL = NSURL.fileURL(withPathComponents: pathComponents)!
                
            print("****************")
            print(audioURL!)
            print("****************")
                
            var settings:[String:AnyObject] = [:]
            settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC) as AnyObject?
            settings[AVSampleRateKey] = 44100.0 as AnyObject?
            settings[AVNumberOfChannelsKey] = 2 as AnyObject?
                
            grabarAudio = try AVAudioRecorder(url: audioURL!, settings: settings)
            grabarAudio?.prepareToRecord()
        } catch let error as NSError{
            print(error)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "putSegue" {
            let siguienteVC = segue.destination as! ToDoTableViewController
            
            if let audioURLString = sender as? String {
                siguienteVC.audioURL = URL(string: audioURLString)
            }
        }
    }
    
}
