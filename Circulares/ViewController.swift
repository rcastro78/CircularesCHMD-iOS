//
//  ViewController.swift
//  Circulares
//
//  Created by Rafael David Castro Luna on 22/7/23.
//

import UIKit
import AVFoundation
import GoogleSignIn
import AuthenticationServices
class ViewController: UIViewController, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    var avPlayer:AVPlayer!
    var avPlayerLayer:AVPlayerLayer!
    var paused:Bool = false
    let base_url:String="https://www.chmd.edu.mx/WebAdminCirculares/ws/";
    let get_usuario:String="getUsuarioEmail2.php";
    let get_usuario1:String="getUsuarioEmail.php";
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var videoView: UIView!
   
    @IBOutlet weak var btnLoginApple: ASAuthorizationAppleIDButton!
    override func viewWillAppear(_ animated: Bool) {
        //playBackgoundVideo()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playBackgoundVideo()
        inyectarDatos()
        btnLoginApple.addTarget(self, action: #selector(actionHandleAppleSignin), for: .touchUpInside)
    }
    
    //Credenciales
    @IBAction func iniciarSesionCredenciales(_ sender: UIButton) {
        let user = username.text
        let pwd = password.text
        obtenerDatosDelUsuario(correo: user!, clave: pwd!)
    }
    
    //Google
    @IBAction func signIn(sender: Any) {
      GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
        guard error == nil else { return }
          if let user = signInResult?.user {
              let email = user.profile?.email
              self.validarCorreo(correo:email!)
          }
          
      }
    }
    
    //Apple
    @objc func actionHandleAppleSignin() {

            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()

        }
    
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            // Create an account in your system.
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            self.validarCorreo(correo:email!)
           
            
        default:
            break
        }
    }
    
   
    func inyectarDatos(){
        username.text = "programador@chmd.edu.mx"
        password.text = "1463"
    }
    
    
    
    
    func obtenerDatosDelUsuario(correo:String, clave:String) {
            let usuarioURL = base_url+get_usuario+"?correo=\(correo)&pwd=\(clave)"
        print("VALIDAR \(usuarioURL)")
        
        Utilerias().obtenerDatosUsuario(uri: usuarioURL) { result in
                switch result {
                case .success:
                    // La función se ejecutó con éxito, aquí puedes realizar acciones adicionales
                    //Registrar el dispositivo para recibir notificaciones
                   
                    
                    
                    self.performSegue(withIdentifier: "loginSegue", sender: self)
                case .failure(let error):
                    //showCredentialsErrorDialog()
                    let alertController = UIAlertController(title: "CHMD - Iniciar sesión", message: "Credenciales Incorrectas", preferredStyle: .alert)
                            
                            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                                
                                // Code in this block will trigger when OK button tapped.
                                print("Ok button tapped");
                                
                            }
                            
                            alertController.addAction(OKAction)
                    self.present(alertController, animated: true, completion:nil)
                }
            }
        }
    
    //Google y Apple
    func validarCorreo(correo:String) {
            let usuarioURL = base_url+get_usuario1+"?correo=\(correo)"
        print("VALIDAR \(usuarioURL)")
        
        Utilerias().obtenerDatosUsuario(uri: usuarioURL) { result in
                switch result {
                case .success:
                    self.performSegue(withIdentifier: "loginSegue", sender: self)
                case .failure(let error):
                    let alertController = UIAlertController(title: "CHMD - Iniciar sesión", message: "Cuenta no válida", preferredStyle: .alert)
                            
                            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                                
                                // Code in this block will trigger when OK button tapped.
                                print("Ok button tapped");
                                
                            }
                            
                            alertController.addAction(OKAction)
                    self.present(alertController, animated: true, completion:nil)
                }
            }
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





extension UIViewController {
    func ocultarTeclado() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
