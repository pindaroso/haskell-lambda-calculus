[![Build Status](https://travis-ci.org/pindaroso/haskell-lambda-calculus.svg?branch=master)](https://travis-ci.org/pindaroso/haskell-lambda-calculus)

# lambda-calculus-interpreter

*λ-Calculus Interpreter in Haskell*

## Setup

**Requirements**

* Docker or Stack

## Building

**Stack**

`make`

**Docker**

`docker pull stilesb/lambda-calculus:latest`

## Notes

**Program Execution**

```
((λtrue.((λfalse.((λif.((λand.((λor.((λnot.((and (not false)) ((or true) false))) (λa.(((if a) false) true)))) (λa.(λb.(((if a) true) b))))) (λa.(λb.(((if a) b) false))))) (λcond.(λt.(λf.((cond t) f)))))) (λt.(λf.f)))) (λt.(λf.t)))
=>
(λt.(λf.t))
```

Code adapted from <a href="https://github.com/Hardmath123/haskell-lambda-calculus" target="_blank">here</a>.
