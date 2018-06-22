module Rule exposing (..)


type Rule
    = Villager
    | Werewolf
    | Seer
    | Hunter
    | Madman
    | Psychic


type alias RuleSet =
    ( Rule, Int )
