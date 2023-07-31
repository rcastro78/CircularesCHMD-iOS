//
//  MenuPrincipalViewController.swift
//  Circulares
//
//  Created by Rafael David Castro Luna on 27/7/23.
//

import UIKit
import AVFoundation
class MenuPrincipalViewController: UIViewController {
    let base_url_foto:String="http://chmd.chmd.edu.mx:65083/CREDENCIALES/padres/"
    let base_url:String="https://www.chmd.edu.mx/WebAdminCirculares/ws/";
    let get_usuario:String="getUsuarioEmail.php";
    let get_vigencia:String="getVigencia.php";
    var userId:String=""
    @IBOutlet weak var stackViewContainer: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playBackgoundVideo()
        renderUI()
        userId = UserDefaults.standard.string(forKey: "idUsuario") ?? "0"
        cifrarUsuario()
        
        
    }
    
    
   
    func obtenerVigenciaDelUsuario() {
            let usuarioURL = base_url+get_vigencia+"?idUsuario=\(userId)"
            
        Utilerias().getVigenciaUsuario(uri: usuarioURL) { result in
                switch result {
                case .success:
                    // La función se ejecutó con éxito, aquí puedes realizar acciones adicionales
                    print("Datos del usuario obtenidos correctamente.")
                case .failure(let error):
                    // Ocurrió un error al obtener los datos del usuario
                    print("Error al obtener los datos del usuario: \(error.localizedDescription)")
                }
            }
        }
    
    
    func cifrarUsuario() {
            let usuarioURL = base_url+"cifrar.php?idUsuario=\(userId)"
            
        Utilerias().cifrarIdUsuario(uri: usuarioURL) { result in
                switch result {
                case .success:
                    // La función se ejecutó con éxito, aquí puedes realizar acciones adicionales
                    print("Datos del usuario obtenidos correctamente.")
                case .failure(let error):
                    // Ocurrió un error al obtener los datos del usuario
                    print("Error al obtener los datos del usuario: \(error.localizedDescription)")
                }
            }
        }


    func renderUI(){
        let btnHome = UIButton()
        btnHome.setImage(UIImage(named: "circulares256"), for: .normal)
        btnHome.imageEdgeInsets = UIEdgeInsets(top:8, left:124, bottom: 8, right: 124)
        btnHome.backgroundColor = UIColor.white.withAlphaComponent(0.0)
        btnHome.translatesAutoresizingMaskIntoConstraints = false
        
        let btnMaguen = UIButton()
        btnMaguen.setImage(UIImage(named: "mi_maguen256"), for: .normal)
        btnMaguen.imageEdgeInsets = UIEdgeInsets(top:8, left:124, bottom: 8, right: 124)
        btnMaguen.backgroundColor = UIColor.white.withAlphaComponent(0.0)
        btnMaguen.translatesAutoresizingMaskIntoConstraints = false
        
        let btnCredencial = UIButton()
        btnCredencial.setImage(UIImage(named: "mi_credencial256"), for: .normal)
        btnCredencial.imageEdgeInsets = UIEdgeInsets(top:8, left:124, bottom: 8, right: 124)
        btnCredencial.backgroundColor = UIColor.white.withAlphaComponent(0.0)
        btnCredencial.translatesAutoresizingMaskIntoConstraints = false
        
        let btnCerrar = UIButton()
        btnCerrar.setImage(UIImage(named: "cerrar_sesion256"), for: .normal)
        btnCerrar.imageEdgeInsets = UIEdgeInsets(top:8, left:124, bottom: 8, right: 124)
        btnCerrar.backgroundColor = UIColor.white.withAlphaComponent(0.0)
        btnCerrar.translatesAutoresizingMaskIntoConstraints = false
        
        btnHome.addTarget(self, action: #selector(goToCirculares), for: .touchUpInside)
        btnCredencial.addTarget(self, action: #selector(goToCredencial), for: .touchUpInside)
        btnMaguen.addTarget(self, action: #selector(goToMaguen), for: .touchUpInside)
        stackViewContainer.alignment = .fill
        stackViewContainer.axis = .vertical
        stackViewContainer.distribution = .fillEqually
        stackViewContainer.spacing = 2.0

        stackViewContainer.addArrangedSubview(btnHome)
        stackViewContainer.addArrangedSubview(btnMaguen)
        stackViewContainer.addArrangedSubview(btnCredencial)
        stackViewContainer.addArrangedSubview(btnCerrar)
        
        
    }
    
    @objc func goToCirculares(){
        performSegue(withIdentifier: "circularesSegue", sender:self)
    }
    
    @objc func goToCredencial(){
        performSegue(withIdentifier: "credencialSegue", sender:self)
    }
    
    @objc func goToMaguen(){
        performSegue(withIdentifier: "miMaguenSegue", sender:self)
    }
    
    
    private func playBackgoundVideo() {
        if let filePath = Bundle.main.path(forResource: "video_app", ofType: "mp4") {
                    let filePathUrl = URL(fileURLWithPath: filePath)
                    let player = AVPlayer(url: filePathUrl)
                    let playerLayer = AVPlayerLayer(player: player)
                    playerLayer.frame = view.bounds
                    playerLayer.videoGravity = AVLayerVideoGravity.resize
                    NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: nil) { (_) in
                        player.seek(to: .zero)
                        player.play()
                    }
                    view.layer.insertSublayer(playerLayer, at: 0) // Agregar AVPlayerLayer al fondo de la vista principal
                    player.play()
                }
    }
    
}
