import Foundation

struct UsuarioClass: Decodable{
    let id:Int
    let email:String
    let nombre:String
    let apellido_paterno:String
    let apellido_materno:String
    let tipo_usuario:String
    let estatus:String
    let telefono:String
    let pin_acceso:Int
    let fecha_nacimiento:String
    let fecha_activo:String
    let created_at:String
    let updated_at:String
}
