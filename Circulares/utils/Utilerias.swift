//
//  Utilerias.swift
//  Circulares
//
//  Created by Rafael David Castro Luna on 26/7/23.
//

import Foundation
import UIKit
import Alamofire
class Utilerias:NSObject{
    let base_url_foto:String="http://chmd.chmd.edu.mx:65083/CREDENCIALES/padres/"
    
    func cifrarIdUsuario(uri: String, completionHandler: @escaping (Result<Void, Error>) -> Void) {
        AF.request(uri).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                if let diccionarios = value as? [[String: Any]] {
                    for diccionario in diccionarios {
                        guard let cifrado = diccionario["cifrado"] as? String else {
                            print("Error: No se pudo obtener el cifrado")
                            continue
                        }
                        
                        // Guardar el cifrado en UserDefaults
                        UserDefaults.standard.set(cifrado, forKey: "cifrado")
                        completionHandler(.success(()))
                    }
                } else {
                    let error = NSError(domain: "Error en la estructura de la respuesta", code: 0, userInfo: nil)
                    completionHandler(.failure(error))
                }
            case .failure(let error):
                print("Error en la consulta: \(error)")
                completionHandler(.failure(error))
            }
        }
    }
    
    func getVigenciaUsuario(uri: String, completionHandler: @escaping (Result<Void, Error>) -> Void) {
        AF.request(uri).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                if let diccionarios = value as? [[String: Any]] {
                    for diccionario in diccionarios {
                        guard let vigencia = diccionario["texto"] as? String else {
                            print("Error: No se pudo obtener la vigencia")
                            continue
                        }
                        
                        // Guardar la vigencia en UserDefaults
                        UserDefaults.standard.set(vigencia, forKey: "vigencia")
                        completionHandler(.success(()))
                    }
                } else {
                    let error = NSError(domain: "Error en la estructura de la respuesta", code: 0, userInfo: nil)
                    completionHandler(.failure(error))
                }
            case .failure(let error):
                print("Error en la consulta: \(error)")
                completionHandler(.failure(error))
            }
        }
    }
    
    
    
    func parseCircularCompleta(from json: [String: Any]) -> CircularCompleta? {
        guard let id = json["id"] as? String,
              let titulo = json["titulo"] as? String,
              let fecha = json["fecha"] as? String,
              let favorito = json["favorito"] as? String,
              let adjunto = json["adjunto"] as? String,
              let eliminada = json["eliminado"] as? String,
              let texto = json["contenido"] as? String,
              let leido = json["leido"] as? String,
              let fechaIcs = json["fecha_ics"] as? String,
              let horaInicioIcs = json["hora_inicial_ics"] as? String,
              let horaFinIcs = json["hora_final_ics"] as? String else {
            print("Error al obtener los datos de JSON")
            return nil
        }
        
        var imagen: UIImage
        imagen = UIImage.init(named: "appmenu05")!
        
        var noLeida = 0
        
        // Leídas
        if Int(leido)! > 0 {
            imagen = UIImage.init(named: "circle_white")!
        }
        
        // No leídas
        if Int(leido) == 0 && Int(favorito) == 0 {
            imagen = UIImage.init(named: "circle")!
            noLeida = 1
        }
        
        if Int(leido)! == 0 {
            noLeida = 1
        }
        
        var adjuntoInt = 0
        if Int(adjunto) == 1 {
            adjuntoInt = 1
        }
        
        if Int(favorito)! > 0 {
            imagen = UIImage.init(named: "circle_white")!
        }
        
        var str = texto.replacingOccurrences(of: "&lt;", with: "<")
            .replacingOccurrences(of: "&gt;", with: ">")
            .replacingOccurrences(of: "&amp;aacute;", with: "á")
            .replacingOccurrences(of: "&amp;eacute;", with: "é")
            .replacingOccurrences(of: "&amp;iacute;", with: "í")
            .replacingOccurrences(of: "&amp;oacute;", with: "ó")
            .replacingOccurrences(of: "&amp;uacute;", with: "ú")
            .replacingOccurrences(of: "&amp;ordm;", with: "o.")
        
        
        
        var nv = ""
        if let nivel = json["nivel"] as? String {
            nv = nivel
        }
        
        var esp = ""
        if let espec = json["espec"] as? String {
            esp = espec
        }
        
        var grados = ""
        if let gradosString = json["grados"] as? String {
            grados = gradosString
        }
        
        var adm = ""
        if let admString = json["adm"] as? String {
            adm = admString
        }
        
        var rts = ""
        if let rtsString = json["rts"] as? String {
            rts = rtsString
        }
        
        var enviaTodos = ""
        if let enviaTodosString = json["envia_todos"] as? String {
            enviaTodos = enviaTodosString
        }
        
        if Int(eliminada)! == 0 {
            
            return CircularCompleta(id: Int(id)!, encabezado: "", nombre: titulo, fecha: fecha, estado: 0, contenido: "", adjunto: adjuntoInt, fechaIcs: fechaIcs, horaInicialIcs: horaInicioIcs, horaFinalIcs: horaFinIcs, nivel: nv, leido: Int(leido)!, favorita: Int(favorito)!, espec: esp, noLeido: noLeida,eliminado: Int(eliminada)!, grados: grados, adm: adm, grupos: "", rts: rts, enviaTodos: enviaTodos)
        }
        
        if nv.count > 0 {
            nv = "\(nv)/"
        }
        
        if grados.count > 0 {
            grados = "\(grados)/"
        }
        
        if esp.count > 0 {
            esp = "\(esp)/"
        }
        
        if adm.count > 0 {
            adm = "\(adm)/"
        }
        
        if rts.count > 0 {
            rts = "\(rts)/"
        }
        
        var para = "\(nv) \(grados) \(esp) \(adm) \(rts)"
        para = para.trimmingCharacters(in: .whitespacesAndNewlines)
        para = String(para.dropLast())
        print("Para: \(para)")
        if enviaTodos == "1" {
            para = "Todos"
        }
        
        if enviaTodos == "0" && esp == "" && adm == "" && rts == "" && nv != "" && grados == "" {
            para = "Personal"
        }
        
        return CircularCompleta(id: Int(id)!, encabezado: "", nombre: titulo, fecha: fecha, estado: 0, contenido: "", adjunto: adjuntoInt, fechaIcs: fechaIcs, horaInicialIcs: horaInicioIcs, horaFinalIcs: horaFinIcs, nivel: nv, leido: Int(leido)!, favorita: Int(favorito)!, espec: esp, noLeido: noLeida,eliminado: Int(eliminada)!, grados: grados, adm: adm, grupos: "", rts: rts, enviaTodos: enviaTodos)
    }
    
    
    
    func formatearFecha(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "es_ES")
        
        guard let date = dateFormatter.date(from: dateString) else {
            return "Fecha inválida"
        }
        
        let calendar = Calendar.current
        let currentDate = Date()
        
        // Calcula la diferencia en días entre la fecha actual y la fecha proporcionada
        let dayDifference = calendar.dateComponents([.day], from: date, to: currentDate).day ?? 0
        
        if dayDifference < 7 {
            // Si la diferencia es menor a 7 días, devuelve el nombre del día de la semana
            dateFormatter.dateFormat = "EEEE"
            return dateFormatter.string(from: date)
        } else {
            // Calcula la diferencia en semanas entre la fecha actual y la fecha proporcionada
            let weekDifference = calendar.dateComponents([.weekOfMonth], from: date, to: currentDate).weekOfMonth ?? 0
            
            if weekDifference < 5 {
                // Si la diferencia es menor a 5 semanas (1 mes), devuelve hace n semanas
                return "Hace \(weekDifference) semana\(weekDifference == 1 ? "" : "s")"
            } else {
                // Calcula la diferencia en meses entre la fecha actual y la fecha proporcionada
                let monthDifference = calendar.dateComponents([.month], from: date, to: currentDate).month ?? 0
                // Devuelve hace n meses
                return "Hace \(monthDifference) mes\(monthDifference == 1 ? "" : "es")"
            }
        }
        
    }
    
    func modificarCircular(direccion: String, usuario_id: String, circular_id: String) {
        let get_badge: String = "recuentoBadge.php"
        let parameters: Parameters = ["usuario_id": usuario_id, "circular_id": circular_id]
        AF.request(direccion, method: .post, parameters: parameters).responseJSON { response in
            switch response.result {
            case .success(let value):
                print(value)
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    func obtenerDatosUsuario(uri: String, completionHandler: @escaping (Result<Void, Error>) -> Void) {
        AF.request(uri).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                if let diccionarios = value as? [[String: Any]] {
                    for diccionario in diccionarios {
                        guard let id = diccionario["id"] as? String,
                              let nombre = diccionario["nombre"] as? String,
                              let numero = diccionario["numero"] as? String,
                              let familia = diccionario["familia"] as? String,
                              let fotografia = diccionario["fotografia"] as? String,
                              let responsable = diccionario["responsable"] as? String,
                              let correo = diccionario["correo"] as? String,
                              let nuevaFoto = diccionario["nuevaFoto"] as? String else {
                            print("Error: No se pudieron obtener los datos del usuario")
                            continue
                        }
                        
                        var fotoUrl = ""
                        
                        if fotografia.count > 5 {
                            fotoUrl = self.base_url_foto + fotografia.components(separatedBy: "\\")[4]
                        } else {
                            fotoUrl = self.base_url_foto + "sinfoto.png"
                        }
                        
                        // Guardar las variables en UserDefaults
                        UserDefaults.standard.set(id, forKey: "idUsuario")
                        UserDefaults.standard.set(nombre, forKey: "nombreUsuario")
                        UserDefaults.standard.set(numero, forKey: "numeroUsuario")
                        UserDefaults.standard.set(familia, forKey: "familia")
                        UserDefaults.standard.set(fotoUrl, forKey: "fotoUrl")
                        UserDefaults.standard.set(responsable, forKey: "responsable")
                        UserDefaults.standard.set(correo, forKey: "correo")
                        UserDefaults.standard.set(nuevaFoto, forKey: "nuevaFoto")
                        UserDefaults.standard.synchronize()
                        
                        print("idUsuario: \(id)")
                    }
                    completionHandler(.success(()))
                } else {
                    let error = NSError(domain: "Error en la estructura de la respuesta", code: 0, userInfo: nil)
                    completionHandler(.failure(error))
                }
            case .failure(let error):
                print("Error en la consulta: \(error)")
                completionHandler(.failure(error))
            }
        }
    }
    
    
    
    
    
    /*let tmr = Timer.scheduledTimer(withTimeInterval:4.0,repeats:false){timer in
     self.performSegue(withIdentifier: "inicioSegue", sender: self)
     print("llamado el segue desde la funcion")
     timer.invalidate()
     }*/
    
    //Trabajo de cambios en estados (favorita, leer, no leer o eliminar)
    
    
    
    
}
    
    
    
    

    


