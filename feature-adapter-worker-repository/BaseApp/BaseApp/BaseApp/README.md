# 4. Architecture Basics

Date: 2023-05-11

## Status

Under discussion

## Context

In this document you will find the explanation of the selected architecture

## Decision

Some clarifications:
* When discussing architecture, I refer to the **logical** module that abstracts different code pieces to achieve modularity and simplification.
* I will talk about structure when we talk about separation achieved by splitting the code into packages or projects to define the general structure.
* I refer as "entities" the business model type hosted in the Entities module.

### Main Goal

This architecture aims to reduce complexity and cognitive load by splitting the project into independent modules that can be easily built and worked on. Also, I keep reusability in mind when needed.

Notice that I do not want a rigid architecture that I can not transgress. Instead, I aim for a base architecture to use that solve most problem. When there is a deviation, I just need to document it for other developers to understand. 

## Global Dependency structure 

In the following diagram, we can see the different architecture pieces and their dependencies. Please notice the legend to understand the dependencies. Also a data called `Task` is used as example data. That data takes different prefix (`Feature`, `Entity`, etc) depending on the owner (where is defined).

In its most simplistic view we can see the three main pieces, the Features, the application that uses the features, and the repositories that provides the data. On the side we have the business logic implemente in the Entities.

```
                                                                        Legend:                 
                                                                                                
┌───────────────────────────────────────────────────────────┐             .            .        
│                                                           │            ( )          ( )       
│                                                           │             '            '        
│                         Feature/s                         │             │            ▲        
│                        (Package/s)                        │             │            │        
│                                                           │             │            │        
│                                                           │                                   
└───────────────────────────────────────────────────────────┘           Offered     Consumed    
                              │                                        Interface    Interface   
                              │                                                   (dependency)  
                              .   Feature.Task or                                               
                             ( )  Entities.Task                                                 
                              '                                                                 
                              ▲                                           ┌──────────────────┐  
                              │                                           │                  │  
                              │                                           │                  │  
┌──────────────────────────────────────────────────────────┐              │                  │  
│                   Adaptors and Workers                   │              │                  │  
│                      (Application)                       │       .      │     Entities     │  
│                                                          │─────▶( )─────│    (Package)     │  
│                                                          │       '      │Is Business Logic │  
└──────────────────────────────────────────────────────────┘              │                  │  
                              │                                           │                  │  
                              ▼    Entities.Task or                       │                  │  
                             ( )   Repository.Task                        │                  │  
                              '                                           └──────────────────┘  
                              │                                                                 
                              │                                                                 
┌───────────────────────────────────────────────────────────┐                                   
│                    Repositories -DATA-                    │                                   
│                         (Package)                         │                                   
│                                                           │                                   
└───────────────────────────────────────────────────────────┘                                   
```

But now we can expand the Application to see the pieces that are inside (Adaptors and Workers) and the data layer as well to see two kind storage, local and remote and the repositories that manage them and abstract it from its consumers.

