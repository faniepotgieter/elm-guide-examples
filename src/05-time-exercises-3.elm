-- Exercises:
--  1) Add a button to pause the clock, turning the Time.every subscription off.
--  2) Make the digital clock look nicer. Maybe add some style attributes.
--> 3) Use elm/svg to make an analog clock with a red second hand!


module Main exposing (..)

import Browser
import Time
import Task
import Html exposing (..)
import Html.Attributes as HtmlAttrs exposing (style)
import Html.Events exposing (onClick)
import Svg exposing (..)
import Svg.Attributes exposing (..)


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


type ClockHandType
    = Hours
    | Minutes
    | Seconds


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
            Time.toHour model.zone model.time

        minute =
            Time.toMinute model.zone model.time

        second =
            Time.toSecond model.zone model.time

        formattedHour =
            formatTimeUnit hour

        formattedMinute =
            formatTimeUnit minute

        formattedSecond =
            formatTimeUnit second

        buttonText =
            if model.paused == True then
                "start clock"
            else
                "stop clock"
    in
        div
            [ HtmlAttrs.style "color" "#333"
            , HtmlAttrs.style "margin" "2vh 2vw"
            , HtmlAttrs.style "font-family" "sans-serif"
            ]
            [ h1 []
                [ Html.text (formattedHour ++ ":" ++ formattedMinute ++ ":" ++ formattedSecond)
                ]
            , button
                [ onClick TogglePause
                , HtmlAttrs.style "display" "block"
                , HtmlAttrs.style "border" "1px solid #333"
                , HtmlAttrs.style "padding" "0.5rem 1rem"
                , HtmlAttrs.style "border-radius" "4px"
                , HtmlAttrs.style "background" "transparent"
                , HtmlAttrs.style "outline" "none"
                , HtmlAttrs.style "font-size" "1.2rem"
                ]
                [ Html.text buttonText ]
            , div [ HtmlAttrs.style "margin-top" "1rem" ]
                [ viewClock hour minute second ]
            ]


viewClock : Int -> Int -> Int -> Svg Msg
viewClock hour minute second =
    svg
        [ width "100"
        , height "100"
        , viewBox "0 0 100 100"
        ]
        [ circle [ cx "50", cy "50", r "50", fill "#efefef" ] []
        , viewClockHand hour "#222" Hours
        , viewClockHand minute "#666" Minutes
        , viewClockHand second "#AAA" Seconds
        ]


viewClockHand : Int -> String -> ClockHandType -> Svg Msg
viewClockHand timeUnits color handType =
    let
        sliceAngle =
            case handType of
                Hours ->
                    -- 360deg / 12 hours,
                    30

                Minutes ->
                    -- 360deg / 60 minutes
                    6

                Seconds ->
                    -- 360deg / 60 seconds
                    6

        handLength =
            case handType of
                Hours ->
                    30

                Minutes ->
                    40

                Seconds ->
                    45

        angleDegrees =
            -- 90 is to move the arm 90deg anti-clocks
            (toFloat timeUnits) * sliceAngle - 90

        angleRadians =
            degrees angleDegrees

        offset =
            50

        handX =
            offset + handLength * cos angleRadians

        handY =
            offset + handLength * sin angleRadians
    in
        line [ x1 "50", y1 "50", x2 (String.fromFloat handX), y2 (String.fromFloat handY), stroke color ] []



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    if model.paused == True then
        Sub.none
    else
        Time.every 1000 Tick
