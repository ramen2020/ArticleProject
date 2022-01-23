import Foundation
import UIKit

class AlertUtil {
    static func errorAlert(vc: UIViewController, error: Error) {
        var title: String?
        var message: String?

        let customError = error as? ArticleCustomError
        switch customError {
        case .errorResponse(let error):
            title = error.type
            message = error.message
        default:
            title = "予期せぬエラーが発生しました。"
            message = error.localizedDescription
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let close = UIAlertAction(title: "閉じる", style: .default) { (_) in
            vc.dismiss(animated: true, completion: nil)
        }
        alert.addAction(close)
        vc.present(alert, animated: true, completion: nil)
    }
}
