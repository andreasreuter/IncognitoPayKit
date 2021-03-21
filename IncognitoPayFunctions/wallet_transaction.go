package IncognitoPayFunctions

import (
	"encoding/json"
	"fmt"
	"net/http"

	incognito "ndncmnky.com/IncognitoPayFunctions/Incognito"
)

//
// WalletTransaction is hosted as Cloud Function. It takes a wallet address
// and its readonly key. It collects transactions of a wallet by its wallet
// address.
//
func WalletTransaction(response http.ResponseWriter, request *http.Request) {
	var wallet struct {
		WalletAddress string `json:"walletAddress"`
		ReadonlyKey   string `json:"readonlyKey"`
	}

	if error := json.NewDecoder(request.Body).Decode(&wallet); error != nil {
		http.Error(response, error.Error(), http.StatusBadRequest)
		return
	}

	publicIncognito := incognito.PublicIncognito()
	newWallet := incognito.NewWallet(publicIncognito)

	transactionInfo, error := newWallet.GetTransactionByReceiversAddress(
		wallet.WalletAddress,
		wallet.ReadonlyKey,
	)

	if error != nil {
		http.Error(response, error.Error(), http.StatusBadRequest)
		return
	}

	fmt.Fprint(response, transactionInfo)
}
