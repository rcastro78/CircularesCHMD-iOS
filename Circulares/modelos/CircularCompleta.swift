//
//  CircularCompleta.swift
//  Circulares
//
//  Created by Rafael David Castro Luna on 22/7/23.
//

import Foundation
import UIKit
class CircularCompleta: NSObject,Codable {
    var nombre:String
    var encabezado:String
    var fecha:String
    var id:Int=0;
    //var imagen:UIImage
    var estado:Int
    var contenido:String
    var adjunto:Int
    var favorita:Int
    var fechaIcs:String
    var horaInicialIcs:String
    var horaFinalIcs:String
    var nivel:String?
    var espec:String
    var leido:Int
    var noLeido:Int
    var eliminado:Int
    var grados:String
    var adm:String
    var grupos:String
    var rts:String
    var enviaTodos:String
 
   
    init(id:Int,encabezado:String,nombre:String,fecha:String,estado:Int,contenido:String, adjunto:Int,fechaIcs:String,horaInicialIcs:String,horaFinalIcs:String,nivel:String,leido:Int,favorita:Int,espec:String,noLeido:Int,eliminado:Int,grados:String,adm:String,grupos:String,rts:String,enviaTodos:String) {
           self.id=id
           self.nombre=nombre
           self.encabezado = encabezado
           self.fecha = fecha
        self.eliminado = eliminado
           self.estado = estado
           self.contenido = contenido
           self.adjunto = adjunto
           self.fechaIcs=fechaIcs
           self.horaInicialIcs=horaInicialIcs
           self.horaFinalIcs=horaFinalIcs
           self.leido = leido
           self.nivel=nivel as? String ?? ""
           self.favorita = favorita
        self.espec = espec
        self.noLeido = noLeido
        self.grados = grados
        self.adm = adm
        self.grupos = grupos
        self.rts = rts
        self.enviaTodos = enviaTodos
       }
    
}
