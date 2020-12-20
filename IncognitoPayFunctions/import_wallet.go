package IncognitoPayFunctions

import (
	"encoding/hex"
	"encoding/json"
	"fmt"
	"net/http"

	"github.com/incognitochain/go-incognito-sdk/privacy"
	wallet2 "github.com/incognitochain/go-incognito-sdk/wallet"
)

//
// ImportWallet is hosted as Cloud Function. It imports an existing wallet
// by its private key and creates public key, readonly key and wallet address.
//
func ImportWallet(response http.ResponseWriter, request *http.Request) {
	var wallet struct {
		PrivateKey string `json:"privateKey"`
	}

	var importWallet struct {
		PrivateKey    string `json:"privateKey"`
		PublicKey     string `json:"publicKey"`
		ReadonlyKey   string `json:"readonlyKey"`
		WalletAddress string `json:"walletAddress"`
	}

	if error := json.NewDecoder(request.Body).Decode(&wallet); error != nil {
		fmt.Fprint(response, error)
		return
	}

	keyWallet, error := wallet2.Base58CheckDeserialize(wallet.PrivateKey)

	if error != nil {
		fmt.Fprint(response, error)
		return
	}

	childKey, _ := keyWallet.NewChildKey(0)

	importWallet.PrivateKey = wallet.PrivateKey
	importWallet.PublicKey = hex.EncodeToString(privacy.GeneratePublicKey(keyWallet.KeySet.PrivateKey))
	importWallet.ReadonlyKey = childKey.Base58CheckSerialize(wallet2.ReadonlyKeyType)
	importWallet.WalletAddress = childKey.Base58CheckSerialize(wallet2.PaymentAddressType)

	encoder := json.NewEncoder(response)
	encoder.Encode(&importWallet)
}
