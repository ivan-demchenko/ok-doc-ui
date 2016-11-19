module Tree exposing (..)

type Tree
  = Tree Int String (List Tree) | Nil

getSampleTree : Tree
getSampleTree =
  Tree 0 "Demo" [
    Tree 1 "Section 1" [],
    Tree 2 "Section 2" [
      Tree 3 "Subsection 1" [],
      Tree 4 "Subsection 2" []
    ],
    Tree 5 "Section 3" [
      Tree 6 "Subsection 1" [],
      Tree 7 "Subsection 2" [],
      Tree 8 "Subsection 3" []
    ]
  ]

getEmptyTree : Tree
getEmptyTree = Nil
