import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Time exposing (Time, second)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import String exposing (..)

main = 
  Html.program 
  { init = init
  , view = view 
  , update = update 
  , subscriptions = subscriptions
  }

-- MODEL
type alias Model = 
  { time: Time
  , paused: Bool
  }

init: (Model, Cmd Msg)
init =
  (Model 0 False, Cmd.none)

-- UPDATE
type Msg 
  = Tick Time
  | Toggle

update: Msg -> Model -> (Model, Cmd Msg)
update msg model = 
  case msg of
    Tick time -> ({model | time = if model.paused then model.time else time}, Cmd.none)
    Toggle -> ({model | paused = not model.paused}, Cmd.none)

-- VIEW
view: Model -> Html Msg
view model = 
  let 
      secAngle =
        turns (Time.inMinutes model.time)

      secX =
        toString (50 + 40 * sin secAngle)

      secY =
        toString (50 - 40 * cos secAngle)

      minAngle =
        turns (Time.inHours model.time)

      minX = 
        toString (50 + 35 * sin minAngle)

      minY =
        toString (50 - 35 * cos minAngle)

      hourAngle =
        turns (model.time / Time.hour / 3) 
        -- no idea why this works its probably wrong

      hourX
        = toString (50 + 25 * sin hourAngle)

      hourY 
        = toString (50 - 25 * cos hourAngle)

  in
    div [] 
      [ p [] [ Html.text "the clock: "]
      , Svg.svg [ viewBox "0 0 100 100", Svg.Attributes.width "300px"  ]
        [ circle [ cx "50", cy "50", r "45", fill "#343434" ] []
        , line [ x1 "50", y1 "50", x2 secX, y2 secY, stroke "#676767" ] []
        , line [ x1 "50", y1 "50", x2 minX, y2 minY, stroke "#464646" ] []
        , line [ x1 "50", y1 "50", x2 hourX, y2 hourY, stroke "#000" ] []
        ]
      , button [ onClick Toggle ] [ Html.text (if model.paused then "Resume" else "Pause") ]
      , p [] [ "Time is " ++ (displayTime model.time) |> Html.text ]
      ]

displayTime: Time -> String
displayTime time = 
  List.map (\f -> toString(f time)) [Time.inHours, Time.inMinutes, Time.inSeconds]
    |> String.join ", "

-- SUBSCRIPTIONS
subscriptions: Model -> Sub Msg
subscriptions model =
  Time.every second Tick

