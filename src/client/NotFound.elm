module NotFound exposing (main)

import Browser
import Browser.Events exposing (onResize)
import Browser.Navigation as Nav
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Html exposing (Html)
import Url



-- MAIN


main : Program Flags Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }



-- MODEL


type alias Flags =
    { width : Int
    , height : Int
    }


type alias Model =
    { key : Nav.Key
    , url : Url.Url
    , device : Device
    }


init : Flags -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    ( Model key url (classifyDevice flags)
    , Cmd.none
    )



-- UPDATE


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | DeviceClassified Device


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged url ->
            ( { model | url = url }
            , Cmd.none
            )

        DeviceClassified device ->
            ( { model | device = device }
            , Cmd.none
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    onResize <|
        \width height ->
            DeviceClassified (classifyDevice { width = width, height = height })



-- VIEW


view : Model -> Browser.Document Msg
view _ =
    { title = "Family 7 Foundations"
    , body =
        [ layout [ Background.color (rgb255 240 240 240), centerX, centerY ] <|
            column [ centerX, centerY, spacing 20, padding 20 ]
                [ el [ centerX, Font.size 36, Font.bold, Font.color (rgb255 50 50 50), padding 10 ] <| text "404 - Page Not Found"
                , el [ centerX, Font.size 18, Font.color (rgb255 80 80 80), padding 10 ] <| text "The page you're looking for might have been removed, had its name changed, or is temporarily unavailable."
                , el [ centerX, padding 10 ] <|
                    Element.link
                        [ Font.size 18
                        , Font.color (rgb255 69 129 142)
                        , Border.rounded 5
                        , padding 10
                        , Background.color (rgb255 240 240 240)
                        ]
                        { url = "/home"
                        , label = text "Return to Home"
                        }
                ]
        ]
    }
