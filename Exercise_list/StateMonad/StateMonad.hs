

module Main where

    -- st is the type for the state, while a is the type for the data contained in the state
    data State st a = State (st -> (st, a))

    state1 = State (\s -> (s, s + 1))
    state2 = State (\s -> (2*s, ()))

    runState :: State st a -> st -> (st, a)
    runState (State f) initial_state = f initial_state

    instance Functor (State st) where
        fmap :: (a -> b) -> State st a -> State st b 
        fmap valuef (State statef) = State (\old -> 
                                            let
                                                (new_state, value) = statef old
                                            in (new_state, valuef value))
    
    instance Applicative (State st) where 
        pure :: a -> State st a 
        pure x = State (\st -> (st, x))

        (<*>) :: State st (a -> b) -> State st a -> State st b 
        State statef1 <*> State statef2 = State (\old_state ->
                                                let 
                                                    (new_state1, value_function) = statef1 old_state
                                                    (new_state2, value) = statef2 new_state1
                                                in (new_state2, value_function value))

    -- States to try apply.
    -- This state doesn't change the state in any way, but provides the function
    state_fun = State(\state -> (2 * state, \x -> 2 * x))
    state_data = State(\state -> (state, 10 * state))

    instance Monad (State st) where 
        return = pure 

        (>>=) :: State st a -> (a -> State st b) -> State st b 
        State statef1 >>= create_State = State (\old_state ->
                                                let 
                                                    (new_state, value) = statef1 old_state
                                                    State statef2 = create_State value
                                                in statef2 new_state)
    
    monadic_states = do 
        x <- return 5
        return (x + 1)

    getState = State(\state -> (state, state))
    putState new = State(\_ -> (new, ()))

    monadic_states2 = do
        x <- getState
        return(x+1)

    monadic_states3 = do
        x <- getState
        putState(x + 1)
        x <- getState
        return x

    main = do
        putStrLn(show(runState state1 1))
        putStrLn(show(runState state2 1))
        putStrLn(show(runState (fmap (\x -> x*x) state1) 1))
        putStrLn(show(runState(state_fun <*> state_data) 1))
        putStrLn(show(runState ((State (\st -> (st, st + 1))) >>= (\x -> return x)) 1))
        putStrLn(show(runState monadic_states 1))
        putStrLn(show(runState monadic_states2 1))
        putStrLn(show(runState monadic_states3 1))



        
