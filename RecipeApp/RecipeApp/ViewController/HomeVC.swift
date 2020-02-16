//
//  HomeVC.swift
//  RecipeApp
//
//  Created by Kai Xuan on 16/02/2020.
//  Copyright © 2020 Kai Xuan. All rights reserved.
//

import UIKit
import CoreData

class HomeVC: UIViewController {
    
    fileprivate let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(HomeCell.self, forCellWithReuseIdentifier: "cell")
        return cv
    }()
    
    let cellId = "RecipeCell"
    
    var recipeList = [Recipe]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.pin(to: view)
        self.title = "Recipe List"
        
        self.addButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
//        let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()
//
//
//        if let result = try? PersistenceServce.context.fetch(fetchRequest) {
//            for object in result {
//                PersistenceServce.context.delete(object)
//                PersistenceServce.saveContext()
//            }
//        }
        
    }
    
    func fetchData() {
        let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        do {
            let recipesData = try PersistenceServce.context.fetch(fetchRequest)
            self.recipeList = recipesData
        } catch {}
        self.collectionView.reloadData()
    }
    
    func addButton() {
        let rightButton = UIBarButtonItem(title: "+",  style: .plain, target: self, action:#selector(addButtonTapped))
        rightButton.tintColor = .black
        self.navigationItem.rightBarButtonItem = rightButton
    }
    
    @objc func addButtonTapped() {
        let vc = AddRecipeVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

extension HomeVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if recipeList.count == 0 {
            let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height))
            noDataLabel.text = "No Data Available"
            noDataLabel.textColor = UIColor(red: 22.0/255.0, green: 106.0/255.0, blue: 176.0/255.0, alpha: 1.0)
            noDataLabel.textAlignment = NSTextAlignment.center
            collectionView.backgroundView = noDataLabel
            return 0
        } else {
            collectionView.backgroundView = nil
            return recipeList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HomeCell
        cell.recipe = recipeList[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.view.frame.width - 16), height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = RecipeDetailVC()
        vc.recipeDetails = recipeList[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    }
    
}