```
                                                                                                
                                                                        Legend:                 
                                                                                                
┌───────────────────────────────────────────────────────────┐             .            .        
│                                                           │            ( )          ( )       
│                                                           │             '            '        
│                         Feature/s                         │             │            ▲        
│                        (Package/s)                        │             │            │        
│                                                           │             │            │        
│                                                           │                                   
└───────────────────────────────────────────────────────────┘           Offered     Consumed    
                              │                                        Interface    Interface   
                              │                                                   (dependency)  
                              .   Feature.Task or                                               
                             ( )  Entities.Task                                                 
                              '                                                                 
                              ▲                                                                 
                              │                                                                 
                              │                                           ┌──────────────────┐  
┌──────────────────────────────────────────────────────────┐              │                  │  
│                         Adaptors                         │              │                  │  
│                      (Application)                       │              │                  │  
│                                                          │───┐          │                  │  
│                                                          │   │          │                  │  
└──────────────────────────────────────────────────────────┘   │          │                  │  
                              │                                │          │                  │  
                              ▼                                │          │                  │  
                              .                                │    .     │     Entities     │  
                             ( ) Entities.Task                 ├──▶( )────│    (Package)     │  
                              '                                │    '     │Is Business Logic │  
                              │                                │          │                  │  
                              │                                │          │                  │  
┌───────────────────────────────────────────────────────────┐  │          │                  │  
│                          Workers                          │  │          │                  │  
│                 (Application or Packages)                 │──┘          │                  │  
└───────────────────────────────────────────────────────────┘             │                  │  
                              │                                           │                  │  
                              │                                           │                  │  
                              ▼                                           └──────────────────┘  
                              .    Entities.Task or                                             
                             ( )   Repository.Task                                              
                              '                                                                 
                              │                                                                 
                              │                                                                 
┌───────────────────────────────────────────────────────────┐                                   
│                       Repositories                        │                                   
│                         (Package)                         │                                   
│                                                           │                                   
└───────────────────────────────────────────────────────────┘                                   
                              │                                                                 
               ┌──────────────┴─────────────────┐                                               
               │                                │                                               
               ▼                                ▼                                               
               .                                .                                               
              ( )RemoteStorage.Task            ( ) LocalStorage.Task                            
               '                                '                                               
               │                                │                                               
               │                                │                                               
┌────────────────────────────┐    ┌──────────────────────────┐                                  
│       RemoteStorage        │    │       LocalStorage       │                                  
│         (Package)          │    │        (Package)         │                                  
└────────────────────────────┘    └──────────────────────────┘                                  
```

Later we will explain every block in more detail, and now we will focus on the dependencies. At the top, we have the "Features", which are almost independent modules, only depending on Entities. At the bottom, we also have the Remote and Local Storages that are independent. Notice that those three modules provide an interface for others to consume while not depending on other modules (except for tooling modules like Utils). There is a third module that is also independent, the Entities module.

In the middle, we have two modules, the Workers and the Adapters. Workers work on top of the Repositories depending on the Entities. The adaptor, as its name suggests, is the glue code that adapts the impedance to make the different features use the many available workers. Notice that the adaptors and workers are the only parts in this diagram that are not a module but part of the main application.

The diagram also includes some data annotation that will be commented on in the following sections.

## Modules Description

### RemoteStorage

**Goal:** The goal of the API is to abstract the communication details of the Data servers.

The RemoteStorage offers an interface grouped logically by Projects functionality.

The RemoteStorage abstracts the communication mechanism but not the data coming from the server. That means that the data returned by the API has the same structure and names that the one received from the server. Notice that RemoteStorage supports different endpoint versions; this information should not leak outside the module.

The RemoteStorage module offers that data with the same name that will be found on the Entities. We will use the package namespace to differentiate between them ("RemoteStorage.Task").

### LocalStorage

**Goal:** The goal of the LocalStorage is to abstract the persistent storage mechanism for data and configuration.

The Storage module offers that data with the same name that will be found on the Entities. We will use the package namespace to differentiate between them ("LocalStorage.Task").

### Repositories

**Goal:** The goal of the Repositories module is to abstract the application's data management completely, giving the rest of the application the illusion that it is dealing with a local store.

It offers an interface grouped logically in classes named Repositories. 

The Repositories module offers that data with the same name that will be found on the Entities. We will use the package namespace to differentiate between them ("Repositories.Task").

Internally, the Repositories module will work with a custom version of data to achieve some of its features (like storing partial data). But, externally, the Repositories will return regular entities. This means that the mapping will be performed in the repository.

### Entities

**Goal:** The entities contain the business logic associated with the data. Many logic rules associated with the data will be directly implemented into the entities.

Examples of types in the entities are: `Task`, `Project`, `Tasklist`, `UserTimer`, etc.

### Workers

