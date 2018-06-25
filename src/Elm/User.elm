module User exposing (..)


type alias User =
    { uid : String
    , name : String
    , iconUrl : Maybe String
    }


anonymousIcon : String
anonymousIcon =
    "https://vignette.wikia.nocookie.net/logopedia/images/c/c3/Question-mark-logo-icon-76440.png/revision/latest?cb=20171120182312"