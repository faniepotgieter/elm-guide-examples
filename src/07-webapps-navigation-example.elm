module Main exposing (..)

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Url


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = LinkClicked
        , onUrlChange = UrlChanged
        }



-- MODEL


type alias Model =
    { url : Url.Url
    , key : Nav.Key
    }


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    ( Model url key, Cmd.none )



-- UPDATE


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged newUrl ->
            ( { model | url = newUrl }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Browser.Document Msg
view model =
    { title = "Webapps Navigation Example"
    , body =
        [ p [] [ text ("the url is: " ++ Url.toString model.url) ]
        , ul []
            [ viewLink "/home"
            , viewLink "/about"
            , viewLink "/contact"
            ]
        ]
    }


viewLink : String -> Html Msg
viewLink txt =
    li [] [ a [ href txt ] [ text txt ] ]
