# The Cuis Book
A book about Cuis Smalltalk. A community effort to bring documentation
to people new to Smalltalk and even computer programming. The book
comes in three parts.

Part one of the book is an introduction to Smalltalk, it wants to
be an informal introduction to get the user smoothly acclimated to the
Cuis world: the user will learn a bit about the syntax, the
environment and its tools, the user will write small applications. The
part two is more academic as it reviews the fundamental classes of the
Cuis world. In part three, more advanced topics are covered.

The book comes with examples and exercises. The solutions of the
exercises are in the annexes. We encourage writers to provides both
examples then exercises with solutions in annexes.


## License 

The contents of this book are protected under Creative Commons
[Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)](https://creativecommons.org/licenses/by-sa/4.0/)

# Notes to the writers
The book is writen with the GNU Texinfo software. It is the
documentation package of the GNU project. It is a well maintained and
documented project. Documentation writen with Texinfo can be converted
to info, PDF, HTML, docbook, text formats. We provide a makeBook.sh
script to output HTML and PDF

## Documentation
The Texinfo format is mainly pure text, the tagging is done with @
command, for example to @strong{strong} or
@url{http://cuis-smalltalk.org}

To learn more about the Texinfo format:
  * [Ref. card letter size](http://git.savannah.gnu.org/cgit/texinfo.git/plain/doc/refcard/txirefcard.pdf) or [Ref. card A4 size](http://git.savannah.gnu.org/cgit/texinfo.git/plain/doc/refcard/txirefcard-a4.pdf)
  * [GNU Texinfo manual](https://www.gnu.org/software/texinfo/manual/texinfo/)




## Writing documentation

### General recommendations
**Indentation.** Indent with 0, 3, 6, etc spaces when writing code. Do
not use tab unless the text editor converts it to spaces.

**Index.** Index when important concepts are explained. We write index
entry lowercase! Insert an index just after a section, and just before
a paragraph. The command to use is @cindex for conceptual index:
`@cindex tool, workspace`

### Macros and commands to use
We defined a few macros to. Of course standard Texinfo command are
used, you should look at the written documentation to see when and how
to use them.

**@cuis{}.** To name Cuis-Smalltalk every where it is necessary

**@vm{}.** For Virtual Machine

**@class{Object}.** To cite a class

**@method{collect:}.** To cite a method

**@msg{collect:}.** to cite a message (will render as #collect:)

**@smalltalk{5 factorial}.** To cite a portion of Smalltalk code in a
flow of text

**@kbd{Ctrl-A}.** To name a keyboard shortcut

**@option{resize...}.** To name a menu entry or a button label

**@dfn{Workspace}.** To emphasis a new term when it is first
defined. Use only once.

**@clicksequence{}** To describe a clic sequence, for example:

`...@clicksequence{Background click @click{} Open... @click{}
Workspace}...`

**@smalltalkExample{smalltalk code}.** To display in its own block
environment an example of Smalltlak code. Use this when writing an
example that don't need to be added to list of examples nor references
from elsewhere.

`@smalltalkExemple{@{1 . 2 . 3 @} collect: [:x |
   x @@ 3]}`

**@smalltalkExampleCaption{caption,uniqueLabel,smalltalk code}.** To
display in its own block environment an example of Smalltlak code. A
Caption is added below the example. The uniqueLabel is a reference to
be used elsewhere with `@ref{uniqueLabel}`. The example will be added to
the list of examples in the annexes.

**@exercise{caption,uniqueLabel,text}.** To display in its own block
environment an exercise. The exercises are compiled in the annexes, and
the resolved exercise must be added to the E-Exercises section too.

**@figure{caption,filename,width}.** Add a centered image with a
caption with the given width in cm. The filename (without path) must
be located in the img folder, along the source .texinfo file where is
inserted this command.

**@button{filename}.** To insert a button (0.5 cm width}

**@icon{filename}.** To insert an icon (1 cm width)

### Tips when using a macro
TO GET... | ...WRITE
----------|----------
@ | @@
{ (in a macro) | @{
} (in a macro) | @}
, (in a macro with multiple arguments) | @comma{}


### Compile the documentation
To compile the documentation you need to install the Texinfo package
and PDFLatex. Texinfo is shipped with all GNU/Linux
distribution. There are packages for other systems.

To compile invoke the build script, for example: `makeBook en pdf`


**DO NOT READ BELLOW, NEED TO BE PROCESSED, NOT YET THERE.**

-------------------------------------------------------------------------------


SPECIAL BLOC COMMAND TO DESCRIBE METHODS
read source book for examples



@defmethod class method arguments(if any)
/description/
@end defmethod

@defmethod DrGeoFigure faire: bloc
  @var{bloc}, bloc de code Pharo contenant des
    instructions de construction et/ou d'animation de la figure
    interactive.
  
Exécute le bloc de code dans un processus en tâche de fond. A utiliser
lorsque la construction doit se faire sous les yeux de l'utilisateur
ou bien lorsque la figure est animée.
  
@example
| figure point | 
figure := DrGeoFigure nouveau.
point := figure point: 0@@0.
figure do: [ 
   -5 a: 5 par: 0.1 faire: [:x |
      point deplacerA: x@@(x cos * 3).
      (Delay forMilliseconds: 100) wait.
      figure actualiser]
]
@end example
@end defmethod

@deftypemethod class classOfReturnedInstance method arguments(if any)
/description/
@end deftypemethod

Example:
@deftypemethod DrGeoFigure <WrpValue> angleGeometriqueCentre:de:a: a b c

  @var{a}, référence d'un point, sommet de l'angle

  @var{b}, référence d'un point

  @var{c}, référence d'un point

  @result{} référence d'un angle géométrique bac dont la mesure
  appartient à [0 ; 180[.
@example
figure angleGeometriqueCentre: a de: b a: c
@end example
@end deftypemethod

