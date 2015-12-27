Enum.each 1..100, fn (n) ->
  fizzbuzz = fn
    (0, 0, _) -> "fizzbuzz"
    (0, _, _) -> "fizz"
    (_, 0, _) -> "buzz"
    (_, _, last) -> last
  end

  IO.puts fizzbuzz.(rem(n, 3), rem(n, 5), n)
end
