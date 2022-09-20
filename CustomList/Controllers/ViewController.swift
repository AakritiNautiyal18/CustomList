//
//  ViewController.swift
//  CustomList
//
//  Created by Daffolap-mac-114 on 19/09/22.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var itemsTableView: UITableView!
    var items = [Any]()
    let imgPicker = UIImagePickerController()
    
    //Index of photo item for which camera is opened
    var currentPhotoIndex = -1
    var currentCommentItemIndex = -1
    var activeTextView:UITextView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDataFromJson()
        registerNibs()
        registerForKeyboardNotifications()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    //method for registering all nibs for all types of table view cells
    func registerNibs(){
        itemsTableView.register(UINib(nibName: "CameraTableViewCell", bundle: nil), forCellReuseIdentifier: "CameraCell")
        itemsTableView.register(UINib(nibName: "CommentTableViewCell", bundle: nil), forCellReuseIdentifier: "CommentCell")
        itemsTableView.register(UINib(nibName: "SingleChoiceTableViewCell", bundle: nil), forCellReuseIdentifier: "SingleChoiceCell")
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardAppear(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardDisappear(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
    }

    
    //Method for loading data from json file
    func loadDataFromJson(){
        guard let url = Bundle.main.url(forResource: "Data", withExtension: ".json") else{
            print("failed loading json")
            return
        }
        do {
            let data = try Data.init(contentsOf: url)
            if let _ = try JSONSerialization.jsonObject(with: data as Data, options: .allowFragments) as? [Any] {
                let itemsArray = try JSONDecoder().decode([ListItem].self, from: data)
                createItemsList(from: itemsArray)
            }
        }catch {
            print(error)
        }
    }
    
    func createItemsList(from items: [ListItem]){
        for index in 0..<items.count{
            let listItem = items[index]
            if let type = ItemType(rawValue: listItem.type){
                switch type {
                    
                case .PHOTO:
                    let item = PhotoItem(listItem: listItem, index: index)
                    self.items.append(item)
                    break
                    
                case .COMMENT:
                    let item = CommentItem(listItem: listItem, index: index)
                    self.items.append(item)
                    break
                    
                case .SINGLE_CHOICE:
                    let item = SingleChoiceItem(listItem: listItem, index: index)
                    self.items.append(item)
                    break
                    
                }
            }
        }
    }


    //Will print id of each ite along with user input
    @IBAction func submit(_ sender: Any) {
        for listItem in items{

            if let photoItem = listItem as? PhotoItem{
                
                if let image = photoItem.image{
                    print("Item number",photoItem.index + 1, "\nItem id - ", photoItem.id, "\nUser Input - ", image.pngData() as Any)
                } else {
                    print("Item number",photoItem.index + 1, "\nItem id - ", photoItem.id, "\nUser Input - No Image")
                }
                
                
            } else if let commentItem = listItem as? CommentItem{
                print("Item number",commentItem.index + 1, "\nItem id - ", commentItem.id, "\nUser Input - ", commentItem.text)
                
            } else if let singleChoiceItem = listItem as? SingleChoiceItem{
                if(singleChoiceItem.selectedOptionIndex) == -1{
                    print("Item number",singleChoiceItem.index + 1, "\nItem id - ", singleChoiceItem.id, "\nUser Input - None")
                } else {
                    print("Item number",singleChoiceItem.index + 1, "\nItem id - ", singleChoiceItem.id, "\nUser Input - ", singleChoiceItem.options[singleChoiceItem.selectedOptionIndex].title)
                }
               
            }
            print("\n")
        }
    }
    
    func getItemType(for item: Any)-> ItemType?{
        if let _ = item as? PhotoItem{
            return ItemType.PHOTO
        } else if let _ = item as? CommentItem{
            return ItemType.COMMENT
        } else if let _ = item as? SingleChoiceItem{
            return ItemType.SINGLE_CHOICE
        }
        return nil
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func onKeyboardAppear(_ notification: NSNotification) {
        let info = notification.userInfo!
        let rect: CGRect = info[UIResponder.keyboardFrameBeginUserInfoKey] as! CGRect
        let kbSize = rect.size

        let insets = UIEdgeInsets(top: 0, left: 0, bottom: kbSize.height + 100, right: 0)
        itemsTableView.contentInset = insets
        itemsTableView.scrollIndicatorInsets = insets

        var aRect = self.view.frame;
        aRect.size.height -= kbSize.height;

        if let activeField = activeTextView {
            if !aRect.contains(activeField.frame.origin) {
                let scrollPoint = CGPoint(x: 0, y: activeField.frame.origin.y-kbSize.height)
                itemsTableView.setContentOffset(scrollPoint, animated: true)
            }
            if currentCommentItemIndex != -1{
                itemsTableView.scrollToRow(at: IndexPath(row: currentCommentItemIndex, section: 0), at: .middle, animated: true)
            }
        }
    }

    @objc func onKeyboardDisappear(_ notification: NSNotification) {
        itemsTableView.contentInset = UIEdgeInsets.zero
        itemsTableView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    
    func cameraPermission(){
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            
        case .authorized: // The user has previously granted access to the camera.
            showCamera()
            break
            
        case .notDetermined: // The user has not yet been asked for camera access.
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    self.showCamera()
                } else {
                    self.currentPhotoIndex = -1
                }
            }
            
        case .denied: // The user has previously denied access.
            presentCameraSettings()
            self.currentPhotoIndex = -1
            break
            
        default:
            cameraNotaccessibleAlert()
            break
        }
        
    }
    
    func showCamera(){
        imgPicker.delegate = self
        imgPicker.sourceType = .camera
        imgPicker.allowsEditing = true
        self.present(imgPicker, animated: true, completion: nil)
    }
    
    func presentCameraSettings() {
        let alertController = UIAlertController(title: "Alert",
                                      message: "Camera access is denied",
                                      preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default))
        alertController.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        })
        present(alertController, animated: true)
    }
    
    func cameraNotaccessibleAlert(){
        let alertController = UIAlertController(title: "Alert",
                                                message: "Camera is not accessible",
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }

}

