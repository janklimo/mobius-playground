# frozen_string_literal: true

module DashboardHelper
  def transaction_user_label(user:, value:)
    value == user.email ? "you" : value
  end

  def transaction_credits_label(current_user:, sender:, value:)
    if current_user.email == sender.email
      content_tag(:span, "-#{value}", class: 'negative')
    else
      content_tag(:span, value, class: 'positive')
    end
  end
end
