import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Random

main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }
    
-- MODEL
type alias Model = 
  { face: Int
  , face2: Int
  }

-- UPDATE
type Msg =
  Roll | NewFace Int | NewFace2 Int 

update: Msg -> Model -> (Model, Cmd Msg)
update msg model = 
  case msg of
    NewFace newFace ->
      ({model | face = newFace}, Cmd.none)
    NewFace2 newFace ->
      ({model | face2 = newFace}, Cmd.none)
    Roll ->
      (model, Cmd.batch [
        Random.generate NewFace (Random.int 1 6)
        , Random.generate NewFace2 (Random.int 1 6)
      ])

-- VIEW
view: Model -> Html Msg
view model = 
  div [] 
    [ getDiceHtml model.face "first"
    , getDiceHtml model.face2 "second"
    , button [ onClick Roll ] [ text "Roll" ]
  ]

getDiceHtml: Int -> String -> Html Msg
getDiceHtml face name =
  div []
    [ h1 [] [ text ("The " ++ name ++ " dice") ]
    , p [] [ text ( "My face is " ++ toString face )]
    , img [ src (getImageFilename face) ] []
  ]

getImageFilename: Int -> String
getImageFilename face =
  "http://ptgmedia.pearsoncmg.com/images/chap3_0789735229/elementLinks/" ++ (numberToEnglishString face) ++ ".jpg"

numberToEnglishString: Int -> String
numberToEnglishString n = 
  case n of
    1 -> "one"
    2 -> "two"
    3 -> "three"
    4 -> "four"
    5 -> "five"
    6 -> "six"
    _ -> "too big"

-- SUBSCRIPTIONS
subscriptions: Model -> Sub Msg
subscriptions model =
  Sub.none

init: (Model, Cmd Msg)
init = (Model 1 1, Cmd.batch [
  Random.generate NewFace (Random.int 1 6)
  , Random.generate NewFace2 (Random.int 1 6)
  ])
