{-
Consider the "fancy pair" data type (called Fpair), which encodes a pair of the same type a, 
and may optionally have another component of some "showable" type b, e.g. the character '$'. 
Define Fpair, parametric with respect to both a and b. 

1) Make Fpair an instance of Show, where the implementation of show of a fancy pair e.g. encoding (x, y, '$') 
must return the string "[x$y]", where x is the string representation of x and y of y. 
If the third component is not available, the standard representation is "[x, y]". 

2) Make Fpair an instance of Eq — of course the component of type b does not influence the actual value, being only part of the representation, 
so pairs with different representations could be equal. 

3) Make Fpair an instance of Functor, Applicative and Foldable.
-}

module Main where

    data Fpair sep a = Fpairnot a a | (Show sep) => Fpairwith a a sep

    instance (Show a) => Show (Fpair sep a) where
        show (Fpairnot x y)= "[" ++ show x ++ ", " ++ show y ++ "]"
        show (Fpairwith x y z) = "[" ++ show x ++ show z ++ show y ++ "]"

    fpair1 :: Fpair Char Int
    fpair1 = Fpairnot 3 4
    fpair2 = Fpairwith 3 4 '/'
    fpair3 = Fpairnot 5 4

    instance (Eq a) => Eq (Fpair sep a) where
        (Fpairnot x y) == (Fpairnot p q) = x == p && y == q
        (Fpairwith x y _) == (Fpairwith p q _) = x == p && y == q
        (Fpairnot x y) == (Fpairwith p q _) = x == p && y == q
        (Fpairwith x y _) == (Fpairnot p q) = x == p && y == q
    
    instance Functor (Fpair sep) where
        fmap :: (a -> b) -> Fpair sep a -> Fpair sep b
        fmap f (Fpairnot x y) = Fpairnot (f x) (f y)
        fmap f (Fpairwith x y z) = Fpairwith (f x) (f y) z

    instance Applicative (Fpair sep) where
        pure :: a -> Fpair sep a
        pure x = Fpairnot x x 

        (<*>) :: Fpair sep (a -> b) -> Fpair sep a -> Fpair sep b
        (Fpairnot f1 f2) <*> (Fpairnot x y) = Fpairnot (f1 x) (f2 y)
        (Fpairwith f1 f2 z) <*> (Fpairwith x y _) = Fpairwith (f1 x) (f2 y) z   -- The separator is the one of the first Fpair
        (Fpairnot f1 f2) <*> (Fpairwith x y z) = Fpairwith (f1 x) (f2 y) z
        (Fpairwith f1 f2 z) <*> (Fpairnot x y) = Fpairwith (f1 x) (f2 y) z
    

    instance Foldable (Fpair sep) where
        foldr :: (a -> b -> b) -> b -> Fpair sep a -> b
        foldr f i (Fpairnot x y) = f x (f y i)
        foldr f i (Fpairwith x y _) = f x (f y i)




    main = do
        putStrLn(show(fpair1))
        putStrLn(show(fpair2))
        putStrLn(show(fpair1 == fpair2))  -- true because they both contain the values 3 4
        putStrLn(show(fpair1 == fpair3))
        putStrLn(show((Fpairwith (\x -> x*x) (\x -> 2*x) "2") <*> (Fpairnot 3 4)))
        putStrLn(show(foldr (*) 1 (Fpairwith 3 4 "00")))
