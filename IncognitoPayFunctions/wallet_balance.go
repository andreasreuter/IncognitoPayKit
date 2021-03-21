package IncognitoPayFunctions

import (
	"encoding/json"
	"fmt"
	"net/http"

	incognito "ndncmnky.com/IncognitoPayFunctions/Incognito"
)

//
// WalletBalance is hosted as Cloud Function. It calculates the overall
// balance of a wallet by its private key.
//
func WalletBalance(response http.ResponseWriter, request *http.Request) {
	var wallet struct {
		WalletAddress string `json:"walletAddress"`
	}

	if error := json.NewDecoder(request.Body).Decode(&wallet); error != nil {
		http.Error(response, error.Error(), http.StatusBadRequest)
		return
	}

	publicIncognito := incognito.PublicIncognito()
	newWallet := incognito.NewWallet(publicIncognito)

	privacyCoins, error := newWallet.GetBalance(
		wallet.WalletAddress, "0000000000000000000000000000000000000000000000000000000000000004", // Privacy coin
	)

	if error != nil {
		http.Error(response, error.Error(), http.StatusBadRequest)
		return
	}

	/*
	 * cast a numeric value of Privacy coins to string.
	 */
	fmt.Fprint(response, privacyCoins)
}
