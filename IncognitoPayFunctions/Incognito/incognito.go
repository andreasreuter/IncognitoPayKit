package Incognito

import (
	"net/http"

	"github.com/incognitochain/go-incognito-sdk/incognitoclient"
)

//
// IncognitoBlockchain creates an instance of Incognito client
// to connect with Incognito Blockchain.
//
func IncognitoBlockchain() *incognitoclient.Blockchain {
	client := &http.Client{}
	incognitoBlockchain := incognitoclient.NewBlockchain(
		client,
		"https://testnet.incognito.org/fullnode",
		"",
		"",
		"",
		"0000000000000000000000000000000000000000000000000000000000000004",
	)

	return incognitoBlockchain
}
