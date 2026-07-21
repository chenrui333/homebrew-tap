class AutotoolsLanguageServer < Formula
  include Language::Python::Virtualenv

  desc "Language tools for Autotools, support configure.ac, Makefile.am, Makefile"
  homepage "https://github.com/Freed-Wu/autotools-language-server"
  url "https://files.pythonhosted.org/packages/03/94/8b6928d8bea79a97c573715e3a105152a13bf04a000ca6134c90afc3a548/autotools_language_server-0.1.1.tar.gz"
  sha256 "f900d26e1bce034304905ec41b709415a38785e4a41ab0bbb170454ff3e0093a"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "d7a0eecd8aad41853bf95992c43a6bee41b79aac5c04debe984783eeeb36c34b"
    sha256 cellar: :any,                 arm64_sequoia: "46403d10a49a01b7fecca49c012be6d7ba516d29c9dca9eb3ca15f0c35a4f93b"
    sha256 cellar: :any,                 arm64_sonoma:  "3af3c1f01356ae5c841b3d282f5adb4991625e6bf6fa7e9985b4fcf797138ce2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd8624f7478f86fd112655a963e6340089ee2e7b978f7c0e31b23414f67d0afc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6cb19984b1aa0da391bf1c44c8a3fd82e33bda0a46a62722869943ec546d3e3"
  end

  depends_on "rust" => :build # for rpds-py
  depends_on "python@3.14"
  depends_on "rpds-py" => :no_linkage

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "cattrs" do
    url "https://files.pythonhosted.org/packages/a0/ec/ba18945e7d6e55a58364d9fb2e46049c1c2998b3d805f19b703f14e81057/cattrs-26.1.0.tar.gz"
    sha256 "fa239e0f0ec0715ba34852ce813986dfed1e12117e209b816ab87401271cdd40"
  end

  resource "lsprotocol" do
    url "https://files.pythonhosted.org/packages/e9/26/67b84e6ec1402f0e6764ef3d2a0aaf9a79522cc1d37738f4e5bb0b21521a/lsprotocol-2025.0.0.tar.gz"
    sha256 "e879da2b9301e82cfc3e60d805630487ac2f7ab17492f4f5ba5aaba94fe56c29"
  end

  resource "pygls" do
    url "https://files.pythonhosted.org/packages/da/2e/7bbe061d175c0baddde8fc9edb908a4c31ba5d9165b8c68e3439c3a9f138/pygls-2.1.1.tar.gz"
    sha256 "1da03ba9053201bb337dcdd8d121df70feb2a91e1a0dcc74de5da79755b1a201"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"processId":null,"rootUri":null,"capabilities":{}}}
    JSON
    input = "Content-Length: #{json.bytesize}\r\n\r\n#{json}"
    output = pipe_output((bin/"autotools-language-server").to_s, input, 0)

    assert_match version.to_s, output
    assert_match "completionProvider", output
  end
end