**Goal:** The workers provide a more functionality-oriented interface by using the data repositories. By utilising a worker, you gain the capability to create and destroy tasks, modify tasks, and control timers, for example. So workers build small functionality blocks to compose all of the feature needs.

Examples of workers could be:
* create tasks
* edit tasks (includes delete)
* create timers
* edit timers(include delete)

Since we use workers for multiple features, it is the perfect place to broadcast notifications of the action that other features need to be aware of.

Be careful not to include Feature logic in the workers. They act as a facility to better manage the raw access offered by the repositories but do not implement logic that should be located into features. Although they can incorporate mechanisms to help implement features like broadcasting events.

Workers should handle errors coming from the data layer and throw them under the umbrella of a single type of error called `WorkerError`. This simplifies the handling of errors on the application layer and the localisation of those errors.

### Adapters

**Goal:** The features need to access some specific functionality, and they offer an interface that some external provider should fulfil. On the other side, the workers provide functionality, and for that, they offer an interface. The adaptor implements that inversion of dependencies, adapting what the workers offer to what the features need.

There is no logic in the adapters; it is merely a connector. 

### Structure of a Single Feature

A feature is a piece of functionality that could include an entire screen or a small section of a screen, or it might also be a feature without UI at all. It is always contained in a package.

A medium size application could contain more than fifty feature modules. It is then essential to keep them independent to allow for the proper scaling of the solution.

In the next figure can be seen the layout of a module and its structure (packages)

```
        ┌──────────────┐    ┌──────────────┐    ┌──────────────┐                                                    
        │   Utils      │    │  UIUtils     │    │  ...others   │                                                    
        └──────────────┘    └──────────────┘    └──────────────┘                                                    
                ▲                   ▲                   ▲                                                           
                └───────────────────┴─────┬─────────────┘                                                           
                                          │                                                                         
                                          │                                                                         
┌───────────────────────────────────────────────────────────────────────────────────┐                               
│      ┌───────────┐                                                                │                               
│      │  Feature  │                              ┌──────────────────┐              │                               
│      └───────────┘                              │       View       │              │                               
│      ┌───────────┐                ┌─────────────│    (SwiftUI)     │              │                               
│      │           │                │             │                  │              │                               
│ .    │           │                │             └──────────────────┘              │           ┌──────────────────┐
│( )───┼─ Builder  │                ▼                       │                       │           │                  │
│ '    │           │        ┌───────────────┐               │                       │           │                  │
│      │           │        │   Presenter   │               │                       │           │                  │
│      │           │        └───────────────┘               │                       │           │                  │
│      └───────────┘                │                       │                       │           │                  │
│                                   │                       │                       │           │                  │
│                                   │                       │                       │           │                  │
│                                   │        ┌──────────────┘                       │ Optional  │                  │
│                                   │        │                                      │     .     │     Entities     │
│                                   ▼        │                                      │───▶( )────│ (Business Logic) │
│                                   .        │                                      │     '     │                  │
│                                  ( )       │                                      │           │                  │
│                                   '        │                                      │           │                  │
│                                   │        │                                      │           │                  │
│                                   │        │                                      │           │                  │
│     ┌─────────────────────────────┘        ▼                                      │           │                  │
│     │  ┌───────────────────────────────────────────────────────────────────────┐  │           │                  │
│     └──│                              Interactor                               │  │           │                  │
│        └─────────────────────────────┬──────────────────┬─────────────────┬────┘  │           │                  │
│                                      │                  │                 │       │           └──────────────────┘
│ ┌────────────────┐                   .                  .                 .       │                               
│ │  Feature Data  │        Services  ( )    Coordinator ( )    Analytics  ( )      │                               
│ │   (Optional)   │        Protocol   '      Protocol    '     Protocol    '       │                               
│ └────────────────┘                                                                │                               
└───────────────────────────────────────────────────────────────────────────────────┘                               
```

As explained, features are designed to minimise their dependencies, allowing the best possible experience for developing and connecting.

