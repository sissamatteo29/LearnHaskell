
Consider the "fancy pair" data type (called Fpair), which encodes a pair of the same type a, 
and may optionally have another component of some "showable" type b, e.g. the character '$'. 
Define Fpair, parametric with respect to both a and b. 

1) Make Fpair an instance of Show, where the implementation of show of a fancy pair e.g. encoding (x, y, '$') 
must return the string "[x$y]", where x is the string representation of x and y of y. 
If the third component is not available, the standard representation is "[x, y]". 

2) Make Fpair an instance of Eq — of course the component of type b does not influence the actual value, being only part of the representation, 
so pairs with different representations could be equal. 

3) Make Fpair an instance of Functor, Applicative and Foldable.

Notes:
This exercise is very beneficial to understand the following topics:
- Class constraints
- Partial application of type constructors