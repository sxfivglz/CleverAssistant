//
//  UsuariosClass.swift
//  GreenHouse Assistant
//
//  Created by Mac19 on 20/07/22.
//

import Foundation
struct UsuariosClass: Decodable{
    let id:Int
    let email:String
    let nombre:String
    let apellido_paterno:String
    let apellido_materno:String
    let tipo_usuario:String
    let estatus:String
    let telefono:Int
    let pin_acceso:Int
    let fecha_nacimiento:String
    let fecha_activo:String
    let created_at:String
    let updated_at:String
    
    
    
    
    
    
    
    
    
    
    
    /*init(id:Int,email:String,nombre:String, apellido_paterno:String,apellido_materno:String,tipo_usuario:String,estatus:String,telefono:Int,pin_acceso:Int,fecha_nacimiento:String,fecha_activo:String,created_at:String,updated_at:String ) {
        self.id = id
        self.email = email
        self.nombre = nombre
        self.apellido_paterno = apellido_paterno
        self.apellido_materno = apellido_materno
        self.tipo_usuario = tipo_usuario
        self.estatus = estatus
        self.telefono = telefono
        self.pin_acceso = pin_acceso
        self.fecha_nacimiento = fecha_nacimiento
        self.fecha_activo = fecha_activo
        self.created_at = created_at
        self.updated_at = updated_at
        
    }*/
    
}
 
