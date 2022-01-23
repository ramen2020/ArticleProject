import Kingfisher
import Moya
import Rswift
import RxCocoa
import RxSwift
import SwiftSpinner
import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    private var articleViewModel: ArticleViewModel = ArticleViewModel()

    var searchArticleCategoryButtons: [SearchArticleCategoryButton] = []
    var isSelectedCategoryButtonId: Int?

    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        setUpSettings()
        setUpTableView()
        setupCollectionView()
        viewModelInput()
        viewModelOutput()
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
    
    func viewModelInput() {
        articleViewModel.featchArticles.onNext(Void())
        
        searchTextField.rx.text.orEmpty
            .filter { $0.count >= 1 }
            .bind(to: articleViewModel.input.searchWord)
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] element in
                guard let self = self else {return}
                self.isSelectedCategoryButtonId = element.row
                self.collectionView.reloadData()
                self.articleViewModel.input.searchCategoryButtonTapped
                    .onNext(self.searchArticleCategoryButtons[element.row])
            })
            .disposed(by: disposeBag)
    }
    
    func viewModelOutput() {
        articleViewModel.output.articles
            .bind(to: tableView.rx.items) { tableView, _, element in
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
        
        articleViewModel.output.error
            .subscribe(onNext: { [weak self] error in
                guard let self = self else {return}
                AlertUtil.errorAlert(vc: self, error: error)
            }).disposed(by: disposeBag)
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

        cell.view.backgroundColor = isSelectedCategoryButtonId == indexPath.row
            ? .yellow : .clear
        
        cell.layer.borderWidth = 0.0
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 1, height: 1)
        cell.layer.shadowOpacity = 0.3
        cell.layer.masksToBounds = false
        
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let horizontalPadding: CGFloat = 20
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
