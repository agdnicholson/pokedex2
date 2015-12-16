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
    
    var pokemonNames = [Int:String]()
    
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
    
    @IBOutlet weak var nextPokeButton: UIButton!
    @IBOutlet weak var previousPokeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getPokemonNames()
        checkPrevNextButtons()
        loadPoke()
    }
    
    func checkPrevNextButtons() {
        if pokemon.pokedexId <= 1 {
            previousPokeButton.alpha = 0.2
            previousPokeButton.enabled = false
        }else {
            previousPokeButton.alpha = 1
            previousPokeButton.enabled = true
        }
        
        if pokemon.pokedexId >= 718 {
            nextPokeButton.alpha = 0.2
            nextPokeButton.enabled = false
        } else {
            nextPokeButton.alpha = 1
            nextPokeButton.enabled = true
        }
    }
    
    func loadPoke() {
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

    @IBAction func nextBtnPressed(sender: AnyObject) {
        let newPokeId = pokemon.pokedexId + 1
        if let newPokeName = pokemonNames[newPokeId] {
            pokemon = Pokemon(name: newPokeName, pokedexId: newPokeId)
            checkPrevNextButtons()
            loadPoke()
        }
    }
    
    
    @IBAction func previousBtnPressed(sender: AnyObject) {
        let newPokeId = pokemon.pokedexId - 1
        if let newPokeName = pokemonNames[newPokeId] {
            pokemon = Pokemon(name: newPokeName, pokedexId: newPokeId)
            checkPrevNextButtons()
            loadPoke()
        }
    }
    
    func getPokemonNames() {
        let path = NSBundle.mainBundle().pathForResource("pokemon", ofType: "csv")!
        
        do {
            let csv  = try CSV(contentsOfURL: path)
            let rows = csv.rows
            
            for row in rows {
                let pokeId = Int(row["id"]!)!
                let name = row["identifier"]!
                pokemonNames[pokeId] = name
            }
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
}
