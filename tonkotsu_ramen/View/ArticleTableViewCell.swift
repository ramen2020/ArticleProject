import UIKit

class ArticleTableViewCell: UITableViewCell {

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var articleTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(article: Article) {
            
        let imageUrl = article.user.profile_image_url
        let url = URL(string: imageUrl)
        self.userImage.kf.setImage(with: url)
        
        let userName = article.user.name.count == 0 ? "名無さん" : article.user.name
        self.userName.text = userName

        let articleTitle = article.title
        self.articleTitle.text = articleTitle
    }
    
}
