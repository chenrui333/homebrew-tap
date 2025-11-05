# NOTE: austin-tui needs austin@3 to work properly
class AustinTui < Formula
  include Language::Python::Virtualenv

  desc "Top-like text-based user interface for Austin"
  homepage "https://github.com/P403n1x87/austin-tui"
  url "https://files.pythonhosted.org/packages/ea/e8/5e17d176d3a3464573cffaef94d4bfa8bf710f5d88f1ad3859e199e6efc7/austin_tui-1.4.0.tar.gz"
  sha256 "bf607c175fc770101ebdcf3a7ab69f10339e76524f8019d0dccdce335ccc232c"
  license "GPL-3.0-or-later"
  head "https://github.com/P403n1x87/austin-tui.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ed73b565620117301ac3f9a6c293c462fb3c9bdd5ed479373b33be8f635b29d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd1fd9e917534ae1e3ef0c637f03b6e498c1304f2f207e7b93ef6445949eaa8d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "878c1b691800dd5f2b7d9b4a12738f72c1fa26d00997b438cd933567131b1438"
    sha256 cellar: :any_skip_relocation, sequoia:       "606ab63f6f499a80b2041642dbf120b3dae68ff901d9ff58518b3d6488498d10"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc2e482c80a4e9e848456dddeb32a6d7192a3e71dab31576def7d62688df0afa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab8186b29708aebe2ce20cd4170e4d9642508f259de6d9d0e08344715aeea826"
  end

  depends_on "python@3.13"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "austin-python" do
    url "https://files.pythonhosted.org/packages/45/78/148907bd43a874917b380430586d2067d49289e67f903c740481c4a82fc6/austin_python-2.1.2.tar.gz"
    sha256 "6821bfc8918a3bddb7be34f3c913e385333f53edf27e293232e33a5c6346ac59"
  end

  resource "importlib-resources" do
    url "https://files.pythonhosted.org/packages/a5/f1/8711c49ffd121083007a24c1bff0d324c9ff621d4fdf8b4ffcb8d9e60330/importlib_resources-5.13.0.tar.gz"
    sha256 "82d5c6cca930697dbbd86c93333bb2c2e72861d4789a11c2662b933e5ad2b528"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/76/3d/14e82fc7c8fb1b7761f7e748fd47e2ec8276d137b6acfe5a4bb73853e08f/lxml-5.4.0.tar.gz"
    sha256 "d12832e1dbea4be280b22fd0ea7c9b87f0d8fc51ba06e92dc62d52f804f78ebd"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/55/5b/e3d951e34f8356e5feecacd12a8e3b258a1da6d9a03ad1770f28925f29bc/protobuf-3.20.3.tar.gz"
    sha256 "2e3427429c9cffebf259491be0af70189607f365c2f41c7c3764af6f337105f2"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/e1/88/bdd0a41e5857d5d703287598cbf08dad90aed56774ea52ae071bae9071b6/psutil-7.1.3.tar.gz"
    sha256 "6c86281738d77335af7aec228328e944b30930899ea760ecf33a4dba66be5e74"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/austin-tui --version 2>&1", 1)
    assert_match "🏁 Starting the Austin TUI", output
  end
end
