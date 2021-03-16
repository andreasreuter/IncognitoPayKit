package IncognitoPayFunctions

import (
	"encoding/json"
	"errors"
	"fmt"
	"net/http"
	"strconv"
	"strings"

	incognito "ndncmnky.com/IncognitoPayFunctions/Incognito"
)

//
// WalletSend is hosted as Cloud Function. It takes a private key,
// recipient's wallet address and amount of Privacy coins to send to
// the wallet address. It responds with the transaction hash.
//
func WalletSend(response http.ResponseWriter, request *http.Request) {
	var wallet struct {
		PrivateKey             string `json:"privateKey"`
		RecipientWalletAddress string `json:"recipientWalletAddress"`
		PrivacyCoins           string `json:"privacyCoins"`
	}

	if error := json.NewDecoder(request.Body).Decode(&wallet); error != nil {
		fmt.Fprint(response, error)
		return
	}

	isGenuine, error := isPrivacyCoinGenuine(wallet.PrivacyCoins)

	if !isGenuine && error != nil {
		fmt.Fprint(response, error)
		return
	}

	/*
	 * cast a numeric value of Privacy coins to uint64. It removes all
	 * white spaces from string.
	 */
	privacyCoins, error := strconv.ParseUint(strings.TrimSpace(wallet.PrivacyCoins), 0, 64)

	if error != nil {
		fmt.Fprint(response, error)
		return
	}

	publicIncognito := incognito.PublicIncognito()
	newWallet := incognito.NewWallet(publicIncognito)

	transactionHash, error := newWallet.SendToken(
		wallet.PrivateKey,
		wallet.RecipientWalletAddress,
		"0000000000000000000000000000000000000000000000000000000000000004", // Privacy coin,
		privacyCoins,
		0,
		"",
	)

	if error != nil {
		fmt.Fprint(response, error)
		return
	}

	fmt.Fprint(response, transactionHash)
}

func isPrivacyCoinGenuine(privacyCoins string) (bool, error) {
	if strings.ContainsAny(privacyCoins, " .,") {
		return (false), (errors.New("Invalid privacy coin value because of white spaces, puncts and commas"))
	}

	return (true), (nil)
}
