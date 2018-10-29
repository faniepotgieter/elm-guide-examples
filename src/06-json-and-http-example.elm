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
    , url : String
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model "cat" "...", getRandomGif "cat" )



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
                    ( { model | url = newUrl }, Cmd.none )

                Err _ ->
                    ( model, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    let
        imgTag =
            if model.url == "..." then
                p [] [ text "loading..." ]
            else
                img [ src model.url ] []
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
