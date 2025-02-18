class Mmemoji < Formula
  include Language::Python::Virtualenv

  desc "Custom Emoji manager command-line for Mattermost"
  homepage "https://github.com/bdcht/amoco"
  url "https://files.pythonhosted.org/packages/07/bd/26a107eb89de7b272f04b486b35564582a909d2c02c50c6e6e10ff8b23a0/mmemoji-0.6.0.tar.gz"
  sha256 "767db07a08f44dc3aae4989d1046a820d89fc49be643402879bf813ca3af4e8f"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32f2909aa8c82e932b1f48af336fc184f4cc7d4e8f68ccf5e6c3f8f94fb33097"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "65d16f7291a64bab151f198a0e82e655ceb328108f42309667153e2e3f029bc3"
    sha256 cellar: :any_skip_relocation, ventura:       "d9cd04f7bcab5c716f9c99868934e2a3e1002c71005c4511c1c90bdf84487c49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "291852cc559d40ecd40cd50b2ec27f52aeb62bc384711861bb246e484437f5fb"
  end

  depends_on "python@3.13"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/1c/ab/c9f1e32b7b1bf505bf26f0ef697775960db7932abeb7b516de930ba2705f/certifi-2025.1.31.tar.gz"
    sha256 "3d5da6925056f6f18f119200434a4780a94263f10d1c21d032a6f6b2baa20651"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/16/b0/572805e227f01586461c80e0fd25d65a2115599cc9dad142fee4b747c357/charset_normalizer-3.4.1.tar.gz"
    sha256 "44251f18cd68a75b56585dd00dae26183e102cd5e0f9f1466e6df5da2ed64ea3"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/b9/2e/0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8b/click-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
  end

  resource "filetype" do
    url "https://files.pythonhosted.org/packages/bb/29/745f7d30d47fe0f251d3ad3dc2978a23141917661998763bebb6da007eb1/filetype-1.2.0.tar.gz"
    sha256 "66b56cd6474bf41d8c54660347d37afcc3f7d1970648de365c102ef77548aadb"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "mattermostdriver" do
    url "https://files.pythonhosted.org/packages/b7/01/3a62b245848e95eda10525dd47b50cc97f6171a6902fbff95f7d182afea6/mattermostdriver-7.3.2.tar.gz"
    sha256 "2e4d7b4a17d3013e279c6f993746ea18cd60b45d8fa3be24f47bc2de22b9b3b4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/ec/fe/802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1/tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "unidecode" do
    url "https://files.pythonhosted.org/packages/f7/89/19151076a006b9ac0dd37b1354e031f5297891ee507eb624755e58e10d3e/Unidecode-1.3.8.tar.gz"
    sha256 "cfdb349d46ed3873ece4586b96aa75258726e2fa8ec21d6f00a591d98806c2f4"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/aa/63/e53da845320b757bf29ef6a9062f5c669fe997973f966045cb019c3f4b66/urllib3-2.3.0.tar.gz"
    sha256 "f8c5449b3cf0861679ce7e0503c7b44b5ec981bec0d1d3795a07f1ba96f0204d"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/2e/7a/8bc4d15af7ff30f7ba34f9a172063bfcee9f5001d7cef04bee800a658f33/websockets-15.0.tar.gz"
    sha256 "ca36151289a15b39d8d683fd8b7abbe26fc50be311066c5f8dcf3cb8cee107ab"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mmemoji --version")

    output = shell_output("#{bin}/mmemoji create --no-clobber parrots/guests/hd/*.gif parrots/guests/*.gif 2>&1", 2)
    assert_match "Invalid value", output
  end
end
