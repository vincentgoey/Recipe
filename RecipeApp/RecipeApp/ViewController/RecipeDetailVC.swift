//
//  RecipeDetailVC.swift
//  RecipeApp
//
//  Created by Kai Xuan on 16/02/2020.
//  Copyright © 2020 Kai Xuan. All rights reserved.
//

import UIKit
import CoreData

class RecipeDetailVC: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var IngredientLabel: UILabel!
    @IBOutlet weak var stepsLabel: UILabel!
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var ingredientLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var stepLabelHeight: NSLayoutConstraint!
    
    var recipeDetails : Recipe!
    var ingredientStringLabel = ""
    var stepsStringLabel = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Recipe Title"
        configureView()
    }
    
    func configureView() {
        
        if recipeDetails.recipeImagePathType == "BinaryData" {
            recipeImageView.image = UIImage.init(data: recipeDetails.recipeImageData!)
        } else {
            recipeImageView.image = UIImage.init(named: recipeDetails.recipeImageName!)
        }
        
        nameLabel.text = recipeDetails.recipeName
        typeLabel.text = recipeDetails.recipeType
        
        for (index, element) in (recipeDetails.recipeIngredients?.enumerated() ?? nil)! {
            ingredientStringLabel += "\(index+1). \(element) \n"
        }
        
        for (index, element) in (recipeDetails.recipeSteps?.enumerated() ?? nil)! {
            stepsStringLabel += "\(index+1). \(element) \n"
        }
        
        IngredientLabel.text = ingredientStringLabel
        stepsLabel.text = stepsStringLabel
        
        let ingredientHeight = ingredientStringLabel.height(withConstrainedWidth: view.frame.width, font: UIFont.systemFont(ofSize: 17))
        let stepHeight = stepsStringLabel.height(withConstrainedWidth: view.frame.width, font: UIFont.systemFont(ofSize: 17))
        
        ingredientLabelHeight.constant = ingredientHeight
        stepLabelHeight.constant = stepHeight
        self.view.layoutIfNeeded()
        
    }

    @IBAction func deleteRecipeButton(_ sender: Any) {
        
        let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()

        if let result = try? PersistenceServce.context.fetch(fetchRequest) {
            for object in result {
                if object == recipeDetails{
                    PersistenceServce.context.delete(object)
                    PersistenceServce.saveContext()
                }
            }
        }
        
        self.popupAlert(title: "System", message: " Deleted! ", actionTitles: ["Ok"], actions:[{action1 in
            self.navigationController?.popViewController(animated: true)
        }])
    }
}
