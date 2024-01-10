{-
Consider a data structure Gtree for general trees, i.e. trees containg some data in each node, and a variable number of children. 

1. Define the Gtree data structure. 

2. Define gtree2list, i.e. a function which translates a Gtree to a list. 

3. Make Gtree an instance of Functor, Foldable, and Applicative.
-}

module Main where
    data Gtree a = Empty | Leaf a | Branch a [Gtree a] deriving (Show, Eq)

    gtree1 :: Gtree Int
    gtree1 = Empty
    gtree2 :: Gtree Int
    gtree2 = Leaf 3
    gtree3 :: Gtree Int
    gtree3 = Branch 2 [(Leaf 1), (Branch 8 [(Leaf 10)])]
    comp_gtree :: Gtree Int
    comp_gtree = Branch 2 [(Leaf 1), (Branch 8 [(Leaf 10), (Branch 2 [(Leaf 5), (Leaf 0), (Leaf 11)]), (Leaf 8)]), (Branch 90 [(Leaf 5)])]

    gtree2list :: Gtree a -> [a]
    gtree2list Empty = []
    gtree2list (Leaf x) = [x]
    gtree2list (Branch x (y:ys)) = [x] ++ (concatMap gtree2list (y:ys))

    -- Instance of Functor
    instance Functor Gtree where 
        fmap :: (a -> b) -> Gtree a -> Gtree b 
        fmap f Empty = error "Empty Gtree"
        fmap f (Leaf x) = Leaf (f x)
        fmap f (Branch x (y:ys)) = Branch (f x) (map (\tree -> fmap f tree) (y:ys))

    instance Foldable Gtree where 
        foldr :: (a -> b -> b) -> b -> Gtree a -> b 
        foldr f i Empty = i 
        foldr f i (Leaf x) = f x i 
        foldr f i gtree = foldr f i (gtree2list gtree)


    -- In order to arrive to the definition of Applicative, we can define what it means "concatenating" two Gtrees
    -- Basically, if the first Gtree is a Branch and the other one is not empty, the second Gtree is placed as a subtree of the first one
    gtree_conc :: Gtree a -> Gtree a -> Gtree a 
    gtree_conc Empty g2 = g2 
    gtree_conc g1 Empty = g1
    gtree_conc (Branch x ys) g2 = Branch x (g2:ys)
    gtree_conc (Leaf x) (Branch y zs) = Branch y ((Leaf x) : zs)
    gtree_conc (Leaf x) (Leaf y) = Branch x [(Leaf y)]

    -- By folding gtree_conc, it is possible to obtain a concat for Gtrees
    gtree_concat :: (Foldable t) => t (Gtree a) -> Gtree a
    gtree_concat str = foldr gtree_conc Empty str


    -- Instance of Applicative, using the previous functions
    instance Applicative Gtree where 
        pure :: a -> Gtree a 
        pure x = Leaf x

        (<*>) :: Gtree (a -> b) -> Gtree a -> Gtree b 
        Empty <*> _ = error "Empty Gtree of functions"
        _ <*> Empty = Empty 
        (Leaf fun) <*> gtree = fmap fun gtree 
        fun_tree <*> value_tree =  gtree_concat(fmap (\fun -> fmap fun value_tree) fun_tree)

    gtree_fun :: Gtree (Int -> Int)
    gtree_fun = Branch (\x -> x + 1) [(Leaf (\x -> 2 * x))]


    -- Let's also make Gtrees instances of Monads
    instance Monad Gtree where 
        return = pure
        
        (>>=) :: Gtree a -> (a -> Gtree b) -> Gtree b 
        gtree_data >>= fun = gtree_concat(fmap fun gtree_data)

    main = do 
        putStrLn(show (gtree1 :: Gtree Int))
        putStrLn(show gtree2)
        putStrLn(show gtree3)
        putStrLn(show(gtree2list gtree3))
        putStrLn("Complex gtree: " ++ show(comp_gtree))
        putStrLn(show(fmap (+1) comp_gtree))
        putStrLn(show(fmap (*2) comp_gtree))
        putStrLn(show(foldr (+) 0 comp_gtree))
        putStrLn(show(foldr (*) 1 comp_gtree))
        putStrLn(show(gtree_concat [gtree1, gtree2]))
        putStrLn(show(gtree_concat [gtree2, gtree3]))
        putStrLn(show(gtree_concat [comp_gtree, gtree3]))
        putStrLn(show(gtree_fun <*> comp_gtree))
        putStrLn(show(comp_gtree >>= (\x -> return (x*2))))
        putStrLn(show(gtree3 >>= (\x -> return (x*2))))



        
