package Incognito

import (
	"net/http"

	"github.com/incognitochain/go-incognito-sdk/incognitoclient"
)

//
// PublicIncognito creates an instance of Incognito client
// to connect with blockchain.
//
func PublicIncognito() *incognitoclient.PublicIncognito {
	client := &http.Client{}
	publicIncognito := incognitoclient.NewPublicIncognito(
		client,
		"https://testnet.incognito.org/fullnode",
	)

	return (publicIncognito)
}

//
// NewWallet creates an instance of a wallet from Incognito.
//
func NewWallet(publicIncognito *incognitoclient.PublicIncognito) *incognitoclient.Wallet {
	blockInfo := incognitoclient.NewBlockInfo(publicIncognito)
	wallet := incognitoclient.NewWallet(publicIncognito, blockInfo)

	return (wallet)
}
