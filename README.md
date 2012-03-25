# jaRL -- just another Ruby Lisp ツ

![jaRL logo](http://github.com/downloads/jacksonwillis/jaRL/jaRL.png)

## hello, world!

```common-lisp
(define happy (quote (lambda (name)
   (println "Joyeux anniversaire, " name "!"))))

(happy "Gustave")
```

## gimmeh ruby!

```common-lisp
(print "What is your name? ")
(define name (getln))
(println "Your code name is... " (.reverse name) "!")

(print "How old are you? ")
(define age (.to_f (getln)))
(if (>= age 100) (println "Wow! You are really old!"))
(println "Your age in dog years is... " (* 7 age) "!"))
```

`([function starting with '.'] [a jarl object])` gives you `[that object in ruby].__send__([function])`.

So `(.reverse "gnirts")` in jaRL is equal to `"gnirts".reverse` in Ruby.

## syntax definition

    Expression ::= (Whitespace* '(') (Symbol) (Whitespace Argument)* Whitespace* (')') Whitespace*
    Symbol ::= ("a-z" | "A-Z" | "+" | "-" | "*" | "/" | "=" | "_")+
    Argument ::= (String | Numeral | Expression)
    Numeral ::= ("-")? (digit)+ ((".") (digit)+)?
    String ::= ("'") ("[^\']")* ("'")
    Comment ::= ("#") (anything)* (end-of-line)

All numerals are floats right now.

## uLithp

jaRL uses [uLithp](https://github.com/fogus/lithp/) as a Lisp evaluator.

## License

MIT
