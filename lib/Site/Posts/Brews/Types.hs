{-# LANGUAGE GADTs          #-}
{-# LANGUAGE KindSignatures #-}

module Site.Posts.Brews.Types
  (
    Component(..),
    Unit(..),
    WaterProfile
  )
where

type WaterProfile = [Component] -- Could be a hair more specific, but eh

data Component :: * where
  Component    :: Int -> Unit -> Component
  deriving (Eq, Ord, Read, Show)

newtype Unit = Unit String deriving (Eq, Ord, Read, Show)
