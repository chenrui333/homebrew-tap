# NOTE: austin-tui needs austin@3 to work properly
class AustinTui < Formula
  include Language::Python::Virtualenv

  desc "Top-like text-based user interface for Austin"
  homepage "https://github.com/P403n1x87/austin-tui"
  url "https://files.pythonhosted.org/packages/53/70/2daad7d732eeaf41fe0459a20ecc346353bfb6b2406a098b7a9175e20bc7/austin_tui-1.5.0.tar.gz"
  sha256 "89abb086942c6dff49d5048cfbf0bb5beb2ebf0385b58294d2d10b7015183ead"
  license "GPL-3.0-or-later"
  head "https://github.com/P403n1x87/austin-tui.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c7990de246a16dcb7e693690a272e02622915be5095095e4544f2542a876c5c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "435565c3ba9fb89d6b0da06e682ff42de569bc8e1131aa72f46afc456702c300"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2fd7f38994f1ab40c5868fb787574f81e8ec06f1b473fa42337ab70f39a6a73"
    sha256 cellar: :any_skip_relocation, sequoia:       "befb9f40f92bf96a6588bd5a3bfe7df6f45037f3ad587ac6773a763b61dc26ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e1cd03527c907fbb88302ac59f24f902f4c4f28daf81853a68d6db1d5c89a07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b31f51149f2dde386b656acbe0324b5315b08de4e4b2665786eea57fffe2d426"
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

    output, status = Open3.capture2e(bin/"austin-tui", "--version")
    assert_includes [1, 255], status.exitstatus
    assert_match "Austin failed to start", output
    assert_match "Some arguments were left unparsed", output
  end
end
