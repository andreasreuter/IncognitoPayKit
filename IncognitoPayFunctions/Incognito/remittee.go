package Incognito

import (
	"context"
	"errors"

	"cloud.google.com/go/firestore"
	firebase "firebase.google.com/go"
)

type Remittee struct {
	Id            string `firestore:"id"`
	WalletAddress string `firestore:"wallet_address"`
}

//
// Insert inserts a wallet address in Cloud Firestore because its used to
// execute payments to any of the contacts, they are public anyhow.
//
func Insert(id string, walletAddress string) error {
	var error error

	client, error := createClient()

	if error != nil {
		return (error)
	}

	// Allow the user to access documents in the "remittees" collection
	// only if they are authenticated, values ain't empty and don't exists already.
	if id == "" {
		return (errors.New("Cannot store new remittee because its id appears empty"))
	}

	if walletAddress == "" {
		return (errors.New("Cannot store new remittee because its wallet address appears empty"))
	}

	remitteeById := remitteeBy(client, "id", id)
	remitteeByWalletAddress := remitteeBy(client, "wallet_address", walletAddress)

	if remitteeById != nil || remitteeByWalletAddress != nil {
		return (errors.New("Cannot store new remittee because either its id or wallet address exists already"))
	}

	remittees := client.Collection("remittees")
	_, _, error = remittees.Add(context.Background(), map[string]interface{}{
		"id":             id,
		"wallet_address": walletAddress,
	})

	if error != nil {
		return (error)
	}

	defer client.Close()

	return (nil)
}

func Retrieve(ids []string) ([]Remittee, error) {
	var remitteeList []Remittee
	var error error

	client, error := createClient()

	if error != nil {
		return (nil), (error)
	}

	remittees := client.Collection("remittees")
	docs := remittees.Documents(context.Background())
	snap, _ := docs.GetAll()

	if len(snap) > 0 {
		for _, doc := range snap {
			var remittee Remittee
			error = doc.DataTo(&remittee)

			if error != nil {
				return (nil), (error)
			}

			if contains(ids, remittee.Id) {
				remitteeList = append(remitteeList, remittee)
			}
		}
	}

	return (remitteeList), (nil)
}

func createClient() (*firestore.Client, error) {
	var error error

	app, error := firebase.NewApp(context.Background(), nil)

	if error != nil {
		return (nil), (error)
	}

	client, error := app.Firestore(context.Background())

	if error != nil {
		return (nil), (error)
	}

	return (client), (nil)
}

func remitteeBy(client *firestore.Client, column string, value string) *Remittee {
	var remittee *Remittee

	remittees := client.Collection("remittees")
	docs := remittees.Where(column, "==", value).Limit(1).Documents(context.Background())
	snap, _ := docs.GetAll()

	if len(snap) > 0 {
		snap[0].DataTo(&remittee)
	}

	return (remittee)
}

func contains(s []string, str string) bool {
	for _, v := range s {
		if v == str {
			return true
		}
	}

	return false
}
