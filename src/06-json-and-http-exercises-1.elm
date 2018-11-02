-- Exercises:
--> 1) Show a message explaining why the image didn't change when you get an Http.Error.
--  2) Allow the user to modify the topic with a text field.
--  3) Allow the user to modify the topic with a drop down menu.
--  4) Try decoding other parts of the JSON received from api.giphy.com


module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode
import Url.Builder as Url


-- MAIN


main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { topic : String
    , url : Maybe String
    , errorMessage : Maybe String
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model "cat" Nothing Nothing, getRandomGif "cat" )



-- UPDATE


type Msg
    = MorePlease
    | NewGif (Result Http.Error String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MorePlease ->
            ( model, getRandomGif model.topic )

        NewGif result ->
            case result of
                Ok newUrl ->
                    ( { model | url = Just newUrl }, Cmd.none )

                Err err ->
                    case err of
                        Http.BadUrl _ ->
                            ( { model | errorMessage = Just "bad url" }, Cmd.none )

                        Http.Timeout ->
                            ( { model | errorMessage = Just "timeout" }, Cmd.none )

                        Http.NetworkError ->
                            ( { model | errorMessage = Just "network error" }, Cmd.none )

                        Http.BadStatus _ ->
                            ( { model | errorMessage = Just "bad status" }, Cmd.none )

                        Http.BadPayload _ _ ->
                            ( { model | errorMessage = Just "bad payload" }, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    let
        imgTag =
            case model.url of
                Nothing ->
                    case model.errorMessage of
                        Nothing ->
                            p [] [ text "loading..." ]

                        Just errorMsg ->
                            p [] [ text errorMsg ]

                Just url ->
                    img [ src url ] []
    in
        div []
            [ h2 []
                [ text model.topic
                ]
            , button [ onClick MorePlease ] [ text "Get a gif Please!" ]
            , br [] []
            , imgTag
            ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- HTTP


getRandomGif : String -> Cmd Msg
getRandomGif topic =
    Http.send NewGif (Http.get (toGiphyUrl topic) gifDecoder)


toGiphyUrl : String -> String
toGiphyUrl topic =
    Url.crossOrigin "https://api.giphy.com"
        [ "v1", "gifs", "random" ]
        [ Url.string "api_key" "dc6zaTOxFJmzC"
        , Url.string "tag" topic
        ]


gifDecoder : Decode.Decoder String
gifDecoder =
    Decode.field "data" (Decode.field "image_url" Decode.string)
