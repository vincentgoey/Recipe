//
//  AddRecipeVC.swift
//  RecipeApp
//
//  Created by Kai Xuan on 16/02/2020.
//  Copyright © 2020 Kai Xuan. All rights reserved.
//

import UIKit
import CoreData

class AddRecipeVC: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var ingredientTableView: UITableView!
    @IBOutlet weak var stepTableView: UITableView!
    @IBOutlet weak var ingredientTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var stepTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var typeLAbel: UITextField!
    
    var imagePicker = UIImagePickerController()
    private var typePicker = UIPickerView()
    var recipeTypeArray = [String]()
    var countForIngredients = 3
    var countForSteps = 3
    var isUpdateImage = false
    let ingredientCell = "icell"

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Add Recipe"
        imagePicker.delegate = self
        self.imageView.image = UIImage.init(named: "defaultimg")
        readType()
        configureTableView()
        configureImageView()
        configurePicker()
        addButton()
    }
    
    func configurePicker(){
        let toolBar = UIToolbar().ToolbarPiker(mySelect: #selector(self.dismissPicker))
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        self.typePicker.delegate = self
        self.typePicker.dataSource = self
        typeLAbel.inputView = typePicker
        typeLAbel.inputAccessoryView = toolBar
    }
    
    func readType() {
        var propertyListFormat =  PropertyListSerialization.PropertyListFormat.xml

        let xmlPath: String? = Bundle.main.path(forResource: "recipetypes", ofType: "xml")!
        let xmlFile = FileManager.default.contents(atPath: xmlPath!)!
        do {
            let data = try PropertyListSerialization.propertyList(from: xmlFile, options: .mutableContainersAndLeaves, format: &propertyListFormat)
            recipeTypeArray = data as! [String]

        } catch {
            print("Error reading plist: \(error), format: \(propertyListFormat)")
        }
        
        typePicker.reloadAllComponents()
    }
    
    func configureTableView() {
        ingredientTableView.delegate = self
        ingredientTableView.dataSource = self
        ingredientTableView.rowHeight = 30
        ingredientTableView.register(CustomCell.self, forCellReuseIdentifier: "cell")
        
        stepTableView.delegate = self
        stepTableView.dataSource = self
        stepTableView.rowHeight = 30
        stepTableView.register(CustomCell.self, forCellReuseIdentifier: "cell")
    }
    
    func configureImageView() {
        let tapGesture = UITapGestureRecognizer(target:self, action: #selector(imgTapped(tapGestureRecognizer:)))
        tapGesture.numberOfTapsRequired = 1
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGesture)
    }
    
    @IBAction func addIngredientsTF(_ sender: Any) {
        countForIngredients += 1
        ingredientTableView.beginUpdates()
        ingredientTableView.insertRows(at: [IndexPath(row: countForIngredients - 1, section: 0)], with: .automatic)
        ingredientTableView.endUpdates()
        
        ingredientTableViewHeight.constant = CGFloat(countForIngredients * 30)
        view.layoutIfNeeded()
    }
    
    @IBAction func addStepsTF(_ sender: Any) {
        countForSteps += 1
        stepTableView.beginUpdates()
        stepTableView.insertRows(at: [IndexPath(row: countForIngredients - 1, section: 0)], with: .automatic)
        stepTableView.endUpdates()
        
        stepTableViewHeight.constant = CGFloat(countForSteps * 30)
        view.layoutIfNeeded()
    }
    
    func addButton() {
        let rightButton = UIBarButtonItem(title: "Create",  style: .plain, target: self, action:#selector(addButtonTapped))
        rightButton.tintColor = .black
        self.navigationItem.rightBarButtonItem = rightButton
    }
    
}

extension AddRecipeVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView == ingredientTableView ? countForIngredients : countForSteps
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CustomCell
        cell.placeHolderText = tableView == ingredientTableView ? "1 Spoon of Sugar": "Boil 30 mins"
        cell.tagNumber = tableView == ingredientTableView ? indexPath.row + 20 : indexPath.row + 200
        return cell
    }
    
}

