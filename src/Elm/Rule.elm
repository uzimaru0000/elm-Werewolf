module Rule exposing (..)

import Json.Decode as JD
import Json.Encode as JE
import Tuple


type Rule
    = Villager
    | Werewolf
    | Seer
    | Hunter
    | Madman
    | Psychic


type alias RuleSet =
    ( Rule, Int )


ruleIcon : Rule -> String
ruleIcon rule =
    case rule of
        Villager ->
            "fas fa-male"

        Werewolf ->
            "fab fa-wolf-pack-battalion"

        Seer ->
            "fas fa-magic"

        Hunter ->
            "fas fa-user-shield"

        Madman ->
            "fas fa-skull"

        Psychic ->
            "fas fa-star"


stringToRule : String -> Maybe Rule
stringToRule str =
    case str of
        "Villager" ->
            Just Villager

        "Werewolf" ->
            Just Werewolf

        "Seer" ->
            Just Seer

        "Hunter" ->
            Just Hunter

        "Madman" ->
            Just Madman

        "Psychic" ->
            Just Psychic

        _ ->
            Nothing


ruleDecoder : JD.Decoder Rule
ruleDecoder =
    JD.string
        |> JD.map stringToRule
        |> JD.andThen
            (\x ->
                case x of
                    Just a ->
                        JD.succeed a

                    Nothing ->
                        JD.fail "Decode fail"
            )


ruleEncoder : Rule -> JE.Value
ruleEncoder rule =
    rule
        |> toString
        |> JE.string


ruleSetDecoder : JD.Decoder RuleSet
ruleSetDecoder =
    JD.map2 (,) (JD.index 0 ruleDecoder) (JD.index 1 JD.int)


ruleSetEncoder : RuleSet -> JE.Value
ruleSetEncoder ruleSet =
    let
        fst =
            Tuple.first ruleSet

        snd =
            Tuple.second ruleSet
    in
        JE.list [ ruleEncoder fst, JE.int snd ]
