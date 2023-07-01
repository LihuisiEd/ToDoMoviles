//
//  TareasViewController.swift
//  ToDoMoviles
//
//  Created by Eduardo Lihuisi on 1/07/23.
//

import UIKit

class TareasViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imagenPicker = UIImagePickerController()

    @IBAction func camaraTapped(_ sender: Any) {
        imagenPicker.sourceType = .camera
        imagenPicker.allowsEditing = false
        present(imagenPicker, animated: true,completion: nil)
        
    }
    @IBOutlet weak var descripcion: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        imagenPicker.delegate = self
        // Do any additional setup after loading the view.
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = image
        imageView.backgroundColor = UIColor.clear
        imagenPicker.dismiss(animated: true,completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
