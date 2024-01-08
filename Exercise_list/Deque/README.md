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