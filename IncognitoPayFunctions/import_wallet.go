package IncognitoPayFunctions

import (
	"encoding/hex"
	"encoding/json"
	"net/http"

	"github.com/incognitochain/go-incognito-sdk/privacy"
	wallet2 "github.com/incognitochain/go-incognito-sdk/wallet"
	remittee "ndncmnky.com/IncognitoPayFunctions/Incognito"
)

//
// ImportWallet is hosted as Cloud Function. It imports an existing wallet
// by its private key and creates public key, readonly key and wallet address.
//
func ImportWallet(response http.ResponseWriter, request *http.Request) {
	var wallet struct {
		Id         string `json:"id"`
		PrivateKey string `json:"privateKey"`
	}

	var importWallet struct {
		PrivateKey    string `json:"privateKey"`
		PublicKey     string `json:"publicKey"`
		ReadonlyKey   string `json:"readonlyKey"`
		WalletAddress string `json:"walletAddress"`
	}

	if error := json.NewDecoder(request.Body).Decode(&wallet); error != nil {
		http.Error(response, error.Error(), http.StatusBadRequest)
		return
	}

	keyWallet, error := wallet2.Base58CheckDeserialize(wallet.PrivateKey)

	if error != nil {
		http.Error(response, error.Error(), http.StatusBadRequest)
		return
	}

	error = keyWallet.KeySet.InitFromPrivateKey(&keyWallet.KeySet.PrivateKey)

	if error != nil {
		http.Error(response, error.Error(), http.StatusBadRequest)
		return
	}

	walletAddress := keyWallet.Base58CheckSerialize(wallet2.PaymentAddressType)

	/*
	 * import wallet address in Cloud Firestore because its used to
	 * execute payments to any of the contacts, they are public anyhow.
	 */
	error = remittee.Insert(wallet.Id, walletAddress)

	if error != nil {
		http.Error(response, error.Error(), http.StatusBadRequest)
		return
	}

	importWallet.PrivateKey = wallet.PrivateKey
	importWallet.PublicKey = hex.EncodeToString(privacy.GeneratePublicKey(keyWallet.KeySet.PrivateKey))
	importWallet.ReadonlyKey = keyWallet.Base58CheckSerialize(wallet2.ReadonlyKeyType)
	importWallet.WalletAddress = walletAddress

	encoder := json.NewEncoder(response)
	encoder.Encode(&importWallet)
}
