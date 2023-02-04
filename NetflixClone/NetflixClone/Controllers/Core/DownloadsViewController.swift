//
//  DownloadsViewController.swift
//  NetflixClone
//
//  Created by Rodrigo Sanseverino de Anhaia on 16/01/23.
//

import UIKit

class DownloadsViewController: UIViewController {
    
    private var titles: [TitleItem] = [TitleItem]()
    
    private let downloadTableView: UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.title = "Downloads"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        self.setupLayout()
        
        self.downloadTableView.delegate = self
        self.downloadTableView.dataSource = self
        
        self.fetchLocalStoregeForDownload()
        NotificationCenter.default.addObserver(forName: NSNotification.Name("downloaded"), object: nil, queue: nil) { _ in
            self.fetchLocalStoregeForDownload()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.downloadTableView.frame = self.view.bounds
    }
    
    private func fetchLocalStoregeForDownload() {
        DataPersistenceManager.shared.fetchingTitlesFromDatabase { [weak self] result in
            switch result {
            case .success(let titles):
                DispatchQueue.main.async {
                    self?.titles = titles
                    self?.downloadTableView.reloadData()
                }
                
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
}

extension DownloadsViewController {
    fileprivate func setupLayout() {
        self.view.addSubview(self.downloadTableView)
    }
}

extension DownloadsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
            
        }
        
        let title = titles[indexPath.row]
        
        cell.configure(with: TitleViewModel(titleName: title.original_title ?? title.original_name ?? "Unknown", posterURL: title.poster_path ?? ""))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        switch editingStyle {
        case .delete:
            DataPersistenceManager.shared.deleteTitleWith(model: self.titles[indexPath.row]) { [weak self] result in
                switch result {
                case .success():
                    print("Deleted \(self?.titles[indexPath.row].original_name)")
                case .failure(let error):
                    print(String(describing: error))
                }
                self?.titles.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let title = self.titles[indexPath.row]
        
        guard let titleName = title.original_title ?? title.original_name else { return }
        
        APICaller.shared.getMovie(with: titleName) { [weak self] result in
            switch result {
            case .success(let videoElement):
                DispatchQueue.main.async {
                    let vc = TitlePreviewViewController()
                    vc.configure(with: TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: title.overview ?? "Unknown"))
                    
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
