defmodule Braintree.Integration.DisputeTest do
  use ExUnit.Case, async: true

  alias Braintree.Dispute
  alias Braintree.Testing.CreditCardNumbers
  alias Braintree.Transaction

  @moduletag :integration

  test "find/1 fails for invalid dispute id" do
    assert {:error, :not_found} = Dispute.find("someinvalidid")
  end

  test "find/1 should return dispute" do
    {:ok, transaction} = create_and_settle_transaction()
    %{disputes: [%{"id" => id, "reason" => reason}]} = transaction

    {:ok, dispute} = Dispute.find(id)
    assert dispute.id == id
    assert dispute.reason == reason
    assert dispute.amount_disputed == transaction.amount
    assert dispute.amount_won
    assert dispute.case_number
    assert dispute.created_at
    assert dispute.currency_iso_code
    assert dispute.evidence
    assert dispute.kind
    assert dispute.merchant_account_id
    assert dispute.paypal_messages
    assert dispute.reason_code
    assert dispute.received_date
    assert dispute.reply_by_date
    assert dispute.status
    assert dispute.status_history
    assert dispute.transaction
    assert dispute.updated_at
  end

  test "search/1 should return dispute" do
    {:ok, transaction} = create_and_settle_transaction()
    %{disputes: [%{"id" => id, "reason" => reason}]} = transaction

    search_params = %{
      id: %{
        is: id
      }
    }

    {:ok, [%Dispute{} = dispute | _]} = Dispute.search(search_params)

    assert dispute.reason == reason
  end

  test "search/1 should return empty list when no records are found" do
    search_params = %{
      id: %{
        is: "someinvalidid"
      }
    }

    {:ok, []} = Dispute.search(search_params)
  end

  defp create_and_settle_transaction do
    [card_number | _] = CreditCardNumbers.dispute_open_visa()

    Transaction.sale(%{
      amount: "10.00",
      customer: %{
        last_name: "Batman"
      },
      credit_card: %{
        number: card_number,
        expiration_date: "05/2025"
      }
    })
  end

  test "accept/1 should accept a dispute and return is as accepted" do
    {:ok, transaction} = create_and_settle_transaction()
    %{disputes: [%{"id" => id}]} = transaction

    {:ok, dispute} = Dispute.accept(id)

    assert dispute.status == "accepted"
  end

  test "accept/1 should error not found when dispute does not exist" do
    assert {:error, :not_found} = Dispute.accept("some-invalid-id")
  end

  test "accept/1 should return error when dispute cannot be accepted" do
    {:ok, transaction} = create_and_settle_transaction()
    %{disputes: [%{"id" => id}]} = transaction

    {:ok, dispute} = Dispute.accept(id)

    assert dispute.status == "accepted"

    assert {:error,
            %Braintree.ErrorResponse{
              params: %{id: ^id}
            }} = Dispute.accept(id)
  end
end
