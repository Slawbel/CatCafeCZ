import UIKit

class AddingNewPlace: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTapped))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveTapped))
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CellForAddingNewPlace.self, forCellReuseIdentifier: "CellForAddingNewPlace")
        tableView.allowsSelection = false
        tableView.isScrollEnabled = false
        tableView.backgroundColor = .black
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalTo(view)
            make.top.equalTo(view)
        }
    }
    
    @objc private func cancelTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func saveTapped() {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellForAddingNewPlace", for: indexPath) as? CellForAddingNewPlace
        cell?.layer.cornerRadius = 20
        cell?.backgroundColor = .systemGray6
        
        switch indexPath.row {
        case 0: do { cell?.setupImage(text: "Photo") }
        case 1: do { cell?.setuptNameCell() }
        case 2: do { cell?.setuptLocationCell() }
        case 3: do { cell?.setuptTypeCell() }
        default: break
        }
        
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 250
        } else {
            return 75
        }
    }
    
}
