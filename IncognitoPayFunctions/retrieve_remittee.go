package IncognitoPayFunctions

import (
	"encoding/json"
	"fmt"
	"net/http"

	remittee "ndncmnky.com/IncognitoPayFunctions/Incognito"
)

type Remittee struct {
	Id            string `json:"id"`
	WalletAddress string `json:"walletAddress"`
}

//
// RetrieveRemittee is hosted as Cloud Function. It retrieves remittees
// with their wallet addresses from Google Firebase because each is used
// to execute payments to any of the contacts, they are public anyhow.
//
func RetrieveRemittee(response http.ResponseWriter, request *http.Request) {
	var remittees2 []string

	if error := json.NewDecoder(request.Body).Decode(&remittees2); error != nil {
		fmt.Fprint(response, error)
		return
	}

	/*
	 * retrieves remittees with their wallet addresses by certain ids of remittees.
	 */
	results, error := remittee.Retrieve(remittees2)

	if error != nil {
		fmt.Fprint(response, error)
		return
	}

	var remittees []Remittee

	for _, remittee := range results {
		remittees = append(remittees, Remittee{
			Id:            remittee.Id,
			WalletAddress: remittee.WalletAddress,
		})
	}

	encoder := json.NewEncoder(response)
	encoder.Encode(&remittees)
}
