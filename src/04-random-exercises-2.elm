-- Exercises:
--  1) Instead of showing a number, show the die face as an image.
--> 2) Instead of showing an image of a die face, use elm/svg to draw it yourself.
--  3) Create a weighted die with Random.weighted.
--  4) Add a second die and have them both roll at the same time.
--  5) Have the dice flip around randomly before they settle on a final value.


module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (src, style)
import Html.Events exposing (onClick)
import Random
import Svg exposing (..)
import Svg.Attributes exposing (..)


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
    ( { dieFace = 1 }, Cmd.none )


type alias Model =
    { dieFace : Int
    }



-- UPDATE


type Msg
    = Roll
    | NewFace Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Roll ->
            ( model, Random.generate NewFace (Random.int 1 6) )

        NewFace newFace ->
            ( { model | dieFace = newFace }, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ dieFaceSvg model.dieFace
        , br [] []
        , button [ onClick Roll ] [ Html.text "roll me" ]
        ]


dieFaceSvg : Int -> Svg Msg
dieFaceSvg dieFace =
    if dieFace == 1 then
        viewDieFace1
    else if dieFace == 2 then
        viewDieFace2
    else if dieFace == 3 then
        viewDieFace3
    else if dieFace == 4 then
        viewDieFace4
    else if dieFace == 5 then
        viewDieFace5
    else
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
    Sub.none
