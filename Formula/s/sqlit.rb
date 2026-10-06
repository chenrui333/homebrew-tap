class Sqlit < Formula
  include Language::Python::Virtualenv

  desc "User friendly TUI for SQL databases"
  homepage "https://github.com/Maxteabag/sqlit"
  url "https://files.pythonhosted.org/packages/70/39/c84577fdade8a260ad1b7396ce3eba53e6404ca31df45d86c557e0978417/sqlit_tui-1.6.4.tar.gz"
  sha256 "7f7058b062c0e868bde867047928283909abaa27eb9bb527603b83fe71bdf1d6"
  license "MIT"
  head "https://github.com/Maxteabag/sqlit.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "2c02d4abb480a4d73963b1a64cd433f6f20df35dc061712695e4a92dc028a26f"
    sha256 cellar: :any, arm64_sequoia: "00ccf977e950aa2e9224ecbb98611831e973a6148c723ffb4e38e76c48db37f4"
    sha256 cellar: :any, arm64_linux:   "70630fe890286fcff523c020dc459aaca0c7f72ec1ac40c1298c746aab5fb895"
    sha256 cellar: :any, x86_64_linux:  "0862acb06ff446c71e17653094040b01ea7e586ab6496cb49bed8df64acb0302"
  end

  depends_on "cmake" => :build # for pyarrow
  depends_on "cython" => :build
  depends_on "ninja" => :build # for pyarrow
  depends_on "rust" => :build # for libcst
  depends_on "apache-arrow"
  depends_on "libyaml"
  depends_on "numpy"
  depends_on "openblas"
  depends_on "python@3.14"

  on_linux do
    depends_on "patchelf" => :build # for pyarrow
  end

  pypi_packages extra_packages: %w[
    calver coherent-licensed flit-core hatch-vcs hatchling libcst packaging pathspec pluggy poetry-core pyyaml
    scikit-build-core semantic-version setuptools setuptools-rust setuptools-scm tomlkit trove-classifiers
    vcs-versioning wheel
  ]

  resource "calver" do
    url "https://files.pythonhosted.org/packages/4a/96/0c57e3e228ffc54074867406b659b197678674f1f0bf600d114965289834/calver-2025.10.20.tar.gz"
    sha256 "c98b376c2424642224d456b2f70c51402343e008c63d204634665e1a2a2835f5"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/a3/c2/24167ea9858356b47a87a50d39908bfdb72ceeefe0041586e704e5376b3a/certifi-2026.7.22.tar.gz"
    sha256 "741e2c3b351ddf169a738da9f2c048608ff7f2c5cc02f1ebc6b118bb090d5d55"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e5/3f/143b048436775b0f76ac3eec145c019e8173ccc2885c8f20319b996d5e83/charset_normalizer-3.5.1.tar.gz"
    sha256 "6117b84ea48435e5356dc737f5121485c30920ba43375fa7b434fd753df0eac3"
  end

  resource "coherent-licensed" do
    url "https://files.pythonhosted.org/packages/cd/e9/63d2dcccb5496cc99d96f29a8a5f3e2c6ed0bba7fedb840862f92816ee17/coherent_licensed-0.5.2.tar.gz"
    sha256 "d8071403ce742d3ac3592ddc4fb7057a46caffb415b928b4d52802e5f208416d"
  end

  resource "docker" do
    url "https://files.pythonhosted.org/packages/88/7f/731ff914b0255d3d065f45fd4e626d4b8c95dbcbaada049f337a6ac16410/docker-7.2.0.tar.gz"
    sha256 "cebb93773d334f778e023a7ee352a8d6e13ab1bd3b863a4d4a59dec897df43ac"
  end

  resource "flit-core" do
    url "https://files.pythonhosted.org/packages/69/59/b6fc2188dfc7ea4f936cd12b49d707f66a1cb7a1d2c16172963534db741b/flit_core-3.12.0.tar.gz"
    sha256 "18f63100d6f94385c6ed57a72073443e1a71a4acb4339491615d0f16d6ff01b2"
  end

  resource "hatch-vcs" do
    url "https://files.pythonhosted.org/packages/6b/b0/4cc743d38adbee9d57d786fa496ed1daadb17e48589b6da8fa55717a0746/hatch_vcs-0.5.0.tar.gz"
    sha256 "0395fa126940340215090c344a2bf4e2a77bcbe7daab16f41b37b98c95809ff9"
  end

  resource "hatchling" do
    url "https://files.pythonhosted.org/packages/f6/97/b5312f01a8c6daf729a9d272dd442e0c546dbcc630495788786c4b567ed0/hatchling-1.32.4.tar.gz"
    sha256 "c4468f73144c054d2aab4ef0f0378c43b9878bf07f8ffd6b79690e970d375f07"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "jaraco-classes" do
    url "https://files.pythonhosted.org/packages/06/c0/ed4a27bc5571b99e3cff68f8a9fa5b56ff7df1c2251cc715a652ddd26402/jaraco.classes-3.4.0.tar.gz"
    sha256 "47a024b51d0239c0dd8c8540c6c7f484be3b8fcf0b2d85c13825780d3b3f3acd"
  end

  resource "jaraco-context" do
    url "https://files.pythonhosted.org/packages/af/50/4763cd07e722bb6285316d390a164bc7e479db9d90daa769f22578f698b4/jaraco_context-6.1.2.tar.gz"
    sha256 "f1a6c9d391e661cc5b8d39861ff077a7dc24dc23833ccee564b234b81c82dfe3"
  end

  resource "jaraco-functools" do
    url "https://files.pythonhosted.org/packages/6c/1f/c23395957d41ccf27c4e535c3d334c4051e5395b3752057ba4cbaec35c56/jaraco_functools-4.6.0.tar.gz"
    sha256 "880c577ec9720b3a052d5bc611fb9f2269b3d87902ef42440df443b88e443280"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/43/4b/674af6ef2f97d56f0ab5153bf0bfa28ccb6c3ed4d1babf4305449668807b/keyring-25.7.0.tar.gz"
    sha256 "fe01bd85eb3f8fb3dd0405defdeac9a5b4f6f0439edbb3149577f244a2e8245b"
  end

  resource "libcst" do
    url "https://files.pythonhosted.org/packages/02/c0/098e5c91ff1537f00c85a6438b6cb1863d17144680cc91f47c87f104a200/libcst-1.9.0.tar.gz"
    sha256 "087b58a9afe076bb08e2d726478e1f16cb928d67ffa9092817e033c335de522a"
  end

  resource "linkify-it-py" do
    url "https://files.pythonhosted.org/packages/45/98/7a1a5f31fd5c7ba93e963b168e244b8e3dd705b3d2a718e3c3307583bf57/linkify_it_py-2.2.0.tar.gz"
    sha256 "907acd2d17ac1fbb9ddb62c8957ccbd6158cac602231a15c3b0cd1e215f03cee"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "mdit-py-plugins" do
    url "https://files.pythonhosted.org/packages/59/fc/f8d0863f8862f25602c0404d75568e89fb6b4109804645e5cdfb1be5cf56/mdit_py_plugins-0.6.1.tar.gz"
    sha256 "a2bca0f039f39dbd35fb74ae1b5f998608c437463371f0ff7f49a19a17a114d0"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/de/1d/f4da6f02cdffe04d6362210b807146a26044c88d839208aec273bb0d9184/more_itertools-11.1.0.tar.gz"
    sha256 "48e8f4d9e7e5878571ecf6f2b4e57634f93cd474cc8cfbd2376f2d11b396e30d"
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
    url "https://files.pythonhosted.org/packages/ea/dd/65804b0c2925a1c821a05502ea57517b69a073ff400d25ab9faa3a2cf012/platformdirs-4.11.12.tar.gz"
    sha256 "e8dc1cb58f1153fd7f61db1374317770baababec2480b37b8f01c6cc25b45267"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f9/e2/3e91f31a7d2b083fe6ef3fa267035b518369d9511ffab804f839851d2779/pluggy-1.6.0.tar.gz"
    sha256 "7dcc130b76258d33b90f61b658791dede3486c3e6bfb003ee5c9bfb396dd22f3"
  end

  resource "poetry-core" do
    url "https://files.pythonhosted.org/packages/42/b5/50f1fda26c4fe5b1d6ce5cdf0391bdfa1ca12fdcb8ad68344d5cf678fc90/poetry_core-2.5.0.tar.gz"
    sha256 "81d04c9253b19d0604718268d781867c8f7b2128e5b25bbf1e84141eec6b89c4"
  end

  resource "pyarrow" do
    url "https://files.pythonhosted.org/packages/3d/e3/27f57f80141379d60defe6703eb50a707325706f07fedfd1312c7a751995/pyarrow-25.0.1.tar.gz"
    sha256 "9150a83248bfed9813ea3c3af74c3856c1984d444aa28e58bf7733b9750ddf6a"
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

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "scikit-build-core" do
    url "https://files.pythonhosted.org/packages/b2/1a/8c00b19c0a1e7acf890676af2efa430339d38e59fa9437f2aab8517af3f4/scikit_build_core-1.1.1.tar.gz"
    sha256 "e347a59193c878ac56a363e57506938652a6dd8c965790cb1cbc6bc7e8d5abad"
  end

  resource "semantic-version" do
    url "https://files.pythonhosted.org/packages/7d/31/f2289ce78b9b473d582568c234e104d2a342fd658cc288a7553d83bb8595/semantic_version-2.10.0.tar.gz"
    sha256 "bdabb6d336998cbb378d4b9db3a4b56a1e3235701dc05ea2690d9a997ed5041c"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/6d/44/f5da03a8ef95d369145c5bb53050e7877c9f3d312e128605fd9504829143/setuptools-84.0.0.tar.gz"
    sha256 "f4695c21257f0d9b537ec2692c941d02ee143b7cc1276941349a546573b2ef73"
  end

  resource "setuptools-rust" do
    url "https://files.pythonhosted.org/packages/68/ba/b31781d61bf9ee3c232a1d1160db11c11cdeae1d44e06c90723b25a8279f/setuptools_rust-1.13.0.tar.gz"
    sha256 "f2afcf4baeee689910ce49cfa8aad4e08cce72f417449bcc32891b8664fdc726"
  end

  resource "setuptools-scm" do
    url "https://files.pythonhosted.org/packages/85/d8/fc143f88819ccf10ba2388ba86732ee2de193e578234e25a783f6cc14bf7/setuptools_scm-10.3.4.tar.gz"
    sha256 "a69f28bfc245608781205e912faae437c2b2165773afa4e7b979d77447a69dd2"
  end

  resource "sqlparse" do
    url "https://files.pythonhosted.org/packages/5f/d3/3f06a1006f2261d1342aefb3c71eed02f5d4ca5bdbecd86ebc12ad38306e/sqlparse-0.6.0.tar.gz"
    sha256 "113c35c75365ab9cc9c7231d68c6428fb11c085fc8e9eb1ad659b7ddbf6cd2b9"
  end

  resource "textual" do
    url "https://files.pythonhosted.org/packages/00/21/39a76b01bd5eea82a04baaca7580e105d8c59450df03998345bb2cfb307b/textual-8.2.8.tar.gz"
    sha256 "3f106a9fbc73e39dd266c9712432087de78a6d644084c7c241d6a25c3169115b"
  end

  resource "textual-fastdatatable" do
    url "https://files.pythonhosted.org/packages/ad/a4/e3f2834ed4393afda3b66a4a8133e1b42e1269dd547d5f2064818d814273/textual_fastdatatable-0.19.0.tar.gz"
    sha256 "c9ffa17978e68886be3462c980fece81d21a5d0d5957d9eef2e5c6dae649606f"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/94/96/e07752635b98536177fa1f37671c8f3cdde2e724c6bcf6034b2cfb571565/tomlkit-0.15.1.tar.gz"
    sha256 "e25bbf38843005246210a12982776f27f99cb9be67160e14434d0c0d21ee1e97"
  end

  resource "tree-sitter" do
    url "https://files.pythonhosted.org/packages/f7/03/5600b84aff2e6c4fe80cfebb4063fe2f50299521befe5f6092ab8c082f4a/tree_sitter-0.26.0.tar.gz"
    sha256 "b40c219edccc4564530c96f8f1556f6202b37cda964d1cbd7bd2b7e68b40a245"
  end

  resource "tree-sitter-bash" do
    url "https://github.com/tree-sitter/tree-sitter-bash/archive/refs/tags/v0.25.1.tar.gz"
    sha256 "2e785a761225b6c433410ef9c7b63cfb0a4e83a35a19e0f2aec140b42c06b52d"
  end

  resource "tree-sitter-css" do
    url "https://github.com/tree-sitter/tree-sitter-css/archive/refs/tags/v0.25.0.tar.gz"
    sha256 "03965344d8c0435dc54fb45b281578420bb7db8b99df4d34e7e74105a274cb79"
  end

  resource "tree-sitter-go" do
    url "https://github.com/tree-sitter/tree-sitter-go/archive/refs/tags/v0.25.0.tar.gz"
    sha256 "2dc241b97872c53195e01b86542b411a3c1a6201d9c946c78d5c60c063bba1ef"
  end

  resource "tree-sitter-html" do
    url "https://github.com/tree-sitter/tree-sitter-html/archive/refs/tags/v0.23.2.tar.gz"
    sha256 "21fa4f2d4dcb890ef12d09f4979a0007814f67f1c7294a9b17b0108a09e45ef7"
  end

  resource "tree-sitter-java" do
    url "https://github.com/tree-sitter/tree-sitter-java/archive/refs/tags/v0.23.5.tar.gz"
    sha256 "cb199e0faae4b2c08425f88cbb51c1a9319612e7b96315a174a624db9bf3d9f0"
  end

  resource "tree-sitter-javascript" do
    url "https://github.com/tree-sitter/tree-sitter-javascript/archive/refs/tags/v0.25.0.tar.gz"
    sha256 "9712fc283d3dc01d996d20b6392143445d05867a7aad76fdd723824468428b86"
  end

  resource "tree-sitter-json" do
    url "https://github.com/tree-sitter/tree-sitter-json/archive/refs/tags/v0.24.8.tar.gz"
    sha256 "acf6e8362457e819ed8b613f2ad9a0e1b621a77556c296f3abea58f7880a9213"
  end

  resource "tree-sitter-markdown" do
    url "https://github.com/tree-sitter-grammars/tree-sitter-markdown/archive/refs/tags/v0.5.1.tar.gz"
    sha256 "acaffe5a54b4890f1a082ad6b309b600b792e93fc6ee2903d022257d5b15e216"
  end

  resource "tree-sitter-python" do
    url "https://github.com/tree-sitter/tree-sitter-python/archive/refs/tags/v0.25.0.tar.gz"
    sha256 "4609a3665a620e117acf795ff01b9e965880f81745f287a16336f4ca86cf270c"
  end

  resource "tree-sitter-regex" do
    url "https://github.com/tree-sitter/tree-sitter-regex/archive/refs/tags/v0.25.0.tar.gz"
    sha256 "853200795c4cf856eba9de3f4f9abb370d22aef4fb32e8911e210bb7e4253087"
  end

  resource "tree-sitter-rust" do
    url "https://github.com/tree-sitter/tree-sitter-rust/archive/refs/tags/v0.24.2.tar.gz"
    sha256 "061e90a539a55a6aa65dceb0ad6425c50ab1a6e3e6d4ba430e2795ed4550f10e"
  end

  resource "tree-sitter-sql" do
    url "https://github.com/DerekStride/tree-sitter-sql/releases/download/v0.3.11/tree-sitter-sql-v0.3.11.tar.gz"
    sha256 "a97a324eae9c81ed68f6e162b9b33f8911fc6442caa2950e57c498e2460d1387"
  end

  resource "tree-sitter-toml" do
    url "https://github.com/tree-sitter-grammars/tree-sitter-toml/archive/refs/tags/v0.7.0.tar.gz"
    sha256 "7d52a7d4884f307aabc872867c69084d94456d8afcdc63b0a73031a8b29036dc"
  end

  resource "tree-sitter-xml" do
    url "https://github.com/tree-sitter-grammars/tree-sitter-xml/archive/refs/tags/v0.7.0.tar.gz"
    sha256 "4330a6b3685c2f66d108e1df0448eb40c468518c3a66f2c1607a924c262a3eb9"
  end

  resource "tree-sitter-yaml" do
    url "https://github.com/tree-sitter-grammars/tree-sitter-yaml/archive/refs/tags/v0.7.2.tar.gz"
    sha256 "aeaff5731bb8b66c7054c8aed33cd5edea5f4cd2ac71654f3f6c2ba2073d8fac"
  end

  resource "trove-classifiers" do
    url "https://files.pythonhosted.org/packages/bf/93/af436dfaa845cab5d96f0adbc1e4f3730532d37fa249e4eb796fb1d7fc82/trove_classifiers-2026.9.21.13.tar.gz"
    sha256 "0a9ebc8d4e2f3e8a22848c5258033035bec17a3012ac3fea16dbaa764489eb71"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  resource "vcs-versioning" do
    url "https://files.pythonhosted.org/packages/6f/a0/6977bb418312ad30f27e522c5040604d4bbf7e40ccd5a11d333afe549354/vcs_versioning-2.5.0.tar.gz"
    sha256 "956a796e31f80fe714d219d6d1df15a6bf247d10f6d851bf4b98279d0a42da55"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/d0/20/50ed6bdf27dec98b568a8ae25dc599f35baa3d9709f9e83fd1edb56b9a90/wheel-0.48.0.tar.gz"
    sha256 "94800765601e9171bf5d58d066e640662842bcedcbab982b2c90787a2c987322"
  end

  deny_network_access!

  def fetch
    # maturin/PyO3 run offline `cargo metadata`, which needs crates for all targets.
    resource("libcst").stage { cd("native") { system "cargo", "fetch", "--locked" } }
  end

  def install
    build_resources = %w[
      flit-core
      coherent-licensed
      packaging
      pathspec
      poetry-core
      setuptools
      calver
      pyyaml
      semantic-version
      tomlkit
      trove-classifiers
      vcs-versioning
      setuptools-scm
      pluggy
      hatchling
      hatch-vcs
      scikit-build-core
      setuptools-rust
      wheel
      libcst
    ]

    ENV.append_path "PYTHONPATH", formula_opt_libexec("cython")/Language::Python.site_packages("python3.14")
    ENV["CARGO_NET_OFFLINE"] = "true"

    venv = virtualenv_create(libexec, "python3.14")
    build_resources.each do |name|
      venv.pip_install resource(name), build_isolation: false
    end
    venv.pip_install resources.reject { |r| build_resources.include?(r.name) }, build_isolation: false
    venv.pip_install_and_link buildpath, build_isolation: false
  end

  test do
    db_path = testpath/"sample.db"

    system bin/"sqlit", "connections", "add", "sqlite",
           "--name", "local",
           "--file-path", db_path.to_s

    output = shell_output("#{bin}/sqlit query --connection local --query 'SELECT 1 AS n' --format json")
    assert_match "\"n\": 1", output
  end
end
