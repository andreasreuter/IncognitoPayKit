package IncognitoPayFunctions

import (
	"encoding/json"
	"fmt"
	"net/http"
	"strconv"
	"strings"

	incognito "nodancemonkey.com/IncognitoPayFunctions/Incognito"

	"github.com/incognitochain/go-incognito-sdk/incognitoclient/entity"
)

func WalletSend(response http.ResponseWriter, request *http.Request) {
	var wallet struct {
		PrivateKey             string `json:"privateKey"`
		RecipientWalletAddress string `json:"recipientWalletAddress`
		PrivacyCoins           string `json:"privacyCoins"`
	}

	if error := json.NewDecoder(request.Body).Decode(&wallet); error != nil {
		fmt.Fprint(response, error)
		return
	}

	/*
	 * cast a numeric value of Privacy coins to uint64. It removes all
	 * white space from string.
	 */
	privacyCoins, error := strconv.ParseUint(strings.TrimSpace(wallet.PrivacyCoins), 0, 64)

	if error != nil {
		fmt.Fprint(response, error)
		return
	}

	listPaymentAddresses := entity.WalletSend{
		Type: 0,
		PaymentAddresses: map[string]uint64{
			wallet.RecipientWalletAddress: privacyCoins,
		},
	}

	incognitoBlockchain := incognito.IncognitoBlockchain()

	tx, error := incognitoBlockchain.CreateAndSendConstantPrivacyTransaction(
		wallet.PrivateKey,
		listPaymentAddresses,
	)

	if error != nil {
		fmt.Fprint(response, error)
		return
	}

	fmt.Fprint(response, tx)
}
