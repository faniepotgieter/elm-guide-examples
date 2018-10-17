module Main exposing (..)

import Browser
import Html exposing (..)
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
    div []
        [ h1 [] [ text (String.fromInt model.dieFace) ]
        , button [ onClick Roll ] [ text "roll me" ]
        ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
