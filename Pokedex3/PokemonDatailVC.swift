//
//  PokemonDatailVC.swift
//  Pokedex3
//
//  Created by the Luckiest on 6/20/17.
//  Copyright © 2017 the Luckiest. All rights reserved.
//

import UIKit

class PokemonDatailVC: UIViewController {
    var pokemon: Pokemon!
    
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var defenceLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var pokeIdLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var baseAttackLbl: UILabel!
    
    @IBOutlet weak var currentImg: UIImageView!
    @IBOutlet weak var nextEvoImg: UIImageView!
    
    @IBOutlet weak var evoLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = UIImage(named: "\(pokemon.pokedexId)")
        mainImg.image = image
        
        pokeIdLbl.text = "\(pokemon.pokedexId)"
        
        nameLbl.text = pokemon.name.capitalized

        // Do any additional setup after loading the view.
        
        pokemon.downloadPokemonDetails {
            self.updateUI()
        }
    }
    
    func updateUI(){
        baseAttackLbl.text = pokemon.attack
        defenceLbl.text = pokemon.defence
        heightLbl.text = pokemon.height
        weightLbl.text = pokemon.weight
        typeLbl.text = pokemon.type
        
        descriptionLbl.text = pokemon.description
        if pokemon.nextEvoId == "" {
            evoLbl.text = "No Evolutions"
            nextEvoImg.isHidden = true
        } else {
            nextEvoImg.isHidden = false
            nextEvoImg.image = UIImage(named: pokemon.nextEvoId)
            let str = "Next Evolution: \(pokemon.nextEvoName) - LVL \(pokemon.nextEvoLvl)"
            evoLbl.text = str
        }
        
    }
    
    
    @IBAction func backBtnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
