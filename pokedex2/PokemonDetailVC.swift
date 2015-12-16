//
//  PokemonDetailVC.swift
//  pokedex2
//
//  Created by Andrew Nicholson on 14/12/2015.
//  Copyright © 2015 Nicholson Media. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {
    
    var pokemon: Pokemon!
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var defenseLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var pokedexLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var baseAttackLbl: UILabel!
    @IBOutlet weak var evoLbl: UILabel!
    @IBOutlet weak var curEvoImg: UIImageView!
    @IBOutlet weak var nextEvoImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let img = UIImage(named: "\(pokemon.pokedexId)")
        nameLbl.text = pokemon.name.capitalizedString
        mainImg.image = img
        curEvoImg.image = img
        
        clearUI()
        pokemon.downloadPokemonDetails { () -> () in
            //this will be called after download is done
            self.updateUI()
        }
    }
    
    func clearUI() {
        descriptionLbl.text = ""
        typeLbl.text = ""
        defenseLbl.text = ""
        heightLbl.text = ""
        pokedexLbl.text = ""
        weightLbl.text = ""
        baseAttackLbl.text = ""
        nextEvoImg.hidden = true
        evoLbl.text = ""
    }
    
    func updateUI() {
        descriptionLbl.text = pokemon.description
        typeLbl.text = pokemon.type
        defenseLbl.text = pokemon.defense
        heightLbl.text = pokemon.height
        pokedexLbl.text = "\(pokemon.pokedexId)"
        weightLbl.text = pokemon.weight
        baseAttackLbl.text = pokemon.attack
        
        if pokemon.nextEvolutionId == "" {
            evoLbl.text = "No Evolutions"
        } else {
            nextEvoImg.hidden = false
            nextEvoImg.image = UIImage(named: pokemon.nextEvolutionId)
            var str = "Next Evolutions: \(pokemon.nextEvolutionTxt)"
            
            if pokemon.nextEvolutionLevel != "" {
                str += " - LVL \(pokemon.nextEvolutionLevel)"
            }
            
            evoLbl.text = str
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func backBtnPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}
