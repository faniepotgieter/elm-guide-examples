-- Exercises:
--  1) Add a button to pause the clock, turning the Time.every subscription off.
--> 2) Make the digital clock look nicer. Maybe add some style attributes.
--  3) Use elm/svg to make an analog clock with a red second hand!


module Main exposing (..)

import Browser
import Time
import Task
import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)


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
    , paused : Bool
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
        ( Model initTime initZone False
        , Cmd.batch [ initTimeCmd, initZoneCmd ]
        )



-- UPDATE


type Msg
    = Tick Time.Posix
    | AdjustTimeZone Time.Zone
    | TogglePause


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick newTime ->
            ( { model | time = newTime }, Cmd.none )

        AdjustTimeZone newZone ->
            ( { model | zone = newZone }, Cmd.none )

        TogglePause ->
            ( { model | paused = not model.paused }, Cmd.none )



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

        buttonText =
            if model.paused == True then
                "start clock"
            else
                "stop clock"
    in
        div
            [ style "color" "#333"
            , style "margin" "2vh 2vw"
            , style "font-family" "sans-serif"
            ]
            [ h1 []
                [ text (hour ++ ":" ++ minute ++ ":" ++ second)
                ]
            , button
                [ onClick TogglePause
                , style "border" "1px solid #333"
                , style "padding" "0.5rem 1rem"
                , style "border-radius" "4px"
                , style "background" "transparent"
                , style "outline" "none"
                , style "font-size" "1.2rem"
                ]
                [ text buttonText ]
            ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    if model.paused == True then
        Sub.none
    else
        Time.every 1000 Tick
