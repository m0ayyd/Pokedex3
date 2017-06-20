//
//  Pokemon.swift
//  Pokedex3
//
//  Created by the Luckiest on 6/20/17.
//  Copyright © 2017 the Luckiest. All rights reserved.
//

import Foundation
import Alamofire


class Pokemon {
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defence: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvoText: String!
    
    private var _nextEvoName: String!
    private var _nextEvoId: String!
    private var _nextEvoLvl: String!
    
    private var _pokemonURL: String!
    
    var nextEvoName: String {
        if _nextEvoName == nil {
            _nextEvoName = ""
        }
        return _nextEvoName
    }
    
    var nextEvoId: String {
        if _nextEvoId == nil {
            _nextEvoId = ""
        }
        return _nextEvoId
    }
    
    var nextEvoLvl: String {
        if _nextEvoLvl == nil {
            _nextEvoLvl = ""
        }
        return _nextEvoLvl
    }
    
    
    var description: String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    var type: String {
        if _type == nil {
            _type = ""
        }
        return  _type
    }
    
    var defence: String {
        if _defence == nil {
            _defence = ""
        }
        return _defence
    }
    
    var height: String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    
    var attack: String {
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }
    
    var nextEvoText: String {
        if _nextEvoText == nil {
            _nextEvoText = ""
        }
        return _nextEvoText
    }
    
    
    var name: String {
        return _name
    }
    
    var pokedexId: Int {
        return _pokedexId
    }
    
    init(name: String, pokedexId: Int){
        self._name = name
        self._pokedexId = pokedexId
        
        self._pokemonURL = "\(URL_BASE)\(URL_POKEMONE)\(self.pokedexId)"
    }
    
    func downloadPokemonDetails(completed: @escaping DownloadComplete) {
        print(_pokemonURL)
        Alamofire.request(_pokemonURL).responseJSON { response in
            if let dict = response.result.value as? [String:Any] {
                if let attack = dict["attack"] as? Int {
                    self._attack = "\(attack)"
                }
                
                if let defence = dict["defense"] {
                    self._defence = "\(defence)"
                }
                
                if let weight = dict["weight"] as? String {
                    self._weight = "\(weight)"
                }
                
                if let height = dict["height"] as? String {
                    self._height = "\(height)"
                }
                
                if let types = dict["types"] as? [[String: String]], types.count > 0 {
                    if let name = types[0]["name"] {
                        self._type = name.capitalized
                    }
                    
                    if types.count > 1 {
                        for x in 1..<types.count {
                            if let name =  types[x]["name"]{
                                self._type! += "/\(name.capitalized)"
                            }
                        }
                    }
                    
                } else {
                    self._type = ""
                }
                
                // Description
                if let descArray = dict["descriptions"] as? [[String: String]], descArray.count > 0 {
                    if let url = descArray[0]["resource_uri"] {
                        let dscUrl = "\(URL_BASE)\(url)"
                        Alamofire.request(dscUrl).responseJSON(completionHandler: { (response) in
                            if let d = response.result.value as? [String:Any] {
                                if let description = d["description"] as? String {
                                    let newDescription = description.replacingOccurrences(of: "POKMON", with: "Pokemon")
                                    self._description = newDescription
                                }
                            }
                        })
                        
                    } else {
                        self._description = ""
                    }
                    completed()
                }
                
                
                // Evolution
                if let evoArray = dict["evolutions"] as? [[String: Any]], evoArray.count > 0 {
                    if let nextEvo = evoArray[0]["to"] as? String {
                        if nextEvo.range(of: "mega") == nil {
                            self._nextEvoName = nextEvo
                            
                            if let uri = evoArray[0]["resource_uri"] as? String {
                                let newString = uri.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                                let newEvoId = newString.replacingOccurrences(of: "/", with: "")
                                self._nextEvoId = newEvoId
                                
                                
                                if let lvlExists = evoArray[0]["level"] {
                                    if let lvl = lvlExists as? Int {
                                        self._nextEvoLvl = "\(lvl)"
                                    }
                                } else {
                                    self._nextEvoLvl = ""
                                }
                            }
                        }
                        
                    }
                }
            }
            
        }
    }
}
