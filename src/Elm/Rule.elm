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


rule2String : String -> Maybe Rule
rule2String str =
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
        |> JD.map rule2String
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
    JD.map2 (,) ruleDecoder JD.int


ruleSetEncoder : RuleSet -> JE.Value
ruleSetEncoder ruleSet =
    let
        fst =
            Tuple.first ruleSet

        snd =
            Tuple.second ruleSet
    in
        JE.list [ ruleEncoder fst, JE.int snd ]
