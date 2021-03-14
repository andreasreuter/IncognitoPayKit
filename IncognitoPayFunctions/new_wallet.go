package IncognitoPayFunctions

import (
	"encoding/json"
	"fmt"
	"net/http"

	incognito "ndncmnky.com/IncognitoPayFunctions/Incognito"
	remittee "ndncmnky.com/IncognitoPayFunctions/Incognito"
)

//
// NewWallet is hosted as Cloud Function. It creates a new wallet address
// in Incognito blockchain and responds with private key, public key and
// readonly key in addition to wallet address.
//
func NewWallet(response http.ResponseWriter, request *http.Request) {
	var wallet2 struct {
		Id string `json:"id"`
	}

	var wallet struct {
		PrivateKey    string `json:"privateKey"`
		PublicKey     string `json:"publicKey"`
		ReadonlyKey   string `json:"readonlyKey"`
		WalletAddress string `json:"walletAddress"`
	}

	if error := json.NewDecoder(request.Body).Decode(&wallet2); error != nil {
		fmt.Fprint(response, error)
		return
	}

	publicIncognito := incognito.PublicIncognito()
	newWallet := incognito.NewWallet(publicIncognito)

	walletAddress, publicKey, readonlyKey, privateKey, _, _, error := newWallet.CreateWallet()

	if error != nil {
		fmt.Fprint(response, error)
		return
	}

	// @todo remittee.Insert can fail after wallet was created successful. This makes a new wallet useless.

	/*
	 * import wallet address in Cloud Firestore because its used to
	 * execute payments to any of the contacts, they are public anyhow.
	 */
	error = remittee.Insert(wallet2.Id, walletAddress)

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
