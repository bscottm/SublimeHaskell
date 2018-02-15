-- SYNTAX TEST "Packages/SublimeHaskell/Syntaxes/Haskell-SublimeHaskell.sublime-syntax"

module Test where
-- ^^^ meta.declaration.module.haskell keyword.other.haskell keyword.module.haskell
--     ^^^^ meta.declaration.module.haskell storage.module.haskell
--          ^^^^^ meta.declaration.module.haskell keyword.module.haskell

import Data.Vector as V
-- ^^^
--     ^^^^^^^^^^^ meta.import.haskell storage.module.haskell
--                 ^^ meta.import.haskell keyword.other.haskell keyword.import.haskell
--                    ^ meta.import.haskell storage.module.haskell

static_vec = V.Vector [1 2 3 4 5]
-- ^^^^^^^ meta.function.bind_or_sig.haskell entity.name.function.haskell
--         ^ meta.function.bind_or_sig.haskell meta.haskell.expression keyword.operator.haskell
--           ^^^^^^^^ meta.haskell.expression storage.module.haskell entity.name.module.haskell
--                    ^ meta.haskell.expression keyword.operator.haskell punctuation.list.haskell
--                     ^ meta.haskell.expression constant.numeric.haskell
--                              ^ meta.haskell.expression keyword.operator.haskell punctuation.list.haskell

wombats x = let inner_fun x = x + 1
-- ^^^^ meta.function.bind_or_sig.haskell entity.name.function.haskell
--      ^ meta.function.bind_or_sig.haskell variable.parameter.haskell
--        ^ meta.function.bind_or_sig.haskell meta.haskell.expression keyword.operator.haskell
--          ^^^ meta.haskell.expression meta.function.let-bindings.haskell keyword.other.haskell
--              ^^^^^^^^^ meta.haskell.expression meta.function.let-bindings.haskell meta.function.bind_or_sig.haskell entity.name.function.haskell
--                        ^ meta.haskell.expression meta.function.let-bindings.haskell meta.function.bind_or_sig.haskell variable.parameter.haskell
            in  inner_fun x
-- ^^^^^^^^^ meta.haskell.expression meta.function.let-bindings.haskell meta.haskell.expression
--          ^^ meta.haskell.expression meta.function.let-bindings.haskell keyword.other.haskell
--              ^^^^^^^^^ meta.haskell.expression variable.generic
--                        ^ meta.haskell.expression variable.generic

wombats' x = let
                 inner_fun x = x + 1
                 inner_fun' x = x + 2
             in
                 (inner_fun' . inner_fun) x

wombats'' x = let inner_fun x = x + 1
                  inner_fun' x = x + 2
              in  (inner_fun' . inner_fun) x

wombats''' x = inner_fun (inner_fun' x)
  where
    inner_fun x = x + 1
    inner_fun' x = x + 2

foobar x y =
-- ^^^ meta.function.bind_or_sig.haskell entity.name.function.haskell
--     ^ meta.function.bind_or_sig.haskell variable.parameter.haskell
--       ^ meta.function.bind_or_sig.haskell variable.parameter.haskell
--         ^ meta.function.bind_or_sig.haskell meta.haskell.expression keyword.operator.haskell
  let inner_fun = (+ 1) in inner_fun x
-- ^^ meta.haskell.expression meta.function.let-bindings.haskell keyword.other.haskell
--    ^^^^^^^^^ meta.haskell.expression meta.function.let-bindings.haskell meta.function.bind_or_sig.haskell entity.name.function.haskell
--              ^ meta.haskell.expression meta.function.let-bindings.haskell meta.function.bind_or_sig.haskell meta.haskell.expression keyword.operator.haskell
--                ^^ meta.haskell.expression meta.function.let-bindings.haskell meta.haskell.expression meta.expression.parentheses.haskell keyword.operator.haskell
--                   ^ meta.haskell.expression meta.function.let-bindings.haskell meta.haskell.expression meta.expression.parentheses.haskell constant.numeric.haskell
--                      ^^ meta.haskell.expression meta.function.let-bindings.haskell keyword.other.haskell
--                         ^^^^^^^^^ meta.haskell.expression variable.generic
--                                   ^ meta.haskell.expression variable.generic
foobar' x y =
  let inner_fun = (+ 1)
      -- inner function
      inner_fun' = (+ 2) in inner_fun (inner_fun' y) + x
      -- another inner function and the actual expression.
func x = undefined

(>=>) :: Int -> Int -> Real

(==>)
    :: (Monad m) => m Int

f1 x y z l@(x:xs) (LType x) (Rtype y, HType z) Branch ~holder ~holder' ~holder'' 'a' "abc" 'a' = undefined

f2 x
    = error "Help me!?"

b = \a -> a + 1

c = \(x, y) -> (x + 1, y)

d = f3' 'a'

f3 x = ensign x `elem` 4

multi_line_string =
   "This \
    is a multiline \
    string"

_ ==> _ = undefined
-- ^^ meta.function.bind_or_sig.haskell keyword.operator.haskell
--    ^ meta.function.bind_or_sig.haskell variable.parameter.haskell
--      ^ meta.function.bind_or_sig.haskell meta.haskell.expression keyword.operator.haskell
--        ^^^^^^^^^ meta.haskell.expression support.function.prelude.haskell invalid.haskell
_ ->- _ = undefined
-- ^^ meta.function.bind_or_sig.haskell keyword.operator.haskell
--    ^ meta.function.bind_or_sig.haskell variable.parameter.haskell
--      ^ meta.function.bind_or_sig.haskell meta.haskell.expression keyword.operator.haskell
--        ^^^^^^^^^ meta.haskell.expression support.function.prelude.haskell invalid.haskell
x >-> y = undefined
-- ^^ meta.function.bind_or_sig.haskell keyword.operator.haskell
--    ^ meta.function.bind_or_sig.haskell variable.parameter.haskell
--      ^ meta.function.bind_or_sig.haskell meta.haskell.expression keyword.operator.haskell
--        ^^^^^^^^^ meta.haskell.expression support.function.prelude.haskell invalid.haskell

tests :: Config -> Gen Result -> StdGen -> Int -> Int -> [[String]] -> IO ()
tests config gen rnd0 ntest nfail stamps
  | ntest == configMaxTest config = do done "OK, passed" ntest stamps
  | nfail == configMaxFail config = do done "Arguments exhausted after" ntest stamps
  | otherwise               =
      do putStr (configEvery config ntest (arguments result))
         case ok result of
           Nothing    ->
             tests config gen rnd1 ntest (nfail+1) stamps
           Just True  ->
             tests config gen rnd1 (ntest+1) nfail (stamp result:stamps)
           Just False ->
             putStr ( "Falsifiable, after "
                   ++ show ntest
                   ++ " tests:\n"
                   ++ unlines (arguments result)
                    )
     where
      result      = generate (configSize config ntest) rnd2 gen
      (rnd1,rnd2) = split rnd0

guarded_func x
  | a == 0 = undefined
  | b == 3 = undefined


a = 4 :: Int
