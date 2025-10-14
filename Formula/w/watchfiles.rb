class Watchfiles < Formula
  include Language::Python::Virtualenv

  desc "Simple, modern and high performance file watching and code reload in python"
  homepage "https://watchfiles.helpmanual.io/"
  url "https://files.pythonhosted.org/packages/c2/c9/8869df9b2a2d6c59d79220a4db37679e74f807c559ffe5265e08b227a210/watchfiles-1.1.1.tar.gz"
  sha256 "a173cb5c16c4f40ab19cecf48a534c409f7ea983ab8fed0741304a1c0a31b3f2"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "c075b4b920330d62f2bcf4a1c0854a2d2e5dbdd9fc1dd8bfbcd8edff4ea6b147"
    sha256 cellar: :any,                 arm64_sequoia: "c236a98deda3e4961b5de05fabc7641ef7a9007fd63fe4995c5999ef4b24c0e4"
    sha256 cellar: :any,                 arm64_sonoma:  "ff8c7698686c84c9e5097285f81b1a6d00665c2bb5c5a91b67887a6f831808be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3eb4a4710c29f42f759e97ecef19da39bac3ebe048315402a920746fc2f0e6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72ef269a6aa76bc257371b12bc11d74d9fcea5804b8c6669c9cf9e8176b0f620"
  end

  depends_on "rust" => :build
  depends_on "python@3.13"

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/c6/78/7d432127c41b50bccba979505f272c16cbcadcc33645d5fa3a738110ae75/anyio-4.11.0.tar.gz"
    sha256 "82a8d0b81e318cc5ce71a5f1f8b5c4e63619620b63141ef8c995fa0db95a57c4"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/watchfiles --version")
  end
end
