//
//	KeywordsViewController
//  [Fake Legacy View Controller]
//  UIViewController to manage list of keywords
//  News
//	Created by: @nedimf on 01/05/2022


import Foundation
import UIKit

class KeywordsViewController: UIViewController{
    let searchManger = SearchManager()
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        label.text = "Manage Keywords"
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
    let contentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.text = "Select keywords for which you would like to receive notifications. Swipe left do delete keywords."
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
    //Initialise constraints for view hierarchy
    func initView(){
        self.view.addSubview(tableView)
        self.view.addSubview(titleLabel)
        self.view.addSubview(contentLabel)
        
        NSLayoutConstraint.activate([
            
            self.titleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 5),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            
            self.contentLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 5),
            self.contentLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            self.contentLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            self.tableView.topAnchor.constraint(equalTo: self.contentLabel.bottomAnchor, constant: 15),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 5)
            
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchManger.fetchStoredKeywords()
        searchManger.sortStoredKeywords()
        tableView.dataSource = self
        tableView.delegate = self
        
                
        initView()
    }
}

extension KeywordsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchManger.listOfSearchedKeywords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let searchKeyword = searchManger.listOfSearchedKeywords[indexPath.row]
        cell.textLabel?.text = searchKeyword.keyword
        let lightSwitch = UISwitch(frame: CGRect.zero) as UISwitch
        lightSwitch.isUserInteractionEnabled = true
        
        lightSwitch.isOn = searchKeyword.notify
        lightSwitch.tag = indexPath.row
        lightSwitch.addTarget(self, action: #selector(switchTrigger(_:)), for: .valueChanged)
        lightSwitch.tag = indexPath.row
        cell.accessoryView = lightSwitch
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            searchManger.deleteStoredKeyword(for: searchManger.listOfSearchedKeywords[indexPath.row].keyword)
            searchManger.listOfSearchedKeywords.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
    }
    
    ///Handles UISwitch action for cell
    ///- Parameter sender: UISwitch passes elements state
    @objc func switchTrigger(_ sender: UISwitch){
        let row = sender.tag
        let searchObject = searchManger.listOfSearchedKeywords[row]
        
        searchManger.searchKeyword = searchObject.keyword
        searchManger.storeSearchKeyword(notify: sender.isOn)
    }
    
}
