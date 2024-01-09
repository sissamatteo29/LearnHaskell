
Haskell is a statically-typed, purely functional programming language known for its elegance, expressiveness, and unique approach to programming. Developed in the late 1980s, Haskell has grown into a powerful and influential language, embraced both by academia and industry. Named after mathematician Haskell Curry, the language embodies principles of functional programming and provides a refreshing departure from the imperative paradigm.

**Advantages of Haskell:**

1. **Functional Purity:**
   Haskell follows a purely functional paradigm, which means functions in Haskell are side-effect-free and deterministic. This purity leads to code that is easier to reason about, test, and maintain.

2. **Strong Static Typing:**
   Haskell boasts a strong static type system that catches errors at compile-time, reducing the likelihood of runtime errors. This results in more robust and reliable code.

3. **Lazy Evaluation:**
   Haskell utilizes lazy evaluation, meaning that expressions are only evaluated when their values are needed. This allows for more efficient use of resources and supports the creation of infinite data structures.

4. **Expressive Type System:**
   The type system in Haskell is expressive and allows for concise yet precise code. Features such as type inference relieve developers from explicitly declaring types, reducing boilerplate code.

5. **Type Classes and Polymorphism:**
   Haskell introduces type classes, a powerful mechanism for ad-hoc polymorphism. Type classes enable the creation of generic and reusable code through a form of type-based dispatch.

7. **High-Level Abstractions:**
   Haskell offers high-level abstractions for expressing complex ideas in a concise manner. Monads, for example, provide a structured way to handle side effects, fostering clean and modular code.


**INSTALLING A HASKELL IMPLEMENTATION**

There are many compilers and implementations of Haskell. One of the most popular one is GHC (Glasgow Haskell Compiler).
To install the compiler alone, go to https://www.haskell.org/ghc/.
In most cases it is more convenient to install an entire Haskell distribution, which comes with other tools along with the compiler.
You can find an entire distribution at https://www.haskell.org/downloads/. 
Once the download is complete, there are multiple ways to compile and run Haskell code.
First off, remember to check the environment variables of the operating system, to verify that the bin folder where the Haskell compiler and other 
tools reside is under the PATH variable. If you install the entire Haskell distribution, the bin folder with all you need is usually under C:\ghcup\bin.

First of all, it is necessary to know how and where to write the code:
- Haskell code should be written in files with a .hs extension, which is the extension for source code Haskell files that can be fed to the compiler.
- Each Haskell source code file has to declare a module name at the beginning in order to be correctly executed. The module name has to start with a capital 
  letter and it can have any name. The syntax to do that is the following:

  module <module_name> where 

  	... Haskell code ...

  For example:

  module Main where
  
  main = putStrl "Hello World!"


Once this is done, you can compile and execute the code in two ways.
The first one is the most traditional one, which consists in compiling the code and then executing it:
- Open a terminal window.
- Move on the directory where the .hs file that you want to execute reside.
- Compile the code with ghc <file_name.hs>
This will create in the directory an executable file, which has extention .exe in Windows.
- Run the compiled code with ./<file_name> 
Notice: all Haskell applications need an entry point to run, which is a function called main, where the execution will start.

The other, more convenient way of doing things, is to use an interactive environment like GHCi, which allows you to dynamically load, reload and run haskell
files. With the complete Haskell distribution, GHCi is included (and is under the bin folder C:\ghcup\bin). 
Once the source code of the Haskell application is written, these are the steps to follow:
- Open a terminal window.
- Move to the directory where the Haskell source code resides.
- Simply run on the terminal ghci. This will initiate the Haskell interactive environment on the current directory.
- To load a source code file in the ghci environment, you can use the command :load <file_name.hs> or :l <file_name.hs>. This will 
  compile the code and integrate it with the interactive environment, meaning that all functions and variables defined in those files can now 
  be called directly from the terminal to be executed.
- You can modify a source code file during a GHCi session, and there is no need to recompile the code. Indeed, you can simply 
	- Save the file after the modifications.
	- Use the command :reload or :r (without any file name) to update the interactive GHCi environment to the latest versions of the source code files.
- To close a GHCi session, you can simply type :quit on the terminal.
Using GHCi instead of the compiler actually comes very useful because it can be easily integrated with any IDE that offers a terminal window right in the user interface. Simply edit your files in real time and execute them on the same interface.