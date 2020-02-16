//
//  RecipeDetailVC.swift
//  RecipeApp
//
//  Created by Kai Xuan on 16/02/2020.
//  Copyright © 2020 Kai Xuan. All rights reserved.
//

import UIKit

class RecipeDetailVC: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var IngredientLabel: UILabel!
    @IBOutlet weak var stepsLabel: UILabel!
    
    @IBOutlet weak var ingredientLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var stepLabelHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Recipe Title"
    }

    @IBAction func deleteRecipeButton(_ sender: Any) {
    }
}
