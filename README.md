[![Build Status](https://travis-ci.org/stilesb/haskell-lambda-calculus.svg?branch=master)](https://travis-ci.org/stilesb/haskell-lambda-calculus)

# haskell-lambda-calculus

*λ-Calculus Interpreter in Haskell*

## Setup

**Requirements**

* Docker or Stack

## Building

**Stack**

`make`

**Docker Image**

`docker pull stilesb/lambda-calculus:latest`

## Running

```
((λtrue.((λfalse.((λif.((λand.((λor.((λnot.((and (not false)) ((or true) false))) (λa.(((if a) false) true)))) (λa.(λb.(((if a) true) b))))) (λa.(λb.(((if a) b) false))))) (λcond.(λt.(λf.((cond t) f)))))) (λt.(λf.f)))) (λt.(λf.t)))
=>
(λt.(λf.t))
```

Questions or comments? Message me at https://www.brandonstil.es.
