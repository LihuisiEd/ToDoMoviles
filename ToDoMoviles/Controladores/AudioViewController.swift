//
//  AudioViewController.swift
//  ToDoMoviles
//
//  Created by Eduardo Lihuisi on 7/07/23.
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
    
    var tareaPut: Tarea?
        
    @IBOutlet weak var grabarAudioButton: UIButton!
    @IBOutlet weak var descripcionInput: UITextField!
    @IBOutlet weak var enviaaudio: UIButton!
    @IBOutlet weak var playAudio: UIButton!
    @IBOutlet weak var txtitulo: UITextField!
    
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
            
        }
            
     
 
        let audioRef = Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("tareas").childByAutoId()
        let tareaData: [String: Any] = [
                "titulo": self.descripcionInput.text ?? "",
                "audio": "\(audioURL)",
                "tipo" : "audio"
                
            ]
        
        audioRef.setValue(tareaData) { error, _ in
                if let error = error {
                    print("Error al guardar la tarea en la base de datos: \(error.localizedDescription)")
                } else {
                    print("Audio guardado correctamente en la base de datos.")
                    self.navigationController?.popViewController(animated: true)
                }
            }
    }
    
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
            if let audio = sender as? Tarea {
                let siguienteVC = segue.destination as! CreateTaskViewController
                siguienteVC.tareaPut = audio
            }
        }
    }
    
}
