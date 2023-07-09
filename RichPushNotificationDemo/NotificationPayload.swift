//
//  NotificationPayload.swift
//  RichPushNotificationDemo
//
//  Created by vtadmin on 02/07/23.
//

import Foundation

// MARK: - NotificationPayload
struct NotificationPayload: Codable {
    var aps: Aps?
    var fcmOptions: FcmOptions?
    var gcmMessageID: String?
    var googleCAE: String?
    var googleCFid, googleCSenderID: String?

    enum CodingKeys: String, CodingKey {
        case aps
        case fcmOptions = "fcm_options"
        case gcmMessageID = "gcm.message_id"
        case googleCAE = "google.c.a.e"
        case googleCFid = "google.c.fid"
        case googleCSenderID = "google.c.sender.id"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.aps = try values.decode(Aps.self, forKey: .aps)
        self.fcmOptions = try values.decode(FcmOptions.self, forKey: .fcmOptions)
        
        self.gcmMessageID = decodeToString(values, key: .gcmMessageID)
        self.googleCFid = decodeToString(values, key: .googleCFid)
        self.googleCSenderID = decodeToString(values, key: .googleCSenderID)
        self.googleCAE = decodeToString(values, key: .googleCAE)
        
    }
}

// MARK: - Aps
struct Aps: Codable {
    var alert: Alert?
    var mutableContent, sound: String?

    enum CodingKeys: String, CodingKey {
        case alert
        case mutableContent = "mutable-content"
        case sound
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.alert = try values.decode(Alert.self, forKey: .alert)
        
        self.mutableContent = decodeToString(values, key: .mutableContent)
        self.sound = decodeToString(values, key: .sound)
        
    }
}

// MARK: - Alert
struct Alert: Codable {
    let body, title: String?
}

// MARK: - FcmOptions
struct FcmOptions: Codable {
    let image: String?
}



extension Decodable {
    
    func decodeToString<K:CodingKey>(_ value: KeyedDecodingContainer<K>, key: KeyedDecodingContainer<K>.Key) -> String? {
        var str: String? = nil
        if let res = try? value.decodeIfPresent(String.self, forKey: key) {
            str = res
        } else if let res = try? value.decodeIfPresent(Int.self, forKey: key) {
            str = String(format: "%@", "\(res)")
        } else if let res = try? value.decodeIfPresent(Double.self, forKey: key) {
            str = String(format: "%@", "\(res)")
        } else if let res = try? value.decodeIfPresent(Int64.self, forKey: key) {
            str = String(format: "%@", "\(res)")
        }
        return str
    }
}

extension Dictionary where Key == String, Value: Any {
    
    func object<T: Decodable>() -> T? {
        
        do {
            
            let data = try JSONSerialization.data(withJSONObject: self, options: [])
            return try JSONDecoder().decode(T.self, from: data)
            
        }catch {
            print("DEBUG ERROR OBJECT :-",error.localizedDescription.debugDescription)
            return nil
        }
        
        
    }
    
    func getJsonString() -> String {
        
        do {
            let json = try JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted)
            return String(data: json, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
            
        } catch {
            return ""
        }
    }
}
