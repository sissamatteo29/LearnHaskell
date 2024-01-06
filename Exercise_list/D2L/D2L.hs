{-
1. Define a data structure, called D2L, to store lists of possibly depth two, e.g. like [1,2,[3,4],5,[6]]. 
2. Implement a flatten function which takes a D2L and returns a flat list containing all the stored values in it in the same order. 
3. Make D2L an instance of Functor, Foldable, Applicative.
-}


module Main where

    -- Defining a new data structure can be done with the data clause
    data D2L a = Empty | Level1 a (D2L a) | Level2 [a] (D2L a) deriving (Show, Eq)

    -- For instance, a possible instantiation might be
    listD2L :: D2L Int
    listD2L = Level1 0 (Level1 1 (Level2 [1,2,3] (Level2 [5,6,7] Empty)))

    -- Function flatten to turn a D2L into a flat list containing all the elements of the original D2L in the same order
    flatten :: D2L a -> [a]
    flatten Empty = []
    flatten (Level1 x rest) = x : flatten rest
    flatten (Level2 xs rest) = xs ++ flatten rest


    --D2L an instance of Functor class
    instance Functor D2L where
        fmap :: (a -> b) -> D2L a -> D2L b
        fmap f Empty = Empty
        fmap f (Level1 x rest) = Level1 (f x) (fmap f rest)
        fmap f (Level2 xs rest) = Level2 (map f xs) (fmap f rest)

    
    --D2L an instance of Foldable class
    {-
    For the last pattern match of this function:
    - First unfold the D2L structure until the end (maintaining a foldr approach)
    - When rolling back the recursion, if a Level2 is encountered, then the value that has been returned so far
      is stored in "i" and it is used as the base value to foldr the list.
    -}
    instance Foldable D2L where
        foldr :: (a -> b -> b) -> b -> D2L a -> b
        foldr f i Empty = i
        foldr f i (Level1 x rest) = f x (foldr f i rest)
        foldr f i (Level2 xs rest) = foldr f (foldr f i rest) xs


    -- D2L an instance of Applicative class
    {-
    Since D2L are very similar to lists, the definition of D2L as instances of the Applicative class is very similar
    to the one for lists []. It is therefore necessary to define concatenation of two D2L.
    -}

    -- This first function concatenates two D2L
    d2Lconc :: D2L a -> D2L a -> D2L a
    d2Lconc (Level1 x Empty) list = Level1 x list
    d2Lconc (Level2 xs Empty) list = Level2 xs list
    d2Lconc (Level1 x rest) list = Level1 x (d2Lconc rest list)
    d2Lconc (Level2 xs rest) list = Level2 xs (d2Lconc rest list)

    -- Then it is possible to concatenate a set of D2L stored in a list
    d2Lconcat :: D2L (D2L a) -> D2L a
    d2Lconcat = foldr d2Lconc Empty


    instance Applicative D2L where
        pure :: a -> D2L a
        pure x = Level1 x Empty
        
        (<*>) :: D2L (a -> b) -> D2L a -> D2L b
        fs <*> xs = d2Lconcat (fmap (\fun -> fmap fun xs) fs)



    main = do 
        putStrLn (show listD2L)
        putStrLn (show $ flatten listD2L)
        putStrLn (show (fmap (+1) listD2L))
        putStrLn (show (foldr (+) 0 listD2L))
        putStrLn (show (pure 3 :: D2L Int))
        putStrLn (show (d2Lconc listD2L listD2L))
        putStrLn (show (d2Lconcat (Level1 listD2L (Level1 listD2L Empty))))
        putStrLn (show ((Level1 (+1) (Level1 (*2) Empty)) <*> listD2L))

        {-
        Here's the entire output for these test cases:

        Level1 0 (Level1 1 (Level2 [1,2,3] (Level2 [5,6,7] Empty)))
        [0,1,1,2,3,5,6,7]
        Level1 1 (Level1 2 (Level2 [2,3,4] (Level2 [6,7,8] Empty)))
        25
        Level1 3 Empty
        Level1 0 (Level1 1 (Level2 [1,2,3] (Level2 [5,6,7] (Level1 0 (Level1 1 (Level2 [1,2,3] (Level2 [5,6,7] Empty)))))))
        Level1 0 (Level1 1 (Level2 [1,2,3] (Level2 [5,6,7] (Level1 0 (Level1 1 (Level2 [1,2,3] (Level2 [5,6,7] Empty)))))))
        Level1 1 (Level1 2 (Level2 [2,3,4] (Level2 [6,7,8] (Level1 0 (Level1 2 (Level2 [2,4,6] (Level2 [10,12,14] Empty)))))))
        -}
