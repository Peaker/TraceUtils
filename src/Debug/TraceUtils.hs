{-# OPTIONS -O2 -Wall #-}

-- | This module exposes some useful tracing functions that should
-- have been exported by Debug.Trace.
--
-- Feel free to copy&paste these functions into modules that need
-- them, that may be easier to remove/clean up than adding a cabal
-- dependency.

module Debug.TraceUtils(
  traceId
 ,traceIdVia
 ,traceAround
) where

import Debug.Trace(trace)

-- | Generate an identity function that has the side-effect of tracing
-- the value that passes through it by first processing it and then
-- showing the result.
traceIdVia :: Show b =>
              (a -> b) -- ^ Function to preprocess the value before showing it
           -> String   -- ^ Prefix string to use before showing the result value
           -> a -> a
traceIdVia via prefix x = trace (prefix ++ show (via x)) x

-- | Generate an identity function that has the side-effect of showing
-- the value that passes through it.
traceId :: Show a =>
           String -- ^ Prefix string to use before showing the value
        -> a -> a
traceId = traceIdVia id

-- | Convert a pure function to one that also has a side effect of
-- tracing the value of the input and output values that pass through
-- the function.
traceAround :: (Show i, Show o) => String -> (i -> o) -> i -> o
traceAround funcName func = traceId ("output from " ++ funcName) . func . traceId ("input to " ++ funcName)
