defmodule Braintree.Dispute.Evidence do
  @moduledoc """
  Manage disputes.

  You can either search, find by id, and manage disputes lifecycle.
  You can accept, dispute, add and remove evidences as well as finalize dispute evidence submition

  https://developers.braintreepayments.com/reference/response/dispute/ruby
  """
  use Braintree.Construction

  alias Braintree.{HTTP}

  # @evidence_categories [
  #   "DEVICE_ID",
  #   "DEVICE_NAME",
  #   "DOWNLOAD_DATE_TIME",
  #   "GEOGRAPHICAL_LOCATION",
  #   "PRIOR_DIGITAL_GOODS_TRANSACTION_ID",
  #   "PRIOR_DIGITAL_GOODS_TRANSACTION_DATE_TIME",
  #   "PRIOR_NON_DISPUTED_TRANSACTION_ID",
  #   "PRIOR_NON_DISPUTED_TRANSACTION_DATE_TIME",
  #   "PRIOR_NON_DISPUTED_TRANSACTION_EMAIL_ADDRESS",
  #   "PRIOR_NON_DISPUTED_TRANSACTION_IP_ADDRESS",
  #   "PRIOR_NON_DISPUTED_TRANSACTION_PHONE_NUMBER",
  #   "PRIOR_NON_DISPUTED_TRANSACTION_PHYSICAL_ADDRESS",
  #   "PURCHASER_EMAIL_ADDRESS",
  #   "PURCHASER_IP_ADDRESS",
  #   "PURCHASER_NAME",
  #   "RECURRING_TRANSACTION_ID",
  #   "RECURRING_TRANSACTION_DATE_TIME"
  # ]

  @spec add_text_evidence(String.t(), String.t(), Keyword.t()) ::
          {:error, Braintree.ErrorResponse.t()} | {:ok, map}
  def add_text_evidence(dispute_id, content, opts \\ []) do
    add_text_evidence(dispute_id, content, nil, opts)
  end

  @spec add_text_evidence(String.t(), String.t(), String.t(), Keyword.t()) ::
          {:error, Braintree.ErrorResponse.t()} | {:ok, map}
  def add_text_evidence(dispute_id, content, category, opts) do
    body = %{
      comments: content,
      category: category
    }

    with {:ok, payload} <- HTTP.post("disputes/#{dispute_id}/evidence", %{evidence: body}, opts) do
      {:ok, payload}
    end
  end
end
