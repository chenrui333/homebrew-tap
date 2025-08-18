class OxylabsMcp < Formula
  include Language::Python::Virtualenv

  desc "MCP server for Oxylabs"
  homepage "https://github.com/oxylabs/oxylabs-mcp"
  url "https://files.pythonhosted.org/packages/7e/66/d6ef3b0940c6695367000b4a00a8cad17cd559cf40f2de4f9393874864c3/oxylabs_mcp-0.5.0.tar.gz"
  sha256 "ed7b460d890058d6844e80e59043bd8bdc40b28c8a5eb17547f2f48d0b290245"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "cb37fa0e6bb259d170503f6fa7cb0aded06b6052c37254d1416c250f30caf7c9"
    sha256 cellar: :any,                 arm64_sonoma:  "dca730a25a42cad082f139d1b7855b4cb7d7b213b4c1312f176700b7175fa056"
    sha256 cellar: :any,                 ventura:       "6174781a8cc3eded15c9a18853c85842116ecce07f5e712e45dff77bbcc578f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "880149a13671617d5972bb952d503b46f3a27a2c7c03255c80736bfe2328d751"
  end

  depends_on "rust" => :build # for pydantic
  depends_on "certifi"
  depends_on "python@3.13"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/ee/67/531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5/annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/f1/b4/636b3b65173d3ce9a38ef5f0522789614e590dab6a8d505340a4efe4c567/anyio-4.10.0.tar.gz"
    sha256 "3f3fae35c96039744587aa5b8371e7e8e603c0702999535961dd336026973ba6"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/d8/e4/0c4c39e18fd76d6a628d4dd8da40543d136ce2d1752bd6eeeab0791f4d6b/beautifulsoup4-4.13.4.tar.gz"
    sha256 "dbb3c4e1ceae6aefebdaf2423247260cd062430a410e38c66f2baa50a8437195"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/dc/67/960ebe6bf230a96cda2e0abcf73af550ec4f090005363542f0765df162e0/certifi-2025.8.3.tar.gz"
    sha256 "e564105f78ded564e3ae7c923924435e1daa7463faeab5bb932bc53ffae63407"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/60/6c/8ca2efa64cf75a977a0d7fac081354553ebe483345c734fb6b6515d96bbc/click-8.2.1.tar.gz"
    sha256 "27c491cc05d968d271d5a1db13e3b5a184636d9d930f148c50b038f0d0646202"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
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
    url "https://files.pythonhosted.org/packages/6e/fa/66bd985dd0b7c109a3bcb89272ee0bfb7e2b4d06309ad7b38ff866734b2a/httpx_sse-0.4.1.tar.gz"
    sha256 "8f44d34414bc7b21bf3602713005c5df4917884f76072479b21f68befa4ea26e"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/76/3d/14e82fc7c8fb1b7761f7e748fd47e2ec8276d137b6acfe5a4bb73853e08f/lxml-5.4.0.tar.gz"
    sha256 "d12832e1dbea4be280b22fd0ea7c9b87f0d8fc51ba06e92dc62d52f804f78ebd"
  end

  resource "lxml-html-clean" do
    url "https://files.pythonhosted.org/packages/79/b6/466e71db127950fb8d172026a8f0a9f0dc6f64c8e78e2ca79f252e5790b8/lxml_html_clean-0.4.2.tar.gz"
    sha256 "91291e7b5db95430abf461bc53440964d58e06cc468950f9e47db64976cebcb3"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/5b/f5/4ec618ed16cc4f8fb3b701563655a69816155e79e24a17b651541804721d/markdown_it_py-4.0.0.tar.gz"
    sha256 "cb0a2b4aa34f932c007117b194e945bd74e0ec24133ceb5bac59009cda1cb9f3"
  end

  resource "markdownify" do
    url "https://files.pythonhosted.org/packages/83/1b/6f2697b51eaca81f08852fd2734745af15718fea10222a1d40f8a239c4ea/markdownify-1.2.0.tar.gz"
    sha256 "f6c367c54eb24ee953921804dfe6d6575c5e5b42c643955e7242034435de634c"
  end

  resource "mcp" do
    url "https://files.pythonhosted.org/packages/bc/8d/0f4468582e9e97b0a24604b585c651dfd2144300ecffd1c06a680f5c8861/mcp-1.9.0.tar.gz"
    sha256 "905d8d208baf7e3e71d70c82803b89112e321581bcd2530f9de0fe4103d28749"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "oxylabs-ai-studio" do
    url "https://files.pythonhosted.org/packages/75/40/d22e4c3eb3372b72cad3a0d18c32f5646c1c952f2c33d1b1409656baf468/oxylabs_ai_studio-0.2.12.tar.gz"
    sha256 "631162a1e9e0ef28720866e7b22617352ffbf86597c9168a9e40d9f39aaccb92"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/00/dd/4325abf92c39ba8623b5af936ddb36ffcfe0beae70405d456ab1fb2f5b8c/pydantic-2.11.7.tar.gz"
    sha256 "d989c3c6cb79469287b1569f7447a17848c998458d49ebe294e975b9baf0f0db"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/ad/88/5f2260bdfae97aabf98f1778d43f69574390ad787afb646292a638c923d4/pydantic_core-2.33.2.tar.gz"
    sha256 "7cb8bc3605c29176e1b105350d2e6474142d7c1bd1d9327c4a9bdb46bf827acc"
  end

  resource "pydantic-settings" do
    url "https://files.pythonhosted.org/packages/68/85/1ea668bbab3c50071ca613c6ab30047fb36ab0da1b92fa8f17bbc38fd36c/pydantic_settings-2.10.1.tar.gz"
    sha256 "06f0062169818d0f5524420a360d632d5857b83cffd4d42fe29597807a1614ee"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/f6/b0/4bc07ccd3572a2f9df7e6782f52b0c6c90dcbb803ac4a167702d7d0dfe1e/python_dotenv-1.1.1.tar.gz"
    sha256 "a8a6399716257f45be6a007360200409fce5cda2661e3dec71d23dc15f6189ab"
  end

  resource "python-multipart" do
    url "https://files.pythonhosted.org/packages/f3/87/f44d7c9f274c7ee665a29b885ec97089ec5dc034c7f3fafa03da9e39a09e/python_multipart-0.0.20.tar.gz"
    sha256 "8dd0cab45b8e23064ae09147625994d090fa46f5b0d1e13af944c331a7fa9d13"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/fe/75/af448d8e52bf1d8fa6a9d089ca6c07ff4453d86c65c145d0a300bb073b9b/rich-14.1.0.tar.gz"
    sha256 "e497a48b844b0320d45007cdebfeaeed8db2a4f4bcf49f15e455cfc4af11eaa8"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/58/15/8b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58e/shellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/3f/f4/4a80cd6ef364b2e8b65b15816a843c0980f7a5a2b4dc701fc574952aa19f/soupsieve-2.7.tar.gz"
    sha256 "ad282f9b6926286d2ead4750552c8a6142bc4c783fd66b0293547c8fe6ae126a"
  end

  resource "sse-starlette" do
    url "https://files.pythonhosted.org/packages/42/6f/22ed6e33f8a9e76ca0a412405f31abb844b779d52c5f96660766edcd737c/sse_starlette-3.0.2.tar.gz"
    sha256 "ccd60b5765ebb3584d0de2d7a6e4f745672581de4f5005ab31c3a25d10b52b3a"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/04/57/d062573f391d062710d4088fa1369428c38d51460ab6fedff920efef932e/starlette-0.47.2.tar.gz"
    sha256 "6ae9aa5db235e4846decc1e7b79c4f346adf41e9777aebeb49dfd09bbd7023d8"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/c5/8c/7d682431efca5fd290017663ea4588bf6f2c6aad085c7f108c5dbc316e70/typer-0.16.0.tar.gz"
    sha256 "af377ffaee1dbe37ae9440cb4e8f11686ea5ce4e9bae01b84ae7c63b87f1dd3b"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/98/5a/da40306b885cc8c09109dc2e1abd358d5684b1425678151cdaed4731c822/typing_extensions-4.14.1.tar.gz"
    sha256 "38b39f4aeeab64884ce9f74c94263ef78f3c22467c8724005483154c26648d36"
  end

  resource "typing-inspection" do
    url "https://files.pythonhosted.org/packages/f8/b1/0c11f5058406b3af7609f121aaa6b609744687f1d158b3c3a5bf4cc94238/typing_inspection-0.4.1.tar.gz"
    sha256 "6ae134cc0203c33377d43188d4064e9b357dba58cff3185f22924610e70a9d28"
  end

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/5e/42/e0e305207bb88c6b8d3061399c6a961ffe5fbb7e2aa63c9234df7259e9cd/uvicorn-0.35.0.tar.gz"
    sha256 "bc662f087f7cf2ce11a1d7fd70b90c9f98ef2e2831556dd078d131b96cc94a01"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["OXYLABS_AI_STUDIO_API_KEY"] = "test"

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    output = pipe_output("#{bin}/oxylabs-mcp 2>&1", json, 1)
    assert_match "OXYLABS_AI_STUDIO_API_KEY is not valid", output
  end
end
