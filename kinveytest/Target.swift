//
//  Target.swift
//  kinveytest
//
//  Created by jetgem on 1/14/19.
//  Copyright © 2019 jetgem. All rights reserved.
//

import Kinvey

class Target: Entity, Codable {
    @objc dynamic var isEnabled: Bool = false
    
    override class func collectionName() -> String {
        //return the name of the backend collection corresponding to this entity
        return "Targets"
    }
    
    enum CodingKeys : String, CodingKey {
        case isEnabled = "show"
    }
    
    // Swift.Decodable
    required init(from decoder: Decoder) throws {
        //This maps the "_id", "_kmd" and "_acl" properties
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        //Each property in your entity should be mapped using the following scheme:
        isEnabled = try container.decodeIfPresent(Bool.self, forKey: .isEnabled)!
    }
    // Swift.Encodable
    override func encode(to encoder: Encoder) throws {
        //This maps the "_id", "_kmd" and "_acl" properties
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeIfPresent(isEnabled, forKey: .isEnabled)
    }
    /// Default Constructor
    required init() {
        super.init()
    }
    /// Realm Constructor
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    /// Realm Constructor
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    @available(*, deprecated, message: "Please use Swift.Codable instead")
    required init?(map: Map) {
        super.init(map: map)
    }
}
