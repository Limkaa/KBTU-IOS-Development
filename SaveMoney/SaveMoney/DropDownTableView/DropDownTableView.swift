//
//  DropDownTableView.swift
//  SaveMoney
//
//  Created by Alim on 10.05.2021.
//

import Foundation
import UIKit

public class DropDownTableView: UIView {
    
    var transparentView = UIView()
    var tableView = UITableView()
    
    var viewForTransoarentView: UIView!
    var selectedButton: UIButton!
    var x: CGFloat!
    var y: CGFloat!
    var width: CGFloat!
    var maxHeight: CGFloat!
    var rowHeight: CGFloat = 50
    var font = UIFont(name: "Helvetica", size: 15)
    
    var choosenObject: NSObject!
    var array: [NSObject]!
    var dataSource: [Any]!
    var fieldName: String!
    
    func addTransparentView() {
        
        if array.count > 0 {
            transparentView.alpha = 0
            let tapgesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
            transparentView.addGestureRecognizer(tapgesture)
            
            transparentView.frame = viewForTransoarentView.frame
            transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
            viewForTransoarentView.addSubview(transparentView)
            
            tableView.frame = CGRect(x: self.x, y: self.y, width: selectedButton.frame.width, height: 0)
            tableView.layer.cornerRadius = 15
            tableView.dataSource = self
            tableView.delegate = self
            dataSource = array.map({ (object: NSObject) -> Any in
                object.value(forKey: fieldName)!
            })
            tableView.reloadData()
            tableView.register(DropDownTableViewCell.self, forCellReuseIdentifier: "DropDownTableViewCell")
            viewForTransoarentView.addSubview(tableView)
            
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
                self.transparentView.alpha = 0.5
                var tableViewHeight = CGFloat(self.dataSource.count * 50)
                if tableViewHeight > self.maxHeight {
                    tableViewHeight = self.maxHeight
                }
                self.tableView.frame = CGRect(x: self.x, y: self.y, width: self.width, height: tableViewHeight)
            }, completion: nil)
        }
    }
    
    @objc func removeTransparentView() {
        let frames = selectedButton.frame
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
            self.transparentView.alpha = 0
            self.tableView.frame = CGRect(x: self.x, y: self.y, width: frames.width, height: 0)
        }, completion: nil)
    }
}


extension DropDownTableView: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DropDownTableViewCell", for: indexPath)
        cell.textLabel?.text = (dataSource[indexPath.row] as! String)
        cell.textLabel?.font = font
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedButton.setTitle((dataSource[indexPath.row] as! String), for: .normal)
        choosenObject = array[indexPath.row]
        removeTransparentView()
    }
}
