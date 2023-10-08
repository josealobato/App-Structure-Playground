# Repositories

From the product perspective, there are many ways to do offline behaviour of the application, 
and we should select the ones that fit better the product we are building, thinking about the 
user experience when using the app.

Here, I depict some strategies I have used in the past, from simplest to more complex.

Notice that all these types of local storage will have problems when the data changes on 
the remote. If entries are removed or added on the server side, the pages will get out of 
synchronization quickly. We could set more complex mechanisms in place to alleviate the issue.

## Simple Cache

The simple approach could be saving all data from remote to local storage. When remote 
storage is unavailable, we could show the data on local storage. This mechanism might 
cause some glitches on the UI when the connection is lost or recovered. Notice that the 
navigation (scrolling) will differ with and without connectivity unless we save the 
pagination on local storage.

## Local storage as the source of truth

Another approach is always to show the data on local storage. This means we fetch the 
data from the remote, save it on the local, and show it. When there is no connectivity 
or it fails, we show the local storage anyway. This one is slightly more elaborate but 
could minimize the UI glitches.

## Local storage as the source of truth with data streams

An even better solution is using async sequences instead of just returning one value 
when fetching the data. Using this mechanism, we could send several updates to the 
UI as follows:

1. Return first the content of the local storage (update one).
2. Fetch the remote.
2. Update the local storage with the data from remote storage.
4. Send the local storage content again to the UI (update two).

With the new structure concurrency mechanism in Swift, the repository interface will change to something like:

```
func usersFirstPage() -> AsyncThrowingStream<[UserDataEntity], Error>
func usersNextPage() -> AsyncThrowingStream<[UserDataEntity], Error>
```
