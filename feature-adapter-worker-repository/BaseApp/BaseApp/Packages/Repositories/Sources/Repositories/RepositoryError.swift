
/// The `RepositoryError` provides a single type of error to the Repositories consumer outside the packages.
public enum RepositoryError: Error {
    
    /// An error caused on the local storage.
    case localStorageError
    /// Somthing is wrong on the server side. More details in the error.
    case remoteStorageError(Error)
    /// Error not handled by the repository error mechanism.
    case unknownError(Error)
}
