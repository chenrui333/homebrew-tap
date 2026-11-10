class Memora < Formula
  include Language::Python::Virtualenv

  desc "Lightweight MCP server for semantic memory storage"
  homepage "https://github.com/agentic-mcp-tools/memora"
  url "https://github.com/agentic-mcp-tools/memora/archive/refs/tags/v0.4.3.tar.gz"
  sha256 "a111da9c05107a79f6e52b104a124768f0a800225aa9e27294c68222c7623c13"
  license "MIT"
  revision 1
  head "https://github.com/agentic-mcp-tools/memora.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "0c0b667569f57d7be3d7bd0fe5e726c24a63979f3cd61efe99b44cc7a5336c6a"
    sha256 cellar: :any, arm64_sequoia: "2fef2cb0ca77f805d53fd2225374018b40648f3cbbc5976ef2519b942d56c327"
    sha256 cellar: :any, arm64_linux:   "d3e04ff4e3af7aea8c75a4e5a22bd7217923ce04875905bd1e1e70c632fd6607"
    sha256 cellar: :any, x86_64_linux:  "4173bb8d86061592cce9a4d4c92529c66c9531cafb8da2063f6e352c4d4a8588"
  end

  depends_on "maturin" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "pillow" => :no_linkage
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.14"
  depends_on "rpds-py" => :no_linkage

  on_linux do
    depends_on "openssl@3"
  end

  pypi_packages exclude_packages: %w[certifi cryptography pillow pydantic rpds-py],
                extra_packages:   %w[
                  calver dunamai flit-core<4 hatch-fancy-pypi-readme hatch-vcs hatchling jinja2 markupsafe packaging
                  pathspec pluggy poetry-core setuptools setuptools-scm tomlkit trove-classifiers
                  uv-dynamic-versioning vcs-versioning wheel
                ]

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/96/f0/5eb65b2bb0d09ac6776f2eb54adee6abe8228ea05b20a5ad0e4945de8aac/anyio-4.12.1.tar.gz"
    sha256 "41cfcc3a4c85d3f05c932da7c26d0201ac36f72abd4435ba90d0464a3ffed703"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/6b/5c/685e6633917e101e5dcb62b9dd76946cbb57c26e133bae9e0cd36033c0a9/attrs-25.4.0.tar.gz"
    sha256 "16d5969b87f0859ef33a48b35d55ac1be6e42ae49d5e853b597db70c35c57e11"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/4f/53/2e0a325e080bd83f5dfd8f964b70b93badc284bcb5680bee75327771ad4a/boto3-1.42.54.tar.gz"
    sha256 "fe3d8ec586c39a0c96327fd317c77ca601ec5f991e9ba7211cacae8db4c07a73"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/be/9a/5ab14330e5d1c3489e91f32f6ece40f3b58cf82d2aafe1e4a61711f616b0/botocore-1.42.54.tar.gz"
    sha256 "ab203d4e57d22913c8386a695d048e003b7508a8a4a7a46c9ddf4ebd67a20b69"
  end

  resource "calver" do
    url "https://files.pythonhosted.org/packages/4a/96/0c57e3e228ffc54074867406b659b197678674f1f0bf600d114965289834/calver-2025.10.20.tar.gz"
    sha256 "c98b376c2424642224d456b2f70c51402343e008c63d204634665e1a2a2835f5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/3d/fa/656b739db8587d7b5dfa22e22ed02566950fbfbcdc20311993483657a5c0/click-8.3.1.tar.gz"
    sha256 "12ff4785d337a1bb490bb7e9c2b1ee5da3112e94a8622f26a6c77f5d2fc6842a"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/fc/f8/98eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3/distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "dunamai" do
    url "https://files.pythonhosted.org/packages/12/18/020d3b27a10450ddb11429f637404e8ea67ecf4d9fd999d4f1d553f25506/dunamai-1.26.2.tar.gz"
    sha256 "84ea45eddf9bb4b40df7610b1b22a03137365e6257dbf9d7b72128fdccca564c"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/73/92/a8e2479937ff39185d20dd6a851c1a63e55849e447a55e798cc2e1f49c65/filelock-3.24.3.tar.gz"
    sha256 "011a5644dc937c22699943ebbfc46e969cdde3e171470a6e40b9533e5a72affa"
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
    url "https://files.pythonhosted.org/packages/f6/97/b5312f01a8c6daf729a9d272dd442e0c546dbcc630495788786c4b567ed0/hatchling-1.32.4.tar.gz"
    sha256 "c4468f73144c054d2aab4ef0f0378c43b9878bf07f8ffd6b79690e970d375f07"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/06/94/82699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cb/httpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "httpx-sse" do
    url "https://files.pythonhosted.org/packages/0f/4c/751061ffa58615a32c31b2d82e8482be8dd4a89154f003147acee90f2be9/httpx_sse-0.4.3.tar.gz"
    sha256 "9b1ed0127459a66014aec3c56bebd93da3c1bc8bb6618c8082039a44889a755d"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "jiter" do
    url "https://files.pythonhosted.org/packages/0d/5e/4ec91646aee381d01cdb9974e30882c9cd3b8c5d1079d6b5ff4af522439a/jiter-0.13.0.tar.gz"
    sha256 "f2839f9c2c7e2dffc1bc5929a510e14ce0a946be9365fd1219e7ef342dae14f4"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/d3/59/322338183ecda247fb5d1763a6cbe46eff7222eaeebafd9fa65d4bf5cb11/jmespath-1.1.0.tar.gz"
    sha256 "472c87d80f36026ae83c6ddd0f1d05d4e510134ed462851fd5f754c8c3cbb88d"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/b3/fc/e067678238fa451312d4c62bf6e6cf5ec56375422aee02f9cb5f909b3047/jsonschema-4.26.0.tar.gz"
    sha256 "0c26707e2efad8aa1bfc5b7ce170f3fccc2e4918ff85989ba9ffa9facb2be326"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/19/74/a633ee74eb36c44aa6d1095e7cc5569bebf04342ee146178e2d36600708b/jsonschema_specifications-2025.9.1.tar.gz"
    sha256 "b540987f239e745613c7a9176f3edb72b832a4ac465cf02712288397832b5e8d"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/38/9b/e422a865e1d5d57d0e509b4e0bf1c1a70a7f6382c29a5aa428df994c8bc8/markupsafe-3.0.4.tar.gz"
    sha256 "2e9ad7dd851bf45fab9f75cbff4cb493fee9979e8d8c7c9c3ee119022518edd6"
  end

  resource "mcp" do
    url "https://files.pythonhosted.org/packages/8b/eb/c0cfc62075dc6e1ec1c64d352ae09ac051d9334311ed226f1f425312848a/mcp-1.27.0.tar.gz"
    sha256 "d3dc35a7eec0d458c1da4976a48f982097ddaab87e278c5511d5a4a56e852b83"
  end

  resource "openai" do
    url "https://files.pythonhosted.org/packages/92/e5/3d197a0947a166649f566706d7a4c8f7fe38f1fa7b24c9bcffe4c7591d44/openai-2.21.0.tar.gz"
    sha256 "81b48ce4b8bbb2cc3af02047ceb19561f7b1dc0d4e52d1de7f02abfd15aa59b7"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/5a/82/42f767fc1c1143d6fd36efb827202a2d997a375e160a71eb2888a925aac1/pathspec-1.1.1.tar.gz"
    sha256 "17db5ecd524104a120e173814c90367a96a98d07c45b2e10c2f3919fff91bf5a"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f9/e2/3e91f31a7d2b083fe6ef3fa267035b518369d9511ffab804f839851d2779/pluggy-1.6.0.tar.gz"
    sha256 "7dcc130b76258d33b90f61b658791dede3486c3e6bfb003ee5c9bfb396dd22f3"
  end

  resource "poetry-core" do
    url "https://files.pythonhosted.org/packages/42/b5/50f1fda26c4fe5b1d6ce5cdf0391bdfa1ca12fdcb8ad68344d5cf678fc90/poetry_core-2.5.0.tar.gz"
    sha256 "81d04c9253b19d0604718268d781867c8f7b2128e5b25bbf1e84141eec6b89c4"
  end

  resource "pydantic-settings" do
    url "https://files.pythonhosted.org/packages/52/6d/fffca34caecc4a3f97bda81b2098da5e8ab7efc9a66e819074a11955d87e/pydantic_settings-2.13.1.tar.gz"
    sha256 "b4c11847b15237fb0171e1462bf540e294affb9b86db4d9aa5c01730bdbe4025"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/5c/5a/b46fa56bf322901eee5b0454a34343cdbdae202cd421775a8ee4e42fd519/pyjwt-2.11.0.tar.gz"
    sha256 "35f95c1f0fbe5d5ba6e43f00271c275f7a1a4db1dab27bf708073b75318ea623"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/f0/26/19cadc79a718c5edbec86fd4919a6b6d3f681039a2f6d66d14be94e75fb9/python_dotenv-1.2.1.tar.gz"
    sha256 "42667e897e16ab0d66954af0e60a9caa94f0fd4ecf3aaf6d2d260eec1aa36ad6"
  end

  resource "python-multipart" do
    url "https://files.pythonhosted.org/packages/94/01/979e98d542a70714b0cb2b6728ed0b7c46792b695e3eaec3e20711271ca3/python_multipart-0.0.22.tar.gz"
    sha256 "7340bef99a7e0032613f56dc36027b959fd3b30a787ed62d310e951f7c3a3a58"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/22/f5/df4e9027acead3ecc63e50fe1e36aca1523e1719559c499951bb4b53188f/referencing-0.37.0.tar.gz"
    sha256 "44aefc3142c5b842538163acb373e24cce6632bd54bdb01b21ad5863489f50d8"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/05/04/74127fc843314818edfa81b5540e26dd537353b123a4edc563109d8f17dd/s3transfer-0.16.0.tar.gz"
    sha256 "8e990f13268025792229cd52fa10cb7163744bf56e719e0b9cb925ab79abf920"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/6d/44/f5da03a8ef95d369145c5bb53050e7877c9f3d312e128605fd9504829143/setuptools-84.0.0.tar.gz"
    sha256 "f4695c21257f0d9b537ec2692c941d02ee143b7cc1276941349a546573b2ef73"
  end

  resource "setuptools-scm" do
    url "https://files.pythonhosted.org/packages/85/d8/fc143f88819ccf10ba2388ba86732ee2de193e578234e25a783f6cc14bf7/setuptools_scm-10.3.4.tar.gz"
    sha256 "a69f28bfc245608781205e912faae437c2b2165773afa4e7b979d77447a69dd2"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "sse-starlette" do
    url "https://files.pythonhosted.org/packages/8b/8d/00d280c03ffd39aaee0e86ec81e2d3b9253036a0f93f51d10503adef0e65/sse_starlette-3.2.0.tar.gz"
    sha256 "8127594edfb51abe44eac9c49e59b0b01f1039d0c7461c6fd91d4e03b70da422"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/c4/68/79977123bb7be889ad680d79a40f339082c1978b5cfcf62c2d8d196873ac/starlette-0.52.1.tar.gz"
    sha256 "834edd1b0a23167694292e94f597773bc3f89f362be6effee198165a35d62933"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/94/96/e07752635b98536177fa1f37671c8f3cdde2e724c6bcf6034b2cfb571565/tomlkit-0.15.1.tar.gz"
    sha256 "e25bbf38843005246210a12982776f27f99cb9be67160e14434d0c0d21ee1e97"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/09/a9/6ba95a270c6f1fbcd8dac228323f2777d886cb206987444e4bce66338dd4/tqdm-4.67.3.tar.gz"
    sha256 "7d825f03f89244ef73f1d4ce193cb1774a8179fd96f31d7e1dcde62092b960bb"
  end

  resource "trove-classifiers" do
    url "https://files.pythonhosted.org/packages/bf/93/af436dfaa845cab5d96f0adbc1e4f3730532d37fa249e4eb796fb1d7fc82/trove_classifiers-2026.9.21.13.tar.gz"
    sha256 "0a9ebc8d4e2f3e8a22848c5258033035bec17a3012ac3fea16dbaa764489eb71"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c7/24/5f1b3bdffd70275f6661c76461e25f024d5a38a46f04aaca912426a2b1d3/urllib3-2.6.3.tar.gz"
    sha256 "1b62b6884944a57dbe321509ab94fd4d3b307075e0c2eae991ac71ee15ad38ed"
  end

  resource "uv-dynamic-versioning" do
    url "https://files.pythonhosted.org/packages/6f/c8/fa500ee29af69cfeeea5ff6d6597919f1989b2e3f1a236c3006bdb21d320/uv_dynamic_versioning-0.14.1.tar.gz"
    sha256 "8642db686ce5c50417035e7a257ac73b7e5c3a7a32c33e45bd7e36ba22eeb648"
  end

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/32/ce/eeb58ae4ac36fe09e3842eb02e0eb676bf2c53ae062b98f1b2531673efdd/uvicorn-0.41.0.tar.gz"
    sha256 "09d11cf7008da33113824ee5a1c6422d89fbc2ff476540d69a34c87fab8b571a"
  end

  resource "vcs-versioning" do
    url "https://files.pythonhosted.org/packages/6f/a0/6977bb418312ad30f27e522c5040604d4bbf7e40ccd5a11d333afe549354/vcs_versioning-2.5.0.tar.gz"
    sha256 "956a796e31f80fe714d219d6d1df15a6bf247d10f6d851bf4b98279d0a42da55"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/d0/20/50ed6bdf27dec98b568a8ae25dc599f35baa3d9709f9e83fd1edb56b9a90/wheel-0.48.0.tar.gz"
    sha256 "94800765601e9171bf5d58d066e640662842bcedcbab982b2c90787a2c987322"
  end

  # Distinct lookup keys retain incompatible SDK roles with their canonical distribution names.
  resource "homebrew-hatchling-openai" do
    self.name = "hatchling"
    url "https://files.pythonhosted.org/packages/e1/47/7ec270a9567262ae3cb32dd420d2b53bf7aee769aca1f240eae0426b5bbc/hatchling-1.26.3.tar.gz"
    sha256 "b672a9c36a601a06c4e88a1abb1330639ee8e721e0535a37536e546a667efc7a"
  end

  resource "homebrew-setuptools-scm-dateutil" do
    self.name = "setuptools-scm"
    url "https://files.pythonhosted.org/packages/98/12/2c1e579bb968759fc512391473340d0661b1a8c96a59fb7c65b02eec1321/setuptools_scm-7.1.0.tar.gz"
    sha256 "6c508345a771aad7d56ebff0e70628bf2b0ec7573762be9960214730de278f27"
  end

  resource "homebrew-setuptools-scm-urllib3" do
    self.name = "setuptools-scm"
    url "https://files.pythonhosted.org/packages/7b/b1/19587742aad604f1988a8a362e660e8c3ac03adccdb71c96d86526e5eb62/setuptools_scm-9.2.2.tar.gz"
    sha256 "1c674ab4665686a0887d7e24c03ab25f24201c213e82ea689d2f3e169ef7ef57"
  end

  deny_network_access!

  def fetch
    # jiter's sdist lock file still lists workspace members that are not shipped.
    resource("jiter").stage { system "cargo", "fetch" }
  end

  def install
    build_resources = %w[
      flit-core
      jinja2
      packaging
      pathspec
      poetry-core
      dunamai
      setuptools
      calver
      markupsafe
      tomlkit
      trove-classifiers
      vcs-versioning
      setuptools-scm
      pluggy
      hatchling
      hatch-fancy-pypi-readme
      hatch-vcs
      uv-dynamic-versioning
      wheel
    ]

    ENV.append_path "PYTHONPATH", formula_opt_prefix("maturin")/Language::Python.site_packages("python3.14")
    ENV["CARGO_NET_OFFLINE"] = "true"

    venv = virtualenv_create(libexec, "python3.14")
    build_resources.each do |name|
      venv.pip_install resource(name), build_isolation: false
    end
    staged_resources = %w[
      openai python-dateutil urllib3
      homebrew-hatchling-openai homebrew-setuptools-scm-dateutil homebrew-setuptools-scm-urllib3
    ]
    venv.pip_install resources.reject { |r| (build_resources + staged_resources).include?(r.name) },
                     build_isolation: false

    # std_pip_args ignores installed packages, so remove each backend before switching versions.
    [
      ["hatchling", "homebrew-hatchling-openai", "openai"],
      ["setuptools-scm", "homebrew-setuptools-scm-dateutil", "python-dateutil"],
      ["setuptools-scm", "homebrew-setuptools-scm-urllib3", "urllib3"],
    ].each do |backend, sdk, consumer|
      system "python3.14", "-m", "pip", "--python=#{venv.root}/bin/python", "uninstall", "--yes", backend
      venv.pip_install resource(sdk), build_isolation: false
      venv.pip_install resource(consumer), build_isolation: false
      system "python3.14", "-m", "pip", "--python=#{venv.root}/bin/python", "uninstall", "--yes", backend
      venv.pip_install resource(backend), build_isolation: false
    end
    venv.pip_install_and_link buildpath, build_isolation: false
  end

  test do
    require "json"
    require "open3"
    require "timeout"

    # Stop the package's import-time upward search before it can read a user's .mcp.json.
    (testpath/".mcp.json").write "{}"

    python = libexec/"bin/python"
    offline_env = {
      "PATH"                     => ENV.fetch("PATH"),
      "HOME"                     => Dir.home,
      "MEMORA_DB_PATH"           => (testpath/"memories.db").to_s,
      "MEMORA_STORAGE_URI"       => "file://#{testpath}/memories.db",
      "PYTHONNOUSERSITE"         => "1",
      "PYDANTIC_DISABLE_PLUGINS" => "__all__",
      "XDG_CACHE_HOME"           => (testpath/"cache").to_s,
      "XDG_CONFIG_HOME"          => (testpath/"config").to_s,
      "XDG_DATA_HOME"            => (testpath/"data").to_s,
      "XDG_STATE_HOME"           => (testpath/"state").to_s,
    }
    # v0.4.3 supports --version on the installed CLI without starting either server.
    output, status = Open3.capture2(offline_env, bin/"memora-server", "--version",
                                   chdir: testpath, unsetenv_others: true)
    assert status.success?
    assert_match version.to_s, output

    output, status = Open3.capture2(offline_env, bin/"memora-server", "info",
                                   chdir: testpath, unsetenv_others: true)
    assert status.success?
    info = JSON.parse(output)
    assert_equal "local_sqlite", info.fetch("backend_type")
    assert_equal (testpath/"memories.db").to_s, info.fetch("db_path")

    (testpath/"offline.py").write <<~PYTHON
      import importlib
      import importlib.machinery
      import io
      import json
      import os
      from importlib import metadata, resources
      from pathlib import Path

      from cryptography.hazmat.primitives.ciphers.aead import AESGCM
      from jiter import from_json
      from markupsafe import escape
      from PIL import Image
      from pydantic import BaseModel, ValidationError
      from rpds import HashTrieMap

      from memora.backends import LocalSQLiteBackend
      from memora.graph.data import _INVALID_LIMIT, parse_graph_limit_value
      from memora.schema import connect

      for package, expected in {
          "memora-mcp": "#{version}", "mcp": "1.27.0", "openai": "2.21.0",
          "jiter": "0.13.0", "pluggy": "1.6.0", "vcs-versioning": "2.5.0",
          "setuptools-scm": "10.3.4",
      }.items():
          assert metadata.version(package) == expected, package
      for name in (
          "cryptography.hazmat.bindings._rust", "pydantic_core._pydantic_core",
          "rpds.rpds", "PIL._imaging", "jiter.jiter", "markupsafe._speedups",
      ):
          module = importlib.import_module(name)
          assert any(module.__file__.endswith(s) for s in importlib.machinery.EXTENSION_SUFFIXES), name
      assert from_json(b'{"answer":42}') == {"answer": 42}
      assert str(escape("<owned>")) == "&lt;owned&gt;"
      original = HashTrieMap({"answer": 41})
      assert original.insert("answer", 42)["answer"] == 42
      assert original["answer"] == 41
      cipher = AESGCM(bytes(range(32)))
      nonce = bytes(range(12))
      ciphertext = cipher.encrypt(nonce, b"owned fixture", None)
      assert cipher.decrypt(nonce, ciphertext, None) == b"owned fixture"
      image_bytes = io.BytesIO()
      Image.new("RGB", (2, 3), (12, 34, 56)).save(image_bytes, format="PNG")
      image_bytes.seek(0)
      with Image.open(image_bytes) as image:
          image.load()
          assert image.size == (2, 3) and image.getpixel((1, 2)) == (12, 34, 56)

      class Fixture(BaseModel):
          count: int

      assert Fixture.model_validate({"count": "3"}).count == 3
      try:
          Fixture.model_validate({"count": "invalid"})
      except ValidationError:
          pass
      else:
          raise AssertionError("invalid integer accepted")

      db = Path(os.environ["MEMORA_DB_PATH"])
      connection = connect(LocalSQLiteBackend(db))
      try:
          assert connection.execute("SELECT count(*) FROM memories").fetchone()[0] == 0
          connection.execute("CREATE TABLE homebrew_fixture (payload TEXT NOT NULL)")
          payload = {"owned": [1, 2, 3]}
          connection.execute("INSERT INTO homebrew_fixture VALUES (?)", (json.dumps(payload),))
          assert json.loads(connection.execute("SELECT payload FROM homebrew_fixture").fetchone()[0]) == payload
          connection.commit()
      finally:
          connection.close()
      assert parse_graph_limit_value(" 42 ") == 42
      assert parse_graph_limit_value("-1") is _INVALID_LIMIT
      for asset in ("index.html", "_graph_limit.mjs"):
          assert resources.files("memora.graph").joinpath(asset).is_file(), asset
    PYTHON
    output, status = Open3.capture2(offline_env, python, testpath/"offline.py",
                                   chdir: testpath, unsetenv_others: true)
    assert status.success?, output
    system "python3.14", "-m", "pip", "--python=#{python}", "check"

    # Do not start the default graph listener or invoke any registered tool.
    Open3.popen2(offline_env, bin/"memora-server", "--transport", "stdio", "--no-graph",
                chdir: testpath, unsetenv_others: true) do |input, output, process|
      Timeout.timeout(60) do
        read_response = lambda do
          loop do
            line = output.gets
            raise "memora-server exited before responding" unless line

            begin
              break JSON.parse(line)
            rescue JSON::ParserError
              next
            end
          end
        end

        input.puts JSON.generate(jsonrpc: "2.0", id: 1, method: "initialize", params: {
          protocolVersion: "2025-06-18", capabilities: {}, clientInfo: { name: "Homebrew", version: "1.0" }
        })
        response = read_response.call
        assert_equal 1, response.fetch("id")
        assert_nil response["error"]
        assert_equal "Memory MCP Server", response.dig("result", "serverInfo", "name")

        input.puts JSON.generate(jsonrpc: "2.0", method: "notifications/initialized", params: {})
        input.puts JSON.generate(jsonrpc: "2.0", id: 2, method: "tools/list", params: {})
        response = read_response.call
        assert_equal 2, response.fetch("id")
        assert_nil response["error"]
        assert_includes response.dig("result", "tools").map { |tool| tool["name"] }, "memory_create"
      end
    ensure
      input.close unless input.closed?
      Process.kill("TERM", process.pid) if process.alive?
      Process.kill("KILL", process.pid) unless process.join(5)
    end
  end
end
