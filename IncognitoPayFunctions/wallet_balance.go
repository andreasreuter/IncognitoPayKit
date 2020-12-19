package IncognitoPayFunctions

import (
	"encoding/json"
	"fmt"
	"net/http"
	"strconv"

	incognito "nodancemonkey.com/IncognitoPayFunctions/Incognito"
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
		fmt.Fprint(response, error)
		return
	}

	incognitoBlockchain := incognito.IncognitoBlockchain()

	privacyCoins, error := incognitoBlockchain.GetBalanceByPaymentAddress(wallet.WalletAddress)

	if error != nil {
		fmt.Fprint(response, error)
		return
	}

	/*
	 * cast a numeric value of Privacy coins to string.
	 */
	fmt.Fprint(response, strconv.FormatUint(privacyCoins, 10))
}
