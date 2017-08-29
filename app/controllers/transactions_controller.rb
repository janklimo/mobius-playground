# frozen_string_literal: true

class TransactionsController < ApplicationController
  def create
    attributes = permitted_params.merge(sender_id: current_user.id)
    transaction = Transaction.new(attributes)

    unless current_user.can_send? permitted_params[:num_credits]
      flash[:alert] = "Bummer, you can't send more credits than you own!"
      redirect_to root_url
      return
    end

    if transaction.save
      flash[:notice] = "Success! You've sent #{permitted_params[:num_credits]}" \
        " #{'credit'.pluralize(permitted_params[:num_credits])}."
    else
      flash[:alert] = "We couldn't complete your transaction :("
    end

    redirect_to root_url
  end

  private

  def permitted_params
    params.require(:transaction).permit(:recipient_id, :num_credits)
  end
end
