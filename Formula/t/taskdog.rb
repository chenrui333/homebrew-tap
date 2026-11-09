class Taskdog < Formula
  include Language::Python::Virtualenv

  desc "Task manager with CLI, TUI, and local REST API server"
  homepage "https://github.com/Kohei-Wada/taskdog"
  url "https://github.com/Kohei-Wada/taskdog/archive/refs/tags/v0.29.1.tar.gz"
  sha256 "3fc22ba09bf5bd09c5e671f5301dd94183bc325462bb4353b679154cac318b46"
  license "MIT"
  head "https://github.com/Kohei-Wada/taskdog.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "5699c5c9acf6b6cbdb72fd5976a2b6361c317f18165f075d9517973e43e3270f"
    sha256 cellar: :any, arm64_sequoia: "7f5d40af5194b2ba7bb63ac984fbfa718e3562bfb5976316463243de446633a5"
    sha256 cellar: :any, arm64_linux:   "ce80a0301689cf31bd70c4f9bda18322162e92012a08207ef3498c5f11972e5a"
    sha256 cellar: :any, x86_64_linux:  "c5457bd311bd06c86f34d3fe3981466c5afc97be54345167031947a83fb39573"
  end

  depends_on "maturin" => :build
  depends_on "rust" => :build # for watchfiles
  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.14"

  # The workspace root has no dependencies; resolve the four installed packages' requirements.
  pypi_packages package_name:     "",
                exclude_packages: %w[certifi pydantic],
                extra_packages:   %w[
                  alembic click fastapi holidays httpx python-dateutil python-multipart rich sqlalchemy
                  textual textual-plotext uvicorn[standard] websockets
                  calver cython flit-core<4 hatch-fancy-pypi-readme hatch-vcs hatchling packaging pathspec pdm-backend
                  pluggy poetry-core setuptools setuptools-scm tomlkit trove-classifiers vcs-versioning wheel
                ]

  resource "alembic" do
    url "https://files.pythonhosted.org/packages/93/1c/00909e0fbebad2121d916fdcab044cae988146680e9ee4387ba25fef8747/alembic-1.20.1.tar.gz"
    sha256 "83490def1f723413db5096591f7609ac52544805be93849170088ed04f5a2e0b"
  end

  resource "annotated-doc" do
    url "https://files.pythonhosted.org/packages/5a/8e/38aa427ed5402449e226975b649c5dc73ccadfefeb95e6aecb8f8ea4b6b6/annotated_doc-0.0.5.tar.gz"
    sha256 "c7e58ce09192557605d8bbd92836d7e1d520ac9580096042c0bfd197efacf1bb"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/a1/98/7e457a3b014976887a050561955c0b76e1e7e2d6e27b78ecef2ef80518f2/anyio-4.16.0.tar.gz"
    sha256 "59bb03251907983d1603d27c3087ddb1e93299ea2163adcdba37899a4fb12ffb"
  end

  resource "calver" do
    url "https://files.pythonhosted.org/packages/4a/96/0c57e3e228ffc54074867406b659b197678674f1f0bf600d114965289834/calver-2025.10.20.tar.gz"
    sha256 "c98b376c2424642224d456b2f70c51402343e008c63d204634665e1a2a2835f5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/45/37/edbf1b0707709013c0cf2e8317e03d97ed29bf4cac709fe328904ae92a38/click-8.5.1.tar.gz"
    sha256 "9bbfada76703fd1d784b83eea012e3e8c6a001a876543ef104fa56aaaeb072b4"
  end

  resource "cython" do
    url "https://files.pythonhosted.org/packages/99/ca/18e324972e5cac914816fdd7bb03e19a455b90039c277a538f7781b50c85/cython-3.3.1.tar.gz"
    sha256 "e0e45989e821bef6aa9ae15c7d583ab5e055f7406c4b3624e49e06d24e90375a"
  end

  resource "fastapi" do
    url "https://files.pythonhosted.org/packages/eb/fb/3e954cd19540d69f9547e2577afe73b2eadad2ee47b691376a5b9345c50a/fastapi-0.162.1.tar.gz"
    sha256 "b18411785f55d05baa296fcfa2901f26728483190e7d8eb8f8e6aa47ed94b030"
  end

  resource "flit-core" do
    url "https://files.pythonhosted.org/packages/69/59/b6fc2188dfc7ea4f936cd12b49d707f66a1cb7a1d2c16172963534db741b/flit_core-3.12.0.tar.gz"
    sha256 "18f63100d6f94385c6ed57a72073443e1a71a4acb4339491615d0f16d6ff01b2"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "hatch-fancy-pypi-readme" do
    url "https://files.pythonhosted.org/packages/f3/0f/aed57c301f339936eb91cb4d8c1e5088a101081854bd3ec18a889df32365/hatch_fancy_pypi_readme-25.1.0.tar.gz"
    sha256 "9c58ed3dff90d51f43414ce37009ad1d5b0f08ffc9fc216998a06380f01c0045"
  end

  resource "hatch-vcs" do
    url "https://files.pythonhosted.org/packages/6b/b0/4cc743d38adbee9d57d786fa496ed1daadb17e48589b6da8fa55717a0746/hatch_vcs-0.5.0.tar.gz"
    sha256 "0395fa126940340215090c344a2bf4e2a77bcbe7daab16f41b37b98c95809ff9"
  end

  resource "hatchling" do
    url "https://files.pythonhosted.org/packages/7a/f1/e47b937226ae3b093bbd0132eb0b7ee5bfad12c2b5324afd10ae49946b05/hatchling-1.33.0.tar.gz"
    sha256 "4c422bd4d554fcff5de5b73e9596f85e41e9f97f7e553d8f7595ecb31a627bef"
  end

  resource "holidays" do
    url "https://files.pythonhosted.org/packages/a7/d0/f41f3c821961325324a39afe2865a62b9e789c3064c4ef48114ef29e4cf5/holidays-0.108.tar.gz"
    sha256 "b6daaa1f630512427fb0889700efaf9fa2eb4209f777ef4ce9ee216a4f0d0691"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/06/94/82699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cb/httpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httptools" do
    url "https://files.pythonhosted.org/packages/3a/ec/deed52912ab7ca6c0b12859330c571c60c61d7267b341b28951fcbf13694/httptools-0.9.0.tar.gz"
    sha256 "d484ebb7e3a3f3597b0f645fbd1b85633674ca808c1f5ba11c2caf7c66f5c8b6"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "linkify-it-py" do
    url "https://files.pythonhosted.org/packages/45/98/7a1a5f31fd5c7ba93e963b168e244b8e3dd705b3d2a718e3c3307583bf57/linkify_it_py-2.2.0.tar.gz"
    sha256 "907acd2d17ac1fbb9ddb62c8957ccbd6158cac602231a15c3b0cd1e215f03cee"
  end

  resource "mako" do
    url "https://files.pythonhosted.org/packages/5a/09/e07c4b5579a79f4b16f8d4f29f6c54514ac787c4ad506b8c4f28a0e6b0bf/mako-1.4.3.tar.gz"
    sha256 "cd6537fe88d5fec315c55c2f8529bc4ce7a9a352ad7db3eeaa6a66e2dd4ec37a"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/38/9b/e422a865e1d5d57d0e509b4e0bf1c1a70a7f6382c29a5aa428df994c8bc8/markupsafe-3.0.4.tar.gz"
    sha256 "2e9ad7dd851bf45fab9f75cbff4cb493fee9979e8d8c7c9c3ee119022518edd6"
  end

  resource "mdit-py-plugins" do
    url "https://files.pythonhosted.org/packages/59/fc/f8d0863f8862f25602c0404d75568e89fb6b4109804645e5cdfb1be5cf56/mdit_py_plugins-0.6.1.tar.gz"
    sha256 "a2bca0f039f39dbd35fb74ae1b5f998608c437463371f0ff7f49a19a17a114d0"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "opentelemetry-api" do
    url "https://files.pythonhosted.org/packages/19/14/cf3a6b6448849656e1e5f4e2101f3988dc6789724050096aba1bc5ccf592/opentelemetry_api-1.45.2.tar.gz"
    sha256 "d7b0008e21e5fd61cbe7a7f34ca3b6905a78ab677d9bc395e299359c75cda6b4"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/5a/82/42f767fc1c1143d6fd36efb827202a2d997a375e160a71eb2888a925aac1/pathspec-1.1.1.tar.gz"
    sha256 "17db5ecd524104a120e173814c90367a96a98d07c45b2e10c2f3919fff91bf5a"
  end

  resource "pdm-backend" do
    url "https://files.pythonhosted.org/packages/fc/d5/a82f533ed51f91a2183faf67a1fcb3b759615ffeca95d05b3e7648bf84bf/pdm_backend-2.5.0.tar.gz"
    sha256 "7953b994563d3151755e3364b9d0cfe817ed0eaecdf27c8f777f412d26bcd98a"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/d7/9a/8475be631fb33ca1466915e70fd594c42a4e84b512db650eaa14f90fe75d/platformdirs-4.14.5.tar.gz"
    sha256 "32e9921db7385aa8169bee4fe9501923e5715ba9fb7ea3b9c69b0d8e0639f7a1"
  end

  resource "plotext" do
    url "https://files.pythonhosted.org/packages/c9/d7/f75f397af966fe252d0d34ffd3cae765317fce2134f925f95e7d6725d1ce/plotext-5.3.2.tar.gz"
    sha256 "52d1e932e67c177bf357a3f0fe6ce14d1a96f7f7d5679d7b455b929df517068e"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/bf/db/7fc19e6f2dc92a966727031389fc2e08b558f0f25eb7403c1119ad4713cd/pluggy-1.7.0.tar.gz"
    sha256 "d1eaa46ebb595891b860ab086b4d09c8588af65ebd4361b8e8f4bb8920b90ba8"
  end

  resource "poetry-core" do
    url "https://files.pythonhosted.org/packages/42/b5/50f1fda26c4fe5b1d6ce5cdf0391bdfa1ca12fdcb8ad68344d5cf678fc90/poetry_core-2.5.0.tar.gz"
    sha256 "81d04c9253b19d0604718268d781867c8f7b2128e5b25bbf1e84141eec6b89c4"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/74/26/2fbeedb218a787a5eea551c7532cac4e009f83d689dd2faa0d0353473f86/python_dotenv-1.2.4.tar.gz"
    sha256 "f0d53e69935a851c0dcc78f3ab7aaccd8cabef0b92382b576b824212902873c0"
  end

  resource "python-multipart" do
    url "https://files.pythonhosted.org/packages/9f/b7/15b905f6142a9a8a68f66900788da1a32e4d4254452783b37ad1eccb0506/python_multipart-0.0.33.tar.gz"
    sha256 "b8112424a6abd162ec08d390565dd113ad699f2fe6fef3c987b8bbcbfe9e390d"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "setuptools-for-httptools" do
    self.name = "setuptools"
    url "https://files.pythonhosted.org/packages/4f/db/cfac1baf10650ab4d1c111714410d2fbb77ac5a616db26775db562c8fab2/setuptools-82.0.1.tar.gz"
    sha256 "7d872682c5d01cfde07da7bccc7b65469d3dca203318515ada1de5eda35efbf9"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/70/b3/c19426f783614d625699a4b247faf628ea9ab1db228674491767b417f9e1/setuptools-84.2.1.tar.gz"
    sha256 "3ff8b3b5492a0aa66960f4419365a86b84e013070d4313e4d4a6894f5d64d6bc"
  end

  resource "setuptools-scm-for-dateutil" do
    self.name = "setuptools-scm"
    url "https://files.pythonhosted.org/packages/98/12/2c1e579bb968759fc512391473340d0661b1a8c96a59fb7c65b02eec1321/setuptools_scm-7.1.0.tar.gz"
    sha256 "6c508345a771aad7d56ebff0e70628bf2b0ec7573762be9960214730de278f27"
  end

  resource "setuptools-scm" do
    url "https://files.pythonhosted.org/packages/85/d8/fc143f88819ccf10ba2388ba86732ee2de193e578234e25a783f6cc14bf7/setuptools_scm-10.3.4.tar.gz"
    sha256 "a69f28bfc245608781205e912faae437c2b2165773afa4e7b979d77447a69dd2"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "sqlalchemy" do
    url "https://files.pythonhosted.org/packages/9c/e7/2855174facf54a83b4fa3eddcece3631c6bdae43605dacd69cc3b6794319/sqlalchemy-2.1.8.tar.gz"
    sha256 "8bc4081dd7c17c073f2384ad0f5ee968e63b43507b2e024a3523c000a06d70da"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/48/bb/3d8757f21e9a53d9035c9eb039a777047139a16bfdbedfc7a58241c3d914/starlette-1.10.0.tar.gz"
    sha256 "b8399098d4c1e3522734f7235dc79b1fc967f96cf139c81e0fa30479e0685f9b"
  end

  resource "textual" do
    url "https://files.pythonhosted.org/packages/00/21/39a76b01bd5eea82a04baaca7580e105d8c59450df03998345bb2cfb307b/textual-8.2.8.tar.gz"
    sha256 "3f106a9fbc73e39dd266c9712432087de78a6d644084c7c241d6a25c3169115b"
  end

  resource "textual-plotext" do
    url "https://files.pythonhosted.org/packages/9a/b0/e4e0f38df057db778252db0dd2c08522d7222b8537b6a0181d797b9044bd/textual_plotext-1.0.1.tar.gz"
    sha256 "836f53a3316756609e194129a35c2875638e7958c261f541e0a794f7c98011be"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/08/72/fc01563df95c189a9f65850096bdc205bc2fe37da6c740cd64afaf18d07e/tomlkit-0.15.2.tar.gz"
    sha256 "83e32755ba1d20d9340bd069ee97e9f6232ba2346b63ffcba425de01f7e327a6"
  end

  resource "trove-classifiers" do
    url "https://files.pythonhosted.org/packages/bf/93/af436dfaa845cab5d96f0adbc1e4f3730532d37fa249e4eb796fb1d7fc82/trove_classifiers-2026.9.21.13.tar.gz"
    sha256 "0a9ebc8d4e2f3e8a22848c5258033035bec17a3012ac3fea16dbaa764489eb71"
  end

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/da/34/30e9280707135d2cfc589dfff3cb796bd07a3aeb1a3e415ba09dd89d7bb4/uvicorn-0.54.0.tar.gz"
    sha256 "a2e33cbfaa0306f8e6b0c13e0cb89d7d7a2da3e62b90c66e18c33d9807b28620"
  end

  resource "uvloop" do
    url "https://files.pythonhosted.org/packages/fa/42/02c739ce85fb2ee8d99212c61417da8140c6b87e9d97c430bea520d76044/uvloop-0.23.0.tar.gz"
    sha256 "28d160f51ab4da3b187063652e643dea6831072add4adc1e6d62afbe73b6be27"
  end

  resource "vcs-versioning" do
    url "https://files.pythonhosted.org/packages/ad/e7/2a691db7d076b75d099fdba1a14cd966931f2aeb591e77f6d22f15097326/vcs_versioning-2.6.0.tar.gz"
    sha256 "22e9159288e2d8bca2fa6f6c31c34c9c66aec157f60e9e526f5d160d2516d60f"
  end

  resource "watchfiles" do
    url "https://files.pythonhosted.org/packages/b3/68/e6aa0b77d217b31f8f486ec0cdfe5e00e6e38dc0be657e7d85819b9faf0a/watchfiles-1.3.0.tar.gz"
    sha256 "99aee4a07847c06820765fd7b1b49ceac4f3f711ccb7d104655a33231de1c207"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/75/79/590c5f0cc7d1661195aeefccb0e342b79f4c77d368d526d028821a390332/websockets-17.4.tar.gz"
    sha256 "09d3939b70df0c8ad2da145ebd50978bccaee1d565e838b0e7921a34d38571eb"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/d0/20/50ed6bdf27dec98b568a8ae25dc599f35baa3d9709f9e83fd1edb56b9a90/wheel-0.48.0.tar.gz"
    sha256 "94800765601e9171bf5d58d066e640662842bcedcbab982b2c90787a2c987322"
  end

  # The test starts taskdog-server and talks to it over a loopback HTTP socket.
  allow_network_access! :test

  def fetch
    # maturin/PyO3 run offline `cargo metadata`, which needs crates for all targets.
    resource("watchfiles").stage { system "cargo", "fetch", "--locked" }
  end

  def install
    build_resources = %w[
      flit-core
      packaging
      pathspec
      pdm-backend
      poetry-core
      setuptools-for-httptools
      calver
      cython
      tomlkit
      trove-classifiers
      vcs-versioning
      wheel
      setuptools-scm-for-dateutil
      setuptools
      setuptools-scm
      pluggy
      hatchling
      hatch-fancy-pypi-readme
      hatch-vcs
    ]

    ENV.append_path "PYTHONPATH", formula_opt_prefix("maturin")/Language::Python.site_packages("python3.14")
    ENV["CARGO_NET_OFFLINE"] = "true"
    ENV["PYYAML_FORCE_LIBYAML"] = "1"

    venv = virtualenv_create(libexec, "python3.14")
    # Dateutil needs setuptools-scm <8; httptools needs setuptools <=82.0.1.
    legacy_resources = build_resources.take_while { |name| name != "setuptools" }
    legacy_resources.each { |name| venv.pip_install resource(name), build_isolation: false }
    venv.pip_install resource("python-dateutil"), build_isolation: false
    venv.pip_install resource("httptools"), build_isolation: false
    # std_pip_args uses --ignore-installed, so remove old backends before replacing them.
    system "python3.14", "-m", "pip", "--python=#{libexec}/bin/python",
           "uninstall", "--yes", "setuptools", "setuptools-scm"
    (build_resources - legacy_resources).each do |name|
      venv.pip_install resource(name), build_isolation: false
    end
    installed_resources = build_resources + %w[python-dateutil httptools]
    venv.pip_install resources.reject { |r| installed_resources.include?(r.name) }, build_isolation: false
    venv.pip_install buildpath/"packages/taskdog-core", build_isolation: false
    venv.pip_install buildpath/"packages/taskdog-client", build_isolation: false
    venv.pip_install buildpath/"packages/taskdog-server", build_isolation: false
    venv.pip_install_and_link buildpath/"packages/taskdog-ui", build_isolation: false
    bin.install_symlink libexec/"bin/taskdog-server"

    generate_completions_from_executable(bin/"taskdog", shell_parameter_format: :click, shells: [:fish, :zsh])
  end

  service do
    run [opt_bin/"taskdog-server"]
    keep_alive true
  end

  test do
    system formula_opt_libexec("python@3.14")/"bin/python", "-m", "pip", "--python", libexec/"bin/python", "check"
    system libexec/"bin/python", "-c", <<~PYTHON
      import importlib.machinery
      import importlib.metadata
      import json
      import sys
      from pathlib import Path
      from time import monotonic
      import Cython.Plex.Scanners
      import pydantic_core
      from pydantic import BaseModel
      import watchfiles._rust_notify
      import yaml
      import yaml._yaml
      from taskdog.cli.commands.fix_times import ClearableDateTimeType, ClearableFloatType
      from taskdog.shared.click_types.field_list import FieldList

      for name in ("taskdog-core", "taskdog-client", "taskdog-server", "taskdog-ui"):
          assert importlib.metadata.version(name) == "#{version}"
      modules = (Cython.Plex.Scanners, pydantic_core._pydantic_core, watchfiles._rust_notify, yaml._yaml)
      for module in modules:
          assert any(module.__file__.endswith(suffix) for suffix in importlib.machinery.EXTENSION_SUFFIXES)
      class Task(BaseModel):
          priority: int
      assert Task(priority="10").model_dump() == {"priority": 10}
      data = {"tasks": ["Learn Taskdog"], "priority": 10}
      assert yaml.load(yaml.dump(data, Dumper=yaml.CSafeDumper), Loader=yaml.CSafeLoader) == data
      assert FieldList(valid_fields={"id", "name"}).convert("id,name", None, None) == ["id", "name"]
      assert ClearableDateTimeType().convert("", None, None) == "CLEAR"
      assert ClearableFloatType().convert("1.5", None, None) == 1.5
      watched = Path("watched").resolve()
      watched.mkdir()
      fixture = watched / "task.txt"
      fixture.write_text("pending")
      with watchfiles._rust_notify.RustNotify([str(watched)], False, False, 300, True, False) as watcher:
          assert repr(watcher).startswith("RustNotify(Recommended(")
          fixture.write_text("Learn Taskdog")
          if sys.platform == "darwin":
              # Exercise native lifecycle without requiring OS events in the macOS sandbox.
              watcher.close()
              assert repr(watcher) == "RustNotify(None)"
              try:
                  watcher.watch(100, 50, 1, None)
              except RuntimeError as error:
                  assert str(error) == "RustNotify watcher closed"
              else:
                  raise AssertionError("A closed native watcher accepted another watch")
          else:
              deadline = monotonic() + 5
              observed = set()
              while monotonic() < deadline:
                  remaining = max(1, int((deadline - monotonic()) * 1000))
                  changes = watcher.watch(100, 50, remaining, None)
                  if isinstance(changes, set):
                      observed.update(changes)
                      if any(Path(path).resolve() == fixture for _, path in observed):
                          break
              assert any(Path(path).resolve() == fixture for _, path in observed), observed
      print(json.dumps({module.__name__: module.__file__ for module in modules}))
    PYTHON

    port = free_port
    config_home = testpath/"config"
    data_home = testpath/"data"
    data_home.mkpath
    log_file = testpath/"taskdog-server.log"

    pid = spawn(
      {
        "XDG_CONFIG_HOME"              => config_home.to_s,
        "XDG_DATA_HOME"                => data_home.to_s,
        "XDG_STATE_HOME"               => (testpath/"state").to_s,
        "TASKDOG_AUTH_ENABLED"         => "false",
        "TASKDOG_STORAGE_BACKEND"      => "sqlite",
        "TASKDOG_STORAGE_DATABASE_URL" => "sqlite:///#{data_home}/tasks.db",
        "TASKDOG_REGION_COUNTRY"       => nil,
      },
      bin/"taskdog-server", "--host", "127.0.0.1", "--port", port.to_s,
      [:out, :err] => log_file.to_s
    )

    server_ready = false
    10.times do
      server_ready = quiet_system "curl", "-fsS", "--connect-timeout", "1", "--max-time", "1",
                                  "http://127.0.0.1:#{port}/health"
      break if server_ready

      sleep 1
    end

    assert server_ready, "taskdog-server failed to start: #{log_file.read}"
    assert_equal "ok", JSON.parse(shell_output("curl -fsS --max-time 2 http://127.0.0.1:#{port}/health")).fetch("status")

    with_env(
      "XDG_CONFIG_HOME"      => config_home.to_s,
      "XDG_DATA_HOME"        => data_home.to_s,
      "TASKDOG_API_BASE_URL" => "http://127.0.0.1:#{port}",
      "TASKDOG_API_KEY"      => nil,
    ) do
      assert_match version.to_s, shell_output("#{bin}/taskdog --version")
      assert_empty JSON.parse(shell_output("#{bin}/taskdog export --format json"))
      system bin/"taskdog", "add", "Learn Taskdog", "--priority", "10"
      tasks = JSON.parse(shell_output("#{bin}/taskdog export --format json --fields id,name,priority"))
      assert_equal 1, tasks.length
      task = tasks.fetch(0)
      assert_equal "Learn Taskdog", task.fetch("name")
      assert_equal 10, task.fetch("priority")
      system bin/"taskdog", "update", task.fetch("id").to_s, "--priority", "20"
      updated = JSON.parse(shell_output("#{bin}/taskdog export --format json --fields id,name,priority")).fetch(0)
      assert_equal task.merge("priority" => 20), updated
      system bin/"taskdog", "rm", task.fetch("id").to_s, "--hard"
      assert_empty JSON.parse(shell_output("#{bin}/taskdog export --format json --all"))
    end
  ensure
    if pid
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
