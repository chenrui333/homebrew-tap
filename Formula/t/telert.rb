class Telert < Formula
  include Language::Python::Virtualenv

  desc "Multi-channel alerts for long-running commands and process/log/uptime monitoring"
  homepage "https://github.com/navig-me/telert"
  url "https://files.pythonhosted.org/packages/7b/8b/a252724f5325e16749305f40b76a66a1cd388bf08d507625da1786cc9971/telert-0.2.7.tar.gz"
  sha256 "3607e8d2f8ea0cf5cf4779b730d285fb3ca5ad3be0a4f9afa18d6301828f5166"
  license "MIT"
  head "https://github.com/navig-me/telert.git", branch: "main"

  depends_on "certifi"
  depends_on "python@3.13"

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/77/e9/df2358efd7659577435e2177bfa69cba6c33216681af51a707193dec162a/beautifulsoup4-4.14.2.tar.gz"
    sha256 "2a98ab9f944a11acee9cc848508ec28d9228abfd522ef0fad6a02a72e0ded69e"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/83/2d/5fd176ceb9b2fc619e63405525573493ca23441330fcdaee6bef9460e924/charset_normalizer-3.4.3.tar.gz"
    sha256 "6fce4b8500244f6fcb71465d4a4930d132ba9ab8e71a7859e6a5d59851068d14"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "ping3" do
    url "https://files.pythonhosted.org/packages/0d/e5/702dfb79e74990585d502734065f8a1610d18473bbd4bd18e4058abe9dbc/ping3-5.1.5.tar.gz"
    sha256 "6c99bc844e0b7dbc5c9765e8b530140daf1ccd2112c99db01ab79831bd8081cd"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/b3/31/4723d756b59344b643542936e37a31d1d3204bcdc42a7daa8ee9eb06fb50/psutil-7.1.0.tar.gz"
    sha256 "655708b3c069387c8b77b072fc429a57d0e214221d01c0a772df7dfedcb3bcd2"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/6d/e6/21ccce3262dd4889aa3332e5a119a3491a95e8f60939870a3a035aabac0d/soupsieve-2.8.tar.gz"
    sha256 "e2dd4a40a628cb5f28f6d4b0db8800b8f581b65bb380b97de22ba5ca8d72572f"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    require "socket"

    assert_match version.to_s, shell_output("#{bin}/telert --version")

    port = free_port
    request_log = testpath/"request.json"
    server = TCPServer.new("127.0.0.1", port)
    server_thread = Thread.new do
      client = server.accept
      request = +""

      while (line = client.gets)
        request << line
        break if line == "\r\n"
      end

      content_length = request[/Content-Length:\s*(\d+)/i, 1].to_i
      request << client.read(content_length)
      request_log.write(request)

      client.write("HTTP/1.1 200 OK\r\nContent-Length: 2\r\n\r\nok")
      client.close
    ensure
      server.close if server && !server.closed?
    end

    output = pipe_output(
      "TELERT_ENDPOINT_URL=http://127.0.0.1:#{port} " \
      "TELERT_DEFAULT_PROVIDER=endpoint #{bin}/telert",
      "brew telert test\n",
      0,
    )

    server_thread.join

    assert_match "EndpointProvider", output
    assert_match "brew telert test", request_log.read
  ensure
    server.close if defined?(server) && server && !server.closed?
    server_thread.kill if defined?(server_thread) && server_thread&.alive?
    server_thread.join if defined?(server_thread) && server_thread
  end
end
