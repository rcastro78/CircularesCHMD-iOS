//
//  CircularesViewController.swift
//  Circulares
//
//  Created by Rafael David Castro Luna on 22/7/23.
//

import UIKit
import Alamofire
import Foundation
 

class CircularesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,
UISearchBarDelegate{
    var idCircular:String=""
    let activityIndicator = UIActivityIndicatorView(style: .gray)
      
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return circulares.count
    
}
    let TODAS=0
    let NO_LEIDAS=1
    let FAVORITAS=2
    let ELIMINADAS=3
    var seleccion:Int=0
    var userId:String=""
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.selectionStyle = .none
        let c = circulares[indexPath.row] 
        UserDefaults.standard.set(indexPath.row,forKey:"posicion")
        UserDefaults.standard.set(c.id,forKey:"id")
        UserDefaults.standard.set(c.favorita,forKey:"favorita")
        UserDefaults.standard.set(c.horaInicialIcs,forKey:"horaInicialIcs")
        UserDefaults.standard.set(indexPath.row,forKey:"idx")
        performSegue(withIdentifier: "webSegue", sender:self)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath)
            as! CircularTableViewCell
        let c = circulares[indexPath.row]
        if(c.leido==1){
            cell.imgLectura.isHidden = true
        }else{
            cell.imgLectura.isHidden = false
        }
        if(c.favorita==1){
            //cell.imgFavorito.setImage(UIImage(named: "estrella_amarilla"), for: .normal)
            cell.imgEstrella.image = UIImage(named: "estrella_amarilla")
        }else{
            cell.imgEstrella.image = UIImage(named: "estrella_fav_icono")
        }
        idCircular = String(c.id)
        cell.imgFavorito.addTarget(self, action: #selector(setFavorita(_:)), for: .touchUpInside)
        
        
        cell.lblTitulo.text? = c.nombre
        cell.lblPara.text? = c.grupos
        cell.lblFecha.text? = Utilerias().formatearFecha(c.fecha)
        return cell
    }
    
    //Manejar el swipe de derecha a izquierda
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let leerAction = self.contextualReadAction(forRowAtIndexPath: indexPath)
        let eliminaAction = self.contextualDelAction(forRowAtIndexPath: indexPath)
        let noleerAction = self.contextualUnreadAction(forRowAtIndexPath: indexPath)
        let swipeConfig = UISwipeActionsConfiguration(actions: [eliminaAction,noleerAction,leerAction])
        return swipeConfig
    }
    
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var tableViewCirculares: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var circulares = [CircularCompleta]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        userId = UserDefaults.standard.string(forKey: "idUsuario") ?? "0"
        if(seleccion==TODAS){
            mostrarTodas()
        }
        if(seleccion==NO_LEIDAS){
            mostrarNoLeidas()
        }
        if(seleccion==FAVORITAS){
            mostrarFavoritas()
        }
        
        if(seleccion==ELIMINADAS){
            mostrarEliminadas()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userId = UserDefaults.standard.string(forKey: "idUsuario") ?? "0"
        renderUI()
        self.tableViewCirculares.dataSource = self
        self.tableViewCirculares.delegate = self
        self.searchBar.delegate = self
        activityIndicator.center = view.center
        tableViewCirculares.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    @IBAction func homeOnClickListener(_ sender: UIButton) {
    }
    
    func getDataFromURL(url: URL) {
        print("Leer desde el servidor....")
        print(url)
        
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
                    OperationQueue.main.addOperation {
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.removeFromSuperview()
                        self.tableViewCirculares.reloadData()
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
    
   
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText:String) {
        if searchBar.text==nil || searchBar.text==""{
            self.searchBar.perform(#selector(self.resignFirstResponder), with: nil, afterDelay: 0.1)
            self.searchBar.endEditing(true)
            if(seleccion==TODAS){
                mostrarTodas()
            }
            if(seleccion==NO_LEIDAS){
                mostrarNoLeidas()
            }
            if(seleccion==FAVORITAS){
                mostrarFavoritas()
            }
            
            if(seleccion==ELIMINADAS){
                mostrarEliminadas()
            }
            
        }else{
            if(searchText.count>=4){
                circulares = circulares.filter({$0.nombre.lowercased().contains(searchBar.text!.lowercased()) || $0.contenido.lowercased().contains(searchBar.text!.lowercased())})
                self.activityIndicator.stopAnimating()
                self.activityIndicator.removeFromSuperview()
                self.tableViewCirculares?.reloadData()
            }
        }
    }
    
    
    
    
    func renderUI(){
        let btnHome = UIButton()
        btnHome.setImage(UIImage(named: "appmenu03"), for: .normal)
        btnHome.imageEdgeInsets = UIEdgeInsets(top: 16, left: 28, bottom: 16, right: 28)
        btnHome.backgroundColor = UIColor.white.withAlphaComponent(0.0)
        btnHome.translatesAutoresizingMaskIntoConstraints = false

        let btnNoLeidos = UIButton()
        btnNoLeidos.setImage(UIImage(named: "appmenu05"), for: .normal)
        btnNoLeidos.imageEdgeInsets = UIEdgeInsets(top: 16, left: 32, bottom: 16, right: 32)
        btnNoLeidos.backgroundColor = UIColor.white.withAlphaComponent(0.0)
        btnNoLeidos.translatesAutoresizingMaskIntoConstraints = false

        
        
        let btnFavoritos = UIButton()
        btnFavoritos.setImage(UIImage(named: "appmenu06"), for: .normal)
        btnFavoritos.imageEdgeInsets = UIEdgeInsets(top: 16, left: 28, bottom: 16, right: 28)
        btnFavoritos.backgroundColor = UIColor.white.withAlphaComponent(0.0)
        btnFavoritos.translatesAutoresizingMaskIntoConstraints = false

        
        let btnEliminadas = UIButton()
        btnEliminadas.setImage(UIImage(named: "appmenu07"), for: .normal)
        btnEliminadas.imageEdgeInsets = UIEdgeInsets(top: 16, left: 32, bottom: 16, right: 32)
        btnEliminadas.backgroundColor = UIColor.white.withAlphaComponent(0.0)
        btnEliminadas.translatesAutoresizingMaskIntoConstraints = false

        btnNoLeidos.addTarget(self, action: #selector(mostrarNoLeidas), for: .touchUpInside)
        
        btnFavoritos.addTarget(self, action: #selector(mostrarFavoritas), for: .touchUpInside)
        
        btnEliminadas.addTarget(self, action: #selector(mostrarEliminadas), for: .touchUpInside)
       
        btnHome.addTarget(self, action: #selector(mostrarTodas), for: .touchUpInside)
          

        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 2.0

        stackView.addArrangedSubview(btnHome)
        stackView.addArrangedSubview(btnNoLeidos)
        stackView.addArrangedSubview(btnFavoritos)
        stackView.addArrangedSubview(btnEliminadas)
    }
    
    @objc func mostrarTodas(){
        self.title = "Circulares"
        seleccion = TODAS
        let address="https://www.chmd.edu.mx/WebAdminCirculares/ws/getCirculares_Android.php?usuario_id=\(userId)"
        
                   guard let _url = URL(string: address) else { return };
                   self.getDataFromURL(url: _url)
    }
    
    @objc func mostrarNoLeidas(){
        self.title = "No leídas"
        seleccion = NO_LEIDAS
        let address="https://www.chmd.edu.mx/WebAdminCirculares/ws/getCircularesNoLeidas.php?usuario_id=\(userId)"
        
                   guard let _url = URL(string: address) else { return };
                   self.getDataFromURL(url: _url)
    }
    
    @objc func mostrarFavoritas(){
        seleccion = FAVORITAS
        self.title = "Favoritas"
        let address="https://www.chmd.edu.mx/WebAdminCirculares/ws/getCircularesFavoritas.php?usuario_id=\(userId)"
        
                   guard let _url = URL(string: address) else { return };
                   self.getDataFromURL(url: _url)
    }
    
    @objc func mostrarEliminadas(){
        seleccion = ELIMINADAS
        self.title = "Eliminadas"
        let address="https://www.chmd.edu.mx/WebAdminCirculares/ws/getCircularesEliminadas.php?usuario_id=\(userId)"
        
                   guard let _url = URL(string: address) else { return };
                   self.getDataFromURL(url: _url)
    }
    
   
    @objc func setFavorita(_ sender: UIButton) {
        
        var superView = sender.superview
        
        while !(superView is UITableViewCell) {
            superView = superView?.superview
        }
        let cell = superView as! CircularTableViewCell
        
        
        let favorita = circulares.filter{($0.nombre == cell.lblTitulo.text!)}[0].favorita
        let idC = String(circulares.filter{($0.nombre == cell.lblTitulo.text!)}[0].id)
        if(favorita==0){
        
            cell.imgEstrella.image = UIImage(named: "estrella_amarilla")
            Utilerias().modificarCircular(direccion: "https://www.chmd.edu.mx/WebAdminCirculares/ws/favCircular.php", usuario_id: userId, circular_id: idC)
            
        }else{
            cell.imgEstrella.image = UIImage(named: "estrella_fav_icono")
            Utilerias().modificarCircular(direccion: "https://www.chmd.edu.mx/WebAdminCirculares/ws/elimFavCircular.php", usuario_id: userId, circular_id: idC)
        }
    }
    
    
    //Acciones
    func contextualDelAction(forRowAtIndexPath indexPath: IndexPath) -> UIContextualAction {
        
        var circular = circulares[indexPath.row]
        idCircular = String(circular.id)
        let action = UIContextualAction(style: .normal,
                                        title: "") { [self] (contextAction: UIContextualAction, sourceView: UIView, completionHandler: (Bool) -> Void) in
            if(seleccion != ELIMINADAS){
                let idCircular:String = "\(circular.id)"
                Utilerias().modificarCircular(direccion: "https://www.chmd.edu.mx/WebAdminCirculares/ws/eliminarCircular.php", usuario_id: userId, circular_id: idCircular)
                circulares.remove(at: indexPath.row)
                self.activityIndicator.stopAnimating()
                self.activityIndicator.removeFromSuperview()
                self.tableViewCirculares.reloadData()
            }
        }
        action.image = UIImage(named: "eliminar_blanco64")
        action.backgroundColor = UIColor.red
        
        return action
    }
    
    func contextualUnreadAction(forRowAtIndexPath indexPath: IndexPath) -> UIContextualAction {
        
        var circular = circulares[indexPath.row]
        
        let action = UIContextualAction(style: .normal,
                                        title: "") { [self] (contextAction: UIContextualAction, sourceView: UIView, completionHandler: (Bool) -> Void) in
        
            if(seleccion != NO_LEIDAS){
                idCircular = String(circular.id)
                Utilerias().modificarCircular(direccion: "https://www.chmd.edu.mx/WebAdminCirculares/ws/noleerCircular.php", usuario_id: userId, circular_id: idCircular)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    if(seleccion==TODAS){
                        mostrarTodas()
                    }
                    if(seleccion==NO_LEIDAS){
                        mostrarNoLeidas()
                    }
                    if(seleccion==FAVORITAS){
                        mostrarFavoritas()
                    }
                    
                    if(seleccion==ELIMINADAS){
                        mostrarEliminadas()
                    }
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.removeFromSuperview()
                    tableViewCirculares.reloadData()
                }
                
                
                tableViewCirculares.reloadData()
            }
            
        }
        action.image = UIImage(named: "appmenu05")
        action.backgroundColor = UIColor.white
        
        return action
    }
    
    func contextualReadAction(forRowAtIndexPath indexPath: IndexPath) -> UIContextualAction {
        
        var circular = circulares[indexPath.row]
        idCircular = String(circular.id)
        let action = UIContextualAction(style: .normal,
                                        title: "") { [self] (contextAction: UIContextualAction, sourceView: UIView, completionHandler: (Bool) -> Void) in
            let idCircular:String = "\(circular.id)"
            Utilerias().modificarCircular(direccion: "https://www.chmd.edu.mx/WebAdminCirculares/ws/leerCircular.php", usuario_id: userId, circular_id: idCircular)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                if(seleccion==TODAS){
                    mostrarTodas()
                }
                if(seleccion==NO_LEIDAS){
                    mostrarNoLeidas()
                }
                if(seleccion==FAVORITAS){
                    mostrarFavoritas()
                }
                
                if(seleccion==ELIMINADAS){
                    mostrarEliminadas()
                }
                self.activityIndicator.stopAnimating()
                self.activityIndicator.removeFromSuperview()
                tableViewCirculares.reloadData()
            }
        }
        action.image = UIImage(named: "appmenu04")
        action.backgroundColor = UIColor.white
        
        return action
    }

}
