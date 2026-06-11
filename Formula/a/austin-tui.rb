# NOTE: austin-tui needs austin@3 to work properly
class AustinTui < Formula
  include Language::Python::Virtualenv

  desc "Top-like text-based user interface for Austin"
  homepage "https://github.com/P403n1x87/austin-tui"
  url "https://files.pythonhosted.org/packages/e6/68/f4ed76675f8dfc13f883422bdc5cf8837fc86c2affb06c447c9a074122b7/austin_tui-2.1.0.tar.gz"
  sha256 "4e474c134852ff315f92ee456b6e1a59dfb1c4ae9cd2a42d46a25236410bff9b"
  license "GPL-3.0-or-later"
  head "https://github.com/P403n1x87/austin-tui.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b46d3fe341ff9d509ed12dc639d540294186795c046189d0439b86a85fb7de25"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79a24a6e1fe69f427a6e0e6b6049e46e56ac9c5316615910a2f9e1d17c0de194"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48c05ff5f13a7085e84eff80393503c17c550b9d4986d6b3f07108c6687eb71a"
    sha256 cellar: :any_skip_relocation, sequoia:       "a529451c486537896149a2aa1bd839451486d42999e0b5f042e070a71ce9969f"
    sha256 cellar: :any,                 arm64_linux:   "04ebc29122aeb190e6d59445fed2865a80cf84b4946ea34f313bc5e6581f91b8"
    sha256 cellar: :any,                 x86_64_linux:  "ed451d60e0273d42f8e5b462b61eb90b34cd1c435ad99e7d2a70442a655ab0e7"
  end

  depends_on "python@3.14"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "austin-python" do
    url "https://files.pythonhosted.org/packages/07/f0/690fe6927dddbb3f9daa546dcac6817073b1ece72af20b398cce35edd10c/austin_python-2.2.0.tar.gz"
    sha256 "c546f6c57410332b3734c2b96451c1fd409d883ddaeac39e085c497f6ff1e408"
  end

  resource "importlib-resources" do
    url "https://files.pythonhosted.org/packages/a5/f1/8711c49ffd121083007a24c1bff0d324c9ff621d4fdf8b4ffcb8d9e60330/importlib_resources-5.13.0.tar.gz"
    sha256 "82d5c6cca930697dbbd86c93333bb2c2e72861d4789a11c2662b933e5ad2b528"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/05/3b/aab6728cae887456f409b4d75e8a01856e4f04bd510de38052a47768b680/lxml-6.1.1.tar.gz"
    sha256 "ba96ae44888e0185281e937633a743ea90d5a196c6000f82565ebb0580012d40"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/55/5b/e3d951e34f8356e5feecacd12a8e3b258a1da6d9a03ad1770f28925f29bc/protobuf-3.20.3.tar.gz"
    sha256 "2e3427429c9cffebf259491be0af70189607f365c2f41c7c3764af6f337105f2"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/aa/c6/d1ddf4abb55e93cebc4f2ed8b5d6dbad109ecb8d63748dd2b20ab5e57ebe/psutil-7.2.2.tar.gz"
    sha256 "0746f5f8d406af344fd547f1c8daa5f5c33dbc293bb8d6a16d80b4bb88f59372"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/0d/1c/73e719955c59b8e424d015ab450f51c0af856ae46ea2da83eba51cc88de1/setuptools-81.0.0.tar.gz"
    sha256 "487b53915f52501f0a79ccfd0c02c165ffe06631443a886740b91af4b7a5845a"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  def install
    venv = virtualenv_create(libexec, "python3.14")
    venv.pip_install resource("setuptools"), build_isolation: false
    venv.pip_install resource("protobuf"), build_isolation: false
    venv.pip_install resources.reject { |r| %w[setuptools protobuf].include?(r.name) }
    venv.pip_install_and_link buildpath
  end

  test do
    require "open3"

    python = Formula["python@3.14"].opt_bin/"python3.14"
    output, status = Open3.capture2e(bin/"austin-tui", "--version", python, "-c", "print('hi')")
    assert_includes [1, 255], status.exitstatus
    assert_match "Some arguments were left unparsed", output
  end
end
