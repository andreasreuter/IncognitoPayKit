package IncognitoPayFunctions

import (
	"encoding/json"
	"fmt"
	"net/http"

	"github.com/incognitochain/go-incognito-sdk/incognitoclient"
)

func NewWallet(response http.ResponseWriter, request *http.Request) {
	var wallet struct {
		PrivateKey    string `json:"privateKey"`
		PublicKey     string `json:"publicKey"`
		ReadonlyKey   string `json:"readonlyKey"`
		WalletAddress string `json:"walletAddress"`
	}

	client := &http.Client{}
	incognitoBlockchain := incognitoclient.NewBlockchain(
		client,
		"https://testnet.incognito.org/fullnode",
		"",
		"",
		"",
		"0000000000000000000000000000000000000000000000000000000000000004",
	)

	address, pubKey, readonlyKey, privateKey, error := incognitoBlockchain.CreateWalletAddress()

	if error != nil {
		fmt.Fprint(response, error)
		return
	}

	wallet.PrivateKey = privateKey
	wallet.PublicKey = pubKey
	wallet.ReadonlyKey = readonlyKey
	wallet.WalletAddress = address

	encoder := json.NewEncoder(response)
	encoder.Encode(&wallet)
}
