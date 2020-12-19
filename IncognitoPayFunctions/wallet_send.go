package IncognitoPayFunctions

import (
	"encoding/json"
	"fmt"
	"net/http"

	incognito "nodancemonkey.com/IncognitoPayFunctions/Incognito"

	"github.com/incognitochain/go-incognito-sdk/incognitoclient/entity"
)

func WalletSend(response http.ResponseWriter, request *http.Request) {
	var wallet struct {
		PrivateKey             string `json:"privateKey"`
		RecipientWalletAddress string `json:"recipientWalletAddress`
		PrivacyCoins           uint64 `json:"privacyCoins,string"`
	}

	if error := json.NewDecoder(request.Body).Decode(&wallet); error != nil {
		fmt.Fprint(response, error)
		return
	}

	listPaymentAddresses := entity.WalletSend{
		Type: 0,
		PaymentAddresses: map[string]uint64{
			wallet.RecipientWalletAddress: wallet.PrivacyCoins,
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
