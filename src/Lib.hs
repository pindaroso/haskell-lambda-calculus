-- Code adapted from https://github.com/Hardmath123/haskell-lambda-calculus

module Lib
    ( prog
    , eval
    ) where

type Label = String

data Exp = Lam Label Exp
         | App Exp Exp
         | Var Label

instance Show Exp where
  show (Lam label exp) = "(lambda (" ++ label ++ ") " ++ show exp ++ ")"
  show (App exp exp')  = "(" ++ show exp ++ " " ++ show exp' ++ ")"
  show (Var label)     = label

data Lambda = Lambda { argumentname :: Label
                     , contents     :: Exp
                     , parentEnv    :: Environment
                     }

instance Show Lambda where
  show (Lambda argumentname contents parentEnv) = "(lambda (" ++ argumentname ++ ") " ++ show contents ++ ")"

data Environment = Root
                 | Environment Label Lambda Environment

labelLookup :: Label -> Environment -> Lambda
labelLookup n Root                           = error $ "Could not find the name " ++ n
labelLookup n (Environment key value parent) = if n == key then value else labelLookup n parent

evalExp :: Environment -> Exp -> Lambda
evalExp env (Lam argname body) = Lambda argname body env
evalExp env (Var name) = labelLookup name env
evalExp env (App function argument) =
  let arg = evalExp env argument
      fn  = evalExp env function
      ne  = Environment (argumentname fn) arg (parentEnv fn)
  in  evalExp ne (contents fn)

eval :: Exp -> Lambda
eval = evalExp Root

define :: Label -> Exp -> Exp -> Exp
define name value next = App (Lam name next) value

cl :: [Label] -> Exp -> Exp
cl [n] body      = Lam n body
cl (n:rest) body = Lam n (cl rest body)

cc :: Exp -> [Exp] -> Exp
cc e [arg]      = App e arg
cc e (arg:rest) = cc (App e  arg) rest

prog =
  define "true"  (cl ["t", "f"]         (Var "t")) $
  define "false" (cl ["t", "f"]         (Var "f")) $
  define "if"    (cl ["cond", "t", "f"] (cc (Var "cond") [Var "t", Var "f"])) $
  define "and"   (cl ["a", "b"]         (cc (Var "if")   [Var "a", Var "b",     Var "false"])) $
  define "or"    (cl ["a", "b"]         (cc (Var "if")   [Var "a", Var "true",  Var "b"])) $
  define "not"   (cl ["a"]              (cc (Var "if")   [Var "a", Var "false", Var "true"])) $
  cc (Var "and") [cc (Var "not") [Var "false"], cc (Var "or") [Var "true", Var "false"]]
