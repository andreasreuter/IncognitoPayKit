package IncognitoPayFunctions

import (
	"encoding/json"
	"fmt"
	"net/http"

	incognito "nodancemonkey.com/IncognitoPayFunctions/Incognito"
)

//
// NewWallet is hosted as Cloud Function. It creates a new wallet address
// in Incognito blockchain and responds with private key, public key and
// readonly key in addition to wallet address.
//
func NewWallet(response http.ResponseWriter, request *http.Request) {
	var wallet struct {
		PrivateKey    string `json:"privateKey"`
		PublicKey     string `json:"publicKey"`
		ReadonlyKey   string `json:"readonlyKey"`
		WalletAddress string `json:"walletAddress"`
	}

	publicIncognito := incognito.PublicIncognito()
	newWallet := incognito.NewWallet(publicIncognito)

	walletAddress, publicKey, readonlyKey, privateKey, _, _, error := newWallet.CreateWallet()

	if error != nil {
		fmt.Fprint(response, error)
		return
	}

	wallet.PrivateKey = privateKey
	wallet.PublicKey = publicKey
	wallet.ReadonlyKey = readonlyKey
	wallet.WalletAddress = walletAddress

	encoder := json.NewEncoder(response)
	encoder.Encode(&wallet)
}
