# Doc viewer

Documentation viewer. *This is just a pet project for practicing Elm.*

[Elm](http://elm-lang.org/) is a functional language with static typisation and infrastructure for creating web applications without runtime errors.

### Why?

Long time ago I had an idea of self-documenting projects. Thus, the documentation should be generated from file system using some atomated task. As a result, a JSON is generated. This app is a viewer for this JSON.

The examples of data structures can be found [here](https://runkit.com/raqystyle/express-test).

### How to run

```
elm-package install
elm-reactor
Open [http://localhost:8000](http://localhost:8000)
```

### How it works

When the app runs, it makes a request for the json file that describes the tree of your documentation. This file can be generated using [the generator](https://github.com/raqystyle/ok-doc-generator)

Each time user selects the item in the tree, another request is being fired for the info about selected branch in the tree. The backend for such requests as well as for the tree json can be easily configured and run using [the backend](https://github.com/raqystyle/ok-doc-backend)

Basically, you can install those two globally via npm. They both have cli and can be run using CL params.
