module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onSubmit)


-- MAIN


main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }



-- MODEL


type alias FormValidation =
    ( String, String, Bool )


type alias Model =
    { name : String
    , age : Int
    , password : String
    , confirm : String
    , validation : FormValidation
    }


init : Model
init =
    { name = ""
    , age = 0
    , password = ""
    , confirm = ""
    , validation = ( "black", "Please complete the form, so we can sell your information to the highest bidder", False )
    }



-- UPDATE


type Msg
    = NameChange String
    | AgeChange String
    | PasswordChange String
    | ConfirmChange String
    | HandleSubmit


update : Msg -> Model -> Model
update msg model =
    case msg of
        NameChange newName ->
            { model | name = newName }

        AgeChange newAge ->
            { model | age = Maybe.withDefault 0 (String.toInt newAge) }

        PasswordChange newPassword ->
            { model | password = newPassword }

        ConfirmChange newConfirm ->
            { model | confirm = newConfirm }

        HandleSubmit ->
            { model | validation = validate model }


validate : Model -> FormValidation
validate { name, password, confirm, age } =
    if name == "" then
        ( "red", "Please enter your name", False )
    else if age == 0 then
        ( "red", "Please enter your age", False )
    else if password == "" || confirm == "" then
        ( "red", "Please enter a password and confirmation", False )
    else if password /= confirm then
        ( "red", "Passwords do not match!", False )
    else if String.length password < 9 then
        ( "red", "The password must be longer than 8 characters.", False )
    else if not (String.any Char.isDigit password) then
        ( "red", "The password must contain a numeric character.", False )
    else if not (String.any Char.isUpper password) then
        ( "red", "The password must contain an uppercase character.", False )
    else if not (String.any Char.isLower password) then
        ( "red", "The password must contain a lowercase character.", False )
    else
        ( "green", "Thanks for submitting your details!", True )



-- VIEW


view : Model -> Html Msg
view model =
    let
        ( color, message, validationStatus ) =
            model.validation

        validationStatusMessage =
            if validationStatus == True then
                "Congratulations. The form can be submitted."
            else
                "The information is not valid yet, and we can't submit the form at this stage"
    in
        div []
            [ Html.form [ onSubmit HandleSubmit ]
                [ viewInputItem "text" model.name "name" NameChange
                , viewInputItem "text" (String.fromInt model.age) "age" AgeChange
                , viewInputItem "password" model.password "password" PasswordChange
                , viewInputItem "password" model.confirm "confirm" ConfirmChange
                , button [ type_ "submit" ] [ text "submit" ]
                ]
            , p [ style "color" color ] [ text message ]
            , hr [] []
            , h6 [] [ text ("Form Validation Status: " ++ validationStatusMessage) ]
            ]


viewInputItem t v p toMsg =
    input [ type_ t, value v, placeholder p, onInput toMsg ] []
