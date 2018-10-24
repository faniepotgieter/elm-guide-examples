-- Exercises:
--  1) Instead of showing a number, show the die face as an image.
--  2) Instead of showing an image of a die face, use elm/svg to draw it yourself.
--  3) Create a weighted die with Random.weighted.
--  4) Add a second die and have them both roll at the same time.
--> 5) Have the dice flip around randomly before they settle on a final value.


module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (src, style)
import Html.Events exposing (onClick)
import Random
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Time


-- MAIN


main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- MODEL


init : () -> ( Model, Cmd Msg )
init () =
    ( { dieFaces = ( One, One ), flipCount = 0 }, Cmd.none )


type alias Model =
    { dieFaces : ( DieFace, DieFace )
    , flipCount : Int
    }


type DieFace
    = One
    | Two
    | Three
    | Four
    | Five
    | Six



-- UPDATE


type Msg
    = Roll
    | NewFaces ( DieFace, DieFace )
    | FlipCountDec
    | FlipCountInit Int


minFlipCount : Int
minFlipCount =
    2


maxFlipCount : Int
maxFlipCount =
    3


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Roll ->
            let
                randomFlipCount =
                    Random.generate FlipCountInit (Random.int minFlipCount maxFlipCount)
            in
                ( model, Cmd.batch [ newFaces, randomFlipCount ] )

        FlipCountInit randomFlipCount ->
            ( { model | flipCount = randomFlipCount }, Cmd.none )

        FlipCountDec ->
            ( { model | flipCount = model.flipCount - 1 }, newFaces )

        NewFaces updatedFaces ->
            ( { model | dieFaces = updatedFaces }, Cmd.none )


newFaces : Cmd Msg
newFaces =
    Random.generate NewFaces newFacesGenerator


newFacesGenerator : Random.Generator ( DieFace, DieFace )
newFacesGenerator =
    Random.pair dieFaceGenerator dieFaceGenerator


dieFaceGenerator : Random.Generator DieFace
dieFaceGenerator =
    Random.weighted
        ( 10, One )
        [ ( 10, Two )
        , ( 10, Three )
        , ( 10, Four )
        , ( 20, Five )
        , ( 40, Six )
        ]



-- VIEW


view : Model -> Html Msg
view model =
    let
        ( d1, d2 ) =
            model.dieFaces
    in
        div []
            [ dieFaceSvg d1
            , dieFaceSvg d2
            , br [] []
            , button [ onClick Roll ] [ Html.text "roll me" ]
            ]


dieFaceSvg : DieFace -> Svg Msg
dieFaceSvg dieFace =
    case dieFace of
        One ->
            viewDieFace1

        Two ->
            viewDieFace2

        Three ->
            viewDieFace3

        Four ->
            viewDieFace4

        Five ->
            viewDieFace5

        Six ->
            viewDieFace6


viewDieFace1 : Svg Msg
viewDieFace1 =
    svg [ width "120", height "100", viewBox "0 0 100 100" ]
        [ rect [ fill "#eee", x "0", y "0", width "100", height "100", rx "5", ry "5" ] []
        , circle [ r "10", cx "50", cy "50" ] []
        ]


viewDieFace2 : Svg Msg
viewDieFace2 =
    svg [ width "120", height "100", viewBox "0 0 100 100" ]
        [ rect [ fill "#eee", x "0", y "0", width "100", height "100", rx "5", ry "5" ] []
        , circle [ r "10", cx "25", cy "80" ] []
        , circle [ r "10", cx "75", cy "20" ] []
        ]


viewDieFace3 : Svg Msg
viewDieFace3 =
    svg [ width "120", height "100", viewBox "0 0 100 100" ]
        [ rect [ fill "#eee", x "0", y "0", width "100", height "100", rx "5", ry "5" ] []
        , circle [ r "10", cx "25", cy "80" ] []
        , circle [ r "10", cx "50", cy "50" ] []
        , circle [ r "10", cx "75", cy "20" ] []
        ]


viewDieFace4 : Svg Msg
viewDieFace4 =
    svg [ width "120", height "100", viewBox "0 0 100 100" ]
        [ rect [ fill "#eee", x "0", y "0", width "100", height "100", rx "5", ry "5" ] []
        , circle [ r "10", cx "25", cy "20" ] []
        , circle [ r "10", cx "25", cy "80" ] []
        , circle [ r "10", cx "75", cy "20" ] []
        , circle [ r "10", cx "75", cy "80" ] []
        ]


viewDieFace5 : Svg Msg
viewDieFace5 =
    svg [ width "120", height "100", viewBox "0 0 100 100" ]
        [ rect [ fill "#eee", x "0", y "0", width "100", height "100", rx "5", ry "5" ] []
        , circle [ r "10", cx "25", cy "20" ] []
        , circle [ r "10", cx "25", cy "80" ] []
        , circle [ r "10", cx "50", cy "50" ] []
        , circle [ r "10", cx "75", cy "20" ] []
        , circle [ r "10", cx "75", cy "80" ] []
        ]


viewDieFace6 : Svg Msg
viewDieFace6 =
    svg [ width "120", height "100", viewBox "0 0 100 100" ]
        [ rect [ fill "#eee", x "0", y "0", width "100", height "100", rx "5", ry "5" ] []
        , circle [ r "10", cx "25", cy "20" ] []
        , circle [ r "10", cx "25", cy "50" ] []
        , circle [ r "10", cx "25", cy "80" ] []
        , circle [ r "10", cx "75", cy "20" ] []
        , circle [ r "10", cx "75", cy "50" ] []
        , circle [ r "10", cx "75", cy "80" ] []
        ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    if model.flipCount > 0 then
        Time.every 300 (always FlipCountDec)
    else
        Sub.none
