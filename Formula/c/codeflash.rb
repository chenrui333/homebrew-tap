class Codeflash < Formula
  include Language::Python::Virtualenv

  desc "Optimize your code automatically with AI"
  homepage "https://github.com/codeflash-ai/codeflash"
  url "https://files.pythonhosted.org/packages/c5/cf/8ce2ac7c3e9174e8eee3eae27b47fea506bb937e5ef5ea226316482485dd/codeflash-0.20.5.tar.gz"
  sha256 "8f627416ac9f131a7d6893b1ae6984e0f46fa658aedc330e9990aeeaf461021b"
  license "BUSL-1.1"
  head "https://github.com/codeflash-ai/codeflash.git", branch: "main"

  depends_on "rust" => :build # for tree-sitter
  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.13"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  pypi_packages exclude_packages: %w[certifi pydantic pydantic-core]

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/ee/67/531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5/annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "backoff" do
    url "https://files.pythonhosted.org/packages/47/d7/5bbeb12c44d7c4f2fb5b56abce497eb5ed9f34d85701de869acedd602619/backoff-2.2.1.tar.gz"
    sha256 "03f829f5bb1923180821643f8753b0502c3b682293992485b0eef2807afa5cba"
  end

  resource "blessed" do
    url "https://files.pythonhosted.org/packages/9f/1f/f2535d0eb1fb8af7915f96b4d42810345c255bbbca39939a23e59c0695d8/blessed-1.38.0.tar.gz"
    sha256 "89ce6ec6567f7aced0716b73577b7a1702eb23c667838bb46d7d9bd48c36d1b3"
  end

  resource "cattrs" do
    url "https://files.pythonhosted.org/packages/a0/ec/ba18945e7d6e55a58364d9fb2e46049c1c2998b3d805f19b703f14e81057/cattrs-26.1.0.tar.gz"
    sha256 "fa239e0f0ec0715ba34852ce813986dfed1e12117e209b816ab87401271cdd40"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e7/a1/67fe25fac3c7642725500a3f6cfe5821ad557c3abb11c9d20d12c7008d3e/charset_normalizer-3.4.7.tar.gz"
    sha256 "ae89db9e5f98a11a4bf50407d4363e7b09b31e55bc117b4f7d80aab97ba009e5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/bb/63/f9e1ea081ce35720d8b92acde70daaedace594dc93b693c869e0d5910718/click-8.3.3.tar.gz"
    sha256 "398329ad4837b2ff7cbe1dd166a4c0f8900c3ca3a218de04466f38f6497f18a2"
  end

  resource "codeflash-benchmark" do
    url "https://files.pythonhosted.org/packages/7c/10/4d43fcb71914324efc9e1f88ec88d3abd2a615aaf26d268f26dd29a9bffa/codeflash_benchmark-0.3.0.tar.gz"
    sha256 "465232854ed64a263c0c4c8d1f919a3a92b82b73487806c45686df89feb62037"
  end

  resource "coverage" do
    url "https://files.pythonhosted.org/packages/9d/e0/70553e3000e345daff267cec284ce4cbf3fc141b6da229ac52775b5428f1/coverage-7.13.5.tar.gz"
    sha256 "c81f6515c4c40141f83f502b07bbfa5c240ba25bbe73da7b33f1e5b6120ff179"
  end

  resource "crosshair-tool" do
    url "https://files.pythonhosted.org/packages/60/c7/ac2e7a78fa58d08b66919de9c9e13d45974976407e53ef8bfc64d62d11d5/crosshair_tool-0.0.104.tar.gz"
    sha256 "c92cc8554ec1f35e079c041025cf0534d8ce83f6a8aedb7dec68d60c6d6989c2"
  end

  resource "dill" do
    url "https://files.pythonhosted.org/packages/81/e1/56027a71e31b02ddc53c7d65b01e68edf64dea2932122fe7746a516f75d5/dill-0.4.1.tar.gz"
    sha256 "423092df4182177d4d8ba8290c8a5b640c66ab35ec7da59ccfa00f6fa3eea5fa"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/fc/f8/98eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3/distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "editor" do
    url "https://files.pythonhosted.org/packages/d9/4f/00e0b75d86bb1e6a943c08942619e3f31de54a0dce3b33b14ae3c2af2dc0/editor-1.7.0.tar.gz"
    sha256 "979b25e3f7e0386af4478e7392ecb99e6c16a42db7c4336d6b16658fa0449fb3"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/b5/fe/997687a931ab51049acce6fa1f23e8f01216374ea81374ddee763c493db5/filelock-3.29.0.tar.gz"
    sha256 "69974355e960702e789734cb4871f884ea6fe50bd8404051a3530bc07809cf90"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/72/94/63b0fc47eb32792c7ba1fe1b694daec9a63620db1e313033d18140c2320a/gitdb-4.0.12.tar.gz"
    sha256 "5ef71f855d191a3326fcfbc0d5da835f26b13fbcba60c32c21091c349ffdb571"
  end

  resource "gitpython" do
    url "https://files.pythonhosted.org/packages/c1/bd/50db468e9b1310529a19fce651b3b0e753b5c07954d486cba31bbee9a5d5/gitpython-3.1.47.tar.gz"
    sha256 "dba27f922bd2b42cb54c87a8ab3cb6beb6bf07f3d564e21ac848913a05a8a3cd"
  end

  resource "humanize" do
    url "https://files.pythonhosted.org/packages/ba/66/a3921783d54be8a6870ac4ccffcd15c4dc0dd7fcce51c6d63b8c63935276/humanize-4.15.0.tar.gz"
    sha256 "1dd098483eb1c7ee8e32eb2e99ad1910baefa4b75c3aff3a82f4d78688993b10"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ce/cc/762dfb036166873f0059f3b7de4565e1b5bc3d6f28a414c13da27e442f99/idna-3.13.tar.gz"
    sha256 "585ea8fe5d69b9181ec1afba340451fba6ba764af97026f92a91d4eef164a242"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/a9/01/15bb152d77b21318514a96f43af312635eb2500c96b55398d020c93d86ea/importlib_metadata-9.0.0.tar.gz"
    sha256 "a4f57ab599e6a2e3016d7595cfd72eb4661a5106e787a95bcc90c7105b831efc"
  end

  resource "importlib-resources" do
    url "https://files.pythonhosted.org/packages/e4/06/b56dfa750b44e86157093bc8fca0ab81dccbf5260510de4eaf1cb69b5b99/importlib_resources-7.1.0.tar.gz"
    sha256 "0722d4c6212489c530f2a145a34c0a7a3b4721bc96a15fada5930e2a0b760708"
  end

  resource "iniconfig" do
    url "https://files.pythonhosted.org/packages/72/34/14ca021ce8e5dfedc35312d08ba8bf51fdd999c576889fc2c24cb97f4f10/iniconfig-2.3.0.tar.gz"
    sha256 "c76315c77db068650d49c5b56314774a7804df16fee4402c1f19d6d15d8c4730"
  end

  resource "inquirer" do
    url "https://files.pythonhosted.org/packages/c1/79/165579fdcd3c2439503732ae76394bf77f5542f3dd18135b60e808e4813c/inquirer-3.4.1.tar.gz"
    sha256 "60d169fddffe297e2f8ad54ab33698249ccfc3fc377dafb1e5cf01a0efb9cbe5"
  end

  resource "isort" do
    url "https://files.pythonhosted.org/packages/ef/7c/ec4ab396d31b3b395e2e999c8f46dec78c5e29209fac49d1f4dace04041d/isort-8.0.1.tar.gz"
    sha256 "171ac4ff559cdc060bcfff550bc8404a486fee0caab245679c2abe7cb253c78d"
  end

  resource "jedi" do
    url "https://files.pythonhosted.org/packages/72/3a/79a912fbd4d8dd6fbb02bf69afd3bb72cf0c729bb3063c6f4498603db17a/jedi-0.19.2.tar.gz"
    sha256 "4770dc3de41bde3966b02eb84fbcf557fb33cce26ad23da12c742fb50ecb11f0"
  end

  resource "junitparser" do
    url "https://files.pythonhosted.org/packages/26/61/1685f940545177c553683c10114f5bb5bc093996fe651b29b8bee07f63e9/junitparser-5.0.0.tar.gz"
    sha256 "f15e292877258d7c5755d672ce86f82c3622c7ea4c2f44f55de44ed7518484d3"
  end

  resource "libcst" do
    url "https://files.pythonhosted.org/packages/de/cd/337df968b38d94c5aabd3e1b10630f047a2b345f6e1d4456bd9fe7417537/libcst-1.8.6.tar.gz"
    sha256 "f729c37c9317126da9475bdd06a7208eb52fcbd180a6341648b45a56b4ba708b"
  end

  resource "line-profiler" do
    url "https://files.pythonhosted.org/packages/03/b6/6d18ad201417a9c5168995541d0fd7981b5652b2b34f6e46a3a93c0f1beb/line_profiler-5.0.2.tar.gz"
    sha256 "8d8a990c84c64bcde45af22af502d17bc0ae107be405ce41bba92af5c39c0000"
  end

  resource "lsprotocol" do
    url "https://files.pythonhosted.org/packages/e9/26/67b84e6ec1402f0e6764ef3d2a0aaf9a79522cc1d37738f4e5bb0b21521a/lsprotocol-2025.0.0.tar.gz"
    sha256 "e879da2b9301e82cfc3e60d805630487ac2f7ab17492f4f5ba5aaba94fe56c29"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/28/30/9abc9e34c657c33834eaf6cd02124c61bdf5944d802aa48e69be8da3585d/lxml-6.1.0.tar.gz"
    sha256 "bfd57d8008c4965709a919c3e9a98f76c2c7cb319086b3d26858250620023b13"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/5b/f5/4ec618ed16cc4f8fb3b701563655a69816155e79e24a17b651541804721d/markdown_it_py-4.0.0.tar.gz"
    sha256 "cb0a2b4aa34f932c007117b194e945bd74e0ec24133ceb5bac59009cda1cb9f3"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/a2/6e/371856a3fb9d31ca8dac321cda606860fa4548858c0cc45d9d1d4ca2628b/mypy_extensions-1.1.0.tar.gz"
    sha256 "52e68efc3284861e772bbcd66823fde5ae21fd2fdb51c62a211403730b916558"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
    sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
  end

  resource "parameterized" do
    url "https://files.pythonhosted.org/packages/ea/49/00c0c0cc24ff4266025a53e41336b79adaa5a4ebfad214f433d623f9865e/parameterized-0.9.0.tar.gz"
    sha256 "7fc905272cefa4f364c1a3429cbbe9c0f98b793988efb5bf90aac80f08db09b1"
  end

  resource "parso" do
    url "https://files.pythonhosted.org/packages/81/76/a1e769043c0c0c9fe391b702539d594731a4362334cdf4dc25d0c09761e7/parso-0.8.6.tar.gz"
    sha256 "2b9a0332696df97d454fa67b81618fd69c35a7b90327cbe6ba5c92d2c68a7bfd"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/9f/4a/0883b8e3802965322523f0b200ecf33d31f10991d0401162f4b23c698b42/platformdirs-4.9.6.tar.gz"
    sha256 "3bfa75b0ad0db84096ae777218481852c0ebc6c727b3168c1b9e0118e458cf0a"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f9/e2/3e91f31a7d2b083fe6ef3fa267035b518369d9511ffab804f839851d2779/pluggy-1.6.0.tar.gz"
    sha256 "7dcc130b76258d33b90f61b658791dede3486c3e6bfb003ee5c9bfb396dd22f3"
  end

  resource "posthog" do
    url "https://files.pythonhosted.org/packages/2a/09/ecc82b5ba5876164a3807adcc5101466da1e4416600075bdbd2071327457/posthog-7.13.1.tar.gz"
    sha256 "5e53c57db076807530bbec5634c96673ceae8e8e58b99c983af26f02bb4759aa"
  end

  resource "pygls" do
    url "https://files.pythonhosted.org/packages/da/2e/7bbe061d175c0baddde8fc9edb908a4c31ba5d9165b8c68e3439c3a9f138/pygls-2.1.1.tar.gz"
    sha256 "1da03ba9053201bb337dcdd8d121df70feb2a91e1a0dcc74de5da79755b1a201"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  end

  resource "pytest" do
    url "https://files.pythonhosted.org/packages/7d/0d/549bd94f1a0a402dc8cf64563a117c0f3765662e2e668477624baeec44d5/pytest-9.0.3.tar.gz"
    sha256 "b86ada508af81d19edeb213c681b1d48246c1a91d304c6c81a427674c17eb91c"
  end

  resource "pytest-asyncio" do
    url "https://files.pythonhosted.org/packages/90/2c/8af215c0f776415f3590cac4f9086ccefd6fd463befeae41cd4d3f193e5a/pytest_asyncio-1.3.0.tar.gz"
    sha256 "d7f52f36d231b80ee124cd216ffb19369aa168fc10095013c6b014a34d3ee9e5"
  end

  resource "pytest-timeout" do
    url "https://files.pythonhosted.org/packages/ac/82/4c9ecabab13363e72d880f2fb504c5f750433b2b6f16e99f4ec21ada284c/pytest_timeout-2.4.0.tar.gz"
    sha256 "7e68e90b01f9eff71332b25001f85c75495fc4e3a836701876183c4bcfd0540a"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml-ft" do
    url "https://files.pythonhosted.org/packages/5e/eb/5a0d575de784f9a1f94e2b1288c6886f13f34185e13117ed530f32b6f8a8/pyyaml_ft-8.0.0.tar.gz"
    sha256 "0c947dce03954c7b5d38869ed4878b2e6ff1d44b08a0d84dc83fdad205ae39ab"
  end

  resource "readchar" do
    url "https://files.pythonhosted.org/packages/ed/49/a10341024c45bed95d13197ec9ef0f4e2fd10b5ca6e7f8d7684d18082398/readchar-4.2.2.tar.gz"
    sha256 "e3b270fe16fc90c50ac79107700330a133dd4c63d22939f5b03b4f24564d5dd8"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/5f/a4/98b9c7c6428a668bf7e42ebb7c79d576a1c3c1e3ae2d47e674b468388871/requests-2.33.1.tar.gz"
    sha256 "18817f8c57c6263968bc123d237e3b8b08ac046f5456bd1e307ee8f4250d3517"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "runs" do
    url "https://files.pythonhosted.org/packages/f2/ae/095cb626504733e288a81f871f86b10530b787d77c50193c170daaca0df1/runs-1.3.0.tar.gz"
    sha256 "cca304b631dbefec598c7bfbcfb50d6feace6d3a968734b67fd42d3c728f5a05"
  end

  resource "sentry-sdk" do
    url "https://files.pythonhosted.org/packages/26/b3/fb8291170d0e844173164709fc0fa0c221ed75a5da740c8746f2a83b4eb1/sentry_sdk-2.58.0.tar.gz"
    sha256 "c1144d947352d54e5b7daa63596d9f848adf684989c06c4f5a659f0c85a18f6f"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/1f/ea/49c993d6dfdd7338c9b1000a0f36817ed7ec84577ae2e52f890d1a4ff909/smmap-5.0.3.tar.gz"
    sha256 "4d9debb8b99007ae47165abc08670bd74cb74b5227dda7f643eccc4e9eb5642c"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/c3/af/14b24e41977adb296d6bd1fb59402cf7d60ce364f90c890bd2ec65c43b5a/tomlkit-0.14.0.tar.gz"
    sha256 "cf00efca415dbd57575befb1f6634c4f42d2d87dbba376128adb42c121b87064"
  end

  resource "tree-sitter" do
    url "https://files.pythonhosted.org/packages/66/7c/0350cfc47faadc0d3cf7d8237a4e34032b3014ddf4a12ded9933e1648b55/tree-sitter-0.25.2.tar.gz"
    sha256 "fe43c158555da46723b28b52e058ad444195afd1db3ca7720c59a254544e9c20"
  end

  resource "tree-sitter-groovy" do
    url "https://github.com/amaanq/tree-sitter-groovy/archive/refs/tags/v0.1.2.tar.gz"
    sha256 "d3eafa455e3a092d79c2d3488fa58a461c1a18cdfa1b7edb22e168b513e454fe"
  end

  resource "tree-sitter-java" do
    url "https://github.com/tree-sitter/tree-sitter-java/archive/refs/tags/v0.23.5.tar.gz"
    sha256 "cb199e0faae4b2c08425f88cbb51c1a9319612e7b96315a174a624db9bf3d9f0"
  end

  resource "tree-sitter-javascript" do
    url "https://github.com/tree-sitter/tree-sitter-javascript/archive/refs/tags/v0.25.0.tar.gz"
    sha256 "9712fc283d3dc01d996d20b6392143445d05867a7aad76fdd723824468428b86"
  end

  resource "tree-sitter-kotlin" do
    url "https://github.com/tree-sitter-grammars/tree-sitter-kotlin/archive/refs/tags/v1.1.0.tar.gz"
    sha256 "3c36bd5627fff38e4323ebead1f7e86e6d1727f0353618d1c976fea88260ba90"
  end

  resource "tree-sitter-typescript" do
    url "https://github.com/tree-sitter/tree-sitter-typescript/archive/refs/tags/v0.23.2.tar.gz"
    sha256 "2c4ce711ae8d1218a3b2f899189298159d672870b5b34dff5d937bed2f3e8983"
  end

  resource "typeshed-client" do
    url "https://files.pythonhosted.org/packages/46/de/cc79c33f6268740567ea109c11809e3c799daf5c1c5aeffb9c3f3b052dbe/typeshed_client-2.10.0.tar.gz"
    sha256 "906bf343595aed4a120ccc0a35dde2d85cae8c15d015703a768541291e38cfc3"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "typing-inspect" do
    url "https://files.pythonhosted.org/packages/dc/74/1789779d91f1961fa9438e9a8710cdae6bd138c80d7303996933d117264a/typing_inspect-0.9.0.tar.gz"
    sha256 "b23fc42ff6f6ef6954e4852c1fb512cdd18dbea03134f91f856a95ccc9461f78"
  end

  resource "typing-inspection" do
    url "https://files.pythonhosted.org/packages/55/e3/70399cb7dd41c10ac53367ae42139cf4b1ca5f36bb3dc6c9d33acdb43655/typing_inspection-0.4.2.tar.gz"
    sha256 "ba561c48a67c5958007083d386c3295464928b01faa735ab8547c5692e87f464"
  end

  resource "unidiff" do
    url "https://files.pythonhosted.org/packages/a3/48/81be0ac96e423a877754153699731ef439fd7b80b4c8b5425c94ed079ebd/unidiff-0.7.5.tar.gz"
    sha256 "2e5f0162052248946b9f0970a40e9e124236bf86c82b70821143a6fc1dea2574"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c7/24/5f1b3bdffd70275f6661c76461e25f024d5a38a46f04aaca912426a2b1d3/urllib3-2.6.3.tar.gz"
    sha256 "1b62b6884944a57dbe321509ab94fd4d3b307075e0c2eae991ac71ee15ad38ed"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/35/a2/8e3becb46433538a38726c948d3399905a4c7cabd0df578ede5dc51f0ec2/wcwidth-0.6.0.tar.gz"
    sha256 "cdc4e4262d6ef9a1a57e018384cbeb1208d8abbc64176027e2c2455c81313159"
  end

  resource "xmod" do
    url "https://files.pythonhosted.org/packages/8b/3f/0bc3b89c1dd4dee1f954db4c857f8fbe9cdfa8b25efe370b6d78399a93ac/xmod-1.9.0.tar.gz"
    sha256 "98b2e7e8e659c51b635f4e98faf3fa1f3f96dab2805f19ddd6e352bbb4d23991"
  end

  resource "z3-solver" do
    url "https://files.pythonhosted.org/packages/93/3b/2b714c40ef2ecf6d8aa080056b9c24a77fe4ca2c83abd83e9c93d34212ac/z3_solver-4.16.0.0.tar.gz"
    sha256 "263d9ad668966e832c2b246ba0389298a599637793da2dc01cc5e4ef4b0b6c78"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/30/21/093488dfc7cc8964ded15ab726fad40f25fd3d788fd741cc1c5a17d78ee8/zipp-3.23.1.tar.gz"
    sha256 "32120e378d32cd9714ad503c1d024619063ec28aad2248dc6672ad13edfa5110"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codeflash --version")
  end
end