> NOTE: Sometimes we made the Features depending on the Entities, but we should avoid that, following the ISP, to make the Features as independent as possible. Otherwise, a change in an entity might affect many modules.

In general, a feature provides two primary interfaces, one for creation and another for interaction and data.

* Build Protocol: This one allows to build the Feature while injecting all objects conforming to the provided interfaces for the Feature to work. Only the feature knows how to build itself.
* Services Protocol: This protocol informs us of what the Feature needs to function correctly. It will include data methods to collect data and to request external actions. Unless there is a particular case, all of the methods in this protocol will use structure concurrency to allow the implementers to use the best source independently of their asynchronicity. An adapter on the host application will fulfil this protocol.

Apart from those vital interfaces, a couple more interfaces could be needed:

* Coordinator: A connection to the Coordinator to present or navigate. The Feature doesn't know how to do that task, and it defers it to the Coordinator.
* Analytics: Most of the Features will need to report events to analytics.

On its internals, the Feature has a minimum of 3 basic pieces:

* Interactor: It is independent but requires an object to conform to one of its interfaces to render the view's state. That object will be the presenter. The Interactor contains as much of the Feature's logic as possible. It is also in charge to interact with external modules through the provided interfaces. Since it includes most of the logic, it is the right candidate to be under Unit Test.
* Presenter: receives the new state request from the Interactor, build the ViewModel and pushes it to the view.

* View: Visual representation of the feature. It can be on UIKit or SwiftUI and have minimal logic. All interactions are redirected to the Interactor to be managed.
f
Finally, the Feature will provide and get data through the service protocol. For that we can use the Entities on the Entities package or define a new public one inside the Feature, making the package independent from Entities. We leave that decision open on every implementation.

## Complete system

The following diagram shows a more complete view of the system, including the package structure. Notice that it does not include the storage modules.

