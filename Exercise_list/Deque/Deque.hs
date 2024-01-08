
{-
A deque, short for double-ended queue, is a list-like data structure that supports efficient element insertion and removal from both its head and its tail. 
Recall that Haskell lists, however, only support O(1) insertion and removal from their head. 
Implement a deque data type in Haskell by using two lists: the first one containing elements from the initial part of the list, 
and the second one containing elements form the final part of the list, reversed. 
In this way, elements can be inserted/removed from the first list when pushing to/popping the deque's head, 
and from the second list when pushing to/popping the deque's tail. 

1) Write a data type declaration for Deque. 

2) Implement the following functions: 
• toList: takes a Deque and converts it to a list 
• fromList: takes a list and converts it to a Deque
• pushFront: pushes a new element to a Deque's head 
• popFront: pops the first element of a Deque, returning a tuple with the popped element and the new Deque 
• pushBack: pushes a new element to the end of a Deque 
• popBack: pops the last element of a Deque, returning a tuple with the popped element and the new Deque 

3) Make Deque an instance of Eq and Show. 

4) Make Deque an instance of Functor, Foldable, Applicative and Monad. 

You may rely on instances of the above classes for plain lists.
-}

module Main where

    -- Deque new data type, whose data constructor takes two lists as arguments, the first
    -- one is the head, the second one is the tail
    data Deque a = Deque [a] [a]

    reverselist :: [a] -> [a]
    reverselist [] = []
    reverselist (x:xs) = (reverselist xs) ++ [x]

    tolist :: Deque a -> [a]
    tolist (Deque h t) = h ++ (reverselist t)

    takelist :: [a] -> Int -> [a]
    takelist [] _ = []
    takelist _ 0 = []
    takelist (x:xs) n = x : (takelist xs (n - 1))

    removelist :: [a] -> Int -> [a]
    removelist [] _ = []
    removelist xs 0 = xs
    removelist (x:xs) n = removelist xs (n - 1)

    splitlistAt :: [a] -> Int -> ([a], [a])
    splitlistAt [] _ = ([], [])
    splitlistAt xs 0 = ([], xs)
    splitlistAt xs n = ((takelist xs n), (removelist xs n))

    -- Transforms a list in a Deque a data type, by splitting the list in half
    fromlist :: [a] -> Deque a
    fromlist xs = let (h, t) = splitlistAt xs (div (length xs) 2)
                  in Deque h (reverselist t)
    
    pushFront :: Deque a -> a -> Deque a 
    pushFront (Deque xs ys) x = Deque (x:xs) ys

    balanceDeque :: Deque a -> Deque a 
    balanceDeque (Deque [] (y:ys)) = fromlist (reverse (y:ys))
    balanceDeque (Deque (x:xs) []) = fromlist (x:xs)

    popFront :: Deque a -> (a, Deque a)
    popFront (Deque [] []) = error "Empty Deque"
    -- If there are no elements in the first list, but the second list has some elements
    -- it is necessary to get the element from the second list.
    popFront (Deque [] (y:ys)) = 
        let (Deque h t) = balanceDeque (Deque [] (y:ys))
            he = head h
        in (head h, (Deque (removelist h 1) t))

    popFront (Deque (x:xs) ys) = (x, Deque xs ys)

    swapDeque :: Deque a -> Deque a 
    swapDeque (Deque xs ys) = Deque ys xs

    -- For the operations on the back of the list, the previous functions are leveraged, thanks to a simple swap mechanism
    -- between the two lists of the Deque
    pushBack :: Deque a -> a -> Deque a 
    pushBack xs y = swapDeque (pushFront (swapDeque xs) y)

    popBack :: Deque a -> (a, Deque a)
    popBack xs = 
        let (y, ys) = popFront (swapDeque xs)
        in (y, swapDeque ys)
        

    -- Let's make Deque an instance of Eq
    instance (Eq a) => Eq (Deque a) where
        (Deque xs ys) == (Deque zs ps) = xs == zs && ys == ps

    -- Let's make Deque an instance of Show
    instance (Show a) => Show (Deque a) where
        show (Deque xs ys) = "Deque" ++ show xs ++ show ys

    -- Let's make Deque an instance of Foldable
    instance Foldable Deque where
        foldr :: (a -> b -> b) -> b -> Deque a -> b
        foldr f i (Deque xs ys) = 
            let
                rev = reverselist ys
            in foldr f (foldr f i xs) ys

    instance Functor Deque where
        fmap :: (a -> b) -> Deque a -> Deque b
        fmap f (Deque xs ys) = Deque (map f xs) (map f ys)

    instance Applicative Deque where
        pure :: a -> Deque a 
        pure x = Deque [x] []

        -- The application is going to be very similar to the definition of Applicative for lists
        -- with concatMap
        (<*>) :: Deque (a -> b) -> Deque a -> Deque b
        xs <*> ys =
            let func_list = tolist xs
                data_list = tolist ys
                res_list = func_list <*> data_list
            in fromlist res_list

    -- Let's first define a function to concatenate two Deque(s).
    -- This function simply places the second Deque to the end of the first one
    dconc :: Deque a -> Deque a -> Deque a
    dconc (Deque xs ys) zs = 
        let 
            lst = tolist zs
            lst_rev = reverselist lst
        in (Deque xs (lst_rev ++ ys))

    dconcat :: (Foldable t) => t (Deque a) -> Deque a
    dconcat = foldr dconc (Deque [] []) 


    instance Monad Deque where
        (>>=) :: Deque a -> (a -> Deque b) -> Deque b
        xs >>= f = (dconcat (fmap f xs))

  





    main = do
        putStrLn(show(reverselist [1, 2, 3]))
        putStrLn(show(tolist(Deque [1,2,3] [1,2,3])))
        putStrLn(show(tolist(Deque [] [1,2,3])))
        putStrLn(show(splitlistAt [1,2,3,4,5] 3))
        putStrLn(show(fromlist [1,2,3,4,5]))
        putStrLn(show(pushFront (Deque [1,2,3] [4,5]) 0))
        putStrLn(show(balanceDeque (Deque [] [3,2,1,0])))
        putStrLn(show(balanceDeque (Deque [3,2,1,0] [])))
        putStrLn(show(popFront (Deque [] [1,2,3])))
        putStrLn(show(popFront (Deque [1,2,3] [1,2,3])))
        putStrLn(show(pushBack (Deque [] [1,2,3]) 0))
        putStrLn(show(popBack(Deque [] [1,2,3])))
        putStrLn(show((Deque [1,2] []) == (Deque [1,2] [])))
        putStrLn(show(foldr (+) 0 (Deque [1,2] [])))
        putStrLn(show(foldr (+) 0 (Deque [1,2] [])))
        putStrLn(show(fmap (+1) (Deque [1,2] [])))
        putStrLn(show((Deque [(+1)] [(*2)]) <*> (Deque [1,2,3,4] [9,8,7])))
        putStrLn(show(dconc (Deque [1,2,3] [1,2,3]) (Deque [1] [3,2])))
        putStrLn(show(dconcat [(Deque [1,2,3] [1,2,3]), (Deque [1] [3,2])]))
        putStrLn(show((Deque [1,2,3] [1]) >>= (\x -> Deque [x*2] [])))

        

        




