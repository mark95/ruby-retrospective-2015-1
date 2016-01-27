def convert_to_bgn(price, currency)
  new_price = price

  if(currency == :usd)
    new_price = price * 1.7408
  elsif(currency == :eur)
    new_price = price * 1.9557
  elsif(currency == :gbp)
    new_price = price * 2.6415
  end

  new_price.round(2)
end

def compare_prices(price_1, currency_1, price_2, currency_2)
  value_1 = convert_to_bgn(price_1, currency_1)
  value_2 = convert_to_bgn(price_2, currency_2)

  value_1 <=> value_2
end