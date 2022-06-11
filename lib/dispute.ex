defmodule Braintree.Dispute do
  @moduledoc """
  Manage disputes.

  You can either search, find by id, and manage disputes lifecycle.
  You can accept, dispute, add and remove evidences as well as finalize dispute evidence submition

  https://developers.braintreepayments.com/reference/response/dispute/ruby
  """
  use Braintree.Construction

  alias Braintree.{HTTP, Search, Transaction}
  alias Braintree.ErrorResponse, as: Error

  @type t :: %__MODULE__{
          amount_disputed: number,
          amount_won: number,
          case_number: String.t(),
          chargeback_protection_level: String.t(),
          created_at: String.t(),
          currency_iso_code: String.t(),
          evidence: [any],
          graphql_id: String.t(),
          id: String.t(),
          kind: String.t(),
          merchant_account_id: String.t(),
          original_dispute_id: String.t(),
          paypal_messages: [any],
          processor_comments: String.t(),
          reason: String.t(),
          reason_code: String.t(),
          reason_description: String.t(),
          received_date: String.t(),
          reference_number: String.t(),
          reply_by_date: String.t(),
          status: String.t(),
          status_history: [any],
          transaction: Transaction.t(),
          updated_at: String.t()
        }

  defstruct amount_disputed: 0,
            amount_won: 0,
            case_number: nil,
            chargeback_protection_level: nil,
            created_at: nil,
            currency_iso_code: nil,
            evidence: [],
            graphql_id: nil,
            id: nil,
            kind: nil,
            merchant_account_id: nil,
            original_dispute_id: nil,
            paypal_messages: [],
            processor_comments: nil,
            reason: nil,
            reason_code: nil,
            reason_description: nil,
            received_date: nil,
            reference_number: nil,
            reply_by_date: nil,
            status: nil,
            status_history: [],
            transaction: %Transaction{},
            updated_at: nil

  @doc """
  Find an existing dispute by `dispute_id`

  ## Example

      {:ok, dispute} = Dispute.find("ax6hg4fk9")
  """
  @spec find(String.t(), Keyword.t()) :: {:ok, t} | {:error, Error.t()}
  def find(dispute_id, opts \\ []) do
    path = "disputes/#{dispute_id}"

    with {:ok, payload} <- HTTP.get(path, opts) do
      {:ok, new(payload)}
    end
  end

  @doc """
  To search for disputes, pass a map of search parameters.

  For more information about which fields are searchable please refer to
  https://developer.paypal.com/braintree/docs/reference/request/dispute/search

  ## Example:

      {:ok, disputes} = Braintree.Dispute.search(%{kind: %{is: "chargeback"}})
  """
  @spec search(map, Keyword.t()) :: {:ok, t} | {:error, Error.t()}
  def search(params, opts \\ []) when is_map(params) do
    Search.perform(params, "disputes", &new/1, opts)
  end

  @doc """
  Accepts a dispute by its `dispute_id`.

  ## Example

      {:ok, dispute} = Dispute.accept("ax6hg4fk9")
  """
  @spec accept(String.t(), Keyword.t()) :: {:ok, t} | {:error, Error.t()}
  def accept(dispute_id, opts \\ []) do
    path = "disputes/#{dispute_id}/accept"

    with {:ok, payload} <- HTTP.put(path, opts) do
      {:ok, new(payload)}
    end
  end

  @doc """
  Finalize a dispute by its `dispute_id`.

  ## Example

      {:ok, dispute} = Dispute.finalize("ax6hg4fk9")
  """
  @spec finalize(String.t(), Keyword.t()) :: {:ok, t} | {:error, Error.t()}
  def finalize(dispute_id, opts \\ []) do
    path = "disputes/#{dispute_id}/finalize"

    with {:ok, payload} <- HTTP.put(path, opts) do
      {:ok, new(payload)}
    end
  end

  @doc """
  Convert a map into a Dispute struct.

  ## Example

  dispute =
    Braintree.Dispute.new(%{
      "id" => "q7j87ybw9qvhp4fp",
      "status" => "open"
    })
  """
  def new(%{"dispute" => map}) do
    new(map)
  end

  def new(%{"disputes" => list}) do
    new(list)
  end

  def new(map) when is_map(map) do
    dispute = super(map)

    dispute
  end

  def new(list) when is_list(list) do
    Enum.map(list, &new/1)
  end
end
