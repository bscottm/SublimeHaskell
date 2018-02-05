-- SYNTAX TEST "Packages/SublimeHaskell/Syntaxes/Haskell-SublimeHaskell.sublime-syntax"

module Test where

import Data.Vector as V

static_vec = V.Vector [1 2 3 4 5]

wombats x = let inner_fun x = x + 1
            in  inner_fun x

wombats' x = let
                 inner_fun x = x + 1
                 inner_fun' x = x + 2
             in
                 (inner_fun' . inner_fun) x

wombats'' x = let inner_fun x = x + 1
                  inner_fun' x = x + 2
              in (inner_fun' . inner_fun) x

func x = undefined

(==>) = undefined

f1 x y z l@(x:xs) (LType x) (Rtype y, HType z) Branch ~holder ~holder' ~holder'' 'a' "abc" 'a' = undefined

f2 x
    = error "Help me!?"

a = 4 :: Int

b = \a -> a + 1

c = f3' 'a'

f3 x = ensign x `elem` 4

guarded_func x
  | a == 0 = undefined
  | b == 3 = undefined

_ ==> _ = undefined
