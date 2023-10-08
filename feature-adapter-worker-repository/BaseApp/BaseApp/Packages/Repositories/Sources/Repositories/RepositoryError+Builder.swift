import Foundation

/// The builder of the repository Error provides a single place to handle errors inside repositories
/// at the same time that offers a single type of errors (RepositoryError) to the upper consumer layers.

extension RepositoryError {
    
    static func build(error: Error) -> RepositoryError {
        
        // If the error is already a repository error we will just return it.
        if let error = error as? RepositoryError { return error }
        
        // Otherwise we will try to sort the error in the proper repository error bucket:
        var repositoryError: RepositoryError
        if let error = error as? RemoteStorageError {
            
            repositoryError = .remoteStorageError(error)
        } else if let _ = error as? LocalStorageError {
            
            repositoryError = .localStorageError
        } else {
            
            repositoryError = .unknownError(error)
        }
        
        return repositoryError
    }
}
