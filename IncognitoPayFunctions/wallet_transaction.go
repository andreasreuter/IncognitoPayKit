package IncognitoPayFunctions

import (
	"encoding/json"
	"fmt"
	"net/http"

	incognito "nodancemonkey.com/IncognitoPayFunctions/Incognito"
)

//
// WalletTransaction is hosted as Cloud Function. It takes a wallet address
// and its readonly key. It responds with the transaction info.
//
func WalletTransaction(response http.ResponseWriter, request *http.Request) {
	var wallet struct {
		WalletAddress string `json:"walletAddress`
		ReadonlyKey   string `json:"readonlyKey"`
	}

	if error := json.NewDecoder(request.Body).Decode(&wallet); error != nil {
		fmt.Fprint(response, error)
		return
	}

	publicIncognito := incognito.PublicIncognito()
	newWallet := incognito.NewWallet(publicIncognito)

	transactionInfo, error := newWallet.GetTransactionByReceiversAddress(
		wallet.WalletAddress,
		wallet.ReadonlyKey,
	)

	if error != nil {
		fmt.Fprint(response, error)
		return
	}

	fmt.Fprint(response, transactionInfo)
}