```
          ┌──────────────┐    ┌──────────────┐    ┌──────────────┐                                                         
          │TeamworkUtils │    │  TeamworkUI  │    │  ...others   │                                                         
          └──────────────┘    └──────────────┘    └──────────────┘                                                         
                  ▲                   ▲                   ▲                                                                
                  └───────────────────┴────────┬──────────┘                                                                
                                               │                                                                           
                                               │                                                                           
       ┌──────────────────────────────────────────────────────────────────────────────┐                                    
       │ ┌───────────┐                                                                │                                    
       │ │  Feature  │                   ┌──────────────────┐                         │                                    
       │ └───────────┘                   │       View       │                         │                                    
       │ ┌───────────┐           ┌───────│    (SwiftUI)     │                         │                                    
       │ │           │           │       │                  │                         │                                    
    .  │ │           │           │       └──────────────────┘                         │                                    
┌─▶( )─┼─┼─ Builder  │           │                 │                                  │                                    
│   '  │ │           │           │                 │                                  │                                    
│      │ │           │           ▼                 │                                  │                                    
│      │ │           │   ┌───────────────┐         │                                  │                                    
│      │ └───────────┘   │   Presenter   │         │                                  │                                    
│      │                 └───────────────┘         │                                  │                                    
│      │                         │                 │                                  │                                    
│      │                         │             ┌───┘                                  │                                    
│      │                         │             │                                      │                                    
│      │                         ▼             │                                      │─────────┐                          
│      │                         .             │                                      │         │                          
│      │                        ( )            │                                      │         │                          
│      │                         '             │                                      │         │                          
│      │                         │             │                                      │         │                          
│      │                         │             │                                      │         │                          
│      │┌────────────────────────┘             ▼                                      │         │                          
│      ││  ┌───────────────────────────────────────────────────────────────────────┐  │         │                          
│      │└──│                              Interactor                               │  │         │                          
│      │   └─────────────────────────────┬──────────────────┬─────────────────┬────┘  │         │                          
│      │                                 │                  │                 │       │         │                          
│      │  ┌──────────┐                   .                  .                 .       │         │                          
│      │  │ Feature  │        Services  ( )    Coordinator ( )    Analytics  ( )      │         │                          
│      │  │   Data   │        Protocol   '      Protocol    '     Protocol    '       │         │                          
│      │  └──────────┘                   ▲                  ▲                 ▲       │         │                          
│      └─────────────────────────────────┼──────────────────┼─────────────────┼───────┘         │                          
│                                        │                  │                 │                 │                          
│      ┌─────────────────────────────────┼──────────────────┼─────────────────┼────────────┐    │                          
│      │                                 │                  │                 │            │    │         ┌───────────────┐
│      │  ┌───────────┐                  │                  │                 │            │    │         │ ┌───────────┐ │
│      │  │    App    │                  │          ┌───────────────┐   ┌──────────┐       │    │         │ │ Entities  │ │
│      │  └───────────┘                  │          │               │   │          │       │    │         │ └───────────┘ │
└──────┼─────────────────────────────────┼──────────│AppCoordinator │   │Analytics │       │    │         │               │
       │                                 │          │               │   │          │       │    │         │               │
       │                                 │          └───────────────┘   └──────────┘       │    │         │               │
       │                                 │                                                 │    │         │               │
       │                    ┌────────────────────────┐                                     │    │         │               │
       │                    │                        │                                     │    │         │               │
       │                    │        Adapter         │─────────────────────────────────────┼────┼─┬──────▶│               │
       │                    │                        │                                     │    │ │       │               │
       │                    └────────────────────────┘                                     │    │ │       │               │
       │                                 │                                                 │    │ │       │               │
       │                                 │                                                 │    │ │       │               │
       │                                 │                                                 │    │ │       │               │
       │                                 │                                                 │    │ │       │               │
       │                                 ├───────────────────┬───────────────────┐         │    │ │       │               │
       │                                 │                   │                   │         │    │ │       │               │
       └─────────────────────────────────┼───────────────────┼───────────────────┼─────────┘    │ │       └───────────────┘
                                         │                   │                   │              │ │                        
       ┌─────────────────────────────────┼───────────────────┼───────────────────┼──────────┐   │ │                        
       │ ┌───────────┐                   ▼                   ▼                   ▼          │   │ │                        
       │ │  Workers  │            ┌────────────┐      ┌────────────┐      ┌────────────┐    │   │ │                        
       │ └───────────┘            │            │      │            │      │            │    │   │ │                        
       │                          │   Worker   │      │   Worker   │      │   Worker   │────┼───┘ │                        
       │                          │            │      │            │      │            │    │     │                        
       │                          └────────────┘      └────────────┘      └────────────┘    │     │                        
       │                                 │                   │                   │          │     │                        
       │                                 │                   │                   │          │     │                        
       │                                 │                   │                   │          │     │                        
       └─────────────────────────────────┼───────────────────┼───────────────────┼──────────┘     │                        
                                         │                   │                   │                │                        
                                         │                   │                   │                │                        
                                         │                   │                   │                │                        
                                         │                   │                   │                │                        
       ┌─────────────────────────────────┼───────────────────┼───────────────────┼──────────┐     │                        
       │ ┌───────────┐                   │  Repositories     │                   │          │     │                        
       │ │   Data    │                   │                   │                   │          │     │                        
       │ └───────────┘                   ▼                   ▼                   ▼          │     │                        
       │                        ┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐ │     │                        
       │                        │                 │ │                 │ │                 │ │     │                        
       │                        │EventsRepository │ │EventsRepository │ │EventsRepository │─┼─────┘                        
       │                        │                 │ │                 │ │                 │ │                              
       │                        └─────────────────┘ └─────────────────┘ └─────────────────┘ │                              
       │                                                                                    │                              
       └────────────────────────────────────────────────────────────────────────────────────┘                              
```

> NOTE: At the moment of writing, the `Data` package contains repositories, API and Storage, so the name keeps being a generic `Data`.

## Consequences

None

