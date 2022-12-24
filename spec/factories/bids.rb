# frozen_string_literal: true

FactoryBot.define do
  factory :bid do
    country { 'us' }
    category { 'categ1' }
    channel { 'ca' }
    amount { 9.99 }
  end
end
