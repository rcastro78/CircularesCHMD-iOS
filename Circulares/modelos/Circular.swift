//
//  Circular.swift
//  Circulares
//
//  Created by Rafael David Castro Luna on 22/7/23.
//

import UIKit

class Circular: NSObject,Decodable {
    var nombre:String
    var encabezado:String
    var fecha:String
    var id:Int=0
    var contenido:String
    
    init(id:Int,encabezado:String,nombre:String,fecha:String,contenido:String) {
        self.id=id
        self.nombre=nombre
        self.encabezado = encabezado
        self.fecha = fecha
        self.contenido = contenido
      }
}

class CircularN: NSObject,Decodable {
        var id:Int=0
    var fecha:String
    init(id:Int,fecha:String){
        self.id=id
        self.fecha = fecha
    }
    
}
