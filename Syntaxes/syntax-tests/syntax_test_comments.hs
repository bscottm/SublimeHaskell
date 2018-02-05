-- SYNTAX TEST "Packages/SublimeHaskell/Syntaxes/Haskell-SublimeHaskell.sublime-syntax"
{-# LANGUAGE GADTs #-}
--  ^^^^^^^^ keyword.preprocessor.haskell
--           ^^^^^ keyword.other.preprocessor.haskell
-- <-comment.pragma.haskell
{-# OPTIONS_GHC -O2 #-}
-- <-comment.pragma.haskell

{- This is an interior comment.
 -- with a double dash comment embedded. {- and a comment within a comment
 -}-}
-- <- comment.block.haskell


-- Multiline comments with pragmas in the middle:
{-
{-# INLINE foo #-}
foo :: Int -> Int
foo x = x
     -}
--   ^^ comment.block.haskell
