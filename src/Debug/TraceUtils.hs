{-# OPTIONS -O2 -Wall #-}

-- | This module exposes some useful tracing functions that should
-- have been exported by Debug.Trace.
--
-- Feel free to copy&paste these functions into modules that need
-- them, that may be easier to remove/clean up than adding a cabal
-- dependency.

module Debug.TraceUtils(
    traceId
  , traceIdVia
  , traceAround
  , traceAroundVia
  , tracePutStrLn
  , tracePrint
  , trace
) where

import Debug.Trace(trace)

tracePutStrLn :: Monad m => String -> m ()
tracePutStrLn x = trace x $ return ()

tracePrint :: (Show a, Monad m) => a -> m ()
tracePrint = tracePutStrLn . show

-- | Generate an identity function that has the side-effect of tracing
-- the value that passes through it by first processing it and then
-- showing the result.
--
-- Examples:
--
-- traceIdVia (take 5) \"First 5 sorted elements of: \" result
--
-- fmap (traceIdVia objName \"The object we got\") . receiveObject
traceIdVia :: Show b =>
              (a -> b) -- ^ Function to preprocess the value before showing it
           -> String   -- ^ Prefix string to use before showing the result value
           -> a -> a
traceIdVia via prefix x = trace (prefix ++ ": " ++ show (via x)) x

-- | Generate an identity function that has the side-effect of showing
-- the value that passes through it.
--
-- Examples:
--
-- traceId \"x,y = \" (x, y)
traceId :: Show a =>
           String -- ^ Prefix string to use before showing the value
        -> a -> a
traceId = traceIdVia id

traceAroundVia :: (Show ishow, Show oshow) => (i -> ishow) -> (o -> oshow) -> String -> (i -> o) -> i -> o
traceAroundVia ishow oshow funcName func =
  traceIdVia oshow ("output from " ++ funcName) . func .
  traceIdVia ishow ("input to " ++ funcName)

-- | Convert a pure function to one that also has a side effect of
-- tracing the value of the input and output values that pass through
-- the function.
--
-- Examples:
--
-- traceAround \"filterEntries\" filterEntries entries
traceAround :: (Show i, Show o) => String -> (i -> o) -> i -> o
traceAround = traceAroundVia id id
