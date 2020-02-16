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
    var dataToBeDisplay = [Recipe]()
    var recipeTypeArray = [String]()
    var recipeTypeArray2 = [String]()
    var filterPicker = UIPickerView()
    var toolBar = UIToolbar()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configurePicker()
        readType()
        addButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
    }
    
    func readType() {
        var propertyListFormat =  PropertyListSerialization.PropertyListFormat.xml

        let xmlPath: String? = Bundle.main.path(forResource: "recipetypes", ofType: "xml")!
        let xmlFile = FileManager.default.contents(atPath: xmlPath!)!
        do {
            let data = try PropertyListSerialization.propertyList(from: xmlFile, options: .mutableContainersAndLeaves, format: &propertyListFormat)
            recipeTypeArray = data as! [String]
            recipeTypeArray2 = data as! [String]

        } catch {
            print("Error reading plist: \(error), format: \(propertyListFormat)")
        }
        
        filterPicker.reloadAllComponents()
    }
    
    func configurePicker() {
        filterPicker.frame = CGRect(x: 0.0, y: UIScreen.main.bounds.size.height - 200, width: UIScreen.main.bounds.size.width, height: 200)
        filterPicker.isHidden = true
        filterPicker.delegate = self
        
        toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 250, width: UIScreen.main.bounds.size.width, height: 50))
        toolBar.barStyle = .default
        toolBar.items = [UIBarButtonItem.init(title: "Filter", style: .done, target: self, action: #selector(filterConfirmPicker)),UIBarButtonItem.init(title: "Cancel", style: .done, target: self, action: #selector(dismissPicker))]
        toolBar.isHidden = true
        
        self.view.addSubview(toolBar)
        self.view.addSubview(filterPicker)
    }
    
    func configureView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.pin(to: view)
        self.title = "Recipe List"
    }
    
    func fetchData() {
        let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        do {
            let recipesData = try PersistenceServce.context.fetch(fetchRequest)
            recipeList = recipesData
            dataToBeDisplay = recipesData
        } catch {}
        self.collectionView.reloadData()
    }
    
    func addButton() {
        let rightButton = UIBarButtonItem(title: "+",  style: .plain, target: self, action:#selector(addButtonTapped))
        rightButton.tintColor = .black
        self.navigationItem.rightBarButtonItem = rightButton
        
        let leftButton = UIBarButtonItem(title: "Filter",  style: .plain, target: self, action:#selector(filteration))
        leftButton.tintColor = .black
        self.navigationItem.leftBarButtonItem = leftButton
    }
    
    @objc func addButtonTapped() {
        let vc = AddRecipeVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func filteration() {
        filterPicker.isHidden = !filterPicker.isHidden
        toolBar.isHidden = !toolBar.isHidden
    }

}

extension HomeVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if dataToBeDisplay.count == 0 {
            let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height))
            noDataLabel.text = "No Data Available"
            noDataLabel.textColor = UIColor(red: 22.0/255.0, green: 106.0/255.0, blue: 176.0/255.0, alpha: 1.0)
            noDataLabel.textAlignment = NSTextAlignment.center
            collectionView.backgroundView = noDataLabel
            return 0
        } else {
            collectionView.backgroundView = nil
            return dataToBeDisplay.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HomeCell
        cell.recipe = dataToBeDisplay[indexPath.row]
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

extension HomeVC: UIPickerViewDelegate, UIPickerViewDataSource {
    @objc func dismissPicker() {
        filterPicker.isHidden = true
        toolBar.isHidden = true
    }
    
    @objc func filterConfirmPicker() {
        filterPicker.isHidden = true
        toolBar.isHidden = true
        filter()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.recipeTypeArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.recipeTypeArray[row]
    }
    
    func filter() {
        //get selectedvalue
        let row = filterPicker.selectedRow(inComponent: 0)
        let selectedFilterType = recipeTypeArray[row]
        
        //update filter button label
        self.navigationItem.leftBarButtonItem = nil
        let leftButton = UIBarButtonItem(title: recipeTypeArray[row],  style: .plain, target: self, action:#selector(filteration))
        leftButton.tintColor = .black
        self.navigationItem.leftBarButtonItem = leftButton
        
        if recipeTypeArray2.contains(selectedFilterType) {
            
            //this part can be done using filter, since this project using core data then use core data predicate to do filteration
            let predicate = NSPredicate(format: "recipeType = %@", selectedFilterType)
            let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()
            fetchRequest.predicate = predicate
            do {
                let recipesData = try PersistenceServce.context.fetch(fetchRequest)
                self.dataToBeDisplay = recipesData
            } catch {}
            self.collectionView.reloadData()
            
        }
        
    }
}
