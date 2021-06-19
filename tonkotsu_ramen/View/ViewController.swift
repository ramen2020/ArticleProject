import UIKit
import Moya
import Kingfisher
import RxSwift
import RxCocoa
import Rswift
import SwiftSpinner


class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    private var articleViewModel: ArticleViewModel = ArticleViewModel()

    var searchArticleCategoryButtons: [SearchArticleCategoryButton] = []

    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        setUpSettings()
        setUpTableView()
        setupCollectionView()
        
        // input
        searchTextField.rx.text.orEmpty
            .filter { $0.count >= 1 }   
            .bind(to: articleViewModel.input.searchWord)
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] element in
                guard let self = self else {return}
                self.articleViewModel.input.searchCategoryButtonTapped
                    .onNext(self.searchArticleCategoryButtons[element.row])
            })
            .disposed(by: disposeBag)
        
        // output
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
        
        articleViewModel.output.isFetching
            .subscribe(onNext: { bool in
                if bool {
                    SwiftSpinner.shared.outerColor = UIColor.red.withAlphaComponent(0.5)
                    SwiftSpinner.setTitleFont(UIFont(name: "Futura", size: 22.0))
                    SwiftSpinner.setTitleColor(UIColor.white)
                    SwiftSpinner.show("loading")
                } else {
                    SwiftSpinner.hide()
                }
            })
            .disposed(by: disposeBag)
    }
    
    func setUpSettings() {
        self.searchArticleCategoryButtons = SettingConst.searchCategoryButtons
    }
    
    func setUpTableView() {
        tableView.delegate = self
        tableView.register(R.nib.articleTableViewCell)
        tableView.separatorStyle = .none
    }
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(R.nib.categoryButtonCollectionViewCell)
        
        // 横スクロール
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        collectionView.showsHorizontalScrollIndicator = false
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.categoryButtonCollectionViewCell, for: indexPath)!

        let targetCategoryButton = self.searchArticleCategoryButtons[indexPath.row]
        cell.title.text = targetCategoryButton.name
        cell.image.image = UIImage(named: targetCategoryButton.name)
        
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let horizontalPadding : CGFloat = 20
        let width = self.view.bounds.width / 3 - horizontalPadding
        return CGSize(width: width, height: 70)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}


extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
