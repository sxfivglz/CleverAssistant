import Foundation

struct HistorialClass: Decodable{
    let _id:String
    let Invernadero:String
    let Estacion:String
    let Fecha:String
    let Tipo_Activacion:String
    let Id_Usuario:String
    let Sensores: [Sensores]
    
    struct Sensores: Codable{
        let id_sensor:String
        let estacion:Int
        let tipo:String
        let nombre:String
        let valor:Double
        let _id:String
    }
}
