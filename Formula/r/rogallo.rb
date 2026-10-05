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

  depends_on "cython" => :build
  depends_on "maturin" => :build
  depends_on "rust" => :build # for uv-build
  depends_on "cryptography" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.14"

  pypi_packages extra_packages: %w[
    calver flit-core hatch-vcs hatchling packaging pathspec pluggy poetry-core setuptools setuptools-scm tomlkit
    trove-classifiers uv-build vcs-versioning
  ]

  resource "bagofstuff" do
    url "https://files.pythonhosted.org/packages/ff/52/020cf95233d6838920e3dfad6e4b4b1df6ce8d42646a8a094f9003356d97/bagofstuff-2.0.0.tar.gz"
    sha256 "423604e10179ec61af1f3a62f8c61aeaa2383040fdea67175f5c43d50e829a44"
  end

  resource "calver" do
    url "https://files.pythonhosted.org/packages/4a/96/0c57e3e228ffc54074867406b659b197678674f1f0bf600d114965289834/calver-2025.10.20.tar.gz"
    sha256 "c98b376c2424642224d456b2f70c51402343e008c63d204634665e1a2a2835f5"
  end

  resource "finger2gemtext" do
    url "https://files.pythonhosted.org/packages/68/e4/18cd643abb1cec703789fc315b240274d34297c887868c38e113e0d0c26c/finger2gemtext-0.1.0.tar.gz"
    sha256 "7bbfa97852018d9b8013143540a4a216844ee0f100ae0b4f133ac6555fc74d19"
  end
  resource "flit-core" do
    url "https://files.pythonhosted.org/packages/69/59/b6fc2188dfc7ea4f936cd12b49d707f66a1cb7a1d2c16172963534db741b/flit_core-3.12.0.tar.gz"
    sha256 "18f63100d6f94385c6ed57a72073443e1a71a4acb4339491615d0f16d6ff01b2"
  end

  resource "gemtext" do
    url "https://files.pythonhosted.org/packages/5d/0e/42d7dba3d43ba12565838d674fecee40db12cd15be92ac58a7309bea7218/gemtext-1.1.0.tar.gz"
    sha256 "d8e0d89994c3d462c416886280b2ff3abfbcd57e3230b8b449bc7fee3b7c3535"
  end

  resource "gophermap" do
    url "https://files.pythonhosted.org/packages/72/85/9372edf76d3f19ba23da9da0ceb1512216bde502b7a5cbf08450d02e725c/gophermap-1.1.0.tar.gz"
    sha256 "050f75d63a7bde70cd74a8acd23520584a84ed11a9426b9f701991988195d4b5"
  end

  resource "hatch-vcs" do
    url "https://files.pythonhosted.org/packages/6b/b0/4cc743d38adbee9d57d786fa496ed1daadb17e48589b6da8fa55717a0746/hatch_vcs-0.5.0.tar.gz"
    sha256 "0395fa126940340215090c344a2bf4e2a77bcbe7daab16f41b37b98c95809ff9"
  end

  resource "hatchling" do
    url "https://files.pythonhosted.org/packages/f6/97/b5312f01a8c6daf729a9d272dd442e0c546dbcc630495788786c4b567ed0/hatchling-1.32.4.tar.gz"
    sha256 "c4468f73144c054d2aab4ef0f0378c43b9878bf07f8ffd6b79690e970d375f07"
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

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/5a/82/42f767fc1c1143d6fd36efb827202a2d997a375e160a71eb2888a925aac1/pathspec-1.1.1.tar.gz"
    sha256 "17db5ecd524104a120e173814c90367a96a98d07c45b2e10c2f3919fff91bf5a"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/ea/06/cf1564dcc2e2261c8c8c6c05628dc8b418943bdae2a4e58640ceb2f770fa/platformdirs-4.11.5.tar.gz"
    sha256 "e8b31f4f8bcbbedef91a6b57a706255e4f148d2a4e01648382a0a47342539173"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f9/e2/3e91f31a7d2b083fe6ef3fa267035b518369d9511ffab804f839851d2779/pluggy-1.6.0.tar.gz"
    sha256 "7dcc130b76258d33b90f61b658791dede3486c3e6bfb003ee5c9bfb396dd22f3"
  end

  resource "poetry-core" do
    url "https://files.pythonhosted.org/packages/42/b5/50f1fda26c4fe5b1d6ce5cdf0391bdfa1ca12fdcb8ad68344d5cf678fc90/poetry_core-2.5.0.tar.gz"
    sha256 "81d04c9253b19d0604718268d781867c8f7b2128e5b25bbf1e84141eec6b89c4"
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

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/6d/44/f5da03a8ef95d369145c5bb53050e7877c9f3d312e128605fd9504829143/setuptools-84.0.0.tar.gz"
    sha256 "f4695c21257f0d9b537ec2692c941d02ee143b7cc1276941349a546573b2ef73"
  end

  resource "setuptools-scm" do
    url "https://files.pythonhosted.org/packages/85/d8/fc143f88819ccf10ba2388ba86732ee2de193e578234e25a783f6cc14bf7/setuptools_scm-10.3.4.tar.gz"
    sha256 "a69f28bfc245608781205e912faae437c2b2165773afa4e7b979d77447a69dd2"
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

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/94/96/e07752635b98536177fa1f37671c8f3cdde2e724c6bcf6034b2cfb571565/tomlkit-0.15.1.tar.gz"
    sha256 "e25bbf38843005246210a12982776f27f99cb9be67160e14434d0c0d21ee1e97"
  end

  resource "trove-classifiers" do
    url "https://files.pythonhosted.org/packages/bf/93/af436dfaa845cab5d96f0adbc1e4f3730532d37fa249e4eb796fb1d7fc82/trove_classifiers-2026.9.21.13.tar.gz"
    sha256 "0a9ebc8d4e2f3e8a22848c5258033035bec17a3012ac3fea16dbaa764489eb71"
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

  resource "uv-build" do
    url "https://files.pythonhosted.org/packages/b4/65/672d5c1e7fff2a602b51758cd96c379ea80c0c20d9d10aae5139bfde9877/uv_build-0.12.23.tar.gz"
    sha256 "b0428317e2783252b33b513446436071f4e14bfeb38655c99877ca6550ea4aac"
  end

  resource "vcs-versioning" do
    url "https://files.pythonhosted.org/packages/6f/a0/6977bb418312ad30f27e522c5040604d4bbf7e40ccd5a11d333afe549354/vcs_versioning-2.5.0.tar.gz"
    sha256 "956a796e31f80fe714d219d6d1df15a6bf247d10f6d851bf4b98279d0a42da55"
  end

  resource "wasat" do
    url "https://files.pythonhosted.org/packages/e0/ae/54991304bc0fc0578e1cbceed4d35c1e9174e25b79ecdb3dfd3d314ef9ed/wasat-1.9.1.tar.gz"
    sha256 "26d7d643e93398f865fa25e064ed486d31f90ced838b2e3855a18b44ca10aa37"
  end

  resource "xdg-base-dirs" do
    url "https://files.pythonhosted.org/packages/bf/d0/bbe05a15347538aaf9fa5b51ac3b97075dfb834931fcb77d81fbdb69e8f6/xdg_base_dirs-6.0.2.tar.gz"
    sha256 "950504e14d27cf3c9cb37744680a43bf0ac42efefc4ef4acf98dc736cab2bced"
  end

  deny_network_access!

  def fetch
    # maturin/PyO3 run offline `cargo metadata`, which needs crates for all targets.
    resource("uv-build").stage { system "cargo", "fetch", "--locked" }
  end

  def install
    build_resources = %w[
      flit-core
      packaging
      pathspec
      poetry-core
      setuptools
      calver
      tomlkit
      trove-classifiers
      uv-build
      vcs-versioning
      setuptools-scm
      pluggy
      hatchling
      hatch-vcs
    ]

    ENV.append_path "PYTHONPATH", formula_opt_libexec("cython")/Language::Python.site_packages("python3.14")
    ENV.append_path "PYTHONPATH", formula_opt_lib("maturin")/Language::Python.site_packages("python3.14")
    ENV.prepend_path "PATH", libexec/"bin"
    ENV["CARGO_NET_OFFLINE"] = "true"

    venv = virtualenv_create(libexec, "python3.14")
    build_resources.each do |name|
      venv.pip_install resource(name), build_isolation: false
    end
    venv.pip_install resources.reject { |r| build_resources.include?(r.name) }, build_isolation: false
    venv.pip_install_and_link buildpath, build_isolation: false
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rogallo --version")
    assert_match "textual-dark", shell_output("#{bin}/rogallo themes")
  end
end
