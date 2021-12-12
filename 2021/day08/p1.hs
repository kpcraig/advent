{-# LANGUAGE OverloadedStrings #-}

import Data.Text.IO (readFile)
import Data.Text (splitOn, unpack, Text)
import Data.List (sort)
-- import Data.Text.Conversions (convertText, convertString)

main :: IO ()
main = do
    d <- Data.Text.IO.readFile "input" 
    let dat = [(a, b) | [a,b] <- map (splitOn " | ") (splitOn "\n" d)]

    let dat2 = length (concat [second | (_, second) <- map splitSort dat])
    print dat2

splitSort :: (Text, Text) -> ([String], [Int])
splitSort (a, b) = do
    -- let test = sort (splitOn " " a)
    (map (sort . unpack) (splitOn " " a), [x | x <- map (length . sort . unpack) (splitOn " " b), x `elem` [2,4,3,7]])
