class Amoco < Formula
  include Language::Python::Virtualenv

  desc "Yet another tool for analysing binaries"
  homepage "https://github.com/bdcht/amoco"
  url "https://github.com/bdcht/amoco/archive/refs/tags/v2.9.11.tar.gz"
  sha256 "5c741d7f7dacd886a10d9439a6593c07a8277847e3427a38d31f48cf0d51ab75"
  license "GPL-2.0-or-later" # TODO: need to upstream it

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "92e1836249525338e58f7c966af223c74ef7243ac763098cce5692aba40411d3"
  end

  depends_on "python@3.14"

  resource "click" do
    url "https://files.pythonhosted.org/packages/46/61/de6cd827efad202d7057d93e0fed9294b96952e188f7384832791c7b2254/click-8.3.0.tar.gz"
    sha256 "e7b8232224eba16f4ebe410c25ced9f7875cb5f3263ffc93cc3e8da705e229c4"
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
    url "https://files.pythonhosted.org/packages/5b/f5/4ec618ed16cc4f8fb3b701563655a69816155e79e24a17b651541804721d/markdown_it_py-4.0.0.tar.gz"
    sha256 "cb0a2b4aa34f932c007117b194e945bd74e0ec24133ceb5bac59009cda1cb9f3"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/f2/a5/181488fc2b9d093e3972d2a472855aae8a03f000592dbfce716a512b3359/pyparsing-3.2.5.tar.gz"
    sha256 "2df8d5b7b2802ef88e8d016a2eb9c7aeaa923529cd251ed0fe4608275d4105b6"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/fb/d2/8920e102050a0de7bfabeb4c4614a49248cf8d5d7a8d01885fbb24dc767a/rich-14.2.0.tar.gz"
    sha256 "73ff50c7c0c1c77c8243079283f4edb376f0f6442433aecb8ce7e6d0b92d1fe4"
  end

  resource "traitlets" do
    url "https://files.pythonhosted.org/packages/eb/79/72064e6a701c2183016abbbfedaba506d81e30e232a68c9f0d6f6fcd1574/traitlets-5.14.3.tar.gz"
    sha256 "9ed0579d3502c94b4b3732ac120375cda96f923114522847de4b3bb98b96b6b7"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"amoco", shells: [:fish, :zsh], shell_parameter_format: :click)
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
