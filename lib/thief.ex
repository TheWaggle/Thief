defmodule Thief do

  @moduledoc """
  Documentation for Thief.
  Scrape and get image link"
  """

  @doc """
  your get link or images at URL.

  ## Examples

      iex> Thief.steal( "https://xxxx.com" , "/xxx/xxxx.html" )
      [https://xxxx.com/img.png,https://xxxx.com/img.jpg]


"""

  # urlからリンクを辿ってimgリストを取得する
  def steal(domain, path) do
    get_domain_link( domain, path )
    |> Enum.map( fn x -> getimage(x) end )
  end

  @doc """
    Thief.steal make a list of URLs and create a list of image downloads.
    We only get lists within the domain.

  ## Examples

      iex> list = Thief.steal( domain, path )
      [https://xxxx.com/img.png,https://xxxx.com/img.jpg]

  """

  # リストをファイルにセーブします。
  def save( list, file_name ) do
    binary = :erlang.term_to_binary(list)
    File.write(file_name, binary)
  end

  @doc """
    Thief.save Save the created list as a file.

  ## Examples

    iex> Thief.save(list, file_name )
      file_name

  """

  # url ドメインチェック
  def get_domain_link( domain, path ) do
    url = domain <> path
    case get_html(url) do
    { :ok , body } -> body
    |>Floki.find("a")
    |>Floki.attribute("href")
    |>Enum.filter(fn link -> String.contains?(link, domain) end )
    { :error , _body } -> "Domain check Error link"
    end
  end

  @doc """
    Get a list of links within the domain."
    "

  ## Examples

    iex> Thief.get_domain_link(domain, path )
    [https://xxxx.com/img.png,https://xxxx.com/img.jpg]


  """

  # img ドメインチェック
  def get_domain_img( domain, path ) do
     url = domain <> path
    case get_html( url ) do
    { :ok , body } -> body
    |>Floki.find("img")
    |>Floki.attribute("src")
    |>Enum.filter(fn link -> String.contains?(link, domain) end )
    { :error , _body } -> "Domain check Error img"
    end
  end

  @doc """
      Collect the linked links and return the list.


    ## Examples

      iex> Thief.get_domain_img( domain, path )
      [https://xxxx.com/img.png,https://xxxx.com/img.jpg]


    """

  # urlからリンクを取得する
  def getlink( url ) do
    case get_html(url) do
     { :ok , body } -> get_links(body)
     { :error , _body } -> "Error not URL"
    end
  end

  @doc """
      Collect the linked image links and return the list.


    ## Examples

      iex> Thief.getlink( url )
      [https://xxxx.com/img.png,https://xxxx.com/img.jpg]


    """

  # urlからimgのリストを取得する
  def getimage( url ) do
    case get_html(url) do
    { :ok , body } -> get_imgs(body)
     { :error , _body } -> "Error not URL"
    end
  end

  @doc """
      Collect the linked image links and return the list.


      ## Examples

      iex> Thief.getimage( url )
      [https://xxxx.com/img.png,https://xxxx.com/img.jpg]


    """

  #bodyからimgのリスト取得
  def get_imgs(body) do
    body
    |>Floki.find("img")
    |>Floki.attribute("src")
    |>Enum.filter(fn link -> String.contains?(link, ["http://", "https://"]) end )
  end

  @doc """
      Return a list of image links from the body element.


      ## Examples

      iex> Thief.get_imgs(body)
      ["https://xxxxx.com/", "https://xxxxx.com/"]


    """

  #bodyからlinkのリストを取得
  def get_links(body) do
    body
    |>Floki.find("a")
    |>Floki.attribute("href")
    |>Enum.filter(fn link -> String.contains?(link, ["http://", "https://"]) end )
  end

  @doc """
      Return a list of links from the body element.


      ## Examples

      iex> list = Thief.get_links(body)
      ["https://xxxxx.com/", "https://xxxxx.com/"]

    """

  #URLのHTMLのbodyを取得
  def get_html(url) do
     case HTTPoison.get(url) do
      {:ok, response} -> %HTTPoison.Response{status_code: status_code, body: body } = response
      if status_code === 200 do
        {:ok, body}
      else
        {:error, status_code }
      end
      {:error, _response } -> "Error not URL"
    end
  end

    @doc """
      Get body element of URL destination.


      ## Examples

      iex> { :ok, body } = Thief.get_html("https://github.com")
      {:ok, "content=\"EB85:0" <> ..."}
    """

end
