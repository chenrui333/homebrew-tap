class Telert < Formula
  include Language::Python::Virtualenv

  desc "Multi-channel alerts for long-running commands and process/log/uptime monitoring"
  homepage "https://github.com/navig-me/telert"
  url "https://files.pythonhosted.org/packages/8b/e5/f59424f60525d2d5011b17e98892684fcf948b8b148b4766aea47b3f24ed/telert-0.2.9.tar.gz"
  sha256 "3e629699feb370e52bf5127322d4ea199dcbb8e1721eccee8037c41dba831182"
  license "MIT"
  head "https://github.com/navig-me/telert.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4b9dab5f699a52514cae52e91baae03a5ab76fe90db7722a7a6a2aae6156d2bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e09e4a6ef4a7c4b8ae7c8f0f8bce1cb5c65241be201a5e77cccf8bd7d52e7679"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2cb8497a38c5654358f025e9f8b0e70badd2a1369078a08c81e5b9a316e4c26a"
    sha256 cellar: :any_skip_relocation, sequoia:       "a2ba0987d481803552a2e8838f614ce8be56bfbe407b75d567426df93839f7f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "652f59835bfe4ca0f35feae2599406ab3c06caeb64695ca832152415f2af7b13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c63af567c17f223f9d09c4e9fb00ce551774cfff7957334b961b6c9ed0de145e"
  end

  depends_on "certifi"
  depends_on "python@3.13"

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/43/65/318323f98dbee45d42dff61d8f047181bc6f2268a9068cfad035a46be5af/beautifulsoup4-4.15.0.tar.gz"
    sha256 "288e3ca7d54b06f2ac191970bc275c1939cb46d450b255bf6718b04aa37ab4f7"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/a3/c2/24167ea9858356b47a87a50d39908bfdb72ceeefe0041586e704e5376b3a/certifi-2026.7.22.tar.gz"
    sha256 "741e2c3b351ddf169a738da9f2c048608ff7f2c5cc02f1ebc6b118bb090d5d55"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e5/3f/143b048436775b0f76ac3eec145c019e8173ccc2885c8f20319b996d5e83/charset_normalizer-3.5.1.tar.gz"
    sha256 "6117b84ea48435e5356dc737f5121485c30920ba43375fa7b434fd753df0eac3"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "ping3" do
    url "https://files.pythonhosted.org/packages/0d/e5/702dfb79e74990585d502734065f8a1610d18473bbd4bd18e4058abe9dbc/ping3-5.1.5.tar.gz"
    sha256 "6c99bc844e0b7dbc5c9765e8b530140daf1ccd2112c99db01ab79831bd8081cd"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/aa/c6/d1ddf4abb55e93cebc4f2ed8b5d6dbad109ecb8d63748dd2b20ab5e57ebe/psutil-7.2.2.tar.gz"
    sha256 "0746f5f8d406af344fd547f1c8daa5f5c33dbc293bb8d6a16d80b4bb88f59372"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/71/c3/1b817965ac12dc002d7c9cd7dfffdd7d4fbf9b45763ef2ffe7b86ee94670/soupsieve-2.10.tar.gz"
    sha256 "49e9380d7d2905463583bafe285e818c7366a9ed7b3aee221c1ac79c905d8bc0"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
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
