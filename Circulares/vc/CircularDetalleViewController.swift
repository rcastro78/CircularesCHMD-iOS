//
//  CircularDetalleViewController.swift
//  Circulares
//
//  Created by Rafael David Castro Luna on 27/7/23.
//

import UIKit
import WebKit
class CircularDetalleViewController: UIViewController,WKNavigationDelegate {
    var circulares = [CircularCompleta]()
    let btnHome = UIButton()
    let btnBack = UIButton()
    let btnNext = UIButton()
    let btnCalendario = UIButton()
    let btnEstrella = UIButton()
    let btnShare = UIButton()
    let btnEliminar = UIButton()
    @IBOutlet weak var stvMenuContainer: UIStackView!
    @IBOutlet weak var webContainer: WKWebView!
    var idx:Int=0
    var userId:String=""
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        renderUI()
        let idCircular:String = UserDefaults.standard.string(forKey: "id") ?? "0"
        userId = UserDefaults.standard.string(forKey: "idUsuario") ?? "0"
        
        let horaInicialIcs:String = UserDefaults.standard.string(forKey: "horaInicialIcs") ?? "0"
        let favorita:Int = UserDefaults.standard.integer(forKey: "favorita") ?? 0
        idx = UserDefaults.standard.integer(forKey: "idx") ?? 0
        
        if(favorita==1){
            btnEstrella.setImage(UIImage(named: "estrella_blanca"), for: .normal)
        }
        if(horaInicialIcs=="00:00:00"){
            btnCalendario.setImage(UIImage(named: "calendar"), for: .normal)
        }else{
            btnCalendario.setImage(UIImage(named: "calendario_blanco"), for: .normal)
        }
        
        Utilerias().modificarCircular(direccion: "https://www.chmd.edu.mx/WebAdminCirculares/ws/leerCircular.php", usuario_id: userId, circular_id: idCircular)
        
            
        let address="https://www.chmd.edu.mx/WebAdminCirculares/ws/getCirculares_Android.php?usuario_id=\(userId)"
        
                   guard let _url = URL(string: address) else { return };
                   self.getDataFromURL(url: _url)
        
        self.webContainer.navigationDelegate = self
        
        
        let link = URL(string:Constantes().urlBase+"getCircularId6.php?id="+idCircular)!
        let request = URLRequest(url: link)
        self.webContainer.load(request)
        
        
        
