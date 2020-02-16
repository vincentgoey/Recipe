//
//  HomeCell.swift
//  RecipeApp
//
//  Created by Kai Xuan on 16/02/2020.
//  Copyright © 2020 Kai Xuan. All rights reserved.
//

import UIKit

class HomeCell: UICollectionViewCell {
    
    fileprivate let recipeImageV : UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        return iv
        }()
    fileprivate let typeLabel : UILabel = {
        let lb = UILabel()
        lb.numberOfLines = 1
        lb.textColor = .lightGray
        lb.font = lb.font.withSize(13)
        return lb
    }()
    fileprivate let nameLabel : UILabel = {
           let lb = UILabel()
           lb.numberOfLines = 1
           lb.textColor = .black
           lb.font = lb.font.withSize(17)
            return lb
       }()
    
    var recipe: Recipe? {
        didSet{
            self.nameLabel.text = recipe?.recipeName
            self.typeLabel.text = recipe?.recipeType
            if recipe!.recipeImagePathType == "BinaryData" {
                recipeImageV.image = UIImage.init(data: recipe!.recipeImageData!)
            } else {
                recipeImageV.image = UIImage.init(named: recipe!.recipeImageName!)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(recipeImageV)
        contentView.addSubview(typeLabel)
        contentView.addSubview(nameLabel)
        
        contentView.backgroundColor = .white
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowRadius = 2
        contentView.layer.shadowOpacity = 0.5
        contentView.layer.masksToBounds = false
        contentView.layer.shadowPath = UIBezierPath(roundedRect: contentView.bounds, cornerRadius: contentView.layer.cornerRadius).cgPath


        setConstaint()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setConstaint() {
        
        recipeImageV.translatesAutoresizingMaskIntoConstraints                                  = false
        recipeImageV.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive   = true
        recipeImageV.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive     = true
        recipeImageV.heightAnchor.constraint(equalToConstant: 140).isActive                     = true
        recipeImageV.widthAnchor.constraint(equalToConstant: contentView.frame.width).isActive  = true
        
        typeLabel.translatesAutoresizingMaskIntoConstraints                                         = false
        typeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive            = true
        typeLabel.topAnchor.constraint(equalTo: recipeImageV.bottomAnchor, constant: 8).isActive    = true
        typeLabel.widthAnchor.constraint(equalToConstant: 120).isActive                             = true
        
        nameLabel.translatesAutoresizingMaskIntoConstraints                                         = false
        nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive            = true
        nameLabel.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 5).isActive       = true
        nameLabel.widthAnchor.constraint(equalToConstant: contentView.frame.width).isActive         = true
                
    }
    
}
