module Main exposing (..)

import Browser
import Time
import Task
import Html exposing (..)


-- MAIN


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { time : Time.Posix
    , zone : Time.Zone
    }


init : () -> ( Model, Cmd Msg )
init _ =
    let
        initTime =
            Time.millisToPosix 0

        initZone =
            Time.utc

        initTimeCmd =
            Task.perform Tick Time.now

        initZoneCmd =
            Task.perform AdjustTimeZone Time.here
    in
        ( Model initTime initZone
        , Cmd.batch [ initTimeCmd, initZoneCmd ]
        )



-- UPDATE


type Msg
    = Tick Time.Posix
    | AdjustTimeZone Time.Zone


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick newTime ->
            ( { model | time = newTime }, Cmd.none )

        AdjustTimeZone newZone ->
            ( { model | zone = newZone }, Cmd.none )



-- VIEW


formatTimeUnit : Int -> String
formatTimeUnit unit =
    if unit < 10 then
        "0" ++ String.fromInt unit
    else
        String.fromInt unit


view : Model -> Html Msg
view model =
    let
        hour =
            formatTimeUnit (Time.toHour model.zone model.time)

        minute =
            formatTimeUnit (Time.toMinute model.zone model.time)

        second =
            formatTimeUnit (Time.toSecond model.zone model.time)
    in
        h1 []
            [ text (hour ++ ":" ++ minute ++ ":" ++ second)
            ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every 1000 Tick
