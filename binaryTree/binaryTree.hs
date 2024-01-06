
module Main where

    data Tree a = Leaf a | Node (Tree a) (Tree a) deriving (Eq)

    
    instance (Show a) => Show (Tree a) where
        show (Leaf x) = "<" ++ show x ++ ">"
        show (Node l r) = "(" ++ show l ++ ")" ++ "(" ++ show r ++ ")" 
    
    instance Functor Tree where
        fmap f (Leaf x) = Leaf $ f x
        fmap f (Node l r) = Node (fmap f l) (fmap f r)

    addLevel :: Tree a -> Tree a
    addLevel x = Node x x

    btrees :: a -> [(Tree a)]
    btrees x = (Leaf x) : [addLevel y | y <- btrees x] 

    incBTrees :: [Tree Int]
    incBTrees = (Leaf 1) : [addLevel $ fmap (+1) x | x <- incBTrees]

    countNodes :: Tree a -> Int
    countNodes (Leaf x) = 1
    countNodes (Node l r) = 1 + countNodes l + countNodes r

    nodesList :: [Int]
    nodesList = [countNodes x | x <- incBTrees]

    list1 = take 4 (btrees "A")
    list2 = take 4 incBTrees
    list3 = take 4 nodesList
    main = do 
        putStrLn (show list1)
        putStrLn (show list2)
        putStrLn (show list3)