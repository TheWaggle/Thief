defmodule Thief do
  @moduledoc """
  Documentation for Thief.
  """

   def project do
    [app: :Thief,
     version: "0.0.1",
     elixir: "~> 1.0",
     description: "Scrape and get image link",
     package: [
       maintainers: ["YOSUKENAKAO.me"],
       licenses: ["MIT"],
       links: %{"GitHub" => "https://github.com/TheWaggle/Thief.git"}
     ],
     deps: deps]
  end



  @doc """
  your get link or images at URL.

  ## Examples

      iex> Thief.steal( "https://xxxx.com" )
      [https://xxxx.com/img.png,https://xxxx.com/img.jpg]



"""

  # url からリンクを辿ってimgリストを取得する
  def steal(url) do
    get_domain_link( url )
    |> Enum.map( fn x -> getimage(x) end )
  end

  # url ドメインチェック
  def get_domain_link( url ) do
    case get_html(url) do
    { :ok , body , request_url } -> body
    |>Floki.find("a")
    |>Floki.attribute("href")
    |>Enum.filter(fn link -> String.contains?(link, request_url) end )
    { :error , _body, _request_url } -> "Domain check Error link"
    end
  end

  # img ドメインチェック
  def get_domain_img( url ) do
    case get_html(url) do
    { :ok , body , request_url } -> body
    |>Floki.find("img")
    |>Floki.attribute("src")
    |>Enum.filter(fn link -> String.contains?(link, request_url) end )
    { :error , _body, _request_url } -> "Domain check Error img"
    end
  end


  # urlからリンクを取得する
  def getlink( url ) do
    case get_html(url) do
     { :ok , body , _request_url } -> get_links(body)
     { :error , _body , _request_url } -> "Error not URL"
    end
  end

  # urlからimgのリストを取得する
  def getimage( url ) do
    case get_html(url) do
    { :ok , body , _request_url } -> get_imgs(body)
     { :error , _body , _request_url} -> "Error not URL"
    end
  end

  #bodyからimgのリスト取得
  def get_imgs(body) do
    body
    |>Floki.find("img")
    |>Floki.attribute("src")
    |>Enum.filter(fn link -> String.contains?(link, ["http://", "https://"]) end )
  end

  #bodyからlinkのリストを取得
  def get_links(body) do
    body
    |>Floki.find("a")
    |>Floki.attribute("href")
    |>Enum.filter(fn link -> String.contains?(link, ["http://", "https://"]) end )
  end

  #URLのHTMLのbodyを取得
  def get_html(url) do
     case HTTPoison.get(url) do
      {:ok, response} -> %HTTPoison.Response{status_code: status_code, body: body, request_url: request_url } = response
      if status_code === 200 do
        {:ok, body, request_url}
      else
        {:error, status_code }
      end
      {:error, _response } -> "Error not URL"
    end
  end

end
