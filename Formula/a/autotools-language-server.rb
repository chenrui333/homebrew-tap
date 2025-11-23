class AutotoolsLanguageServer < Formula
  include Language::Python::Virtualenv

  desc "Language tools for Autotools, support configure.ac, Makefile.am, Makefile"
  homepage "https://github.com/Freed-Wu/autotools-language-server"
  url "https://files.pythonhosted.org/packages/54/84/5fcd5fb39c4857b9264e5b420bfa305f7a8063099e0372851dd0ec23fdf9/autotools_language_server-0.0.23.tar.gz"
  sha256 "fab272a1e049f854541f43c486bc8f73b9bde6e483245245f9d19c5273481964"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "550d40005047e644408b1e98f3b063607a7abd78214c8190f956e4d590b76ddc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00c11827853205db0d9987d0be70e43ab24c5d3a39d1a9baa29184c08d5f7a9d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0822dedcd4e5d707a5e675c4d01e71cd96609ce41b06ad000ce2552bba779064"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "155d0c160df2fc68829bc6930aaa5818ed2d79088561535f91bd86b7eb9e99a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cce201546405893776fbdb77d9e009859c94f978e19e3afce8bb19344c76a3a2"
  end

  depends_on "python@3.14"
  depends_on "rpds-py" => :no_linkage

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/6b/5c/685e6633917e101e5dcb62b9dd76946cbb57c26e133bae9e0cd36033c0a9/attrs-25.4.0.tar.gz"
    sha256 "16d5969b87f0859ef33a48b35d55ac1be6e42ae49d5e853b597db70c35c57e11"
  end

  resource "cattrs" do
    url "https://files.pythonhosted.org/packages/6e/00/2432bb2d445b39b5407f0a90e01b9a271475eea7caf913d7a86bcb956385/cattrs-25.3.0.tar.gz"
    sha256 "1ac88d9e5eda10436c4517e390a4142d88638fe682c436c93db7ce4a277b884a"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/74/69/f7185de793a29082a9f3c7728268ffb31cb5095131a9c139a74078e27336/jsonschema-4.25.1.tar.gz"
    sha256 "e4a9655ce0da0c0b67a085847e00a3a51449e1157f4f75e9fb5aa545e122eb85"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/19/74/a633ee74eb36c44aa6d1095e7cc5569bebf04342ee146178e2d36600708b/jsonschema_specifications-2025.9.1.tar.gz"
    sha256 "b540987f239e745613c7a9176f3edb72b832a4ac465cf02712288397832b5e8d"
  end

  resource "lsp-tree-sitter" do
    url "https://files.pythonhosted.org/packages/04/38/b539693b8222ceae26ef532f229d9ca57f294ed4dcb64dc771e082eec9a7/lsp_tree_sitter-0.1.1.tar.gz"
    sha256 "1668dd456e5669e9d6e102b2dd46952fd39d19573c19b8c985446e272d59128c"
  end

  resource "lsprotocol" do
    url "https://files.pythonhosted.org/packages/e9/26/67b84e6ec1402f0e6764ef3d2a0aaf9a79522cc1d37738f4e5bb0b21521a/lsprotocol-2025.0.0.tar.gz"
    sha256 "e879da2b9301e82cfc3e60d805630487ac2f7ab17492f4f5ba5aaba94fe56c29"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "pygls" do
    url "https://files.pythonhosted.org/packages/87/50/2bfc32f3acbc8941042919b59c9f592291127b55d7331b72e67ce7b62f08/pygls-2.0.0.tar.gz"
    sha256 "99accd03de1ca76fe1e7e317f0968ebccf7b9955afed6e2e3e188606a20b4f07"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/22/f5/df4e9027acead3ecc63e50fe1e36aca1523e1719559c499951bb4b53188f/referencing-0.37.0.tar.gz"
    sha256 "44aefc3142c5b842538163acb373e24cce6632bd54bdb01b21ad5863489f50d8"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/48/dc/95f074d43452b3ef5d06276696ece4b3b5d696e7c9ad7173c54b1390cd70/rpds_py-0.28.0.tar.gz"
    sha256 "abd4df20485a0983e2ca334a216249b6186d6e3c1627e106651943dbdb791aea"
  end

  resource "tree-sitter" do
    url "https://files.pythonhosted.org/packages/66/7c/0350cfc47faadc0d3cf7d8237a4e34032b3014ddf4a12ded9933e1648b55/tree-sitter-0.25.2.tar.gz"
    sha256 "fe43c158555da46723b28b52e058ad444195afd1db3ca7720c59a254544e9c20"
  end

  resource "tree-sitter-make" do
    url "https://files.pythonhosted.org/packages/b6/c9/4b534b0f8be76b5a7495419e7017998ceb1cd260ca91b4bf2358f00af97e/tree_sitter_make-1.1.1.tar.gz"
    sha256 "ef394673ab83956dffb3986526f4c059082ff2d84c87f9da18ab30030f561b4c"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    %w[autoconf-language-server autotools-language-server make-language-server].each do |f|
      assert_match version.to_s, shell_output("#{bin}/#{f} --version")
    end

    (testpath/"Makefile").write <<~EOF
      all:
      \t@echo "Hello, World!"
    EOF

    system bin/"make-language-server", "--check", testpath/"Makefile"
  end
end
