class Sqlit < Formula
  include Language::Python::Virtualenv

  desc "User friendly TUI for SQL databases"
  homepage "https://github.com/Maxteabag/sqlit"
  url "https://files.pythonhosted.org/packages/c4/2e/2557d94a105201d7b6bb4283d575c7fdb27b78319cd6260cd2726c9088e5/sqlit_tui-1.5.2.tar.gz"
  sha256 "77fdc7e18964d9e007e538296d078883cc3b82f0cc9c35edca96cbaf0cfc2af3"
  license "MIT"
  head "https://github.com/Maxteabag/sqlit.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "9d845c2d9a9e2f30712432eb828090967bda90b8541d984b0fb1f29ba009329e"
    sha256 cellar: :any, arm64_sequoia: "4655e04eac52f27ff58d6b126a95ff54b865e37bc60dc3d3d58306c946dabc4b"
    sha256 cellar: :any, arm64_sonoma:  "4cfd51bd7f693982fcaf91f72179ca18b14bdd9e619ddd715d41d1083ff33f2f"
    sha256               arm64_linux:   "abdc66dd9b2bb6091e1af67ff418db460841ecad61b0e050c73bf0d3a8600519"
    sha256               x86_64_linux:  "5eb6d535d6f0d4f66e105b6261bd981131890342f2eb87e1adadf7372b8affdb"
  end

  depends_on "cmake" => :build # for pyarrow
  depends_on "libyaml" => :build # for pyarrow build dependencies
  depends_on "ninja" => :build # for pyarrow
  depends_on "rust" => :build # for pyarrow build dependencies
  depends_on "apache-arrow"
  depends_on "numpy"
  depends_on "openblas"
  depends_on "python@3.14"

  on_linux do
    depends_on "patchelf" => :build # for pyarrow
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/c9/c7/424b75da314c1045981bd9777432fad05a9e0c69daa4ed7e308bbaffe405/certifi-2026.6.17.tar.gz"
    sha256 "024c88eeec92ca068db80f02b8b07c9cef7b9fe261d1d535abfd5abd6f6af432"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/bd/2a/23f34ec9d04624958e137efdc394888716353190e75f25dd22c7a2c7a8aa/charset_normalizer-3.4.9.tar.gz"
    sha256 "673611bbd43f0810bec0b0f028ddeaaa501190339cac411f347ac76917c3ae7b"
  end

  resource "docker" do
    url "https://files.pythonhosted.org/packages/88/7f/731ff914b0255d3d065f45fd4e626d4b8c95dbcbaada049f337a6ac16410/docker-7.2.0.tar.gz"
    sha256 "cebb93773d334f778e023a7ee352a8d6e13ab1bd3b863a4d4a59dec897df43ac"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cd/63/9496c57188a2ee585e0f1db071d75089a11e98aa86eb99d9d7618fc1edce/idna-3.18.tar.gz"
    sha256 "ffb385a7e039654cef1ab9ef32c6fafe283c0c0467bba1d9029738ce4a14a848"
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

  resource "linkify-it-py" do
    url "https://files.pythonhosted.org/packages/2e/c9/06ea13676ef354f0af6169587ae292d3e2406e212876a413bf9eece4eb23/linkify_it_py-2.1.0.tar.gz"
    sha256 "43360231720999c10e9328dc3691160e27a718e280673d444c38d7d3aaa3b98b"
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

  resource "numpy" do
    url "https://files.pythonhosted.org/packages/22/fd/89965aa4ac08c74998539fcbf24fa3540f3e15237fbeb6bcf9c908f4aade/numpy-2.5.1.tar.gz"
    sha256 "a48a113e6afea91f5608793bafa7ef2ad481fefbda87ec5069f483de61cb9fa3"
  end

  resource "pandas" do
    url "https://files.pythonhosted.org/packages/33/01/d40b85317f86cf08d853a4f495195c73815fdf205eef3993821720274518/pandas-2.3.3.tar.gz"
    sha256 "e05e1af93b977f7eafa636d043f9f94c7ee3ac81af99c13508215942e64c993b"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/d7/47/e4501f49c178ae1d9f4a75073fda4204f52647993f075a9db4d14930e0c5/platformdirs-4.10.0.tar.gz"
    sha256 "31e761a6a0ca04faf7353ea759bdba55652be214725111e5aac52dfa29d4bef7"
  end

  resource "pyarrow" do
    url "https://files.pythonhosted.org/packages/27/f3/95428098d1fa7d04432fb750eed06b41304c2f6a5d3319985e64db2d9d41/pyarrow-25.0.0.tar.gz"
    sha256 "d2d697008b5ec06d75952ef260c2e9a8a0f6ccfce24266c04c9c8ade927cb3b4"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/e8/52/d87eba7cb129b81563019d1679026e7a112ef76855d6159d24754dbd2a51/pyperclip-1.11.0.tar.gz"
    sha256 "244035963e4428530d9e3a6101a1ef97209c6825edab1567beac148ccc1db1b6"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/ff/46/dd499ec9038423421951e4fad73051febaa13d2df82b4064f87af8b8c0c3/pytz-2026.2.tar.gz"
    sha256 "0e60b47b29f21574376f218fe21abc009894a2321ea16c6754f3cad6eb7cdd6a"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "sqlparse" do
    url "https://files.pythonhosted.org/packages/90/76/437d71068094df0726366574cf3432a4ed754217b436eb7429415cf2d480/sqlparse-0.5.5.tar.gz"
    sha256 "e20d4a9b0b8585fdf63b10d30066c7c94c5d7a7ec47c889a2d83a3caa93ff28e"
  end

  resource "textual" do
    url "https://files.pythonhosted.org/packages/00/21/39a76b01bd5eea82a04baaca7580e105d8c59450df03998345bb2cfb307b/textual-8.2.8.tar.gz"
    sha256 "3f106a9fbc73e39dd266c9712432087de78a6d644084c7c241d6a25c3169115b"
  end

  resource "textual-fastdatatable" do
    url "https://files.pythonhosted.org/packages/1e/ec/8cc2204560200dcc80abc432a61eb6f99672049aecfd0860472cfc3f82fe/textual_fastdatatable-0.14.0.tar.gz"
    sha256 "cb99e208fb96c7eb5cfb7f225a280da950bd8cfb29d685a49071787c80218901"
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

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/92/ff/5a28bdfd8c3ebec42564ac7d0e54ca3db65044a9314a97f9564fa7a1e926/tzdata-2026.3.tar.gz"
    sha256 "4a1518b8993086a7982523e071643f3c0e5f213e75b21318e78bcabfff9d1415"
  end

  resource "uc-micro-py" do
    url "https://files.pythonhosted.org/packages/78/67/9a363818028526e2d4579334460df777115bdec1bb77c08f9db88f6389f2/uc_micro_py-2.0.0.tar.gz"
    sha256 "c53691e495c8db60e16ffc4861a35469b0ba0821fe409a8a7a0a71864d33a811"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  def install
    # pandas 2.3.x metadata generation is incompatible with Meson 1.11.
    (buildpath/"constraints.txt").write "meson<1.11\n"
    ENV["PIP_CONSTRAINT"] = buildpath/"constraints.txt"

    venv = virtualenv_create(libexec, "python3.14")
    venv.pip_install resources
    venv.pip_install_and_link buildpath
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
