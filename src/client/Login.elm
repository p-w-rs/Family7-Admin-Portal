port module Login exposing (main)

import Browser
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html exposing (Html)
import Html.Events
import Http
import Json.Decode as Decode
import Json.Encode as Encode



-- MAIN


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }



-- MODEL


type alias Model =
    { email : String
    , password : String
    , errorMessage : Maybe String
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { email = ""
      , password = ""
      , errorMessage = Nothing
      }
    , Cmd.none
    )



-- UDATE FUNCTIONS


port redirectToUrl : String -> Cmd msg


sendCredentials : String -> String -> Cmd Msg
sendCredentials email password =
    let
        body =
            Encode.object
                [ ( "email", Encode.string email )
                , ( "password", Encode.string password )
                ]

        request =
            Http.post
                { url = "/api/login"
                , body = Http.jsonBody body
                , expect = Http.expectString LoginResponse
                }
    in
    request



-- UPDATE


type Msg
    = UpdateEmail String
    | UpdatePassword String
    | Submit
    | LoginResponse (Result Http.Error String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateEmail email ->
            ( { model | email = email }, Cmd.none )

        UpdatePassword password ->
            ( { model | password = password }, Cmd.none )

        Submit ->
            ( model, sendCredentials model.email model.password )

        LoginResponse (Ok _) ->
            ( model, redirectToUrl "/home" )

        LoginResponse (Err _) ->
            ( { model | errorMessage = Just "Invalid credentials. Please contact IT admin if this issue persists." }, Cmd.none )



-- VIEW


onEnter : msg -> Element.Attribute msg
onEnter msg =
    Element.htmlAttribute
        (Html.Events.on "keyup"
            (Decode.field "key" Decode.string
                |> Decode.andThen
                    (\key ->
                        if key == "Enter" then
                            Decode.succeed msg

                        else
                            Decode.fail "Not the enter key"
                    )
            )
        )


view : Model -> Html Msg
view model =
    let
        formWidth =
            px 300

        -- Fixed width for form components
        buttonColor =
            rgb255 69 129 142

        hoverColor =
            rgb255 16 31 34

        -- A color inspired by the logo for the button
    in
    layout [ Background.color (rgb255 240 240 240), centerX, centerY ] <|
        column [ centerX, centerY, spacing 20, padding 20 ]
            [ link
                [ centerX, centerY, width formWidth, height (px 100), pointer ]
                { url = "https://www.family7foundations.com"
                , label = image [ width formWidth, pointer ] { src = "/assets/f7f_logo.png", description = "Family 7 Foundations Logo" }
                }
            , Input.email
                [ centerX, centerY, width formWidth, padding 10, Border.rounded 5, Font.size 18, onEnter Submit ]
                { onChange = UpdateEmail
                , text = model.email
                , placeholder = Just <| Input.placeholder [] (text "Enter your F7F email")
                , label = Input.labelAbove [] (text "Email")
                }
            , Input.currentPassword
                [ centerX, centerY, width formWidth, padding 10, Border.rounded 5, Font.size 18, onEnter Submit ]
                { onChange = UpdatePassword
                , text = model.password
                , placeholder = Just <| Input.placeholder [] (text "Enter your password")
                , label = Input.labelAbove [] (text "Password")
                , show = False
                }
            , Input.button
                [ centerX, centerY, width (px 200), padding 10, Background.color buttonColor, Border.rounded 5, mouseOver [ Background.color hoverColor ] ]
                { onPress = Just Submit
                , label = el [ width fill, Font.center, Font.size 18, Font.color (rgb255 255 255 255) ] (text "Login")
                }
            , case model.errorMessage of
                Just errorMessage ->
                    el [ centerX, Font.center, Font.color (rgb255 255 0 0), Font.size 18, padding 5 ] (text errorMessage)

                Nothing ->
                    none
            ]
