-- Exercises:
--  1) Show a message explaining why the image didn't change when you get an Http.Error.
--  2) Allow the user to modify the topic with a text field.
--  3) Allow the user to modify the topic with a drop down menu.
--> 4) Try decoding other parts of the JSON received from api.giphy.com


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
    , apiResponse : ApiResponse
    }


type alias ApiResponse =
    { url : String
    , responseId : String
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model "cat" { url = "...", responseId = "..." }, getRandomGif "cat" )



-- UPDATE


type Msg
    = MorePlease
    | NewGif (Result Http.Error ApiResponse)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MorePlease ->
            ( model, getRandomGif model.topic )

        NewGif result ->
            case result of
                Ok newResponse ->
                    ( { model | apiResponse = newResponse }, Cmd.none )

                Err _ ->
                    ( model, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    let
        imgTag =
            if model.apiResponse.url == "..." then
                p [] [ text "loading..." ]
            else
                img [ src model.apiResponse.url ] []
    in
        div []
            [ h2 []
                [ text model.topic
                ]
            , button [ onClick MorePlease ] [ text "Get a gif Please!" ]
            , br [] []
            , imgTag
            , p [] [ text ("response url: " ++ model.apiResponse.url) ]
            , p [] [ text ("response id: " ++ model.apiResponse.responseId) ]
            ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- HTTP


getRandomGif : String -> Cmd Msg
getRandomGif topic =
    Http.send NewGif (Http.get (toGiphyUrl topic) apiResponseDecoder)


toGiphyUrl : String -> String
toGiphyUrl topic =
    Url.crossOrigin "https://api.giphy.com"
        [ "v1", "gifs", "random" ]
        [ Url.string "api_key" "dc6zaTOxFJmzC"
        , Url.string "tag" topic
        ]


apiResponseDecoder =
    Decode.map2 ApiResponse gifDecoder responseIdDecoder


gifDecoder : Decode.Decoder String
gifDecoder =
    Decode.field "data" (Decode.field "image_url" Decode.string)


responseIdDecoder : Decode.Decoder String
responseIdDecoder =
    Decode.at [ "meta", "response_id" ] Decode.string
