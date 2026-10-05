class Rogallo < Formula
  include Language::Python::Virtualenv

  desc "Terminal client for Gemini and other small web protocols"
  homepage "https://github.com/davep/rogallo"
  url "https://github.com/davep/rogallo/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "6a879edc20d49e6b75f245239ca691f76c726b82b418abc1bd780993026d2cfb"
  license "GPL-3.0-or-later"
  head "https://github.com/davep/rogallo.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ea05fa4d989b36a38439da38b5ae1e8ffefbf3dd1e97a3b9d248ea42e519c848"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70a892239ad185d39d577cb1a8b182c6c49bb91adf800415f15ce95690216d06"
    sha256 cellar: :any,                 arm64_linux:   "83e0df9386e42f2d405582c1d6a3264b75187cd5840ad0c948dc52ef2e71b1c6"
    sha256 cellar: :any,                 x86_64_linux:  "7c6a165d0d5be024060bb7efd33bd21441c1459d1627c85d2c30dae33cca6f61"
  end

  depends_on "rust" => :build
  depends_on "cryptography" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.14"

  resource "bagofstuff" do
    url "https://files.pythonhosted.org/packages/ff/52/020cf95233d6838920e3dfad6e4b4b1df6ce8d42646a8a094f9003356d97/bagofstuff-2.0.0.tar.gz"
    sha256 "423604e10179ec61af1f3a62f8c61aeaa2383040fdea67175f5c43d50e829a44"
  end

  resource "finger2gemtext" do
    url "https://files.pythonhosted.org/packages/68/e4/18cd643abb1cec703789fc315b240274d34297c887868c38e113e0d0c26c/finger2gemtext-0.1.0.tar.gz"
    sha256 "7bbfa97852018d9b8013143540a4a216844ee0f100ae0b4f133ac6555fc74d19"
  end
  resource "gemtext" do
    url "https://files.pythonhosted.org/packages/5d/0e/42d7dba3d43ba12565838d674fecee40db12cd15be92ac58a7309bea7218/gemtext-1.1.0.tar.gz"
    sha256 "d8e0d89994c3d462c416886280b2ff3abfbcd57e3230b8b449bc7fee3b7c3535"
  end

  resource "gophermap" do
    url "https://files.pythonhosted.org/packages/72/85/9372edf76d3f19ba23da9da0ceb1512216bde502b7a5cbf08450d02e725c/gophermap-1.1.0.tar.gz"
    sha256 "050f75d63a7bde70cd74a8acd23520584a84ed11a9426b9f701991988195d4b5"
  end

  resource "html2gemtext" do
    url "https://files.pythonhosted.org/packages/89/44/945f75b007ea424defb3a078885120e75d79a3a0da164095df2b090811d9/html2gemtext-1.0.0.tar.gz"
    sha256 "db50e385bb7374868988f2e0bcd8d74f19791c3d32d1f6049ed5a57dba15b0ab"
  end

  resource "linkify-it-py" do
    url "https://files.pythonhosted.org/packages/45/98/7a1a5f31fd5c7ba93e963b168e244b8e3dd705b3d2a718e3c3307583bf57/linkify_it_py-2.2.0.tar.gz"
    sha256 "907acd2d17ac1fbb9ddb62c8957ccbd6158cac602231a15c3b0cd1e215f03cee"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "md2gemtext" do
    url "https://files.pythonhosted.org/packages/a7/bd/439b7407e528fe8ebc8e0703e321c1ff9efba446db436ebe8ab1329efc6f/md2gemtext-1.0.0.tar.gz"
    sha256 "a7ec50d305acd3c629638e44a874b7db69b5264753a193a892f78a7a78c8cc93"
  end

  resource "mdit-py-plugins" do
    url "https://files.pythonhosted.org/packages/59/fc/f8d0863f8862f25602c0404d75568e89fb6b4109804645e5cdfb1be5cf56/mdit_py_plugins-0.6.1.tar.gz"
    sha256 "a2bca0f039f39dbd35fb74ae1b5f998608c437463371f0ff7f49a19a17a114d0"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/ea/06/cf1564dcc2e2261c8c8c6c05628dc8b418943bdae2a4e58640ceb2f770fa/platformdirs-4.11.5.tar.gz"
    sha256 "e8b31f4f8bcbbedef91a6b57a706255e4f148d2a4e01648382a0a47342539173"
  end

  resource "port1900" do
    url "https://files.pythonhosted.org/packages/a2/d5/41ab19e81cef480540619eaffdd22e17467635c7a95e36b7856d68cd6b86/port1900-1.0.0.tar.gz"
    sha256 "86acdf5070e5ee8abb878d41ce55d1b48dd521efca591fed54b869415991e115"
  end

  resource "port70" do
    url "https://files.pythonhosted.org/packages/a0/fc/cd64e080aee9887618105bb414cf56e71c0b745cc421f0e12c49a7fd0373/port70-1.0.0.tar.gz"
    sha256 "c5f58df5c7f1d6f42d95e4456e9878357b3d8827d7c7a377045ba529043cc050"
  end

  resource "port79" do
    url "https://files.pythonhosted.org/packages/71/00/86159a02077c71a1cfb1a95ba88fbb83c51301bad003cfabdf4ec96dc45f/port79-1.1.0.tar.gz"
    sha256 "19580cec81dbbdae05668d6cd5f98b22ecc38f2cfa596e457b942ad5eee362cf"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/e8/52/d87eba7cb129b81563019d1679026e7a112ef76855d6159d24754dbd2a51/pyperclip-1.11.0.tar.gz"
    sha256 "244035963e4428530d9e3a6101a1ef97209c6825edab1567beac148ccc1db1b6"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "sybaritic" do
    url "https://files.pythonhosted.org/packages/0c/ba/a90c561bca6d1946dc2c897c9ed797ad65a4b1a883d641b79dd8577ca33c/sybaritic-1.0.0.tar.gz"
    sha256 "5b7dec90e9618fee55de023294eefb11a7e5c441541c053d87e565acea2fbe65"
  end

  resource "textual" do
    url "https://files.pythonhosted.org/packages/00/21/39a76b01bd5eea82a04baaca7580e105d8c59450df03998345bb2cfb307b/textual-8.2.8.tar.gz"
    sha256 "3f106a9fbc73e39dd266c9712432087de78a6d644084c7c241d6a25c3169115b"
  end

  resource "textual-enhanced" do
    url "https://files.pythonhosted.org/packages/ee/b6/ac6d8d55e730c57ce8dea1565cd730a345f1f1fed771d7278f13170748a0/textual_enhanced-1.6.0.tar.gz"
    sha256 "5976b608854b5b2550d48810be7f4455a648f4976ce632d643a9a37a05fa67b1"
  end

  resource "textual-fspicker" do
    url "https://files.pythonhosted.org/packages/34/1d/1c078f971363d6b2fcfcccf3008b3c6d98cb78ba92d4d6152051bfeec76e/textual_fspicker-1.0.1.tar.gz"
    sha256 "58f7fa983ded7a5ed69b7279f66de57a0ef6fad0e3acb622f217682e85986c9c"
  end

  resource "types-pygments" do
    url "https://files.pythonhosted.org/packages/84/2b/b3e929c39fb056f0e44560acbe53a7c3f28f428af5362d043642d80b31ec/types_pygments-2.21.0.20260819.tar.gz"
    sha256 "68e0cb27115b08b681c843e30a153b5d9850c048e1158623ada36ccd4cf7e89b"
  end

  resource "types-pyperclip" do
    url "https://files.pythonhosted.org/packages/7a/ab/189f37a135df54686543ab99e8e1e6f8892efedc389beb80a72e038416e9/types_pyperclip-1.11.0.20260508.tar.gz"
    sha256 "e5dafdc929874f3f6bf495171d06cbc22483954a9ac0699ca53abbf9eadc592d"
  end

  resource "types-pyyaml" do
    url "https://files.pythonhosted.org/packages/90/6e/abec85b9013db5b934b0280a6dd104904d84f7bcbaab2e2f3def87ac7463/types_pyyaml-6.0.12.20260906.tar.gz"
    sha256 "f59c1cc05010b833d2d72287bbaa72610106b28d42d89a907313117faba85212"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "wasat" do
    url "https://files.pythonhosted.org/packages/e0/ae/54991304bc0fc0578e1cbceed4d35c1e9174e25b79ecdb3dfd3d314ef9ed/wasat-1.9.1.tar.gz"
    sha256 "26d7d643e93398f865fa25e064ed486d31f90ced838b2e3855a18b44ca10aa37"
  end

  resource "xdg-base-dirs" do
    url "https://files.pythonhosted.org/packages/bf/d0/bbe05a15347538aaf9fa5b51ac3b97075dfb834931fcb77d81fbdb69e8f6/xdg_base_dirs-6.0.2.tar.gz"
    sha256 "950504e14d27cf3c9cb37744680a43bf0ac42efefc4ef4acf98dc736cab2bced"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rogallo --version")
    assert_match "textual-dark", shell_output("#{bin}/rogallo themes")
  end
end
