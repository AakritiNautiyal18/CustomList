//
//  CommentTableViewCell.swift
//  CustomList
//
//  Created by Daffolap-mac-114 on 19/09/22.
//

import UIKit

protocol CommentTextViewDelegate:AnyObject{
    func textViewBeginEditing(textView:UITextView, itemIndex:Int)
    func saveText(text:String, and itemIndex:Int)
    func tapOnToggle(for itemIndex:Int)
}

class CommentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var outerView: UIView!
    @IBOutlet private weak var toggleImageView: UIImageView!
    @IBOutlet private weak var commentTextView: UITextView!
    @IBOutlet private weak var placeHolderLabel: UILabel!
    
    private weak var delegate:CommentTextViewDelegate?
    private var commentItem: CommentItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        outerView.layer.cornerRadius = 5
        outerView.layer.borderColor = UIColor.black.cgColor
        outerView.layer.borderWidth = 1
        
        commentTextView.layer.borderColor = UIColor.gray.cgColor
        commentTextView.layer.borderWidth = 1
        commentTextView.layer.cornerRadius = 5
        commentTextView.delegate = self
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapOnToggleButton))
        toggleImageView.addGestureRecognizer(gesture)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func cellSetup(with itemDetails: CommentItem, and delegate: CommentTextViewDelegate){
        commentItem = itemDetails
        self.delegate = delegate
        designCell()
    }
}

private extension CommentTableViewCell{
    func designCell(){
        if let commentItem = commentItem{
            if commentItem.showComment{
                toggleImageView.image = UIImage(named: "on-button")
                commentTextView.isHidden = false
                commentTextView.text = commentItem.text
                if commentItem.isTextPresent{
                    placeHolderLabel.isHidden = true
                } else{
                    placeHolderLabel.isHidden = false
                }
            } else {
                placeHolderLabel.isHidden = true
                toggleImageView.image = UIImage(named: "off-button")
                commentTextView.isHidden = true
            }
        }
    }
    
    @objc func tapOnToggleButton(){
        if let commentItem = commentItem{
            delegate?.tapOnToggle(for: commentItem.index)
        }
    }
}

extension CommentTableViewCell: UITextViewDelegate{
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        delegate?.textViewBeginEditing(textView: textView, itemIndex: commentItem?.index ?? -1)
        return true
    }
    func textViewDidBeginEditing(_ textView: UITextView){
        placeHolderLabel.isHidden = true
    }

    func textViewDidEndEditing(_ textView: UITextView){
        delegate?.saveText(text: textView.text, and: commentItem?.index ?? -1)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if(text == "\n") {
                textView.resignFirstResponder()
                return false
            }
            return true
        }
}
