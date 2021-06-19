import Foundation

struct ArticleError: Error, Codable {
    let message: String
    let type: String
}

enum ArticleCustomError: Error {
    case errorResponse(ArticleError)
    case mappingError
    case internalError
    case badGatewayError
    case serviceUnavailableError
    case unexpectedError
}

extension ArticleCustomError: LocalizedError {
    var message: String? {
        switch self {
        case .mappingError:
            return APIErrorMessageConst.mappingError
        case .internalError:
            return APIErrorMessageConst.internalErrorMessage
        case .badGatewayError:
            return APIErrorMessageConst.badGatewayError
        case .serviceUnavailableError:
            return APIErrorMessageConst.serviceUnavailableError
        case .unexpectedError:
            return APIErrorMessageConst.unexpectedError
        default:
            return nil
        }
    }
}
