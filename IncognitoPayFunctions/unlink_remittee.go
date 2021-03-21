package IncognitoPayFunctions

import (
	"encoding/json"
	"fmt"
	"net/http"

	remittee "ndncmnky.com/IncognitoPayFunctions/Incognito"
)

//
// UnlinkRemittee is hosted as Cloud Function. It unlinks a remittee
// with their id and wallet address from Google Firebase because their
// id is safely stored in the keychain.
//
func UnlinkRemittee(response http.ResponseWriter, request *http.Request) {
	var wallet struct {
		Id            string `json:"id"`
		WalletAddress string `json:"walletAddress"`
	}

	if error := json.NewDecoder(request.Body).Decode(&wallet); error != nil {
		http.Error(response, error.Error(), http.StatusBadRequest)
		return
	}

	/*
	 * deletes remittee with their id and wallet address.
	 */
	error := remittee.Delete(wallet.Id, wallet.WalletAddress)

	if error != nil {
		http.Error(response, error.Error(), http.StatusBadRequest)
		return
	}

	fmt.Fprint(response, true)
}
