# App-Structure-Playground

This repository contains exercises and tests on architectures and structural patterns. It serves as a playground to experiment with concepts and allow discussion on different implementations.

## Feature, Adapter, worker and repository

This structure is based on the concept of modularity for features. Having a data abstraction layer in a package and only the glue code in the application in the form of workers and adaptors, while all the functionality is in independent packages. A similar approach was used in the Teamwork's iOS app and the `ratpenat` app.

(Read the README.md in that folder for more details.)

## Basic SwiftUI Coordinator (One single flow)

This is a project with the implementation of a coordinator entirely on SwiftUI with just one flow. The goals are:

1. Having Features that can be developed independently, depending only on a protocol to interact with the Coordinator.
2. We should be able to host those features on packages with minimum dependencies.
2. The Features request coordination but do not know how they will be coordinated (presented).
3. The Coordinator knows how to present any feature requested from any other features.

Here, a `Feature` is understood as a self-contained package. Internally, that feature could be developed with VIP, MVVM, or any other pattern and will offer the interfaces (protocols) it needs to do its job. In this demo project, the features are plain SwiftUI views.

## Basic SwiftUI Coordinator with TabView

This second project is the same as Basic SwiftUI Coordinator (One single flow), but It starts with TabView with two independent flows.