        // Do any additional setup after loading the view.
    }
    func renderUI(){
        
        btnHome.setImage(UIImage(named: "home_blanco"), for: .normal)
        btnHome.imageEdgeInsets = UIEdgeInsets(top:12, left: 14, bottom: 12, right: 14)
        btnHome.backgroundColor = UIColor.white.withAlphaComponent(0.0)
        btnHome.translatesAutoresizingMaskIntoConstraints = false
        
       
        btnBack.setImage(UIImage(named: "flecha_izq_icono"), for: .normal)
        btnBack.imageEdgeInsets = UIEdgeInsets(top:12, left: 14, bottom: 12, right: 14)
        btnBack.backgroundColor = UIColor.white.withAlphaComponent(0.0)
        btnBack.translatesAutoresizingMaskIntoConstraints = false
        
        
        btnNext.setImage(UIImage(named: "flecha_der_icono"), for: .normal)
        btnNext.imageEdgeInsets = UIEdgeInsets(top:12, left: 14, bottom: 12, right: 14)
        btnNext.backgroundColor = UIColor.white.withAlphaComponent(0.0)
        btnNext.translatesAutoresizingMaskIntoConstraints = false
        
        
        btnCalendario.setImage(UIImage(named: "calendario_blanco"), for: .normal)
        btnCalendario.imageEdgeInsets = UIEdgeInsets(top:12, left: 14, bottom: 12, right: 14)
        btnCalendario.backgroundColor = UIColor.white.withAlphaComponent(0.0)
        btnCalendario.translatesAutoresizingMaskIntoConstraints = false
        
       
        btnEstrella.setImage(UIImage(named: "estrella_fav_icono"), for: .normal)
        btnEstrella.imageEdgeInsets = UIEdgeInsets(top:12, left: 14, bottom: 12, right: 14)
        btnEstrella.backgroundColor = UIColor.white.withAlphaComponent(0.0)
        btnEstrella.translatesAutoresizingMaskIntoConstraints = false
        
        btnShare.setImage(UIImage(named: "share_blanco"), for: .normal)
        btnShare.imageEdgeInsets = UIEdgeInsets(top:12, left: 14, bottom: 12, right: 14)
        btnShare.backgroundColor = UIColor.white.withAlphaComponent(0.0)
        btnShare.translatesAutoresizingMaskIntoConstraints = false
       
       
        btnEliminar.setImage(UIImage(named: "basurero_blanco"), for: .normal)
        btnEliminar.imageEdgeInsets = UIEdgeInsets(top:12, left: 14, bottom: 12, right: 14)
        btnEliminar.backgroundColor = UIColor.white.withAlphaComponent(0.0)
        btnEliminar.translatesAutoresizingMaskIntoConstraints = false
        
        btnBack.addTarget(self, action: #selector(getAnterior), for: .touchUpInside)
        btnNext.addTarget(self, action: #selector(getSiguiente), for: .touchUpInside)
        btnShare.addTarget(self, action: #selector(compartir), for: .touchUpInside)
        
        stvMenuContainer.alignment = .fill
        stvMenuContainer.distribution = .fillEqually
        stvMenuContainer.spacing = 2.0

        stvMenuContainer.addArrangedSubview(btnHome)
        stvMenuContainer.addArrangedSubview(btnBack)
        stvMenuContainer.addArrangedSubview(btnNext)
        stvMenuContainer.addArrangedSubview(btnCalendario)
        stvMenuContainer.addArrangedSubview(btnShare)
        stvMenuContainer.addArrangedSubview(btnEstrella)
        stvMenuContainer.addArrangedSubview(btnEliminar)
        
        
        
    }
    
    @objc func getSiguiente(){
     idx = idx + 1
        if(idx>circulares.count-1){
            idx = circulares.count-1
        }
        let idCircular = String(circulares[idx].id)
        
        if(circulares[idx].favorita==1){
            btnEstrella.setImage(UIImage(named: "estrella_blanca"), for: .normal)
        }else{
            btnEstrella.setImage(UIImage(named: "estrella_fav_icono"), for: .normal)
        }
        if(circulares[idx].horaInicialIcs=="00:00:00"){
            btnCalendario.setImage(UIImage(named: "calendar"), for: .normal)
        }else{
            btnCalendario.setImage(UIImage(named: "calendario_blanco"), for: .normal)
        }
        
        Utilerias().modificarCircular(direccion: "https://www.chmd.edu.mx/WebAdminCirculares/ws/leerCircular.php", usuario_id: userId, circular_id: idCircular)
        
        let link = URL(string:Constantes().urlBase+"getCircularId6.php?id="+idCircular)!
        let request = URLRequest(url: link)
        self.webContainer.load(request)
    }
    
    @objc func getAnterior(){
        idx = idx - 1
        if(idx<=0){
            idx = 0
        }
        let idCircular = String(circulares[idx].id)
        Utilerias().modificarCircular(direccion: "https://www.chmd.edu.mx/WebAdminCirculares/ws/leerCircular.php", usuario_id: userId, circular_id: idCircular)
        
        if(circulares[idx].favorita==1){
            btnEstrella.setImage(UIImage(named: "estrella_blanca"), for: .normal)
        }else{
            btnEstrella.setImage(UIImage(named: "estrella_fav_icono"), for: .normal)
        }
        if(circulares[idx].horaInicialIcs=="00:00:00"){
            btnCalendario.setImage(UIImage(named: "calendar"), for: .normal)
        }else{
            btnCalendario.setImage(UIImage(named: "calendario_blanco"), for: .normal)
        }
        
        
        let link = URL(string:Constantes().urlBase+"getCircularId6.php?id="+idCircular)!
        let request = URLRequest(url: link)
        self.webContainer.load(request)
    }
    
    @objc func compartir(){
        let idCircular = String(circulares[idx].id)
        let shareLink:String = Constantes().urlBase+"getCircularId6.php?id="+idCircular
        let url = URL(string: shareLink)
        mostrarDialogoCompartirURL(url: url!,mensaje: "Comparto esta circular", desde: self)
    }
    
    func mostrarDialogoCompartirURL(url: URL,mensaje:String?, desde presenter: UIViewController) {
        var items: [Any] = [url] // URL siempre estará presente
            
            if let mensaje = mensaje {
                items.append(mensaje) // Agregamos el mensaje solo si está presente
            }
            
            let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
            presenter.present(activityViewController, animated: true, completion: nil)

    }
    
    
    func getDataFromURL(url: URL) {
        circulares.removeAll()
        UserDefaults.standard.setValue(1, forKey: "primeraCarga")
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                print("Error al obtener los datos: \(error?.localizedDescription ?? "Error desconocido")")
                return
            }
            
            do {
                let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
                
                if let jsonArray = jsonData {
                    print("datos \(jsonArray.count)")
                    
                    for item in jsonArray {
                        if let circularCompletaItem = Utilerias().parseCircularCompleta(from: item) {
                            self.circulares.append(circularCompletaItem)
                        }
                    }
                   
                } else {
                    print("Error al parsear los datos JSON")
                }
            } catch {
                print("Error al parsear los datos JSON: \(error.localizedDescription)")
            }
            
        }.resume()
        UserDefaults.standard.set(0, forKey: "descarga")
    }
    
    
    
    

}
