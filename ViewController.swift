//
//  ViewController.swift
//  alif1
//
//  Created by Farangis Makhmadyorova on 13/12/22.
//

import UIKit
import Alamofire
import SafariServices
import SDWebImage
import CoreData

class ViewController: UIViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var mainViewModel: MainViewModel!
    var internalMainData: [MainDetail] = []
    var count = 0
    private var models = [MainDetailEntity]()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
//        tableView.backgroundColor = UIColor.red
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainViewModel = MainViewModel()
        view.backgroundColor = .systemBackground
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
//        tableView.frame = view.bounds
        
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: UIApplication.shared.statusBarFrame.height).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
         
        
        self.mainViewModel.getMainData()
        self.mainViewModel.mainData.bind { observable, mainData in
            print(mainData)
            self.addMore3rows()
//            self.tableView.reloadData()
        }
        
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.mainViewModel.mainData.value != nil && self.mainViewModel.mainData.value!.count > 0 {
            if(self.tableView.contentOffset.y >= (self.tableView.contentSize.height - self.tableView.bounds.size.height)) {
//                self.mainViewModel.getMainData()
                addMore3rows()
                
            }
        }
    }
    
    func addMore3rows() {
        if count < self.mainViewModel.mainData.value!.count {
            for i in count ... count + 2 {
                if i < self.mainViewModel.mainData.value!.count {
                    createItem(mainData: self.mainViewModel.mainData.value![i])
                    internalMainData.append(self.mainViewModel.mainData.value![i])
                }
            }
            count += 3
            
            getAllItems()
//            tableView.reloadData()
            print(count)
        }
    }
    

    func getAllItems() {
        do {
            models = try context.fetch(MainDetailEntity.fetchRequest())
            tableView.reloadData()
        }
        catch {
            // error
        }
    }
    
    func createItem(mainData: MainDetail) {
        let newItem = MainDetailEntity(context: context)
        newItem.name = mainData.name
        newItem.endDate = mainData.endDate
        newItem.icon = mainData.icon
        newItem.url = mainData.url
        newItem.startDate = mainData.startDate
        newItem.objType = mainData.objType
        newItem.loginRequired = mainData.loginRequired
        
        do {
            try context.save()
        }
        catch {
            
        }
    }
    
    func deleteItem(item: MainDetailEntity) {
        context.delete(item)
        
        do {
            try context.save()
        }
        catch {
            
        }
    }
    
    func updateItem(item: MainDetailEntity, newName: String) {
        item.name = newName
        
        do {
            try context.save()
        }
        catch {
            
        }
    }
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return mainViewModel.mainData.value?.count ?? 0
//        return self.internalMainData.count
        return models.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        
//        guard let data = mainViewModel.mainData.value else {return UITableViewCell()}
//        let data = self.internalMainData
        let data = self.models
        let content = data[indexPath.row]
        cell.content = (data: content, name: content.name, endDate: content.endDate, picture: content.icon)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected cell \(indexPath.row)")
        
        let url = URL(string: "https://guidebook.com" + internalMainData[indexPath.row].url)!

        // Проверка версии IOS
        if #available(iOS 11.0, *) {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            let vc = SFSafariViewController(url: url, configuration: config)
            present(vc, animated: true)

        } else {
        UIApplication.shared.openURL(url)
        }
        
        
    }
}


class TableViewCell: UITableViewCell {
    static let identifier = "TableViewCell"
    
//    var content: (data: MainDetail, name: String, endDate: String, picture: String)? {
    var content: (data: MainDetailEntity, name: String?, endDate: String?, picture: String?)? {
        didSet {
            guard let content = content else { return }
            nameLabel.text = content.name
            endDateLabel.text = content.endDate
            
            bigImageView.sd_setImage(with: URL(string: content.picture!), placeholderImage: UIImage(named: "placeholderImage"))


        }
        
    }
    
    
    
    
    var bigImageView: UIImageView = {
        let imageView = UIImageView()
//        imageView.backgroundColor = .lightGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = UIColor.systemBlue
        label.textAlignment = .center
        label.text = "Aaaaaaaaaaaaaaaa"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var endDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .gray
        label.textAlignment = .center
        label.text = "Bbbbbbbbbbbbbbb"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        self.backgroundColor = UIColor.systemPink.withAlphaComponent(0.3)
        contentView.addSubview(bigImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(endDateLabel)
        
        bigImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
        bigImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        bigImageView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        bigImageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        nameLabel.topAnchor.constraint(equalTo: bigImageView.bottomAnchor, constant: 10).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        
        endDateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10).isActive = true
        endDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        endDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