//MARK: - UITableViewDelegate, UITableViewDataSource methods

extension ViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item  = items[indexPath.row]
        
        if let type = getItemType(for: item){
            switch type {
                
            case .PHOTO:
                if let cameraCell = tableView.dequeueReusableCell(withIdentifier: "CameraCell", for: indexPath) as? CameraTableViewCell, let photoItem = item as? PhotoItem{
                    cameraCell.cellSetup(with:photoItem , and: self)
                    return cameraCell
                }
                break
                
            case .COMMENT:
                if let commentCell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as? CommentTableViewCell, let commentItem = item as? CommentItem{
                    commentCell.cellSetup(with: commentItem, and: self)
                    return commentCell
                }
                break
                
            case .SINGLE_CHOICE:
                if let singleChoiceCell = tableView.dequeueReusableCell(withIdentifier: "SingleChoiceCell", for: indexPath) as? SingleChoiceTableViewCell, let singleChoiceItem = item as? SingleChoiceItem{
                    singleChoiceCell.cellSetup(with: singleChoiceItem, and: self)
                    return singleChoiceCell
                }
                break
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return UITableView.automaticDimension
    }
}

//MARK: - UIImagePickerControllerDelegate &  UINavigationControllerDelegate methods

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true)
        guard let img = info[.editedImage] as? UIImage else {
           print("Error while capturing image")
            currentPhotoIndex = -1
            return
        }
        
        //Display captured image in respective photo item
        if var item = items[currentPhotoIndex] as? PhotoItem{
            item.image = img
            item.isPhotoAvailable = true
            items[currentPhotoIndex] = item
            currentPhotoIndex = -1
            itemsTableView.reloadData()
        }
    }
}

//MARK: - PhotoDelegate methods

extension ViewController:PhotoDelegate{
    
    func openCamera(for itemIndex: Int) {
        currentPhotoIndex = itemIndex
        cameraPermission()
    }
    
    func openPicture(for itemIndex: Int) {
        currentPhotoIndex = itemIndex
        
        if let item = items[itemIndex] as? PhotoItem,
           let image = item.image,
           let imagePreviewVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ImagePreviewVC") as? ImagePreviewViewController {
            
            imagePreviewVC.image = image
            self.present(imagePreviewVC, animated: true, completion: nil)
        }
    }
    
    func removePhoto(for itemIndex: Int) {
        if var item = items[itemIndex] as? PhotoItem{
            item.isPhotoAvailable = false
            item.image = nil
            items[itemIndex] = item
            itemsTableView.reloadData()
        }
    }
}

//MARK: - CommentTextViewDelegate methods

extension ViewController:CommentTextViewDelegate{
    func textViewBeginEditing(textView: UITextView, itemIndex:Int) {
        activeTextView = textView
        currentCommentItemIndex = itemIndex
    }
    
    func saveText(text:String, and itemIndex:Int){
        if var item = items[itemIndex] as? CommentItem{
            item.text = text
            items[itemIndex] = item
            activeTextView = nil
            currentCommentItemIndex = -1
            itemsTableView.reloadData()
        }
    }
    
    func tapOnToggle(for itemIndex: Int) {
        if var item = items[itemIndex] as? CommentItem{
            item.showComment = !item.showComment
            item.text = ""
            items[itemIndex] = item
            itemsTableView.reloadData()
        }
    }
}

//MARK: - SingleChoiceDelegate methods

extension ViewController:SingleChoiceDelegate{
    func optionSelected(for itemIndex: Int, optionIndex: Int){
        if var item = items[itemIndex] as? SingleChoiceItem{
            
            //If there is no last selected element
            if item.selectedOptionIndex == -1{
                item.options[optionIndex].isSelected = true
                item.selectedOptionIndex = optionIndex
            }
            
            //If selected element is tapped again, unselect it
            else if(item.options[optionIndex].isSelected){
                item.options[optionIndex].isSelected = false
                item.selectedOptionIndex = -1
            }
            
            //If any other element is selected, unselect last one
            else {
                let lastSelectedIndex = item.selectedOptionIndex
                item.options[lastSelectedIndex].isSelected = false
                item.options[optionIndex].isSelected = true
                item.selectedOptionIndex = optionIndex
            }
            items[itemIndex] = item
            itemsTableView.reloadData()
        }
    }
}
