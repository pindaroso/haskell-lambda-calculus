-- Code adapted from https://github.com/Hardmath123/haskell-lambda-calculus

module Lib
    ( prog
    , eval
    ) where

data Expr = Lam String Expr
          | App Expr Expr
          | Var String

instance Show Expr where
  show (Lam argname body)      = "(lambda (" ++ argname ++ ") " ++ show body ++ ")"
  show (App function argument) = "(" ++ show function ++ " " ++ show argument ++ ")"
  show (Var name)              = name

data Lambda = Lambda { argumentname :: String
                     , contents     :: Expr
                     , parentEnv    :: Environment
                     }

instance Show Lambda where
  show (Lambda argumentname contents parentEnv) = "(lambda (" ++ argumentname ++ ") " ++ show contents ++ ")"

data Environment = Root
                 | Environment String Lambda Environment

envLookup :: String -> Environment -> Lambda
envLookup n Root                           = error $ "Could not find the name " ++ n
envLookup n (Environment key value parent) = if n == key then value else envLookup n parent

evalExp :: Environment -> Expr -> Lambda
evalExp env (Lam argname body) = Lambda argname body env
evalExp env (Var name) = envLookup name env
evalExp env (App function argument) =
  let arg = evalExp env argument
      fn  = evalExp env function
      ne  = Environment (argumentname fn) arg (parentEnv fn)
  in  evalExp ne (contents fn)

eval :: Expr -> Lambda
eval = evalExp Root

define :: String -> Expr -> Expr -> Expr
define name value next = App (Lam name next) value

cl :: [String] -> Expr -> Expr
cl [n] body      = Lam n body
cl (n:rest) body = Lam n (cl rest body)

cc :: Expr -> [Expr] -> Expr
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
