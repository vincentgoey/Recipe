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
    
    var testingColor: UIColor? {
        didSet{
            self.recipeImageV.backgroundColor = testingColor
        }
    }
    
    var typeLabels: String? {
        didSet{
            self.typeLabel.text = typeLabels
        }
    }
    
    var nameLabels: String? {
        didSet{
            self.nameLabel.text = nameLabels
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(recipeImageV)
        contentView.addSubview(typeLabel)
        contentView.addSubview(nameLabel)

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
        nameLabel.widthAnchor.constraint(equalToConstant: 120).isActive                             = true
                
    }
    
}
