class Mmemoji < Formula
  include Language::Python::Virtualenv

  desc "Custom Emoji manager command-line for Mattermost"
  homepage "https://github.com/maxbrunet/mmemoji"
  url "https://files.pythonhosted.org/packages/07/bd/26a107eb89de7b272f04b486b35564582a909d2c02c50c6e6e10ff8b23a0/mmemoji-0.6.0.tar.gz"
  sha256 "767db07a08f44dc3aae4989d1046a820d89fc49be643402879bf813ca3af4e8f"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2ec8fd2d4f3aec4e8901d3c2e8d5a270fca24232b9368b7d992356892bfd6127"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3150b5a5c71aa5df93be57b510137d0476147aa5d0dc95fcfa634b6736254ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37689c796cf20374a0c6e53e26cf432800861783f09e5b99d541670f3b202b75"
    sha256 cellar: :any_skip_relocation, sequoia:       "4c0aeb8234f05bceacda6a73267f7f5d84fcaeaf4193a23ac33ad6e0a4d4d180"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84dec6590b3b67a4ca8a8ea1c1b9b9077620d4ccf45f32160edfe1ae24f421d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fcae933ed9f2e98d09d008eace37495dcf7a5af54e9efaab55779395b62b66a6"
  end

  depends_on "certifi" => :no_linkage
  depends_on "python@3.14"

  pypi_packages exclude_packages: "certifi"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/3d/fa/656b739db8587d7b5dfa22e22ed02566950fbfbcdc20311993483657a5c0/click-8.3.1.tar.gz"
    sha256 "12ff4785d337a1bb490bb7e9c2b1ee5da3112e94a8622f26a6c77f5d2fc6842a"
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
