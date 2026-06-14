class Fftext < Formula
  include Language::Python::Virtualenv

  desc "Summarize, explain, fact-check, or translate text using local LLM"
  homepage "https://github.com/kouhxp/fftext"
  url "https://github.com/kouhxp/fftext/archive/958c739ca69b2de84e001cd86d03bed880189b36.tar.gz"
  version "0.3.0"
  sha256 "c17ef0257f9c153f4eec17f02a69240afc14117cad2d076f3e23488fa22b29d5"
  license "Apache-2.0"
  head "https://github.com/kouhxp/fftext.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "344e542c8af00b8fe90ba76fb4d99f7e5b3676fa05bf9918a67f72481de41ca5"
    sha256 cellar: :any, arm64_sequoia: "60bbf22c6d13cb8495a1b14f64b324c72e9c56307ef3bce87bdb717c34374ce3"
    sha256 cellar: :any, arm64_sonoma:  "21ab358db024a2f16c5326444c83d6e75d855755f2667364a03cdfdff74767df"
    sha256 cellar: :any, arm64_linux:   "6a4fff1cd058c68aa52f5433d8411aecefec20c95beb6f304add32ecc86fa0ed"
    sha256 cellar: :any, x86_64_linux:  "91411863ae7631ee1b5293487259d6e596952c49b2ea96c40f6526876653b7d7"
  end

  depends_on "cmake" => :build
  depends_on "maturin" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build # for hf-xet
  depends_on "libomp"
  depends_on "libyaml"
  depends_on "numpy"
  depends_on "openssl@3"
  depends_on "python@3.13"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  on_linux do
    depends_on "patchelf" => :build
    depends_on "openblas"
  end

  resource "annotated-doc" do
    url "https://files.pythonhosted.org/packages/57/ba/046ceea27344560984e26a590f90bc7f4a75b06701f653222458922b558c/annotated_doc-0.0.4.tar.gz"
    sha256 "fbcda96e87e9c92ad167c2e53839e57503ecfda18804ea28102353485033faa4"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/19/14/2c5dd9f512b66549ae92767a9c7b330ae88e1932ca57876909410251fe13/anyio-4.13.0.tar.gz"
    sha256 "334b70e641fd2221c1505b3890c69882fe4a2df910cba14d97019b90b24439dc"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/43/65/318323f98dbee45d42dff61d8f047181bc6f2268a9068cfad035a46be5af/beautifulsoup4-4.15.0.tar.gz"
    sha256 "288e3ca7d54b06f2ac191970bc275c1939cb46d450b255bf6718b04aa37ab4f7"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/f3/ce/ee2ecad540810a79593028e88299baeae54d346cc7a0d94b6199988b89b1/certifi-2026.5.20.tar.gz"
    sha256 "69dea482ab64caa7b9f6aba1c6bf48bb6a5448d1c0f1b17ab42ad8c763a5344d"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/19/b6/9df434a8eeba2e6628c465a1dfa31034228ef79b26f76f46278f4ef7e49d/chardet-7.4.3.tar.gz"
    sha256 "cc1d4eb92a4ec1c2df3b490836ffa46922e599d34ce0bb75cf41fd2bf6303d56"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e7/a1/67fe25fac3c7642725500a3f6cfe5821ad557c3abb11c9d20d12c7008d3e/charset_normalizer-3.4.7.tar.gz"
    sha256 "ae89db9e5f98a11a4bf50407d4363e7b09b31e55bc117b4f7d80aab97ba009e5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/9b/98/518d8e5081007684232226f475082b30087d0f585e8457db087298259f49/click-8.4.1.tar.gz"
    sha256 "918b5633eddf6b41c32d4f454bf0de810065c74e3f7dbf8ee5452f8be88d3e96"
  end

  resource "cssselect" do
    url "https://files.pythonhosted.org/packages/ec/2e/cdfd8b01c37cbf4f9482eefd455853a3cf9c995029a46acd31dfaa9c1dd6/cssselect-1.4.0.tar.gz"
    sha256 "fdaf0a1425e17dfe8c5cf66191d211b357cf7872ae8afc4c6762ddd8ac47fc92"
  end

  resource "diskcache" do
    url "https://files.pythonhosted.org/packages/3f/21/1c1ffc1a039ddcc459db43cc108658f32c57d271d7289a2794e401d0fdb6/diskcache-5.6.3.tar.gz"
    sha256 "2c3a3fa2743d8535d832ec61c2054a1641f41775aa7c556758a109941e33e4fc"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/91/f5/3557bf28e0f1943e4849154c821533706e6dea010f96fb6aa0b6949037d1/filelock-3.29.3.tar.gz"
    sha256 "7fc1b3f39cf172fd8203812043c57b8a65aef9969f38b6704f628b881f761a84"
  end

  resource "fsspec" do
    url "https://files.pythonhosted.org/packages/d5/8d/1c51c094345df128ca4a990d633fe1a0ff28726c9e6b3c41ba65087bba1d/fsspec-2026.4.0.tar.gz"
    sha256 "301d8ac70ae90ef3ad05dcf94d6c3754a097f9b5fe4667d2787aa359ec7df7e4"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "hf-xet" do
    url "https://files.pythonhosted.org/packages/4b/2d/57fd21d84d93efb4bd0b962383790e19dd1bc053501b4264c97903b4e83e/hf_xet-1.5.1.tar.gz"
    sha256 "51ef4500dab3764b41135ee1381a4b62ce56fc54d4c92b719b59e597d6df5bf6"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/06/94/82699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cb/httpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "huggingface-hub" do
    url "https://files.pythonhosted.org/packages/88/27/629cfe58c582f92ded066c4a07d1a057ff617118ab7973200f770bd853cb/huggingface_hub-1.19.0.tar.gz"
    sha256 "fd771622182d40977272a923953ee3b1b13538f9f8a7f5d78398f10af0f1c0bd"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cd/63/9496c57188a2ee585e0f1db071d75089a11e98aa86eb99d9d7618fc1edce/idna-3.18.tar.gz"
    sha256 "ffb385a7e039654cef1ab9ef32c6fafe283c0c0467bba1d9029738ce4a14a848"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "llama-cpp-python" do
    url "https://files.pythonhosted.org/packages/83/c1/ac90e90d28f405009a89f08a5727d3f0dac49309575fb2d1a5ff1d265826/llama_cpp_python-0.3.28.tar.gz"
    sha256 "958227b394f413425d6039952096daa0b8b98328c6b99d652862aec775f1672d"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/05/3b/aab6728cae887456f409b4d75e8a01856e4f04bd510de38052a47768b680/lxml-6.1.1.tar.gz"
    sha256 "ba96ae44888e0185281e937633a743ea90d5a196c6000f82565ebb0580012d40"
  end

  resource "lxml-html-clean" do
    url "https://files.pythonhosted.org/packages/0a/63/195dfdde380a84df309e3bccf4384b034b745dba43426886f7ae623b4fba/lxml_html_clean-0.4.5.tar.gz"
    sha256 "e2a4c7d5beedd17cd7b484d848a0571e54baa239a4f9df5546e3acba7f990560"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
    sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "readability-lxml" do
    url "https://files.pythonhosted.org/packages/55/3e/dc87d97532ddad58af786ec89c7036182e352574c1cba37bf2bf783d2b15/readability_lxml-0.8.4.1.tar.gz"
    sha256 "9d2924f5942dd7f37fb4da353263b22a3e877ccf922d0e45e348e4177b035a53"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/58/15/8b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58e/shellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/47/2c/0a5f6f8ee0d5589e48c7640213ed5175d52cf540a06725b628cc1a45d6ce/soupsieve-2.8.4.tar.gz"
    sha256 "e121fd02e975c695e4e9e8774a5ee35d74714b59307868dcc5319ad2d9e3328e"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/85/05/0d5260f1f1ca784f4a4a0def9cbe6affe587f5b4025328d446c3d67765f4/tqdm-4.68.2.tar.gz"
    sha256 "89c230e8dbc67c7615c142487111222f878c77427ea09549960f62389e258add"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/e4/51/9aed62104cea109b820bbd6c14245af756112017d309da813ef107d42e7e/typer-0.25.1.tar.gz"
    sha256 "9616eb8853a09ffeabab1698952f33c6f29ffdbceb4eaeecf571880e8d7664cc"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  def install
    ENV.append_to_rustflags "-C link-arg=-Wl,-undefined,dynamic_lookup" if OS.mac?

    cmake_args = %w[
      -DGGML_BLAS=ON
      -DGGML_CCACHE=OFF
      -DGGML_NATIVE=OFF
    ]
    if OS.mac?
      cmake_args << "-DGGML_METAL=ON"
    else
      cmake_args += %w[
        -DGGML_METAL=OFF
        -DGGML_BLAS_VENDOR=OpenBLAS
      ]
    end
    ENV["CMAKE_ARGS"] = cmake_args.join(" ")
    ENV["FORCE_CMAKE"] = "1"

    venv = virtualenv_install_with_resources(without: "hf-xet")

    resource("hf-xet").stage do
      # Use native-tls since building bundled aws-lc is tricky to do indirectly within superenv.
      inreplace "xet_client/Cargo.toml", 'default = ["rustls-tls"]', 'default = ["native-tls"]'

      if ENV.effective_arch == :armv8
        # Disable sha2-asm which requires a minimum of -march=armv8-a+crypto.
        inreplace "xet_data/Cargo.toml",
                  'sha2 = { workspace = true, features = ["asm"] }',
                  "sha2 = { workspace = true }"
      end

      venv.pip_install Pathname.pwd, build_isolation: false
    end

    if OS.linux?
      site_packages = libexec/Language::Python.site_packages("python3.13")
      llama_libdirs = [
        site_packages/"lib",
        site_packages/"llama_cpp/lib",
      ]
      llama_libdirs.each do |libdir|
        libdir.glob("*.so*").each do |shared_library|
          rpaths = ["$ORIGIN", *llama_libdirs.map(&:to_s)]
          rpaths += Utils.safe_popen_read("patchelf", "--print-rpath", shared_library).chomp.split(":")
          system "patchelf", "--set-rpath", rpaths.uniq.join(":"), shared_library
        end
      end
    end
  end

  test do
    output = shell_output("#{bin}/fftext --help 2>&1")
    assert_match "summarize", output

    (testpath/"input.txt").write "hello from Homebrew"
    (testpath/"check_input.py").write <<~PYTHON
      from main import resolve_input

      text, source = resolve_input("input.txt")
      print(f"{source}: {text}")
    PYTHON
    input = shell_output("#{libexec}/bin/python check_input.py")
    assert_match "input.txt: hello from Homebrew", input

    metadata = libexec/Language::Python.site_packages("python3.13")/"fftext-0.3.0.dist-info/METADATA"
    assert_match version.to_s, metadata.read
  end
end
