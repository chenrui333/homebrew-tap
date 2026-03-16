class Taskdog < Formula
  include Language::Python::Virtualenv

  desc "Task manager with CLI, TUI, and local REST API server"
  homepage "https://github.com/Kohei-Wada/taskdog"
  url "https://github.com/Kohei-Wada/taskdog/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "72eebaf8ba7d5d0ba5f78bb2fe0c19a8a5ed5f9bf5ccf7830c9cc6d901f29eeb"
  license "MIT"
  head "https://github.com/Kohei-Wada/taskdog.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "ae1b5cb77f093e0776c8e83cd87b3e9464da692296b8523c6503fbbccfa5ebb1"
    sha256 cellar: :any,                 arm64_sequoia: "958a0b1ab8cd77695e36d608206a6e87a8b7e8e5a220f2cf17f5cef9f87ede9b"
    sha256 cellar: :any,                 arm64_sonoma:  "56069ca93421b0bc59c5d0d9b945fc494221335bff8fd5d42716735dc2d217a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa073aac277c88f7134e64750b67afec764790973e79930b01d4e36e44243978"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "297babd8165754343554b7d38135f19599cdbe5cdf9fb447cb84a794980e469d"
  end

  depends_on "rust" => :build
  depends_on "libyaml"
  depends_on "python@3.14"

  resource "alembic" do
    url "https://files.pythonhosted.org/packages/94/13/8b084e0f2efb0275a1d534838844926f798bd766566b1375174e2448cd31/alembic-1.18.4.tar.gz"
    sha256 "cb6e1fd84b6174ab8dbb2329f86d631ba9559dd78df550b57804d607672cedbc"
  end

  resource "annotated-doc" do
    url "https://files.pythonhosted.org/packages/57/ba/046ceea27344560984e26a590f90bc7f4a75b06701f653222458922b558c/annotated_doc-0.0.4.tar.gz"
    sha256 "fbcda96e87e9c92ad167c2e53839e57503ecfda18804ea28102353485033faa4"
  end

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/ee/67/531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5/annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/96/f0/5eb65b2bb0d09ac6776f2eb54adee6abe8228ea05b20a5ad0e4945de8aac/anyio-4.12.1.tar.gz"
    sha256 "41cfcc3a4c85d3f05c932da7c26d0201ac36f72abd4435ba90d0464a3ffed703"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/af/2d/7bf41579a8986e348fa033a31cdd0e4121114f6bce2457e8876010b092dd/certifi-2026.2.25.tar.gz"
    sha256 "e887ab5cee78ea814d3472169153c2d12cd43b14bd03329a39a9c6e2e80bfba7"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/3d/fa/656b739db8587d7b5dfa22e22ed02566950fbfbcdc20311993483657a5c0/click-8.3.1.tar.gz"
    sha256 "12ff4785d337a1bb490bb7e9c2b1ee5da3112e94a8622f26a6c77f5d2fc6842a"
  end

  resource "fastapi" do
    url "https://files.pythonhosted.org/packages/e7/7b/f8e0211e9380f7195ba3f3d40c292594fd81ba8ec4629e3854c353aaca45/fastapi-0.135.1.tar.gz"
    sha256 "d04115b508d936d254cea545b7312ecaa58a7b3a0f84952535b4c9afae7668cd"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "holidays" do
    url "https://files.pythonhosted.org/packages/a4/9a/e397b5c64a17f198b7b9b719244b1ffb823ac685656e608b70de7a5b59da/holidays-0.92.tar.gz"
    sha256 "5d716ececf94e0d354ccee255541f6ba702078d7ed17b693262f6446214904a5"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/06/94/82699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cb/httpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httptools" do
    url "https://files.pythonhosted.org/packages/b5/46/120a669232c7bdedb9d52d4aeae7e6c7dfe151e99dc70802e2fc7a5e1993/httptools-0.7.1.tar.gz"
    sha256 "abd72556974f8e7c74a259655924a717a2365b236c882c3f6f8a45fe94703ac9"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "linkify-it-py" do
    url "https://files.pythonhosted.org/packages/2e/c9/06ea13676ef354f0af6169587ae292d3e2406e212876a413bf9eece4eb23/linkify_it_py-2.1.0.tar.gz"
    sha256 "43360231720999c10e9328dc3691160e27a718e280673d444c38d7d3aaa3b98b"
  end

  resource "mako" do
    url "https://files.pythonhosted.org/packages/9e/38/bd5b78a920a64d708fe6bc8e0a2c075e1389d53bef8413725c63ba041535/mako-1.3.10.tar.gz"
    sha256 "99579a6f39583fa7e5630a28c3c1f440e4e97a414b80372649c0ce338da2ea28"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/5b/f5/4ec618ed16cc4f8fb3b701563655a69816155e79e24a17b651541804721d/markdown_it_py-4.0.0.tar.gz"
    sha256 "cb0a2b4aa34f932c007117b194e945bd74e0ec24133ceb5bac59009cda1cb9f3"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "mdit-py-plugins" do
    url "https://files.pythonhosted.org/packages/b2/fd/a756d36c0bfba5f6e39a1cdbdbfdd448dc02692467d83816dff4592a1ebc/mdit_py_plugins-0.5.0.tar.gz"
    sha256 "f4918cb50119f50446560513a8e311d574ff6aaed72606ddae6d35716fe809c6"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/19/56/8d4c30c8a1d07013911a8fdbd8f89440ef9f08d07a1b50ab8ca8be5a20f9/platformdirs-4.9.4.tar.gz"
    sha256 "1ec356301b7dc906d83f371c8f487070e99d3ccf9e501686456394622a01a934"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/69/44/36f1a6e523abc58ae5f928898e4aca2e0ea509b5aa6f6f392a5d882be928/pydantic-2.12.5.tar.gz"
    sha256 "4d351024c75c0f085a9febbb665ce8c0c6ec5d30e903bdb6394b7ede26aebb49"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/71/70/23b021c950c2addd24ec408e9ab05d59b035b39d97cdc1130e1bce647bb6/pydantic_core-2.41.5.tar.gz"
    sha256 "08daa51ea16ad373ffd5e7606252cc32f07bc72b28284b6bc9c6df804816476e"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/82/ed/0301aeeac3e5353ef3d94b6ec08bbcabd04a72018415dcb29e588514bba8/python_dotenv-1.2.2.tar.gz"
    sha256 "2c371a91fbd7ba082c2c1dc1f8bf89ca22564a087c2c287cd9b662adde799cf3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/b3/c6/f3b320c27991c46f43ee9d856302c70dc2d0fb2dba4842ff739d5f46b393/rich-14.3.3.tar.gz"
    sha256 "b8daa0b9e4eef54dd8cf7c86c03713f53241884e814f4e2f5fb342fe520f639b"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "sqlalchemy" do
    url "https://files.pythonhosted.org/packages/1f/73/b4a9737255583b5fa858e0bb8e116eb94b88c910164ed2ed719147bde3de/sqlalchemy-2.0.48.tar.gz"
    sha256 "5ca74f37f3369b45e1f6b7b06afb182af1fd5dde009e4ffd831830d98cbe5fe7"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/c4/68/79977123bb7be889ad680d79a40f339082c1978b5cfcf62c2d8d196873ac/starlette-0.52.1.tar.gz"
    sha256 "834edd1b0a23167694292e94f597773bc3f89f362be6effee198165a35d62933"
  end

  resource "textual" do
    url "https://files.pythonhosted.org/packages/72/23/8c709655c5f2208ee82ab81b8104802421865535c278a7649b842b129db1/textual-8.1.1.tar.gz"
    sha256 "eef0256a6131f06a20ad7576412138c1f30f92ddeedd055953c08d97044bc317"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "typing-inspection" do
    url "https://files.pythonhosted.org/packages/55/e3/70399cb7dd41c10ac53367ae42139cf4b1ca5f36bb3dc6c9d33acdb43655/typing_inspection-0.4.2.tar.gz"
    sha256 "ba561c48a67c5958007083d386c3295464928b01faa735ab8547c5692e87f464"
  end

  resource "uc-micro-py" do
    url "https://files.pythonhosted.org/packages/78/67/9a363818028526e2d4579334460df777115bdec1bb77c08f9db88f6389f2/uc_micro_py-2.0.0.tar.gz"
    sha256 "c53691e495c8db60e16ffc4861a35469b0ba0821fe409a8a7a0a71864d33a811"
  end

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/32/ce/eeb58ae4ac36fe09e3842eb02e0eb676bf2c53ae062b98f1b2531673efdd/uvicorn-0.41.0.tar.gz"
    sha256 "09d11cf7008da33113824ee5a1c6422d89fbc2ff476540d69a34c87fab8b571a"
  end

  resource "uvloop" do
    url "https://files.pythonhosted.org/packages/06/f0/18d39dbd1971d6d62c4629cc7fa67f74821b0dc1f5a77af43719de7936a7/uvloop-0.22.1.tar.gz"
    sha256 "6c84bae345b9147082b17371e3dd5d42775bddce91f885499017f4607fdaf39f"
  end

  resource "watchfiles" do
    url "https://files.pythonhosted.org/packages/c2/c9/8869df9b2a2d6c59d79220a4db37679e74f807c559ffe5265e08b227a210/watchfiles-1.1.1.tar.gz"
    sha256 "a173cb5c16c4f40ab19cecf48a534c409f7ea983ab8fed0741304a1c0a31b3f2"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/04/24/4b2031d72e840ce4c1ccb255f693b15c334757fc50023e4db9537080b8c4/websockets-16.0.tar.gz"
    sha256 "5f6261a5e56e8d5c42a4497b364ea24d94d9563e8fbd44e78ac40879c60179b5"
  end

  def install
    venv = virtualenv_create(libexec, "python3.14")
    venv.pip_install resources
    venv.pip_install buildpath/"packages/taskdog-core"
    venv.pip_install buildpath/"packages/taskdog-client"
    venv.pip_install buildpath/"packages/taskdog-server"
    venv.pip_install_and_link buildpath/"packages/taskdog-ui"
    bin.install_symlink libexec/"bin/taskdog-server"

    generate_completions_from_executable(bin/"taskdog", shell_parameter_format: :click, shells: [:fish, :zsh])
  end

  service do
    run [opt_bin/"taskdog-server"]
    keep_alive true
  end

  test do
    port = free_port
    config_home = testpath/"config"
    data_home = testpath/"data"
    log_file = testpath/"taskdog-server.log"

    pid = spawn(
      {
        "XDG_CONFIG_HOME"      => config_home.to_s,
        "XDG_DATA_HOME"        => data_home.to_s,
        "TASKDOG_AUTH_ENABLED" => "false",
      },
      bin/"taskdog-server", "--host", "127.0.0.1", "--port", port.to_s,
      [:out, :err] => log_file.to_s
    )

    server_ready = false
    10.times do
      server_ready = quiet_system "curl", "-fsS", "http://127.0.0.1:#{port}/health"
      break if server_ready

      sleep 1
    end

    assert_match version.to_s, shell_output("#{bin}/taskdog --version")
    assert server_ready, "taskdog-server failed to start: #{log_file.read}"
    assert_match "ok", shell_output("curl -fsS http://127.0.0.1:#{port}/health")

    with_env(
      "XDG_CONFIG_HOME"  => config_home.to_s,
      "XDG_DATA_HOME"    => data_home.to_s,
      "TASKDOG_API_HOST" => "127.0.0.1",
      "TASKDOG_API_PORT" => port.to_s,
    ) do
      add_output = shell_output("#{bin}/taskdog add 'Learn Taskdog' --priority 10")
      assert_match "Added task: Learn Taskdog", add_output

      table_output = shell_output("#{bin}/taskdog table --fields id,name")
      assert_match "Learn Taskdog", table_output
    end
  ensure
    Process.kill("TERM", pid) if pid
    Process.wait(pid) if pid
  end
end
