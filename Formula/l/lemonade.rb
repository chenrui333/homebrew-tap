class Lemonade < Formula
  include Language::Python::Virtualenv

  desc "Your LLM Aide for Validation and Deployment"
  homepage "https://lemonade-server.ai/"
  url "https://files.pythonhosted.org/packages/d5/78/2d6b2851da34d8ef4842f9a4c89aeaac845689472565b90323edfff14bfd/lemonade_sdk-8.1.7.tar.gz"
  sha256 "d48b445d63715f47f73a477f5f6ad204609d82da8f0b308f7bd4610f69afc3ae"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_sequoia: "e92f1f8f4991a28124c3b5d441c9984103c98925e7ee6212a852b60e67fad2ee"
    sha256 cellar: :any, arm64_sonoma:  "2bda63474e003347961532db3be5261ac0bb486c3a7063a1645b60a4fc0daa41"
    sha256 cellar: :any, ventura:       "1b75d329fd979e7dfe9414f336493b973b1d9821cb04685f9b33af27446a6e29"
    sha256               x86_64_linux:  "b7a33c9785f0c12bca93ff780abc74d339cb718c720ac29a4a1a65ff91cf3521"
  end

  depends_on "rust" => :build # for pydantic
  depends_on "certifi"
  depends_on "libyaml"
  depends_on "numpy"
  depends_on "python@3.13"
  depends_on "sentencepiece"

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/ee/67/531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5/annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/f1/b4/636b3b65173d3ce9a38ef5f0522789614e590dab6a8d505340a4efe4c567/anyio-4.10.0.tar.gz"
    sha256 "3f3fae35c96039744587aa5b8371e7e8e603c0702999535961dd336026973ba6"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/83/2d/5fd176ceb9b2fc619e63405525573493ca23441330fcdaee6bef9460e924/charset_normalizer-3.4.3.tar.gz"
    sha256 "6fce4b8500244f6fcb71465d4a4930d132ba9ab8e71a7859e6a5d59851068d14"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/60/6c/8ca2efa64cf75a977a0d7fac081354553ebe483345c734fb6b6515d96bbc/click-8.2.1.tar.gz"
    sha256 "27c491cc05d968d271d5a1db13e3b5a184636d9d930f148c50b038f0d0646202"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/fc/f8/98eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3/distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "fastapi" do
    url "https://files.pythonhosted.org/packages/78/d7/6c8b3bfe33eeffa208183ec037fee0cce9f7f024089ab1c5d12ef04bd27c/fastapi-0.116.1.tar.gz"
    sha256 "ed52cbf946abfd70c5a0dccb24673f0670deeb517a88b3544d03c2a6bf283143"
  end

  resource "fasteners" do
    url "https://files.pythonhosted.org/packages/2d/18/7881a99ba5244bfc82f06017316ffe93217dbbbcfa52b887caa1d4f2a6d3/fasteners-0.20.tar.gz"
    sha256 "55dce8792a41b56f727ba6e123fcaee77fd87e638a6863cec00007bfea84c8d8"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/40/bb/0ab3e58d22305b6f5440629d20683af28959bf793d98d11950e305c1c326/filelock-3.19.1.tar.gz"
    sha256 "66eda1888b0171c998b35be2bcc0f6d75c388a7ce20c3f3f37aa8e96c2dddf58"
  end

  resource "fsspec" do
    url "https://files.pythonhosted.org/packages/8b/02/0835e6ab9cfc03916fe3f78c0956cfcdb6ff2669ffa6651065d5ebf7fc98/fsspec-2025.7.0.tar.gz"
    sha256 "786120687ffa54b8283d942929540d8bc5ccfa820deb555a2b5d0ed2b737bf58"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/72/94/63b0fc47eb32792c7ba1fe1b694daec9a63620db1e313033d18140c2320a/gitdb-4.0.12.tar.gz"
    sha256 "5ef71f855d191a3326fcfbc0d5da835f26b13fbcba60c32c21091c349ffdb571"
  end

  resource "gitpython" do
    url "https://files.pythonhosted.org/packages/9a/c8/dd58967d119baab745caec2f9d853297cec1989ec1d63f677d3880632b88/gitpython-3.1.45.tar.gz"
    sha256 "85b0ee964ceddf211c41b9f27a49086010a190fd8132a24e21f362a4b36a791c"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "hf-xet" do
    url "https://files.pythonhosted.org/packages/7a/49/91010b59debc7c862a5fd426d343134dd9a68778dbe570234b6495a4e204/hf_xet-1.1.8.tar.gz"
    sha256 "62a0043e441753bbc446dcb5a3fe40a4d03f5fb9f13589ef1df9ab19252beb53"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/06/94/82699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cb/httpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httptools" do
    url "https://files.pythonhosted.org/packages/a7/9a/ce5e1f7e131522e6d3426e8e7a490b3a01f39a6696602e1c4f33f9e94277/httptools-0.6.4.tar.gz"
    sha256 "4e93eee4add6493b59a5c514da98c939b244fce4a0d8879cd3f466562f4b7d5c"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "huggingface-hub" do
    url "https://files.pythonhosted.org/packages/91/8a/1362d565fefabaa4185cf3ae842a98dbc5b35146f5694f7080f043a6952f/huggingface_hub-0.33.0.tar.gz"
    sha256 "aa31f70d29439d00ff7a33837c03f1f9dd83971ce4e29ad664d63ffb17d3bb97"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "invoke" do
    url "https://files.pythonhosted.org/packages/f9/42/127e6d792884ab860defc3f4d80a8f9812e48ace584ffc5a346de58cdc6c/invoke-2.2.0.tar.gz"
    sha256 "ee6cbb101af1a859c7fe84f2a264c059020b0cb7fe3535f9424300ab568f6bd5"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "jiter" do
    url "https://files.pythonhosted.org/packages/ee/9d/ae7ddb4b8ab3fb1b51faf4deb36cb48a4fbbd7cb36bad6a5fca4741306f7/jiter-0.10.0.tar.gz"
    sha256 "07a7142c38aacc85194391108dc91b5b57093c978a9932bd86a36862759d9500"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b2/97/5d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62/markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "onnx" do
    url "https://files.pythonhosted.org/packages/3d/60/e56e8ec44ed34006e6d4a73c92a04d9eea6163cc12440e35045aec069175/onnx-1.18.0.tar.gz"
    sha256 "3d8dbf9e996629131ba3aa1afd1d8239b660d1f830c6688dd7e03157cccd6b9c"
  end

  resource "openai" do
    url "https://files.pythonhosted.org/packages/e0/c6/b8d66e4f3b95493a8957065b24533333c927dc23817abe397f13fe589c6e/openai-1.97.0.tar.gz"
    sha256 "0be349569ccaa4fb54f97bb808423fd29ccaeb1246ee1be762e0c81a47bae0aa"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/c0/df/fb4a8eeea482eca989b51cffd274aac2ee24e825f0bf3cbce5281fa1567b/protobuf-6.32.0.tar.gz"
    sha256 "a81439049127067fc49ec1d36e25c6ee1d1a2b7be930675f919258d03c04e7d2"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/2a/80/336820c1ad9286a4ded7e845b2eccfcb27851ab8ac6abece774a6ff4d3de/psutil-7.0.0.tar.gz"
    sha256 "7be9c3eba38beccb6495ea33afd982a44074b78f28c434a1f51cc07fd315c456"
  end

  resource "py-cpuinfo" do
    url "https://files.pythonhosted.org/packages/37/a8/d832f7293ebb21690860d2e01d8115e5ff6f2ae8bbdc953f0eb0fa4bd2c7/py-cpuinfo-9.0.0.tar.gz"
    sha256 "3cdbbf3fac90dc6f118bfd64384f309edeadd902d7c8fb17f02ffa1fc3f49690"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/00/dd/4325abf92c39ba8623b5af936ddb36ffcfe0beae70405d456ab1fb2f5b8c/pydantic-2.11.7.tar.gz"
    sha256 "d989c3c6cb79469287b1569f7447a17848c998458d49ebe294e975b9baf0f0db"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/ad/88/5f2260bdfae97aabf98f1778d43f69574390ad787afb646292a638c923d4/pydantic_core-2.33.2.tar.gz"
    sha256 "7cb8bc3605c29176e1b105350d2e6474142d7c1bd1d9327c4a9bdb46bf827acc"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/f6/b0/4bc07ccd3572a2f9df7e6782f52b0c6c90dcbb803ac4a167702d7d0dfe1e/python_dotenv-1.1.1.tar.gz"
    sha256 "a8a6399716257f45be6a007360200409fce5cda2661e3dec71d23dc15f6189ab"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/f8/bf/abbd3cdfb8fbc7fb3d4d38d320f2441b1e7cbe29be4f23797b4a2b5d8aac/pytz-2025.2.tar.gz"
    sha256 "360b9e3dbb49a209c21ad61809c7fb453643e048b38924c765813546746e81c3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/0b/de/e13fa6dc61d78b30ba47481f99933a3b49a57779d625c392d8036770a60d/regex-2025.7.34.tar.gz"
    sha256 "9ead9765217afd04a86822dfcd4ed2747dfe426e887da413b15ff0ac2457e21a"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "safetensors" do
    url "https://files.pythonhosted.org/packages/ac/cc/738f3011628920e027a11754d9cae9abec1aed00f7ae860abbf843755233/safetensors-0.6.2.tar.gz"
    sha256 "43ff2aa0e6fa2dc3ea5524ac7ad93a9839256b8703761e76e2d0b2a3fa4f15d9"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/44/cd/a040c4b3119bbe532e5b0732286f805445375489fceaec1f48306068ee3b/smmap-5.0.2.tar.gz"
    sha256 "26ea65a03958fa0c8a1c7e8c7a58fdc77221b8910f6be2131affade476898ad5"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/04/57/d062573f391d062710d4088fa1369428c38d51460ab6fedff920efef932e/starlette-0.47.2.tar.gz"
    sha256 "6ae9aa5db235e4846decc1e7b79c4f346adf41e9777aebeb49dfd09bbd7023d8"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/ec/fe/802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1/tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "tokenizers" do
    url "https://files.pythonhosted.org/packages/c2/2f/402986d0823f8d7ca139d969af2917fefaa9b947d1fb32f6168c509f2492/tokenizers-0.21.4.tar.gz"
    sha256 "fa23f85fbc9a02ec5c6978da172cdcbac23498c3ca9f3645c5c68740ac007880"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/a8/4b/29b4ef32e036bb34e4ab51796dd745cdba7ed47ad142a9f4a1eb8e0c744d/tqdm-4.67.1.tar.gz"
    sha256 "f8aef9c52c08c13a65f30ea34f4e5aac3fd1a34959879d7e59e63027286627f2"
  end

  resource "transformers" do
    url "https://files.pythonhosted.org/packages/4c/67/80f51466ec447028fd84469b208eb742533ce06cc8fad2e3181380199e5c/transformers-4.53.2.tar.gz"
    sha256 "6c3ed95edfb1cba71c4245758f1b4878c93bf8cde77d076307dacb2cbbd72be2"
  end

  resource "typeguard" do
    url "https://files.pythonhosted.org/packages/c7/68/71c1a15b5f65f40e91b65da23b8224dad41349894535a97f63a52e462196/typeguard-4.4.4.tar.gz"
    sha256 "3a7fd2dffb705d4d0efaed4306a704c89b9dee850b688f060a8b1615a79e5f74"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/98/5a/da40306b885cc8c09109dc2e1abd358d5684b1425678151cdaed4731c822/typing_extensions-4.14.1.tar.gz"
    sha256 "38b39f4aeeab64884ce9f74c94263ef78f3c22467c8724005483154c26648d36"
  end

  resource "typing-inspection" do
    url "https://files.pythonhosted.org/packages/f8/b1/0c11f5058406b3af7609f121aaa6b609744687f1d158b3c3a5bf4cc94238/typing_inspection-0.4.1.tar.gz"
    sha256 "6ae134cc0203c33377d43188d4064e9b357dba58cff3185f22924610e70a9d28"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/5e/42/e0e305207bb88c6b8d3061399c6a961ffe5fbb7e2aa63c9234df7259e9cd/uvicorn-0.35.0.tar.gz"
    sha256 "bc662f087f7cf2ce11a1d7fd70b90c9f98ef2e2831556dd078d131b96cc94a01"
  end

  resource "uvloop" do
    url "https://files.pythonhosted.org/packages/af/c0/854216d09d33c543f12a44b393c402e89a920b1a0a7dc634c42de91b9cf6/uvloop-0.21.0.tar.gz"
    sha256 "3bf12b0fda68447806a7ad847bfa591613177275d35b6724b1ee573faa3704e3"
  end

  resource "watchfiles" do
    url "https://files.pythonhosted.org/packages/2a/9a/d451fcc97d029f5812e898fd30a53fd8c15c7bbd058fd75cfc6beb9bd761/watchfiles-1.1.0.tar.gz"
    sha256 "693ed7ec72cbfcee399e92c895362b6e66d63dac6b91e2c11ae03d10d503e575"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/21/e6/26d09fab466b7ca9c7737474c52be4f76a40301b08362eb2dbc19dcc16c1/websockets-15.0.1.tar.gz"
    sha256 "82544de02076bafba038ce055ee6412d68da13ab47f0c60cab827346de828dee"
  end

  resource "wmi" do
    url "https://files.pythonhosted.org/packages/03/2d/cbf13257c0115bef37b6b743758411cec70c565405cbd08d0f7059bc715f/WMI-1.4.9.zip"
    sha256 "192ccfad3d7bb3ef43116d753f4d5cf85c0a6b738f832cc131e928fd93cdd400"
  end

  resource "zstandard" do
    url "https://files.pythonhosted.org/packages/09/1b/c20b2ef1d987627765dcd5bf1dadb8ef6564f00a87972635099bb76b7a05/zstandard-0.24.0.tar.gz"
    sha256 "fe3198b81c00032326342d973e526803f183f97aa9e9a98e3f897ebafe21178f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lemonade-server-dev --version")
    assert_match "Server is not running", shell_output("#{bin}/lemonade-server-dev status")
    assert_match "gpt-oss-120b-GGUF", shell_output("#{bin}/lemonade-server-dev list")
  end
end
