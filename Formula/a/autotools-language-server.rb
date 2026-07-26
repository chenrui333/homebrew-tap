class AutotoolsLanguageServer < Formula
  include Language::Python::Virtualenv

  desc "Language tools for Autotools, support configure.ac, Makefile.am, Makefile"
  homepage "https://github.com/Freed-Wu/autotools-language-server"
  url "https://files.pythonhosted.org/packages/99/78/379b8e284a833edc4c9e01ba2fe0f74208686d77a1fdceae32325051049c/autotools_language_server-0.1.3.tar.gz"
  sha256 "1adc7ba8627533c141533d2da974d615a2f58214527759424d1fdfb6f0953401"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "396a0fa31f1d4f12db0147f311b6afcd9d9ec6493ca5496288091c42d792e910"
    sha256 cellar: :any, arm64_sequoia: "bb40303bac8d41c686b8ab63781db08f51342cd77ceda4455c84f33416b5a60c"
    sha256 cellar: :any, arm64_sonoma:  "d2a5961c5454802e448a4a63929672f85abb6560143166e94ccfdd281c281a15"
    sha256 cellar: :any, arm64_linux:   "282206428f89f8daf0fdc7be67dbd21e2a80b9a7cf414aeb7d7839d71ecafacb"
    sha256 cellar: :any, x86_64_linux:  "8c335d0b09ac386d78108e3009bf35980f064111f37741e63c3cc2b46ce18298"
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

  resource "jq" do
    url "https://files.pythonhosted.org/packages/95/ec/3da01457bbd3c6a2fc8fea6736c0b657ffc628e3decbfb1fafcf33dc7dbe/jq-1.12.0.tar.gz"
    sha256 "729b2d3418c8ca7dccfaa66b9fb7a98bec28474212650d27c5c04358ce26f55c"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/b3/fc/e067678238fa451312d4c62bf6e6cf5ec56375422aee02f9cb5f909b3047/jsonschema-4.26.0.tar.gz"
    sha256 "0c26707e2efad8aa1bfc5b7ce170f3fccc2e4918ff85989ba9ffa9facb2be326"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/19/74/a633ee74eb36c44aa6d1095e7cc5569bebf04342ee146178e2d36600708b/jsonschema_specifications-2025.9.1.tar.gz"
    sha256 "b540987f239e745613c7a9176f3edb72b832a4ac465cf02712288397832b5e8d"
  end

  resource "lsp-tree-sitter" do
    url "https://files.pythonhosted.org/packages/2f/29/8f7ee3b35b2e18df80d418e657e89b630c0c825226efd55e045e7bf612dd/lsp_tree_sitter-0.2.15.tar.gz"
    sha256 "ecdfcbb5e7327df16b9d34487c32b54cd8e39d701a0a1c219df672dd68b2672f"
  end

  resource "lsprotocol" do
    url "https://files.pythonhosted.org/packages/e9/26/67b84e6ec1402f0e6764ef3d2a0aaf9a79522cc1d37738f4e5bb0b21521a/lsprotocol-2025.0.0.tar.gz"
    sha256 "e879da2b9301e82cfc3e60d805630487ac2f7ab17492f4f5ba5aaba94fe56c29"
  end

  resource "pygls" do
    url "https://files.pythonhosted.org/packages/da/2e/7bbe061d175c0baddde8fc9edb908a4c31ba5d9165b8c68e3439c3a9f138/pygls-2.1.1.tar.gz"
    sha256 "1da03ba9053201bb337dcdd8d121df70feb2a91e1a0dcc74de5da79755b1a201"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/22/f5/df4e9027acead3ecc63e50fe1e36aca1523e1719559c499951bb4b53188f/referencing-0.37.0.tar.gz"
    sha256 "44aefc3142c5b842538163acb373e24cce6632bd54bdb01b21ad5863489f50d8"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/aa/2a/9618a122aeb2a169a28b03889a2995fe297588964333d4a7d67bdf46e147/rpds_py-2026.6.3.tar.gz"
    sha256 "1cebd1337c242e4ec2293e541f712b2da849b29f48f0c293684b71c0632625d4"
  end

  resource "tree-sitter" do
    url "https://files.pythonhosted.org/packages/f7/03/5600b84aff2e6c4fe80cfebb4063fe2f50299521befe5f6092ab8c082f4a/tree_sitter-0.26.0.tar.gz"
    sha256 "b40c219edccc4564530c96f8f1556f6202b37cda964d1cbd7bd2b7e68b40a245"
  end

  resource "tree-sitter-autoconf" do
    url "https://files.pythonhosted.org/packages/35/2c/56cf88c33c18ef3e73fda2358723f14529eae6dcc7be484f5d6e12731fa6/tree_sitter_autoconf-0.0.4.tar.gz"
    sha256 "3cbf941b7673981ace4ae1d5b6800a33afa69b3419884a157968a8b211c88416"
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
