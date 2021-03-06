defmodule MasterMind.Core.Game do
  defstruct [:answer, :guesses] 
  def new(answer \\ nil) do
    
    %__MODULE__{ 
      answer: random_answer(answer), 
      guesses: [] 
    }
  end
  
  def random_answer(nil) do
    (1..4)
    |> Enum.map( fn(_) -> :rand.uniform(6) end)
  end
  def random_answer(answer) do
    answer
  end
  
  def score(answer, guess) do
    %{
      reds: score_reds(answer, guess), 
      whites: score_whites(answer, guess)
    }
  end
  
  def scores(game) do
    game.guesses
    |> Enum.map( fn(guess) -> score(game.answer, guess) end)
  end
  
  def game_won?(game) do
    game
    |> scores
    |> Enum.any?( &win?/1 )
  end
  
  def game_lost?(game) do
    length(game.guesses) >= 10 && !(game_won?(game))
  end
  
  def win?(%{ red: 4 }), do: true
  def win?(_), do: false
  
  
  
  def score_reds(answer, guess) do
    answer
    |> Enum.zip(guess)
    |> Enum.filter( fn({x, y}) -> x == y end)
    |> length
  end
  
  def misses(answer, guess) do
    (guess -- answer)
    |> length
  end
  
  def score_whites(answer, guess) do
    length(answer) - score_reds(answer, guess) - misses(answer, guess)
  end
  
  def add_guess(%__MODULE__{}=game, guess) do
    %__MODULE__{ game | guesses: [guess|game.guesses]}
  end
end