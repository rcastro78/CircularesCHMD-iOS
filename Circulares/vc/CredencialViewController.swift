//
//  CredencialViewController.swift
//  Circulares
//
//  Created by Rafael David Castro Luna on 28/7/23.
//

import UIKit
import SnapKit
import SDWebImage
import Alamofire
class CredencialViewController: UIViewController {
    
    @IBOutlet weak var vwContainerDatos: UIView!
    @IBOutlet weak var viewContainerQR: UIView!
    @IBOutlet weak var imgUser: UIImageView!
    var urlFotos:String = "http://chmd.chmd.edu.mx:65083/CREDENCIALES/padres/"
    var urlFirma:String = "https://www.chmd.edu.mx/imagenesapp/img/firma.jpg"
    var urlNuevaFoto:String = "https://www.chmd.edu.mx/WebAdminCirculares/ws/"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        renderUI()
        // Do any additional setup after loading the view.
        var nombre = UserDefaults.standard.string(forKey: "nombreUsuario") ?? ""
        var responsable = UserDefaults.standard.string(forKey: "responsable") ?? ""
        var familia = UserDefaults.standard.string(forKey: "familia") ?? ""
        var vigencia = UserDefaults.standard.string(forKey: "vigencia") ?? ""
        var fotoUrl = UserDefaults.standard.string(forKey: "fotoUrl") ?? ""
        var cifrado = UserDefaults.standard.string(forKey: "cifrado") ?? ""
        var nfamilia = UserDefaults.standard.string(forKey: "numeroUsuario") ?? "0"
        var nuevaFoto = UserDefaults.standard.string(forKey: "nuevaFoto") ?? ""
        nameLabel.text = nombre
        parentLabel.text = responsable
        vigenciaLabel.text = vigencia
        let imagen = self.generarQR(from: cifrado)
        imageViewQR.image = imagen
        print("status code \(nuevaFoto)")
        if(!nuevaFoto.isEmpty){
            obtenerFotoDelUsuario(foto: urlNuevaFoto+nuevaFoto)
        }else{
            obtenerFotoDelUsuario(foto: fotoUrl)
        }
        
        SDWebImageManager.shared.loadImage(
                with:URL(string:self.urlFirma),
                options: .highPriority,
                progress: nil) { (image, data, error, cacheType, isFinished, imageUrl) in
                    self.imageViewFirma.image = image
              }
        
        
        
    }
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .mediumThemeFont(size: 17)
        label.text = "Nombre"
        label.textColor = UIColor.textoClaro
        return label
    }()
    
    lazy var parentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .mediumThemeFont(size: 15)
        label.textAlignment = .center
        label.text = "Padre"
        label.textColor = UIColor.textoClaro
        return label
    }()
    
    lazy var vigenciaLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .mediumThemeFont(size: 15)
        label.textAlignment = .center
        label.text = "Vigencia"
        label.textColor = UIColor.textoClaro
        return label
    }()
    
    lazy var panelIzquierdo:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.azulColegio
        return view
    }()
    
    lazy var panelDerecho:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.azulColegio
        return view
    }()
    
    lazy var panelCentral:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    lazy var imageViewQR: UIImageView = {
        let imageView1 = UIImageView()
        imageView1.backgroundColor = .white
        return imageView1
    }()
    
    lazy var imageViewFirma: UIImageView = {
        let imageView1 = UIImageView()
        imageView1.backgroundColor = .white
        return imageView1
    }()
    
    func generarQR(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }

        return nil
    }

    func obtenerFotoDelUsuario(foto:String) {
        let imageURL = URL(string: foto.replacingOccurrences(of: " ", with: "%20"))!
        print("status code: \(imageURL)")
        AF.request(imageURL).responseJSON { response in
            if let statusCode = response.response?.statusCode {
                print("status code: \(statusCode)")
                if(statusCode > 200){
                    let imagen = URL(string: self.urlFotos+"sinfoto.png")!
                    SDWebImageManager.shared.loadImage(
                            with: imagen,
                            options: .highPriority,
                            progress: nil) { (image, data, error, cacheType, isFinished, imageUrl) in
                                self.imgUser.image = image
                          }
                }else{
                    SDWebImageManager.shared.loadImage(
                            with:imageURL,
                            options: .highPriority,
                            progress: nil) { (image, data, error, cacheType, isFinished, imageUrl) in
                                self.imgUser.image = image
                          }
                }
                
                
            } else {
                print("No se pudo obtener el status de respuesta.")
            }
        }
    }
    
    
    func renderUI(){
        vwContainerDatos.addSubview(nameLabel)
        vwContainerDatos.addSubview(parentLabel)
        vwContainerDatos.addSubview(vigenciaLabel)
        viewContainerQR.addSubview(panelIzquierdo)
        panelCentral.addSubview(imageViewQR)
        panelCentral.addSubview(imageViewFirma)
        viewContainerQR.addSubview(panelCentral)
        viewContainerQR.addSubview(panelDerecho)
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalTo(vwContainerDatos)
            make.top.equalTo(32)
        }
        
        parentLabel.snp.makeConstraints { make in
            make.centerX.equalTo(vwContainerDatos)
            make.top.equalTo(nameLabel).offset(32)
        }
        
        vigenciaLabel.snp.makeConstraints { make in
            make.centerX.equalTo(vwContainerDatos)
            make.top.equalTo(parentLabel).offset(32)
        }
        
        panelIzquierdo.snp.makeConstraints { make in
            make.left.top.bottom.equalTo(viewContainerQR)
            make.width.equalTo(viewContainerQR).multipliedBy(0.25)
        }
        
        panelDerecho.snp.makeConstraints { make in
            make.left.equalTo(panelCentral.snp.right)
            make.top.right.bottom.equalTo(viewContainerQR)
            make.width.equalTo(viewContainerQR).multipliedBy(0.25)
        }
        
        
        
        panelCentral.snp.makeConstraints { make in
            make.left.equalTo(panelIzquierdo.snp.right)
            make.top.bottom.equalTo(viewContainerQR)
            make.width.equalTo(viewContainerQR).multipliedBy(0.5)
        }
        
        imageViewQR.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(12)
            make.centerY.equalToSuperview().multipliedBy(0.5)
            make.width.equalTo(panelCentral).multipliedBy(0.65)
        }
        
        imageViewFirma.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(32)
            make.width.equalTo(imageViewQR)
            make.height.equalTo(imageViewQR).multipliedBy(0.65)
        }
        
    }

}
