//
//  RecipeCell.swift
//  RecipeApp
//
//  Created by Kai Xuan on 16/02/2020.
//  Copyright © 2020 Kai Xuan. All rights reserved.
//

import UIKit

class RecipeCell: UICollectionViewCell {
    
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeTypeLabel: UILabel!
    @IBOutlet weak var recipeNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
