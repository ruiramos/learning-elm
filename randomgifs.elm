import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Task
import Http
import Json.Decode as Json

main = 
  Html.program 
  { init = init
  , view = view
  , update = update
  , subscriptions = subscriptions
  }

-- MODEL
type alias Model = 
  { topic: String
  , currentTopic: String
  , gifUrl: String
  , error: String
  }

-- UPDATE
type Msg 
  = GetImage
  | FetchSucceed String
  | FetchFail Http.Error
  | SetTopic String
  | SetTopicAndGet String

update: Msg -> Model -> (Model, Cmd Msg)
update msg model = 
  case msg of
    GetImage -> 
      (model, getRandomGif model.topic)

    FetchSucceed newUrl ->
      ({ model | currentTopic = model.topic, gifUrl = newUrl }, Cmd.none)

    FetchFail _ ->
      ({model | topic = model.currentTopic, error = "BODE"}, Cmd.none)

    SetTopic topic ->
      ({model | topic = topic }, Cmd.none)

    SetTopicAndGet topic ->
      ({model | topic = topic}, getRandomGif topic)

getRandomGif: String -> Cmd Msg
getRandomGif topic = 
  let
      url = 
        "http://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=" ++ topic
  in
     Task.perform FetchFail FetchSucceed (Http.get decodeGifUrl url)

decodeGifUrl: Json.Decoder String
decodeGifUrl = 
  Json.at ["data", "image_url"] Json.string


-- VIEW
view: Model -> Html Msg
view model = 
  div []
  [ h1 [] [ text ( "hello gifs about " ++ model.currentTopic) ]
  , img [ src model.gifUrl] []
  , div [] 
    [ label [] [ text "Topic is:" ] 
    , input [ value model.topic, onInput SetTopic ] []
    , select [ onChange  SetTopicAndGet ] 
      [ option [ value "cats" ] [ text "Cats" ]
      , option [ value "dogs" ] [ text "Dogs" ]
      , option [ value "people" ] [ text "People" ]
      ]
    ]
  , button [ onClick (GetImage), style [("display", "block")] ] [ text "Get more!" ]
  , p [] [ text model.error ]
  ]

onChange: (String -> Msg) -> Attribute Msg
onChange target =
  on "change" (Json.map target targetValue)

-- SUBSCRIPTIONS
subscriptions: Model -> Sub Msg
subscriptions model =
  Sub.none

init: (Model, Cmd Msg)
init = 
  (Model "cats" "" "" "", getRandomGif "cats") 
