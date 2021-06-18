//
//  ViewController.swift
//  tonkotsu_ramen
//
//  Created by 宮本光直 on 2021/06/10.
//

import UIKit
import Moya
import Kingfisher
import RxSwift
import RxCocoa


class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    private var articleViewModel: ArticleViewModel = ArticleViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        
        setUpTableView()
        
        searchTextField.rx.text.orEmpty
            .filter { $0.count >= 1 }   
            .bind(to: articleViewModel.input.searchWord)
            .disposed(by: disposeBag)
        
        articleViewModel.output.articles
            .bind(to: tableView.rx.items) { tableView, row, element in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleTableViewCell")
                        as? ArticleTableViewCell else {
                    return UITableViewCell()
                }
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                cell.configure(article: element)
                return cell
            }
            .disposed(by: disposeBag)
    }
    
    func setUpTableView() {
        tableView.delegate = self
        tableView.register(UINib(nibName: "ArticleTableViewCell", bundle: nil),
                                forCellReuseIdentifier: "ArticleTableViewCell")
        tableView.separatorStyle = .none
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
