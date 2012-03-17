# jaRL -- just another Ruby Lisp ツ

## hello, world!

```common-lisp
(label happy (quote (lambda (name)
   (println "Joyeux anniversaire, " name "!"))))

(happy "Gustave")
```
## syntax definition

    Expression ::= (Whitespace* '(') (Symbol) (Whitespace Argument)* Whitespace* (')')
    Argument ::= (String|Numeral|Expression)
    Numeral ::= ("-")? ("\d")+ ((".") ("\d")+)?
    String ::= ("'") ("[^\']")* ("'")
    Comment ::= ("#") (anything)* (end-of-line)

## uLithp

jaRL uses [uLithp](https://github.com/fogus/lithp/) as a Lisp evaluator.

## License

MIT
