module Main exposing (..)

import Browser
import Html exposing (Html, form, label, input, div, p, text)
import Html.Attributes exposing (style, class, value, placeholder, type_)
import Html.Events exposing (onInput)


-- MAIN


main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }



-- MODEL


type alias Model =
    { name : String
    , password : String
    , confirm : String
    }


init : Model
init =
    { name = ""
    , password = ""
    , confirm = ""
    }



-- UPDATE


type Msg
    = NameChange String
    | PasswordChange String
    | ConfirmChange String


update : Msg -> Model -> Model
update msg model =
    case msg of
        NameChange newName ->
            { model | name = newName }

        PasswordChange newPassword ->
            { model | password = newPassword }

        ConfirmChange newConfirm ->
            { model | confirm = newConfirm }



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ form []
            [ viewInputItem "text" model.name "name" NameChange
            , viewInputItem "password" model.password "password" PasswordChange
            , viewInputItem "password" model.confirm "confirm" ConfirmChange
            ]
        , p [] [ text ("name: " ++ model.name) ]
        , p [] [ text ("password: " ++ model.password) ]
        , p [] [ text ("confirm password: " ++ model.confirm) ]
        , viewValidation model.password model.confirm
        ]


viewInputItem t v p toMsg =
    input [ type_ t, value v, placeholder p, onInput toMsg ] []


viewValidation : String -> String -> Html Msg
viewValidation password confirm =
    if password == "" || confirm == "" then
        p [ style "color" "red" ] [ text "Please enter a password and confirmation" ]
    else if password /= confirm then
        p [ style "color" "red" ] [ text "Passwords do not match!" ]
    else
        p
            [ style "color" "green" ]
            [ text "Passwords match. Thanks!" ]
