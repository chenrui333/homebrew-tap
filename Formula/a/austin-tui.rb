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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3f5c420c57a12fbb4dd4a12c313b5416c43d6a2b72806f2f932979b326faf7e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ebc688ac12987165577211523e30c74ea7f11976e07a5a47f51e5251aba3100d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d979eb5e42ce09913af640692f7d55940adc491e503e460d635738d8c76c92f"
    sha256 cellar: :any_skip_relocation, sequoia:       "94d3b409f62fac61de6acc47baa93dc924965c5615a5043c961d902c72f57721"
    sha256 cellar: :any,                 arm64_linux:   "6add6ad0d3f25339dcd910e6df13bf00513086b5bfa6e8efe38a368e77d888f5"
    sha256 cellar: :any,                 x86_64_linux:  "a3107aeb3af584f3639f18ba05cb0d324b0fa119192d575d3ab798b85b0fea18"
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
