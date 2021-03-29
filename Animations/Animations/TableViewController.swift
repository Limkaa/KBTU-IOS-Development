//
//  TableViewController.swift
//  Animations
//
//  Created by Alim on 29.03.2021.
//

import UIKit

struct Phone {
    var title: String
    var price: String
    var core: String
    var detail: String
}

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var phones: [Phone] = [Phone(title: "iPhone 7 Plus", price: "350$", core: "A10 Fusion", detail: "12MPX"),
                           Phone(title: "Samsung Galaxy S8", price: "500$", core: "Snapdragon 835", detail: "12MPX"),
                           Phone(title: "LG G4", price: "400$", core: "Snapdragon 808", detail: "16MPX"),
                           Phone(title: "Nexus 6P", price: "700$", core: "Snapdragon 810", detail: "12.3MPX"),
                           Phone(title: "HTC One M9", price: "350$", core: "Snapdragon 810", detail: "20MPX"),
                           Phone(title: "Google Pixel", price: "350$", core: "Snapdragon 821", detail: "12MPX"),]
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return phones.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell") as? CustomCell
        let currentPhone = phones[indexPath.row]

        cell?.title.text = currentPhone.title
        cell?.details.text = currentPhone.price
        cell?.infoButton.tag = indexPath.row
        cell?.additionalView = setupAdditionalView(index: indexPath.row, cell: cell!, phone: currentPhone)
        cell?.addSubview(cell!.additionalView)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(translationX: -tableView.bounds.width, y: 0)
        UIView.animate(
            withDuration: 0.5,
            delay: 0.3 * Double(indexPath.row),
            options: .curveEaseInOut,
            animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0)
        })
    }
    
    func setupAdditionalView(index: Int, cell: UITableViewCell, phone: Phone) -> UIView {
        let additionalView = UIView()
        
        additionalView.backgroundColor = UIColor(red: 230.0/255, green: 100.0/255, blue: 120.0/255, alpha: 1.0)
        additionalView.bounds.size.width = cell.frame.width
        additionalView.bounds.size.height = cell.frame.height
        additionalView.frame.origin.x = 0
        additionalView.frame.origin.y = 0
        additionalView.isHidden = true
        
        let title = UILabel()
        let detail = UILabel()
        let hideButton = UIButton()
    
        title.text = phone.core
        title.textColor = .white
        title.font = UIFont.boldSystemFont(ofSize: 20.0)
        title.frame.size.height = CGFloat(20)

        detail.text = phone.detail
        detail.textColor = .white
        detail.font = UIFont.boldSystemFont(ofSize: 20.0)
        detail.frame.size.height = CGFloat(20)

        hideButton.tag = index
        hideButton.setTitle("hide", for: UIControl.State.normal)
        hideButton.setTitleColor(.white, for: UIControl.State.normal)
        hideButton.layer.borderWidth = 2
        hideButton.layer.cornerRadius = 5
        hideButton.layer.borderColor = UIColor.white.cgColor
        hideButton.frame.size.height = CGFloat(30)
        hideButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
        additionalView.addSubview(title)
        
        title.translatesAutoresizingMaskIntoConstraints = false
        title.topAnchor.constraint(equalTo: additionalView.topAnchor, constant: CGFloat(10)).isActive = true
        title.leftAnchor.constraint(equalTo: additionalView.leftAnchor, constant: CGFloat(50)).isActive = true
        title.rightAnchor.constraint(equalTo: additionalView.rightAnchor, constant: CGFloat(-90)).isActive = true

        additionalView.addSubview(detail)
        detail.translatesAutoresizingMaskIntoConstraints = false
        detail.topAnchor.constraint(equalTo: title.bottomAnchor, constant: CGFloat(5)).isActive = true
        detail.leftAnchor.constraint(equalTo: additionalView.leftAnchor, constant: CGFloat(50)).isActive = true
        detail.rightAnchor.constraint(equalTo: additionalView.rightAnchor, constant: CGFloat(-90)).isActive = true
        
        additionalView.addSubview(hideButton)
        hideButton.translatesAutoresizingMaskIntoConstraints = false
        hideButton.rightAnchor.constraint(equalTo: additionalView.rightAnchor, constant: CGFloat(-20)).isActive = true
        hideButton.centerYAnchor.constraint(equalTo: additionalView.centerYAnchor).isActive = true
        hideButton.leftAnchor.constraint(equalTo: title.rightAnchor, constant: CGFloat(10)).isActive = true
        
        return additionalView
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        let cell = tableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! CustomCell
        
        if cell.additionalView.isHidden {
            UIView.transition(with: cell.additionalView, duration: 0.3, options: .transitionFlipFromLeft, animations: {
                cell.addSubview(cell.additionalView)
                cell.additionalView.alpha = 1
                cell.additionalView.isHidden = false
            })
        } else {
            UIView.animate(withDuration: 0.3) {
                cell.additionalView.frame.origin.x = cell.additionalView.frame.width
                cell.additionalView.alpha = 0
            } completion: { (Bool) in
                cell.additionalView.frame.origin.x = 0
                cell.additionalView.isHidden = true
            }
        }
    }
    
}
