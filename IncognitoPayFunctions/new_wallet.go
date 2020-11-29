package IncognitoPayFunctions

import (
  "encoding/json"
  "fmt"
  "html"
  "net/http"
)

func NewWallet(response http.ResponseWriter, request *http.Request) {
  var wallet struct {
    PrivateKey string `json:"privateKey"`
  }

  if error := json.NewDecoder(request.Body).Decode(&wallet); error != nil {
    fmt.Fprint(response, "Hello world!")
    return
  }

  if wallet.PrivateKey == "" {
    fmt.Fprint(response, "Hello world!")
    return
  }

  fmt.Fprintf(response, "My wallet, %s!", html.EscapeString(wallet.PrivateKey))
}
