module Debug.TraceUtils.Dont(
    traceId
  , traceIdVia
  , traceAround
  , tracePutStrLn
  , tracePrint
  , trace
) where

tracePutStrLn :: Monad m => String -> m ()
tracePutStrLn = const $ return ()

tracePrint :: (Show a, Monad m) => a -> m ()
tracePrint = const $ return ()

traceIdVia :: Show b => (a -> b) -> String -> a -> a
traceIdVia = const $ const id

traceId :: Show a => String -> a -> a
traceId = const id

traceAround :: (Show i, Show o) => String -> (i -> o) -> i -> o
traceAround = const id

trace :: String -> a -> a
trace = const id
