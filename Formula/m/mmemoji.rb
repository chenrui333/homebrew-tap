class Mmemoji < Formula
  include Language::Python::Virtualenv

  desc "Custom Emoji manager command-line for Mattermost"
  homepage "https://github.com/maxbrunet/mmemoji"
  url "https://files.pythonhosted.org/packages/07/bd/26a107eb89de7b272f04b486b35564582a909d2c02c50c6e6e10ff8b23a0/mmemoji-0.6.0.tar.gz"
  sha256 "767db07a08f44dc3aae4989d1046a820d89fc49be643402879bf813ca3af4e8f"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c9354fdc348632b5d73dfc3d6b22ebe76f2fad42a541aab1878640476e28978f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c6e5f159dcbd77b325581f75dbb827d6eb1419f0cb6aafc40b114d883a4dc1ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e1b1bfdf2eb08e955618d7b047a68559ea03ed2d295b7b8599a8d698dfcf939"
    sha256 cellar: :any_skip_relocation, sequoia:       "0b7b90e5a7b74c84f7693388f499a4f568e433b3e6f21d0cf6b1ffeefd3a22cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b63a61be4a8a46e9c889e8d765b8b28ecba0c3c0121eb7a85a1082e61d57c37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c45a1b79bcbd0c957ac15e1f5346035bca752e896a06eefb5d7256211e087a3d"
  end

  depends_on "certifi" => :no_linkage
  depends_on "python@3.13"

  pypi_packages exclude_packages: "certifi"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/46/61/de6cd827efad202d7057d93e0fed9294b96952e188f7384832791c7b2254/click-8.3.0.tar.gz"
    sha256 "e7b8232224eba16f4ebe410c25ced9f7875cb5f3263ffc93cc3e8da705e229c4"
  end

  resource "filetype" do
    url "https://files.pythonhosted.org/packages/bb/29/745f7d30d47fe0f251d3ad3dc2978a23141917661998763bebb6da007eb1/filetype-1.2.0.tar.gz"
    sha256 "66b56cd6474bf41d8c54660347d37afcc3f7d1970648de365c102ef77548aadb"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "mattermostdriver" do
    url "https://files.pythonhosted.org/packages/b7/01/3a62b245848e95eda10525dd47b50cc97f6171a6902fbff95f7d182afea6/mattermostdriver-7.3.2.tar.gz"
    sha256 "2e4d7b4a17d3013e279c6f993746ea18cd60b45d8fa3be24f47bc2de22b9b3b4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/ec/fe/802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1/tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "unidecode" do
    url "https://files.pythonhosted.org/packages/94/7d/a8a765761bbc0c836e397a2e48d498305a865b70a8600fd7a942e85dcf63/Unidecode-1.4.0.tar.gz"
    sha256 "ce35985008338b676573023acc382d62c264f307c8f7963733405add37ea2b23"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/21/e6/26d09fab466b7ca9c7737474c52be4f76a40301b08362eb2dbc19dcc16c1/websockets-15.0.1.tar.gz"
    sha256 "82544de02076bafba038ce055ee6412d68da13ab47f0c60cab827346de828dee"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"mmemoji", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mmemoji --version")

    output = shell_output("#{bin}/mmemoji create --no-clobber parrots/guests/hd/*.gif parrots/guests/*.gif 2>&1", 2)
    assert_match "Invalid value", output
  end
end
