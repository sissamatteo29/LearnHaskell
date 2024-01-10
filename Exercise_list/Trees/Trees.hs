
{-
This module shows simple exercises on the Tree data type.
First, the data type is created, and then it is made an instance of all the most important classes in Haskell.
-}

-- Tree definition (recursive)

module Main where 
    data Tree a = Empty | Leaf a | Branch (Tree a) (Tree a)

    tree1 = Branch (Branch (Leaf 1) (Leaf 10)) (Branch (Leaf 2) (Leaf 8))
    tree2 = Leaf 6
    tree3 = Branch (Leaf 9) (Branch (Leaf 2) (Leaf 8))


    instance (Eq a) => Eq (Tree a) where
        (Leaf x) == (Leaf y) = x == y
        (Branch l r) == (Branch p q) = l == p && r == q
        _ == _ = False

    instance (Show a) => Show (Tree a) where
        show :: (Tree a) -> String
        show (Leaf x) = "(L " ++ show x ++ ")"
        show (Branch l r) = "(B " ++ show l ++ show r ++ ")"
        show (Empty) = "Empty"

    instance Functor Tree where
        fmap :: (a -> b) -> Tree a -> Tree b 
        fmap f (Leaf x) = Leaf (f x)
        fmap f (Branch l r) = Branch (fmap f l) (fmap f r)
        fmap _ _ = error "Empty tree"

    instance Foldable Tree where 
        foldr :: (a -> b -> b) -> b -> Tree a -> b 
        foldr f i (Leaf x) = f x i
        foldr f i (Branch l r) = foldr f (foldr f i r) l
        foldr _ _ _ = error "Empty tree"

    -- To reach the definition of applicative, it is first necessary to define concatenation for trees
    tree_conc :: Tree a -> Tree a -> Tree a 
    tree_conc t1 t2 = (Branch t1 t2)

    tree_concat :: (Foldable t) => t (Tree a) -> Tree a 
    tree_concat cont = foldr (tree_conc) Empty cont 

    instance Applicative Tree where 
        pure :: a -> Tree a 
        pure x = Leaf x

        (<*>) :: Tree (a -> b) -> Tree a -> Tree b 
        t1 <*> t2 = tree_concat (fmap (\fun -> fmap fun t2) t1)
    
    instance Monad Tree where 
        return = pure

        (>>=) :: Tree a -> (a -> Tree b) -> Tree b 
        t1 >>= f = tree_concat(fmap f t1)

    monadic_trees = do
        x <- tree1
        y <- tree3
        return(x + y)


    main = do 
        putStrLn(show(tree1 == tree3))
        putStrLn(show(tree1 == (Branch (Branch (Leaf 1) (Leaf 10)) (Branch (Leaf 2) (Leaf 8)))))
        putStrLn(show tree1)
        putStrLn(show(fmap (\x -> x + 1) (tree1)))
        putStrLn(show(foldr (+) 0 tree1))
        putStrLn(show(tree_concat [tree1, tree2]))
        putStrLn(show((Leaf (\x -> x + 1)) <*> tree1))
        putStrLn(show(tree1 >>= (\x -> return(x + 1))))
        putStrLn(show(monadic_trees))