class CustomCell: UITableViewCell{
    let textField = UITextField()
    
    var placeHolderText: String? {
        didSet{
            textField.placeholder = placeHolderText
        }
    }
    
    var tagNumber: Int? {
        didSet{
            textField.tag = tagNumber!
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(textField)
        textFieldConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textFieldConstraint() {
        textField.translatesAutoresizingMaskIntoConstraints                                 = false
        textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 16).isActive = true
        textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive   = true
        textField.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive            = true
        textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive      = true
        
    }
    
}

extension AddRecipeVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func imgTapped(tapGestureRecognizer: UITapGestureRecognizer){
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.imageView.image = image
        }
        isUpdateImage = true
        dismiss(animated: true, completion: nil)
    }
    
}

extension AddRecipeVC {
    
    @objc func addButtonTapped() {
        createRecipe()
    }
    
    func createRecipe() {
        
        if !isUpdateImage {
            self.popupAlert(title: "System", message: "Please Upload Image!", actionTitles: ["Ok"], actions:[{action1 in}])
            return
        }

        guard let recipeTitle = self.titleLabel.text, !recipeTitle.isEmpty else{
            self.popupAlert(title: "System", message: "Please Enter Recipe Title!", actionTitles: ["Ok"], actions:[{action1 in}])
            return
        }

        guard let recipeType = self.typeLAbel.text, !recipeType.isEmpty else{
            self.popupAlert(title: "System", message: "Please Select Type!", actionTitles: ["Ok"], actions:[{action1 in}])
            return
        }
        
        //Gather Ingredients
        var ingredients = [String]()
        var steps = [String]()

        for index in 0...countForIngredients - 1 {
            if let theTextField = self.view.viewWithTag(index+20) as? UITextField {
                if !theTextField.text!.isEmpty {
                    ingredients.append(theTextField.text!)
                }
            }
        }

        for index in 0...countForSteps - 1 {
            if let theTextField = self.view.viewWithTag(index+200) as? UITextField {
                if !theTextField.text!.isEmpty {
                    steps.append(theTextField.text!)
                }
            }
        }

        if ingredients.count == 0 {
            self.popupAlert(title: "System", message: "Key In At Least One Ingredients!", actionTitles: ["Ok"], actions:[{action1 in}])
        }

        if steps.count == 0 {
            self.popupAlert(title: "System", message: "Key In At Least One Steps!", actionTitles: ["Ok"], actions:[{action1 in}])
        }
        
        guard let imageData = imageView.image!.jpegData(compressionQuality: 1) else {
            // handle failed conversion
            self.popupAlert(title: "System", message: "Image Format Wrong!", actionTitles: ["Ok"], actions:[{action1 in}])
            return
        }
        
        let newRecipe = Recipe(context: PersistenceServce.context)
        newRecipe.createdDate = Date()
        newRecipe.recipeName = recipeTitle
        newRecipe.recipeSteps = steps
        newRecipe.recipeIngredients = ingredients
        newRecipe.recipeImageName = ""
        newRecipe.recipeImagePathType = "BinaryData"
        newRecipe.recipeImageData = imageData
        newRecipe.recipeType = recipeType
        
        PersistenceServce.saveContext()
        
        self.popupAlert(title: "System", message: " Created! ", actionTitles: ["Ok"], actions:[{action1 in
            self.navigationController?.popViewController(animated: true)
        }])
        
    }
}

extension AddRecipeVC: UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.recipeTypeArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.recipeTypeArray[row]
    }
    
    @objc func dismissPicker() {
        let row = typePicker.selectedRow(inComponent: 0)
        if row == 0{
            self.typeLAbel.text = self.recipeTypeArray[row]
        }
        view.endEditing(true)
    }
}
