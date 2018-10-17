-- Exercises:
--  1) Instead of showing a number, show the die face as an image.
--  2) Instead of showing an image of a die face, use elm/svg to draw it yourself.
--  3) Create a weighted die with Random.weighted.
--  4) Add a second die and have them both roll at the same time.
--  5) Have the dice flip around randomly before they settle on a final value.


module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (src)
import Html.Events exposing (onClick)
import Random


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
    let
        imgSrc =
            "/images/die-" ++ (String.fromInt model.dieFace) ++ ".svg"
    in
        div []
            [ img [ src imgSrc ] []
            , br [] []
            , button [ onClick Roll ] [ text "roll me" ]
            ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
