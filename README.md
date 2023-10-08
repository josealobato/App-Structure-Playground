# App-Structure-Playground

This repository contains exercises and tests on architectures and structural patterns. It serves as a playground to experiment with concepts and allow discussion on different implementations.

## Feature, Adapter, worker and repository

This structure is based on the concept of modularity for features. Having a data abstraction layer in a package and only the glue code in the application in the form of workers and adaptors, while all the functionality is in independent packages. A similar approach was used in the Teamwork's iOS app and the `ratpenat` app.

(Read the README.md in that folder for more details.)
