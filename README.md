# jaRL -- just another Ruby Lisp ツ

## hello, world!

```common-lisp
(label happy (quote (lambda (name)
   (println "Joyeux anniversaire, " name "!"))))

(happy "Gustave")
```

# gimmeh ruby!

```common-lisp
(print "What is your name? ") (label name (getln))

(if (eq name "exit") (/exit))

(println "heheh, " (car (.reverse name)) ".")
```

See that `.reverse` function?
That's not defined in jaRL.
`(.foo ...args...)` gives you, in Ruby, `[...args...].map(&:foo)`

Neither is `/exit`.
`(/foo)` gives you `Kernel.__send__(:foo)`

## syntax definition

    Expression ::= (Whitespace* '(') (Symbol) (Whitespace Argument)* Whitespace* (')')
    Argument ::= (String|Numeral|Expression)
    Numeral ::= ("-")? ("\d")+ ((".") ("\d")+)?
    String ::= ("'") ("[^\']")* ("'")
    Comment ::= ("#") (anything)* (end-of-line)

All numerals are floats right now.

## uLithp

jaRL uses [uLithp](https://github.com/fogus/lithp/) as a Lisp evaluator.

## License

MIT
