class Codeflash < Formula
  include Language::Python::Virtualenv

  desc "Optimize your code automatically with AI"
  homepage "https://github.com/codeflash-ai/codeflash"
  url "https://files.pythonhosted.org/packages/2d/bc/d86b03b88cf254f4581162a33c8f296092d1f1c46bd7c3478802dd8b9c23/codeflash-0.20.6.tar.gz"
  sha256 "411202748597aff5ebb3fd8bceb510da209b3253a86fe49783238113076bba55"
  license "BUSL-1.1"
  head "https://github.com/codeflash-ai/codeflash.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "24ad8c7af52f987aed0e4de918a23a1cacc3a3cc5e7c141259531af182a0e142"
    sha256 cellar: :any, arm64_sequoia: "864137f0ef80ebc06b2e90d77e6f02a72bf5a098d0243070cc11b92a56fcb610"
    sha256 cellar: :any, arm64_sonoma:  "d0819cebea31a1b937238eeef236141cec57ea4ed69df3ed0301f6dfa91d9569"
    sha256 cellar: :any, arm64_linux:   "4e6866e83476cfe829d465df6d7c432a83d17eb8d67c6e19732baa953013f616"
    sha256 cellar: :any, x86_64_linux:  "863ac09bfdac0c6ec5a989ecab1489bc3453833d2de0cf7b238d6c08e14ca7d0"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build # for tree-sitter
  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "lz4"
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.13"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  on_linux do
    depends_on "curl" # for libdebuginfod
    depends_on "elfutils" # for libdebuginfod
    depends_on "json-c" # for libdebuginfod
    depends_on "libunwind"

    # TODO: Consider creating a formula for (lib)debuginfod
    resource "elfutils" do
      url "https://sourceware.org/elfutils/ftp/0.194/elfutils-0.194.tar.bz2"
      sha256 "09e2ff033d39baa8b388a2d7fbc5390bfde99ae3b7c67c7daaf7433fbcf0f01e"
    end
  end

  pypi_packages exclude_packages: %w[certifi pydantic pydantic-core]

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "backoff" do
    url "https://files.pythonhosted.org/packages/47/d7/5bbeb12c44d7c4f2fb5b56abce497eb5ed9f34d85701de869acedd602619/backoff-2.2.1.tar.gz"
    sha256 "03f829f5bb1923180821643f8753b0502c3b682293992485b0eef2807afa5cba"
  end

  resource "blessed" do
    url "https://files.pythonhosted.org/packages/7b/73/445c4ef32565d2f5af49f18c4163a32850c9328774ee0af74ed081d4ba15/blessed-1.44.0.tar.gz"
    sha256 "d3b5037f0143eb7c80b2000be5bcdf86161af68aed231b91deadbce4e7379785"
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
    url "https://files.pythonhosted.org/packages/9b/98/518d8e5081007684232226f475082b30087d0f585e8457db087298259f49/click-8.4.1.tar.gz"
    sha256 "918b5633eddf6b41c32d4f454bf0de810065c74e3f7dbf8ee5452f8be88d3e96"
  end

  resource "codeflash-benchmark" do
    url "https://files.pythonhosted.org/packages/7c/10/4d43fcb71914324efc9e1f88ec88d3abd2a615aaf26d268f26dd29a9bffa/codeflash_benchmark-0.3.0.tar.gz"
    sha256 "465232854ed64a263c0c4c8d1f919a3a92b82b73487806c45686df89feb62037"
  end

  resource "coverage" do
    url "https://files.pythonhosted.org/packages/54/fd/0ab2772530e946e1be1abd0bc09e647ec9b02e88f0867857601fefca8953/coverage-7.14.1.tar.gz"
    sha256 "30c08f7d90415aa98b3c990385dea2939b0da55f38515e5b369b83655f8523be"
  end

  resource "crosshair-tool" do
    url "https://files.pythonhosted.org/packages/6f/2d/0044cb0d563ad63d8492b4b18ca688182b089b788580da79000bb3c20d47/crosshair_tool-0.0.106.tar.gz"
    sha256 "7e37ff9829e6dffe40311a8c712999e989160663919e7114480bb22a6653dd72"
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
    url "https://files.pythonhosted.org/packages/ae/5f/fe06c2a13a5282dcef4c7133bb348d4125a9aa69c5fb49037a004599d73a/editor-1.8.0.tar.gz"
    sha256 "b07e1bbcb8b33f05c2e6ed3ce77ee9756354ada840a18aad7c0536d967fe4c0b"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/e6/dc/be6cbe99670cd6e4ad387123647cb08e0c32975e223f82551e914c5568a6/filelock-3.29.4.tar.gz"
    sha256 "10cdb3656fc44541cdf30652a93fb10ec6b05325620eb316bd26893e4201538a"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/72/94/63b0fc47eb32792c7ba1fe1b694daec9a63620db1e313033d18140c2320a/gitdb-4.0.12.tar.gz"
    sha256 "5ef71f855d191a3326fcfbc0d5da835f26b13fbcba60c32c21091c349ffdb571"
  end

  resource "gitpython" do
    url "https://files.pythonhosted.org/packages/33/f6/354ae6491228b5eb40e10d89c4d13c651fe1cf7556e35ebdded50cff57ce/gitpython-3.1.50.tar.gz"
    sha256 "80da2d12504d52e1f998772dc5baf6e553f8d2fcfe1fcc226c9d9a2ee3372dcc"
  end

  resource "humanize" do
    url "https://files.pythonhosted.org/packages/ba/66/a3921783d54be8a6870ac4ccffcd15c4dc0dd7fcce51c6d63b8c63935276/humanize-4.15.0.tar.gz"
    sha256 "1dd098483eb1c7ee8e32eb2e99ad1910baefa4b75c3aff3a82f4d78688993b10"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cd/63/9496c57188a2ee585e0f1db071d75089a11e98aa86eb99d9d7618fc1edce/idna-3.18.tar.gz"
    sha256 "ffb385a7e039654cef1ab9ef32c6fafe283c0c0467bba1d9029738ce4a14a848"
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
    url "https://files.pythonhosted.org/packages/46/b7/a3635f6a2d7cf5b5dd98064fc1d5fbbafcb25477bcea204a3a92145d158b/jedi-0.20.0.tar.gz"
    sha256 "c3f4ccbd276696f4b19c54618d4fb18f9fc24b0aef02acf704b23f487daa1011"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "jinxed" do
    url "https://files.pythonhosted.org/packages/3c/5e/2eea62fd64689685b082f29e1dcd0e57a19009c90733318a4bc9ddb54b2c/jinxed-2.0.4.tar.gz"
    sha256 "a92ac48923433c0a88577bb0479191788813fd5055ef17ff2b04a701a1b83f19"
  end

  resource "junitparser" do
    url "https://files.pythonhosted.org/packages/12/ed/063362ed6c5e39273879ba3db91da13b00551c6277de6842e45ab55a1a22/junitparser-5.0.1.tar.gz"
    sha256 "45d100ca35ce5e2596c1f251de5e0f9411827aa93edaba7ad2d8eef423eecdd0"
  end

  resource "libcst" do
    url "https://files.pythonhosted.org/packages/de/cd/337df968b38d94c5aabd3e1b10630f047a2b345f6e1d4456bd9fe7417537/libcst-1.8.6.tar.gz"
    sha256 "f729c37c9317126da9475bdd06a7208eb52fcbd180a6341648b45a56b4ba708b"
  end

  resource "line-profiler" do
    url "https://files.pythonhosted.org/packages/03/b6/6d18ad201417a9c5168995541d0fd7981b5652b2b34f6e46a3a93c0f1beb/line_profiler-5.0.2.tar.gz"
    sha256 "8d8a990c84c64bcde45af22af502d17bc0ae107be405ce41bba92af5c39c0000"
  end

  resource "linkify-it-py" do
    url "https://files.pythonhosted.org/packages/2e/c9/06ea13676ef354f0af6169587ae292d3e2406e212876a413bf9eece4eb23/linkify_it_py-2.1.0.tar.gz"
    sha256 "43360231720999c10e9328dc3691160e27a718e280673d444c38d7d3aaa3b98b"
  end

  resource "lsprotocol" do
    url "https://files.pythonhosted.org/packages/e9/26/67b84e6ec1402f0e6764ef3d2a0aaf9a79522cc1d37738f4e5bb0b21521a/lsprotocol-2025.0.0.tar.gz"
    sha256 "e879da2b9301e82cfc3e60d805630487ac2f7ab17492f4f5ba5aaba94fe56c29"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/05/3b/aab6728cae887456f409b4d75e8a01856e4f04bd510de38052a47768b680/lxml-6.1.1.tar.gz"
    sha256 "ba96ae44888e0185281e937633a743ea90d5a196c6000f82565ebb0580012d40"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "mdit-py-plugins" do
    url "https://files.pythonhosted.org/packages/59/fc/f8d0863f8862f25602c0404d75568e89fb6b4109804645e5cdfb1be5cf56/mdit_py_plugins-0.6.1.tar.gz"
    sha256 "a2bca0f039f39dbd35fb74ae1b5f998608c437463371f0ff7f49a19a17a114d0"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "memray" do
    url "https://files.pythonhosted.org/packages/96/04/5b886a36df947599e0f37cd46e6e44e565299815f044e2303ab2ae9f8870/memray-1.19.3.tar.gz"
    sha256 "4e0fb29ff0a50c0ec9dc84294d8f2c83419feba561a37628b304c2ae4fe73d03"
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
    url "https://files.pythonhosted.org/packages/30/4b/90c937815137d43ce71ba043cd3566221e9df6b9c805f24b5d138c9d40a7/parso-0.8.7.tar.gz"
    sha256 "eaaac4c9fdd5e9e8852dc778d2d7405897ec510f2a298071453e5e3a07914bb1"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/d7/47/e4501f49c178ae1d9f4a75073fda4204f52647993f075a9db4d14930e0c5/platformdirs-4.10.0.tar.gz"
    sha256 "31e761a6a0ca04faf7353ea759bdba55652be214725111e5aac52dfa29d4bef7"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f9/e2/3e91f31a7d2b083fe6ef3fa267035b518369d9511ffab804f839851d2779/pluggy-1.6.0.tar.gz"
    sha256 "7dcc130b76258d33b90f61b658791dede3486c3e6bfb003ee5c9bfb396dd22f3"
  end

  resource "posthog" do
    url "https://files.pythonhosted.org/packages/51/6e/3a4d9e3e4447a43f6f684316da41d67b66c9d898b089948fb951b27adf41/posthog-7.18.3.tar.gz"
    sha256 "fb3599ae1bf7ef6c10a151ff71511b74db1c1879d9255db0d05618c449188b07"
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
    url "https://files.pythonhosted.org/packages/84/0e/b5858858d74958632c49b72cb25a3976ff9f632397626715be71c89d3971/pytest-9.1.0.tar.gz"
    sha256 "41dd9148c08072446394cefd3d79701701335a9f4cae69ba92e39f6c7f5c061c"
  end

  resource "pytest-asyncio" do
    url "https://files.pythonhosted.org/packages/43/7c/d36d04db312ecf4298932ef77e6e4a9e8ad017906e24e34f0b0c361a2473/pytest_asyncio-1.4.0.tar.gz"
    sha256 "c6c0d2259945122819f171a32ecea2c349ead889ee28176caaf492143424be42"
  end

  resource "pytest-memray" do
    url "https://files.pythonhosted.org/packages/3d/28/f67963efed56d847d028d0bb939f26cdeb32c4de474b3befc9da43bf18f9/pytest_memray-1.8.0.tar.gz"
    sha256 "c0c706ef81941a7aa7064f2b3b8b5cdc0cea72b5277c6a6a09b113ca9ab30bdb"
  end

  resource "pytest-timeout" do
    url "https://files.pythonhosted.org/packages/ac/82/4c9ecabab13363e72d880f2fb504c5f750433b2b6f16e99f4ec21ada284c/pytest_timeout-2.4.0.tar.gz"
    sha256 "7e68e90b01f9eff71332b25001f85c75495fc4e3a836701876183c4bcfd0540a"
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
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
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
    url "https://files.pythonhosted.org/packages/f6/5d/a343201726150e05f2036eeb6e493e2e2f8bf8a66f5aa70f2f4ac96f9ca3/sentry_sdk-2.62.0.tar.gz"
    sha256 "3c870b9f50d9fd15b58c817dbde1c7cfaa9fe3f05df0a4c6edd5571cb82f5491"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/1f/ea/49c993d6dfdd7338c9b1000a0f36817ed7ec84577ae2e52f890d1a4ff909/smmap-5.0.3.tar.gz"
    sha256 "4d9debb8b99007ae47165abc08670bd74cb74b5227dda7f643eccc4e9eb5642c"
  end

  resource "textual" do
    url "https://files.pythonhosted.org/packages/9b/7a/c519db0aba5024f86e71e9631810bfdd6866ed2c8695bd7fa34b90e7ef59/textual-8.2.7.tar.gz"
    sha256 "658f568ff81e30ed43890c3e07520390e5cf1b4763822006e060656b0a88f105"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/51/db/03eaf4331631ef6b27d6e3c9b68c54dc6f0d63d87201fed600cc409307fd/tomlkit-0.15.0.tar.gz"
    sha256 "7d1a9ecba3086638211b13814ea79c90dd54dd11993564376f3aa92271f5c7a3"
  end

  resource "tree-sitter" do
    url "https://files.pythonhosted.org/packages/66/7c/0350cfc47faadc0d3cf7d8237a4e34032b3014ddf4a12ded9933e1648b55/tree-sitter-0.25.2.tar.gz"
    sha256 "fe43c158555da46723b28b52e058ad444195afd1db3ca7720c59a254544e9c20"
  end

  resource "tree-sitter-go" do
    url "https://files.pythonhosted.org/packages/01/05/727308adbbc79bcb1c92fc0ea10556a735f9d0f0a5435a18f59d40f7fd77/tree_sitter_go-0.25.0.tar.gz"
    sha256 "a7466e9b8d94dda94cae8d91629f26edb2d26166fd454d4831c3bf6dfa2e8d68"
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
    url "https://files.pythonhosted.org/packages/54/5d/97d6fa8c204b0d42be931e7a568b306cda43f93ff45f8b47537ee61390de/typeshed_client-2.12.0.tar.gz"
    sha256 "54dcfa25fcff82cedcb1b51c03c1b3c51a614097aab8fe49e4316aff6f79d9c7"
  end

  resource "typing-inspect" do
    url "https://files.pythonhosted.org/packages/dc/74/1789779d91f1961fa9438e9a8710cdae6bd138c80d7303996933d117264a/typing_inspect-0.9.0.tar.gz"
    sha256 "b23fc42ff6f6ef6954e4852c1fb512cdd18dbea03134f91f856a95ccc9461f78"
  end

  resource "uc-micro-py" do
    url "https://files.pythonhosted.org/packages/78/67/9a363818028526e2d4579334460df777115bdec1bb77c08f9db88f6389f2/uc_micro_py-2.0.0.tar.gz"
    sha256 "c53691e495c8db60e16ffc4861a35469b0ba0821fe409a8a7a0a71864d33a811"
  end

  resource "unidiff" do
    url "https://files.pythonhosted.org/packages/a3/48/81be0ac96e423a877754153699731ef439fd7b80b4c8b5425c94ed079ebd/unidiff-0.7.5.tar.gz"
    sha256 "2e5f0162052248946b9f0970a40e9e124236bf86c82b70821143a6fc1dea2574"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/49/b4/51fe890511f0f242d07cb1ebe6a5b6db417262b9d2568b460347c57d95cc/wcwidth-0.8.1.tar.gz"
    sha256 "faf5b4a5366a72dc49cad48cdf21f52bdf63bdda995178e483ba247ff79089b9"
  end

  resource "xmod" do
    url "https://files.pythonhosted.org/packages/7a/3b/5a0d2670bab661164e27a5c27c448ae6204458c97cb94ccf89d0c47715bc/xmod-1.10.0.tar.gz"
    sha256 "b40b2a54d56684b01eb9627892b0c179918e8ef0bd4d7f3bac7a3fdba11cd6e6"
  end

  resource "z3-solver" do
    url "https://files.pythonhosted.org/packages/93/3b/2b714c40ef2ecf6d8aa080056b9c24a77fe4ca2c83abd83e9c93d34212ac/z3_solver-4.16.0.0.tar.gz"
    sha256 "263d9ad668966e832c2b246ba0389298a599637793da2dc01cc5e4ef4b0b6c78"

    # Fix Apple Clang builds that reject parenthesized aggregate initialization.
    patch :DATA
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/b9/d8/eab98a517c14134c0b2eb4e2387bc5f457334293ec5d2dd3857ec2966802/zipp-4.1.0.tar.gz"
    sha256 "4cb57381f544315db7688e976e922a2b18cdb513d21cc194eb42232ba2a3e602"
  end

  def install
    if OS.linux?
      libelf = Formula["elfutils"].opt_lib/"libelf.so"
      resource("elfutils").stage do
        # https://github.com/bloomberg/memray/blob/main/pyproject.toml#L96-L104
        system "./configure", "--disable-debuginfod",
                              "--disable-nls",
                              "--disable-silent-rules",
                              "--enable-libdebuginfod",
                              *std_configure_args(prefix: libexec)
        system "make", "-C", "debuginfod", "install", "bin_PROGRAMS=", "libelf=#{libelf}"
        ENV.append "LDFLAGS", "-L#{libexec}/lib -Wl,-rpath,#{libexec}/lib"
      end

      virtualenv_install_with_resources(without: %w[elfutils memray])
      resource("memray").stage do
        system libexec/"bin/python", "-m", "pip", "install", *std_pip_args(build_isolation: true), "."
      end
    else
      virtualenv_install_with_resources
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codeflash --version")
  end
end

__END__
diff --git a/core/src/util/obj_hashtable.h b/core/src/util/obj_hashtable.h
index fb2c222..2a2e7d0 100644
--- a/core/src/util/obj_hashtable.h
+++ b/core/src/util/obj_hashtable.h
@@ -62,6 +62,10 @@ public:
     struct key_data {
         Key * m_key = nullptr;
         Value m_value;
+        key_data() = default;
+        key_data(Key * key) : m_key(key) {}
+        key_data(Key * key, Value const & value) : m_key(key), m_value(value) {}
+        key_data(Key * key, Value && value) : m_key(key), m_value(std::move(value)) {}
         Value const & get_value() const { return m_value; }
         Key & get_key () const { return *m_key; }
         unsigned hash() const { return m_key->hash(); }
