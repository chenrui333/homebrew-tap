class Amoco < Formula
  include Language::Python::Virtualenv

  desc "Yet another tool for analysing binaries"
  homepage "https://github.com/bdcht/amoco"
  url "https://github.com/bdcht/amoco/archive/refs/tags/v2.9.11.tar.gz"
  sha256 "5c741d7f7dacd886a10d9439a6593c07a8277847e3427a38d31f48cf0d51ab75"
  license "GPL-2.0-or-later" # TODO: need to upstream it

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "572d3bf8fc55f1f3d0cf4b17fe6f5e71d0cc8da3b3cc3db3cbed0af82b2be807"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3e6d653258d3a41052aaf2ea1cb19b3fa9c63c08803cd21090db83af5fb5da9"
    sha256 cellar: :any_skip_relocation, ventura:       "31782e0b2236560ecb424c9288fef23c61e2d6ff85ef8dd49431011ce2e9a281"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38b55a56f43a00db6aa671a88034da0a8530fe24c1d44ee1786b68cb73ee4ccf"
  end

  depends_on "python@3.13" => :build
  depends_on "python@3.13"

  resource "click" do
    url "https://files.pythonhosted.org/packages/b9/2e/0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8b/click-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
  end

  resource "crysp" do
    url "https://files.pythonhosted.org/packages/b9/04/f19d8b43147a2737c8f2d34b0e480af610592507222b332f73e5a10056af/crysp-1.2.tar.gz"
    sha256 "f95662a4f7f4fba0b6a43c73759d116cf90f1bfbbb9311dd473e011a5bad9363"
  end

  resource "grandalf" do
    url "https://files.pythonhosted.org/packages/95/0e/4ac934b416857969f9135dec17ac80660634327e003a870835dd1f382659/grandalf-0.8.tar.gz"
    sha256 "2813f7aab87f0d20f334a3162ccfbcbf085977134a17a5b516940a93a77ea974"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/7c/2d/c3338d48ea6cc0feb8446d8e6937e1408088a72a39937982cc6111d17f84/pygments-2.19.1.tar.gz"
    sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/8b/1a/3544f4f299a47911c2ab3710f534e52fea62a633c96806995da5d25be4b2/pyparsing-3.2.1.tar.gz"
    sha256 "61980854fd66de3a90028d679a954d5f2623e83144b5afe5ee86f43d762e5f0a"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/ab/3a/0316b28d0761c6734d6bc14e770d85506c986c85ffb239e688eeaab2c2bc/rich-13.9.4.tar.gz"
    sha256 "439594978a49a09530cff7ebc4b5c7103ef57baf48d5ea3184f21d9a2befa098"
  end

  resource "traitlets" do
    url "https://files.pythonhosted.org/packages/eb/79/72064e6a701c2183016abbbfedaba506d81e30e232a68c9f0d6f6fcd1574/traitlets-5.14.3.tar.gz"
    sha256 "9ed0579d3502c94b4b3732ac120375cda96f923114522847de4b3bb98b96b6b7"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"amoco", "--help"

    output = shell_output("#{bin}/amoco bin_info --header #{bin}/amoco 2>&1", 1)

    # [10:32:52] WARNING  amoco.system.core: unknown format
    #            WARNING  amoco.system.raw: a cpu module must be imported
    #            INFO     amoco.system.core: a new task is loaded /opt/homebrew/Cellar/amoco/2.9.11/bin/amoco >
    #                     RawExec
    # file:
    # <amoco.ui.render.vltable object at 0x10662af90>
    # checksec:

    # header:
    assert_match "WARNING  amoco.system.core: unknown format", output
    assert_match "WARNING  amoco.system.raw: a cpu module must be imported", output
    assert_match "INFO     amoco.system.core: a new task is loaded", output
  end
end
