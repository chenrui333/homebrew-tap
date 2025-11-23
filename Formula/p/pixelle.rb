class Pixelle < Formula
  include Language::Python::Virtualenv

  desc "Open-Source Multimodal AIGC Solution based on ComfyUI + MCP + LLM"
  homepage "https://pixelle.ai/"
  url "https://files.pythonhosted.org/packages/cf/6a/77b094ee9f63901e6eeb9adfe3d9e659f8c83586ef3f84c80f5249138045/pixelle-0.1.16.tar.gz"
  sha256 "d40534b739bcb76cb7266530ba65824a6ca73964d7b59b5d97b0d42722fbb0ff"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "ea2005982078bfdeb838526e07d5bc460d36528003b943709a01751838308442"
    sha256 cellar: :any,                 arm64_sequoia: "666e09a36cae955a4c1c47ad1661b60d8fa7db34766fd30dc111a02bb91cac37"
    sha256 cellar: :any,                 arm64_sonoma:  "8c6e70b10d681fe2116d1a786db6e2b7b515d49a856cab41de222b6c9be48704"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94279600a3e0e08d8d4c533f35de4c086ea3dad1f4c583a534ccbbc42043d541"
  end

  depends_on "rust" => :build # for tiktoken
  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "libyaml"
  depends_on "pillow" => :no_linkage
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.14"
  depends_on "rpds-py" => :no_linkage

  pypi_packages exclude_packages: %w[certifi cryptography pillow pydantic rpds-py]

  resource "aiofiles" do
    url "https://files.pythonhosted.org/packages/0b/03/a88171e277e8caa88a4c77808c20ebb04ba74cc4681bf1e9416c862de237/aiofiles-24.1.0.tar.gz"
    sha256 "22a075c9e5a3810f0c2e48f3008c94d68c65d763b9b03857924c99e57355166c"
  end

  resource "aiohappyeyeballs" do
    url "https://files.pythonhosted.org/packages/26/30/f84a107a9c4331c14b2b586036f40965c128aa4fee4dda5d3d51cb14ad54/aiohappyeyeballs-2.6.1.tar.gz"
    sha256 "c3f9d0113123803ccadfdf3f0faa505bc78e6a72d1cc4806cbd719826e943558"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/1c/ce/3b83ebba6b3207a7135e5fcaba49706f8a4b6008153b4e30540c982fae26/aiohttp-3.13.2.tar.gz"
    sha256 "40176a52c186aefef6eb3cad2cdd30cd06e3afbe88fe8ab2af9c0b90f228daca"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/61/62/06741b579156360248d1ec624842ad0edf697050bbaf7c3e46394e106ad1/aiosignal-1.4.0.tar.gz"
    sha256 "f47eecd9468083c2029cc99945502cb7708b082c232f9aca65da147157b251c7"
  end

  resource "annotated-doc" do
    url "https://files.pythonhosted.org/packages/57/ba/046ceea27344560984e26a590f90bc7f4a75b06701f653222458922b558c/annotated_doc-0.0.4.tar.gz"
    sha256 "fbcda96e87e9c92ad167c2e53839e57503ecfda18804ea28102353485033faa4"
  end

  resource "anthropic" do
    url "https://files.pythonhosted.org/packages/d7/7b/609eea5c54ae69b1a4a94169d4b0c86dc5c41b43509989913f6cdc61b81d/anthropic-0.74.1.tar.gz"
    sha256 "04c087b2751385c524f6d332d066a913870e4de8b3e335fb0a0c595f1f88dc6e"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/c6/78/7d432127c41b50bccba979505f272c16cbcadcc33645d5fa3a738110ae75/anyio-4.11.0.tar.gz"
    sha256 "82a8d0b81e318cc5ce71a5f1f8b5c4e63619620b63141ef8c995fa0db95a57c4"
  end

  resource "asyncer" do
    url "https://files.pythonhosted.org/packages/6b/41/71af52c036f3e38f3d90f50efd0bc5175b2283d32b2e8a3da11b4b0db84a/asyncer-0.0.10.tar.gz"
    sha256 "8ae3e569d4c0af2882be0822f848adf59712cc52aa5da6ead53473869c90d98e"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/6b/5c/685e6633917e101e5dcb62b9dd76946cbb57c26e133bae9e0cd36033c0a9/attrs-25.4.0.tar.gz"
    sha256 "16d5969b87f0859ef33a48b35d55ac1be6e42ae49d5e853b597db70c35c57e11"
  end

  resource "audioop-lts" do
    url "https://files.pythonhosted.org/packages/38/53/946db57842a50b2da2e0c1e34bd37f36f5aadba1a929a3971c5d7841dbca/audioop_lts-0.2.2.tar.gz"
    sha256 "64d0c62d88e67b98a1a5e71987b7aa7b5bcffc7dcee65b635823dbdd0a8dbbd0"
  end

  resource "authlib" do
    url "https://files.pythonhosted.org/packages/cd/3f/1d3bbd0bf23bdd99276d4def22f29c27a914067b4cf66f753ff9b8bbd0f3/authlib-1.6.5.tar.gz"
    sha256 "6aaf9c79b7cc96c900f0b284061691c5d4e61221640a948fe690b556a6d6d10b"
  end

  resource "backoff" do
    url "https://files.pythonhosted.org/packages/47/d7/5bbeb12c44d7c4f2fb5b56abce497eb5ed9f34d85701de869acedd602619/backoff-2.2.1.tar.gz"
    sha256 "03f829f5bb1923180821643f8753b0502c3b682293992485b0eef2807afa5cba"
  end

  resource "beartype" do
    url "https://files.pythonhosted.org/packages/88/e2/105ceb1704cb80fe4ab3872529ab7b6f365cf7c74f725e6132d0efcf1560/beartype-0.22.6.tar.gz"
    sha256 "97fbda69c20b48c5780ac2ca60ce3c1bb9af29b3a1a0216898ffabdd523e48f4"
  end

  resource "bidict" do
    url "https://files.pythonhosted.org/packages/9a/6e/026678aa5a830e07cd9498a05d3e7e650a4f56a42f267a53d22bcda1bdc9/bidict-0.23.1.tar.gz"
    sha256 "03069d763bc387bbd20e7d49914e75fc4132a41937fa3405417e1a5a2d006d71"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/fa/81/2600e83ddd7cb1dac43d28fd39774434afcda0d85d730402192b1a9266a3/boto3-1.41.2.tar.gz"
    sha256 "7054fbc61cadab383f40ea6d725013ba6c8f569641dddb14c0055e790280ad6c"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/c5/0b/6eb5dc752b240dd0b76d7e3257ae25b70683896d1789e7bfb78fba7c7c99/botocore-1.41.2.tar.gz"
    sha256 "49a3e8f4c1a1759a687941fef8b36efd7bafcf63c1ef74aa75d6497eb4887c9c"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/fb/44/ca1675be2a83aeee1886ab745b28cda92093066590233cc501890eb8417a/cachetools-6.2.2.tar.gz"
    sha256 "8e6d266b25e539df852251cfd6f990b4bc3a141db73b939058d809ebd2590fc6"
  end

  resource "chainlit" do
    url "https://files.pythonhosted.org/packages/c8/0a/69d9a91345749f3edabd6949f41a03de7b8e466a654a567e907cac2c777e/chainlit-2.9.2.tar.gz"
    sha256 "6239c6912e93ee07be2ec0bd84fb207ee570ff62d07d9f4f7c27f16709e8b702"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "chevron" do
    url "https://files.pythonhosted.org/packages/15/1f/ca74b65b19798895d63a6e92874162f44233467c9e7c1ed8afd19016ebe9/chevron-0.14.0.tar.gz"
    sha256 "87613aafdf6d77b6a90ff073165a61ae5086e21ad49057aa0e53681601800ebf"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/3d/fa/656b739db8587d7b5dfa22e22ed02566950fbfbcdc20311993483657a5c0/click-8.3.1.tar.gz"
    sha256 "12ff4785d337a1bb490bb7e9c2b1ee5da3112e94a8622f26a6c77f5d2fc6842a"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "cuid" do
    url "https://files.pythonhosted.org/packages/55/ca/d323556e2bf9bfb63219fbb849ce61bb830cc42d1b25b91cde3815451b91/cuid-0.4.tar.gz"
    sha256 "74eaba154916a2240405c3631acee708c263ef8fa05a86820b87d0f59f84e978"
  end

  resource "cyclopts" do
    url "https://files.pythonhosted.org/packages/94/f0/5a83ac365800969552a7eb261b03860dea38647fb6cc31574bdbcdc9f0f5/cyclopts-4.2.5.tar.gz"
    sha256 "91aff5da5b8b841ccb32b5142c2d12fd93678fbc9eba7ef7319452323e24d6d4"
  end

  resource "dataclasses-json" do
    url "https://files.pythonhosted.org/packages/64/a4/f71d9cf3a5ac257c993b5ca3f93df5f7fb395c725e7f1e6479d2514173c3/dataclasses_json-0.6.7.tar.gz"
    sha256 "b6b3e528266ea45b9535223bc53ca645f5208833c29229e847b3f26a1cc55fc0"
  end

  resource "deprecated" do
    url "https://files.pythonhosted.org/packages/49/85/12f0a49a7c4ffb70572b6c2ef13c90c88fd190debda93b23f026b25f9634/deprecated-1.3.1.tar.gz"
    sha256 "b1b50e0ff0c1fddaa5708a2c6b0a6588bb09b892825ab2b214ac9ea9d92a5223"
  end

  resource "diskcache" do
    url "https://files.pythonhosted.org/packages/3f/21/1c1ffc1a039ddcc459db43cc108658f32c57d271d7289a2794e401d0fdb6/diskcache-5.6.3.tar.gz"
    sha256 "2c3a3fa2743d8535d832ec61c2054a1641f41775aa7c556758a109941e33e4fc"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/fc/f8/98eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3/distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/8c/8b/57666417c0f90f08bcafa776861060426765fdb422eb10212086fb811d26/dnspython-2.8.0.tar.gz"
    sha256 "181d3c6996452cb1189c4046c61599b84a5a86e099562ffde77d26984ff26d0f"
  end

  resource "docstring-parser" do
    url "https://files.pythonhosted.org/packages/b2/9d/c3b43da9515bd270df0f80548d9944e389870713cc1fe2b8fb35fe2bcefd/docstring_parser-0.17.0.tar.gz"
    sha256 "583de4a309722b3315439bb31d64ba3eebada841f2e2cee23b99df001434c912"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/d9/02/111134bfeb6e6c7ac4c74594e39a59f6c0195dc4846afbeac3cba60f1927/docutils-0.22.3.tar.gz"
    sha256 "21486ae730e4ca9f622677b1412b879af1791efcfba517e4c6f60be543fc8cdd"
  end

  resource "email-validator" do
    url "https://files.pythonhosted.org/packages/f5/22/900cb125c76b7aaa450ce02fd727f452243f2e91a61af068b40adba60ea9/email_validator-2.3.0.tar.gz"
    sha256 "9fc05c37f2f6cf439ff414f8fc46d917929974a82244c20eb10231ba60c54426"
  end

  resource "exceptiongroup" do
    url "https://files.pythonhosted.org/packages/50/79/66800aadf48771f6b62f7eb014e352e5d06856655206165d775e675a02c9/exceptiongroup-1.3.1.tar.gz"
    sha256 "8b412432c6055b0b7d14c310000ae93352ed6754f70fa8f7c34141f91c4e3219"
  end

  resource "fastapi" do
    url "https://files.pythonhosted.org/packages/80/f0/086c442c6516195786131b8ca70488c6ef11d2f2e33c9a893576b2b0d3f7/fastapi-0.121.3.tar.gz"
    sha256 "0055bc24fe53e56a40e9e0ad1ae2baa81622c406e548e501e717634e2dfbc40b"
  end

  resource "fastmcp" do
    url "https://files.pythonhosted.org/packages/d4/a3/c9eb28b5f0b979b0dd8aa9ba56e69298cdb2d72c15592165d042ccb20194/fastmcp-2.13.1.tar.gz"
    sha256 "b9c664c51f1ff47c698225e7304267ae29a51913f681bd49e442b8682f9a5f90"
  end

  resource "fastuuid" do
    url "https://files.pythonhosted.org/packages/c3/7d/d9daedf0f2ebcacd20d599928f8913e9d2aea1d56d2d355a93bfa2b611d7/fastuuid-0.14.0.tar.gz"
    sha256 "178947fc2f995b38497a74172adee64fdeb8b7ec18f2a5934d037641ba265d26"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/58/46/0028a82567109b5ef6e4d2a1f04a583fb513e6cf9527fcdd09afd817deeb/filelock-3.20.0.tar.gz"
    sha256 "711e943b4ec6be42e1d4e6690b48dc175c822967466bb31c0c293f34334c13f4"
  end

  resource "filetype" do
    url "https://files.pythonhosted.org/packages/bb/29/745f7d30d47fe0f251d3ad3dc2978a23141917661998763bebb6da007eb1/filetype-1.2.0.tar.gz"
    sha256 "66b56cd6474bf41d8c54660347d37afcc3f7d1970648de365c102ef77548aadb"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/2d/f5/c831fac6cc817d26fd54c7eaccd04ef7e0288806943f7cc5bbf69f3ac1f0/frozenlist-1.8.0.tar.gz"
    sha256 "3ede829ed8d842f6cd48fc7081d7a41001a56f1f38603f9d49bf3020d59a31ad"
  end

  resource "fsspec" do
    url "https://files.pythonhosted.org/packages/24/7f/2747c0d332b9acfa75dc84447a066fdf812b5a6b8d30472b74d309bfe8cb/fsspec-2025.10.0.tar.gz"
    sha256 "b6789427626f068f9a83ca4e8a3cc050850b6c0f71f99ddb4f542b8266a26a59"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/e5/7b/adfd75544c415c487b33061fe7ae526165241c1ea133f9a9125a56b39fd8/googleapis_common_protos-1.72.0.tar.gz"
    sha256 "e55a601c1b32b52d7a3e65f43563e2aa61bcd737998ee672ac9b951cd49319f5"
  end

  resource "grpcio" do
    url "https://files.pythonhosted.org/packages/b6/e0/318c1ce3ae5a17894d5791e87aea147587c9e702f24122cc7a5c8bbaeeb1/grpcio-1.76.0.tar.gz"
    sha256 "7be78388d6da1a25c0d5ec506523db58b18be22d9c37d8d3a32c08be4987bd73"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "hf-xet" do
    url "https://files.pythonhosted.org/packages/5e/6e/0f11bacf08a67f7fb5ee09740f2ca54163863b07b70d579356e9222ce5d8/hf_xet-1.2.0.tar.gz"
    sha256 "a8c27070ca547293b6890c4bf389f713f80e8c478631432962bb7f4bc0bd7d7f"
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

  resource "huggingface-hub" do
    url "https://files.pythonhosted.org/packages/fb/02/c3d534d7498ba2792da1d2ce56b5d38bbcbcbbba62071c90ee289b408e8d/huggingface_hub-1.1.5.tar.gz"
    sha256 "40ba5c9a08792d888fde6088920a0a71ab3cd9d5e6617c81a797c657f1fd9968"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/76/66/650a33bd90f786193e4de4b3ad86ea60b53c89b669a5c7be931fac31cdb0/importlib_metadata-8.7.0.tar.gz"
    sha256 "d13b81ad223b890aa16c5471f2ac3056cf76c5f10f82d6f9292f0b415f389000"
  end

  resource "inflection" do
    url "https://files.pythonhosted.org/packages/e1/7e/691d061b7329bc8d54edbf0ec22fbfb2afe61facb681f9aaa9bff7a27d04/inflection-0.5.1.tar.gz"
    sha256 "1a29730d366e996aaacffb2f1f1cb9593dc38e2ddd30c91250c6dde09ea9b417"
  end

  resource "jaraco-classes" do
    url "https://files.pythonhosted.org/packages/06/c0/ed4a27bc5571b99e3cff68f8a9fa5b56ff7df1c2251cc715a652ddd26402/jaraco.classes-3.4.0.tar.gz"
    sha256 "47a024b51d0239c0dd8c8540c6c7f484be3b8fcf0b2d85c13825780d3b3f3acd"
  end

  resource "jaraco-context" do
    url "https://files.pythonhosted.org/packages/df/ad/f3777b81bf0b6e7bc7514a1656d3e637b2e8e15fab2ce3235730b3e7a4e6/jaraco_context-6.0.1.tar.gz"
    sha256 "9bae4ea555cf0b14938dc0aee7c9f32ed303aa20a3b73e7dc80111628792d1b3"
  end

  resource "jaraco-functools" do
    url "https://files.pythonhosted.org/packages/f7/ed/1aa2d585304ec07262e1a83a9889880701079dde796ac7b1d1826f40c63d/jaraco_functools-4.3.0.tar.gz"
    sha256 "cfd13ad0dd2c47a3600b439ef72d8615d482cedcff1632930d6f28924d92f294"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "jiter" do
    url "https://files.pythonhosted.org/packages/45/9d/e0660989c1370e25848bb4c52d061c71837239738ad937e83edca174c273/jiter-0.12.0.tar.gz"
    sha256 "64dfcd7d5c168b38d3f9f8bba7fc639edb3418abcc74f22fdbe6b8938293f30b"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/74/69/f7185de793a29082a9f3c7728268ffb31cb5095131a9c139a74078e27336/jsonschema-4.25.1.tar.gz"
    sha256 "e4a9655ce0da0c0b67a085847e00a3a51449e1157f4f75e9fb5aa545e122eb85"
  end

  resource "jsonschema-path" do
    url "https://files.pythonhosted.org/packages/6e/45/41ebc679c2a4fced6a722f624c18d658dee42612b83ea24c1caf7c0eb3a8/jsonschema_path-0.3.4.tar.gz"
    sha256 "8365356039f16cc65fddffafda5f58766e34bebab7d6d105616ab52bc4297001"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/19/74/a633ee74eb36c44aa6d1095e7cc5569bebf04342ee146178e2d36600708b/jsonschema_specifications-2025.9.1.tar.gz"
    sha256 "b540987f239e745613c7a9176f3edb72b832a4ac465cf02712288397832b5e8d"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/43/4b/674af6ef2f97d56f0ab5153bf0bfa28ccb6c3ed4d1babf4305449668807b/keyring-25.7.0.tar.gz"
    sha256 "fe01bd85eb3f8fb3dd0405defdeac9a5b4f6f0439edbb3149577f244a2e8245b"
  end

  resource "lazify" do
    url "https://files.pythonhosted.org/packages/24/2c/b55c4a27a56dd9a00bb2812c404b57f8b7aec0cdbff9fdc61acdd73359bc/Lazify-0.4.0.tar.gz"
    sha256 "7102bfe63e56de2ab62b3bc661a7190c4056771a8624f04a8b785275c3dd1f9b"
  end

  resource "litellm" do
    url "https://files.pythonhosted.org/packages/85/b8/357544534bef87dd2858432f3cbd3a0e5cc267caebca5ea86b03618786c5/litellm-1.80.5.tar.gz"
    sha256 "922791c264845d9ed59e540c8fa74a74d237c1b209568a05ffeacd8b51770deb"
  end

  resource "literalai" do
    url "https://files.pythonhosted.org/packages/7e/c1/7bd34ad0ae6cfd99512f8a40b28b9624c3b1f4e1d40c9038eabc2f870b15/literalai-0.1.201.tar.gz"
    sha256 "29e4ccadd9d68bfea319a7f0b4fc32611b081990d9195f98e5e97a14d24d3713"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/5b/f5/4ec618ed16cc4f8fb3b701563655a69816155e79e24a17b651541804721d/markdown_it_py-4.0.0.tar.gz"
    sha256 "cb0a2b4aa34f932c007117b194e945bd74e0ec24133ceb5bac59009cda1cb9f3"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "marshmallow" do
    url "https://files.pythonhosted.org/packages/ab/5e/5e53d26b42ab75491cda89b871dab9e97c840bf12c63ec58a1919710cd06/marshmallow-3.26.1.tar.gz"
    sha256 "e6d8affb6cb61d39d26402096dc0aee12d5a26d490a121f118d2e81dc0719dc6"
  end

  resource "mcp" do
    url "https://files.pythonhosted.org/packages/a3/a2/c5ec0ab38b35ade2ae49a90fada718fbc76811dc5aa1760414c6aaa6b08a/mcp-1.22.0.tar.gz"
    sha256 "769b9ac90ed42134375b19e777a2858ca300f95f2e800982b3e2be62dfc0ba01"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "monotonic" do
    url "https://files.pythonhosted.org/packages/ea/ca/8e91948b782ddfbd194f323e7e7d9ba12e5877addf04fb2bf8fca38e86ac/monotonic-1.6.tar.gz"
    sha256 "3a55207bcfed53ddd5c5bae174524062935efed17792e9de2ad0205ce9ad63f7"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/ea/5d/38b681d3fce7a266dd9ab73c66959406d565b3e85f21d5e66e1181d93721/more_itertools-10.8.0.tar.gz"
    sha256 "f638ddf8a1a0d134181275fb5d58b086ead7c6a72429ad725c67503f13ba30bd"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/80/1e/5492c365f222f907de1039b91f922b93fa4f764c713ee858d235495d8f50/multidict-6.7.0.tar.gz"
    sha256 "c6e99d9a65ca282e578dfea819cfa9c0a62b2499d8677392e09feaf305e9e6f5"
  end

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/a2/6e/371856a3fb9d31ca8dac321cda606860fa4548858c0cc45d9d1d4ca2628b/mypy_extensions-1.1.0.tar.gz"
    sha256 "52e68efc3284861e772bbcd66823fde5ae21fd2fdb51c62a211403730b916558"
  end

  resource "nest-asyncio" do
    url "https://files.pythonhosted.org/packages/83/f8/51569ac65d696c8ecbee95938f89d4abf00f47d58d48f6fbabfe8f0baefe/nest_asyncio-1.6.0.tar.gz"
    sha256 "6f172d5449aca15afd6c646851f4e31e02c598d553a667e38cafa997cfec55fe"
  end

  resource "openai" do
    url "https://files.pythonhosted.org/packages/d5/e4/42591e356f1d53c568418dc7e30dcda7be31dd5a4d570bca22acb0525862/openai-2.8.1.tar.gz"
    sha256 "cb1b79eef6e809f6da326a7ef6038719e35aa944c42d081807bfa1be8060f15f"
  end

  resource "openapi-pydantic" do
    url "https://files.pythonhosted.org/packages/02/2e/58d83848dd1a79cb92ed8e63f6ba901ca282c5f09d04af9423ec26c56fd7/openapi_pydantic-0.5.1.tar.gz"
    sha256 "ff6835af6bde7a459fb93eb93bb92b8749b754fc6e51b2f1590a19dc3005ee0d"
  end

  resource "opentelemetry-api" do
    url "https://files.pythonhosted.org/packages/08/d8/0f354c375628e048bd0570645b310797299754730079853095bf000fba69/opentelemetry_api-1.38.0.tar.gz"
    sha256 "f4c193b5e8acb0912b06ac5b16321908dd0843d75049c091487322284a3eea12"
  end

  resource "opentelemetry-exporter-otlp-proto-common" do
    url "https://files.pythonhosted.org/packages/19/83/dd4660f2956ff88ed071e9e0e36e830df14b8c5dc06722dbde1841accbe8/opentelemetry_exporter_otlp_proto_common-1.38.0.tar.gz"
    sha256 "e333278afab4695aa8114eeb7bf4e44e65c6607d54968271a249c180b2cb605c"
  end

  resource "opentelemetry-exporter-otlp-proto-grpc" do
    url "https://files.pythonhosted.org/packages/a2/c0/43222f5b97dc10812bc4f0abc5dc7cd0a2525a91b5151d26c9e2e958f52e/opentelemetry_exporter_otlp_proto_grpc-1.38.0.tar.gz"
    sha256 "2473935e9eac71f401de6101d37d6f3f0f1831db92b953c7dcc912536158ebd6"
  end

  resource "opentelemetry-exporter-otlp-proto-http" do
    url "https://files.pythonhosted.org/packages/81/0a/debcdfb029fbd1ccd1563f7c287b89a6f7bef3b2902ade56797bfd020854/opentelemetry_exporter_otlp_proto_http-1.38.0.tar.gz"
    sha256 "f16bd44baf15cbe07633c5112ffc68229d0edbeac7b37610be0b2def4e21e90b"
  end

  resource "opentelemetry-instrumentation" do
    url "https://files.pythonhosted.org/packages/04/ed/9c65cd209407fd807fa05be03ee30f159bdac8d59e7ea16a8fe5a1601222/opentelemetry_instrumentation-0.59b0.tar.gz"
    sha256 "6010f0faaacdaf7c4dff8aac84e226d23437b331dcda7e70367f6d73a7db1adc"
  end

  resource "opentelemetry-instrumentation-alephalpha" do
    url "https://files.pythonhosted.org/packages/91/91/3e0bff99a1fbdc6c59b64534af1fc6c735fd3f579809364ce7ae0c6ba930/opentelemetry_instrumentation_alephalpha-0.48.1.tar.gz"
    sha256 "c56d95134973712be1d6eb02c2e40b0bc142af747ce33c0b0b7c73362ed61948"
  end

  resource "opentelemetry-instrumentation-anthropic" do
    url "https://files.pythonhosted.org/packages/c3/78/b90f8d933d56c407e64a0832be8c90bc5bf9df72c6a64deb75f45eede73b/opentelemetry_instrumentation_anthropic-0.48.1.tar.gz"
    sha256 "4b48c6529f44e3f7aa5e6dc4ea1dd02f5ae785ab85ade01c85b34bbf3fb8bda0"
  end

  resource "opentelemetry-instrumentation-bedrock" do
    url "https://files.pythonhosted.org/packages/34/0e/1426231259f15b21b4929ba8a5a3ba1cd46064efcd0519c2a5a9e9faf79b/opentelemetry_instrumentation_bedrock-0.48.1.tar.gz"
    sha256 "091f4ed1b503059de3e641a23d52091136497520073c2683eaa57108ff1371a2"
  end

  resource "opentelemetry-instrumentation-chromadb" do
    url "https://files.pythonhosted.org/packages/bc/6b/e06f82959c0a8f87e7f7b75efde2820d46993066b3a9cbdfe06a1335c5ff/opentelemetry_instrumentation_chromadb-0.48.1.tar.gz"
    sha256 "bca2184ddeeb59c04ce6adc3977c937c1edbd48f05625b0cfc9bfadfba99eaa5"
  end

  resource "opentelemetry-instrumentation-cohere" do
    url "https://files.pythonhosted.org/packages/22/41/563efba4c4ab21f41aacbeee5e908e09e667eb09c7b6439adff156bdb348/opentelemetry_instrumentation_cohere-0.48.1.tar.gz"
    sha256 "4abd1df5dcff54d514f49ceea9cf9780fbd616555a5a6c8f8d204cc0d30b4073"
  end

  resource "opentelemetry-instrumentation-crewai" do
    url "https://files.pythonhosted.org/packages/17/8c/bb088239d4f57c46828fcff580263a100de3ec1e7b270d288609d077f262/opentelemetry_instrumentation_crewai-0.48.1.tar.gz"
    sha256 "e7e53cbbdee480859e90bfc202f80b06845529bf8ddc95a1b9d94337ce403428"
  end

  resource "opentelemetry-instrumentation-google-generativeai" do
    url "https://files.pythonhosted.org/packages/df/f1/8e54ab737414f09c0cb643508efdfc56acb0f854d249f3dead99b37e3b09/opentelemetry_instrumentation_google_generativeai-0.48.1.tar.gz"
    sha256 "54c60a316b79e556ca12f2291aafcb0370d16e3e5a2ba3ac97912b060b7d960b"
  end

  resource "opentelemetry-instrumentation-groq" do
    url "https://files.pythonhosted.org/packages/47/66/79fdcffe1d71b760ffb792a948c73b8a5e3b72912b5d921979c50e2e0f73/opentelemetry_instrumentation_groq-0.48.1.tar.gz"
    sha256 "29914b19f270e45686c9ed80ec4e162f367d0f6e519cde4d43a6b781ae663b0a"
  end

  resource "opentelemetry-instrumentation-haystack" do
    url "https://files.pythonhosted.org/packages/88/e8/a9591cfe54d2d64f9513f9897c4ce609dc44f02df5f8817b4e26c85d0973/opentelemetry_instrumentation_haystack-0.48.1.tar.gz"
    sha256 "2087bbed1c6c741197d0276fcf19735bd1d9f133a04e86c641b4bb9bf2fd69dc"
  end

  resource "opentelemetry-instrumentation-lancedb" do
    url "https://files.pythonhosted.org/packages/04/ba/093142448c14bd44dee3fa5973c1d891b0a6c90744099592caf003d58e96/opentelemetry_instrumentation_lancedb-0.48.1.tar.gz"
    sha256 "97be9e61d8436a386538cd394eca1cdbad10991ee67297f10a8683947fabcd8e"
  end

  resource "opentelemetry-instrumentation-langchain" do
    url "https://files.pythonhosted.org/packages/02/68/2129809e55e0b8b70d5f5532551d7f27d1fa97e3b1a9e4602c0d04655c52/opentelemetry_instrumentation_langchain-0.48.1.tar.gz"
    sha256 "2251d1ab4cbe1d8874f66a7566680dfe48a02ebc78e9f845a69ad0f26840661b"
  end

  resource "opentelemetry-instrumentation-llamaindex" do
    url "https://files.pythonhosted.org/packages/87/ba/56f1e18b45f45f0c38c94b6ab2c5ea35fe01419ad84f2b8f3c4c309c9d39/opentelemetry_instrumentation_llamaindex-0.48.1.tar.gz"
    sha256 "f23059e21708308a625d50359d9bd968059d0ab47807046a1c90aed6fdf72f46"
  end

  resource "opentelemetry-instrumentation-logging" do
    url "https://files.pythonhosted.org/packages/be/88/9c5f70fa8b8d96d30be378fc6eb1776e13aea456db15009f4eaef4928847/opentelemetry_instrumentation_logging-0.59b0.tar.gz"
    sha256 "1b51116444edc74f699daf9002ded61529397100c9bc903c8b9aaa75a5218c76"
  end

  resource "opentelemetry-instrumentation-marqo" do
    url "https://files.pythonhosted.org/packages/09/a4/1476eaa2f1235194f1bd315dbde6ebc7870eb473183b6c067ed6811390d5/opentelemetry_instrumentation_marqo-0.48.1.tar.gz"
    sha256 "05c80fc3e220f942801523ea2e4199af6f48cd8827c6b3ad639c7d00007bdd5d"
  end

  resource "opentelemetry-instrumentation-mcp" do
    url "https://files.pythonhosted.org/packages/dc/61/97d31a8e59c981c21ceb3f7cf96675da306af5a3e8957ad3ceb5c669b780/opentelemetry_instrumentation_mcp-0.48.1.tar.gz"
    sha256 "5907c2d1cc87e530e3c6a3609912d1ade6b56d5ca157afc470586b04ea99602c"
  end

  resource "opentelemetry-instrumentation-milvus" do
    url "https://files.pythonhosted.org/packages/b7/79/c719b97bf8e938f17aedfec4a8cc6c978adefa99c7dec900a62c7d1ce0ed/opentelemetry_instrumentation_milvus-0.48.1.tar.gz"
    sha256 "9de095f8c16c0e149c97d31cbf734c002ca3aa3d33a949845e15e2d228edf5a2"
  end

  resource "opentelemetry-instrumentation-mistralai" do
    url "https://files.pythonhosted.org/packages/b0/22/1c8be67d14dfb5faebfb293e5eae2c12d988dcd2c8cbb68972f7e30370a0/opentelemetry_instrumentation_mistralai-0.48.1.tar.gz"
    sha256 "e206d1012258c31cb431d08b42058e89d5ff07b1b1a50fdf26050ed490ee741c"
  end

  resource "opentelemetry-instrumentation-ollama" do
    url "https://files.pythonhosted.org/packages/8e/72/9d2fecebbb6b000a7abd894192a1c4aa14bad763a59f3b215b5b59344817/opentelemetry_instrumentation_ollama-0.48.1.tar.gz"
    sha256 "fe51018381b4b35db1309b36b1b06eec9a580ff8bd5968e3d5fb0ad87fbf3fa6"
  end

  resource "opentelemetry-instrumentation-openai" do
    url "https://files.pythonhosted.org/packages/ae/2e/9d32127aad2e48f7b05de10acedb96e8da77a7d3f7e4af50096f092cc65b/opentelemetry_instrumentation_openai-0.48.1.tar.gz"
    sha256 "e081eeb6e5aa59f286abd70ce100212b93885ac23061cd4af304217aefc5347a"
  end

  resource "opentelemetry-instrumentation-openai-agents" do
    url "https://files.pythonhosted.org/packages/7a/28/a97989398cf39cf6e66bc3cb1e35409bb2476fe2fe28716eb4829644d8d6/opentelemetry_instrumentation_openai_agents-0.48.1.tar.gz"
    sha256 "bfde836e7be87d007f56466162d3af82d7df87ef5be3e3b04f5311635ef68e75"
  end

  resource "opentelemetry-instrumentation-pinecone" do
    url "https://files.pythonhosted.org/packages/1f/4e/4ec1d30dcd19229c2dcba6f726be52b3daa40f66d43f31f545dbc7b7831a/opentelemetry_instrumentation_pinecone-0.48.1.tar.gz"
    sha256 "225fff84d659d60cefef1b68c79d9f2901ed91e6f3873961bac7883312a6fda9"
  end

  resource "opentelemetry-instrumentation-qdrant" do
    url "https://files.pythonhosted.org/packages/c5/b3/52ecf317134ddf45d8f6edcb2e51f69fa34a849bea5f1fe2aa54cebfe215/opentelemetry_instrumentation_qdrant-0.48.1.tar.gz"
    sha256 "f373120d9925d95f3e72aee8e7b62ac05c9e972dae3c54b74e7b67c019a8c7d3"
  end

  resource "opentelemetry-instrumentation-redis" do
    url "https://files.pythonhosted.org/packages/7f/f8/58bf83b10a97f67c7f06505bc4c4accbea7d961dec653a8c9e91fb65887e/opentelemetry_instrumentation_redis-0.59b0.tar.gz"
    sha256 "d7f1c7c55ab57e10e0155c4c65d028a7e436aec7ccc7ccbf1d77e8cd12b55abd"
  end

  resource "opentelemetry-instrumentation-replicate" do
    url "https://files.pythonhosted.org/packages/9e/f0/88f0d74c52008f3b5f11edcdc9977df2b4c80447018a78c8029a629d25ac/opentelemetry_instrumentation_replicate-0.48.1.tar.gz"
    sha256 "d03b243006aa7ed3b34e16d6ac8b76d8bd1452af20c52a5c343e826b66028af6"
  end

  resource "opentelemetry-instrumentation-requests" do
    url "https://files.pythonhosted.org/packages/49/01/31282a46b09684dfc636bc066deb090bae6973e71e85e253a8c74e727b1f/opentelemetry_instrumentation_requests-0.59b0.tar.gz"
    sha256 "9af2ffe3317f03074d7f865919139e89170b6763a0251b68c25e8e64e04b3400"
  end

  resource "opentelemetry-instrumentation-sagemaker" do
    url "https://files.pythonhosted.org/packages/ae/eb/2b4e249845267ae2aa6609e8ce1e5d4d2e78127404ec67fb33dcb3376aa6/opentelemetry_instrumentation_sagemaker-0.48.1.tar.gz"
    sha256 "d3c103750c270ab69f38a588ca4918031fc9115f45fbfd96f804d29801485fde"
  end

  resource "opentelemetry-instrumentation-sqlalchemy" do
    url "https://files.pythonhosted.org/packages/b9/00/c5222a5e0521772aa530008c6c9c67f453e2b00e97d91fd799e8159aecf5/opentelemetry_instrumentation_sqlalchemy-0.59b0.tar.gz"
    sha256 "7647b1e63497deebd41f9525c414699e0d49f19efcadc8a0642b715897f62d32"
  end

  resource "opentelemetry-instrumentation-threading" do
    url "https://files.pythonhosted.org/packages/82/7a/84e97d8992808197006e607ae410c2219bdbbc23d1289ba0c244d3220741/opentelemetry_instrumentation_threading-0.59b0.tar.gz"
    sha256 "ce5658730b697dcbc0e0d6d13643a69fd8aeb1b32fa8db3bade8ce114c7975f3"
  end

  resource "opentelemetry-instrumentation-together" do
    url "https://files.pythonhosted.org/packages/d6/90/7c410ec9e9578714f3ed62bac3e405348f02e4d00273202bf5041cfe3efa/opentelemetry_instrumentation_together-0.48.1.tar.gz"
    sha256 "aa9bfd602d53c7cc94ac3978298daf7bf5703f30008b7086317b0c3bb502e99c"
  end

  resource "opentelemetry-instrumentation-transformers" do
    url "https://files.pythonhosted.org/packages/d9/6b/059cca8ab13796fc1e445b1b2a5a6209902322cabd68654fc10b082726be/opentelemetry_instrumentation_transformers-0.48.1.tar.gz"
    sha256 "721409c4da7d7f8fdab5b2e1c13b9c7da670bd1d2afcb1d629433a275b2e2bab"
  end

  resource "opentelemetry-instrumentation-urllib3" do
    url "https://files.pythonhosted.org/packages/94/53/ff93665911808933b1af6fbbb1be2eb83c0c46e3b5f24b0b04c094b5b719/opentelemetry_instrumentation_urllib3-0.59b0.tar.gz"
    sha256 "2de8d53a746bba043be1bc8f3246e1b131ebb6e94fe73601edd8b2bd91fe35b8"
  end

  resource "opentelemetry-instrumentation-vertexai" do
    url "https://files.pythonhosted.org/packages/29/62/abefa969fdace6c911f1acd15ada5a90c4c0ef0cb8ba0d2cc38ee2fcc34e/opentelemetry_instrumentation_vertexai-0.48.1.tar.gz"
    sha256 "6c79aa74a76e75d7b16a2fa2e717e9b2df6c09922521323ad5b842422eb3871f"
  end

  resource "opentelemetry-instrumentation-watsonx" do
    url "https://files.pythonhosted.org/packages/a8/ef/59e14bb8f4b9813646ae580200b836e82d52c01e3e8250a6a8ab99343955/opentelemetry_instrumentation_watsonx-0.48.1.tar.gz"
    sha256 "08b06be3a7f34c9f630d462c728b0aa20707250a16ee3635a7efe4bea5b7a2be"
  end

  resource "opentelemetry-instrumentation-weaviate" do
    url "https://files.pythonhosted.org/packages/86/44/38dea71e72ca451709bf10798b9b9a2474282d5b1345edfb9b38f09d7db7/opentelemetry_instrumentation_weaviate-0.48.1.tar.gz"
    sha256 "7d3b058a821d3b470431a6eca8276e7bc47d7805f08345d88007fac58cdf95d2"
  end

  resource "opentelemetry-instrumentation-writer" do
    url "https://files.pythonhosted.org/packages/58/1f/76da80db293c778d9fed2a82ba1dc57bf0e2e917508e6da5e2ae3a0dcbfd/opentelemetry_instrumentation_writer-0.48.1.tar.gz"
    sha256 "270b4738027778ce51d8a3565f8074df64a2c8b58b4463c351c0f38dc2df4028"
  end

  resource "opentelemetry-proto" do
    url "https://files.pythonhosted.org/packages/51/14/f0c4f0f6371b9cb7f9fa9ee8918bfd59ac7040c7791f1e6da32a1839780d/opentelemetry_proto-1.38.0.tar.gz"
    sha256 "88b161e89d9d372ce723da289b7da74c3a8354a8e5359992be813942969ed468"
  end

  resource "opentelemetry-sdk" do
    url "https://files.pythonhosted.org/packages/85/cb/f0eee1445161faf4c9af3ba7b848cc22a50a3d3e2515051ad8628c35ff80/opentelemetry_sdk-1.38.0.tar.gz"
    sha256 "93df5d4d871ed09cb4272305be4d996236eedb232253e3ab864c8620f051cebe"
  end

  resource "opentelemetry-semantic-conventions" do
    url "https://files.pythonhosted.org/packages/40/bc/8b9ad3802cd8ac6583a4eb7de7e5d7db004e89cb7efe7008f9c8a537ee75/opentelemetry_semantic_conventions-0.59b0.tar.gz"
    sha256 "7a6db3f30d70202d5bf9fa4b69bc866ca6a30437287de6c510fb594878aed6b0"
  end

  resource "opentelemetry-semantic-conventions-ai" do
    url "https://files.pythonhosted.org/packages/ba/e6/40b59eda51ac47009fb47afcdf37c6938594a0bd7f3b9fadcbc6058248e3/opentelemetry_semantic_conventions_ai-0.4.13.tar.gz"
    sha256 "94efa9fb4ffac18c45f54a3a338ffeb7eedb7e1bb4d147786e77202e159f0036"
  end

  resource "opentelemetry-util-http" do
    url "https://files.pythonhosted.org/packages/34/f7/13cd081e7851c42520ab0e96efb17ffbd901111a50b8252ec1e240664020/opentelemetry_util_http-0.59b0.tar.gz"
    sha256 "ae66ee91be31938d832f3b4bc4eb8a911f6eddd38969c4a871b1230db2a0a560"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "pathable" do
    url "https://files.pythonhosted.org/packages/67/93/8f2c2075b180c12c1e9f6a09d1a985bc2036906b13dff1d8917e395f2048/pathable-0.4.4.tar.gz"
    sha256 "6905a3cd17804edfac7875b5f6c9142a218c7caef78693c2dbbbfbac186d88b2"
  end

  resource "pathvalidate" do
    url "https://files.pythonhosted.org/packages/fa/2a/52a8da6fe965dea6192eb716b357558e103aea0a1e9a8352ad575a8406ca/pathvalidate-3.3.1.tar.gz"
    sha256 "b18c07212bfead624345bb8e1d6141cdcf15a39736994ea0b94035ad2b1ba177"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/61/33/9611380c2bdb1225fdef633e2a9610622310fed35ab11dac9620972ee088/platformdirs-4.5.0.tar.gz"
    sha256 "70ddccdd7c99fc5942e9fc25636a8b34d04c24b335100223152c2803e4063312"
  end

  resource "posthog" do
    url "https://files.pythonhosted.org/packages/85/a9/ec3bbc23b6f3c23c52e0b5795b1357cca74aa5cfb254213f1e471fef9b4d/posthog-3.25.0.tar.gz"
    sha256 "9168f3e7a0a5571b6b1065c41b3c171fbc68bfe72c3ac0bfd6e3d2fcdb7df2ca"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/a1/96/06e01a7b38dce6fe1db213e061a4602dd6032a8a97ef6c1a862537732421/prompt_toolkit-3.0.52.tar.gz"
    sha256 "28cde192929c8e7321de85de1ddbe736f1375148b02f2e17edd840042b1be855"
  end

  resource "propcache" do
    url "https://files.pythonhosted.org/packages/9e/da/e9fc233cf63743258bff22b3dfa7ea5baef7b5bc324af47a0ad89b8ffc6f/propcache-0.4.1.tar.gz"
    sha256 "f48107a8c637e80362555f37ecf49abe20370e557cc4ab374f04ec4423c97c3d"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/0a/03/a1440979a3f74f16cab3b75b0da1a1a7f922d56a8ddea96092391998edc0/protobuf-6.33.1.tar.gz"
    sha256 "97f65757e8d09870de6fd973aeddb92f85435607235d20b2dfed93405d00c85b"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/e1/88/bdd0a41e5857d5d703287598cbf08dad90aed56774ea52ae071bae9071b6/psutil-7.1.3.tar.gz"
    sha256 "6c86281738d77335af7aec228328e944b30930899ea760ecf33a4dba66be5e74"
  end

  resource "py-key-value-aio" do
    url "https://files.pythonhosted.org/packages/ca/35/65310a4818acec0f87a46e5565e341c5a96fc062a9a03495ad28828ff4d7/py_key_value_aio-0.2.8.tar.gz"
    sha256 "c0cfbb0bd4e962a3fa1a9fa6db9ba9df812899bd9312fa6368aaea7b26008b36"
  end

  resource "py-key-value-shared" do
    url "https://files.pythonhosted.org/packages/26/79/05a1f9280cfa0709479319cbfd2b1c5beb23d5034624f548c83fb65b0b61/py_key_value_shared-0.2.8.tar.gz"
    sha256 "703b4d3c61af124f0d528ba85995c3c8d78f8bd3d2b217377bd3278598070cc1"
  end

  resource "pydantic-settings" do
    url "https://files.pythonhosted.org/packages/43/4b/ac7e0aae12027748076d72a8764ff1c9d82ca75a7a52622e67ed3f765c54/pydantic_settings-2.12.0.tar.gz"
    sha256 "005538ef951e3c2a68e1c08b292b5f2e71490def8589d4221b95dab00dafcfd0"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/e7/46/bd74733ff231675599650d3e47f361794b22ef3e3770998dda30d3b63726/pyjwt-2.10.1.tar.gz"
    sha256 "3cc5772eb20009233caf06e9d8a0577824723b44e6648ee0a2aedb6cf9381953"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/e8/52/d87eba7cb129b81563019d1679026e7a112ef76855d6159d24754dbd2a51/pyperclip-1.11.0.tar.gz"
    sha256 "244035963e4428530d9e3a6101a1ef97209c6825edab1567beac148ccc1db1b6"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/f0/26/19cadc79a718c5edbec86fd4919a6b6d3f681039a2f6d66d14be94e75fb9/python_dotenv-1.2.1.tar.gz"
    sha256 "42667e897e16ab0d66954af0e60a9caa94f0fd4ecf3aaf6d2d260eec1aa36ad6"
  end

  resource "python-engineio" do
    url "https://files.pythonhosted.org/packages/c9/d8/63e5535ab21dc4998ba1cfe13690ccf122883a38f025dca24d6e56c05eba/python_engineio-4.12.3.tar.gz"
    sha256 "35633e55ec30915e7fc8f7e34ca8d73ee0c080cec8a8cd04faf2d7396f0a7a7a"
  end

  resource "python-multipart" do
    url "https://files.pythonhosted.org/packages/f3/87/f44d7c9f274c7ee665a29b885ec97089ec5dc034c7f3fafa03da9e39a09e/python_multipart-0.0.20.tar.gz"
    sha256 "8dd0cab45b8e23064ae09147625994d090fa46f5b0d1e13af944c331a7fa9d13"
  end

  resource "python-socketio" do
    url "https://files.pythonhosted.org/packages/72/a8/5f7c805dd6d0d6cba91d3ea215b4b88889d1b99b71a53c932629daba53f1/python_socketio-5.15.0.tar.gz"
    sha256 "d0403ababb59aa12fd5adcfc933a821113f27bd77761bc1c54aad2e3191a9b69"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "questionary" do
    url "https://files.pythonhosted.org/packages/f6/45/eafb0bba0f9988f6a2520f9ca2df2c82ddfa8d67c95d6625452e97b204a5/questionary-2.1.1.tar.gz"
    sha256 "3d7e980292bb0107abaa79c68dd3eee3c561b83a0f89ae482860b181c8bd412d"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/2f/db/98b5c277be99dd18bfd91dd04e1b759cad18d1a338188c936e92f921c7e2/referencing-0.36.2.tar.gz"
    sha256 "df2e89862cd09deabbdba16944cc3f10feb6b3e6f18e902f7cc25609a34775aa"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/cc/a9/546676f25e573a4cf00fe8e119b78a37b6a8fe2dc95cda877b30889c9c45/regex-2025.11.3.tar.gz"
    sha256 "1fedc720f9bb2494ce31a58a1631f9c82df6a09b49c19517ea5cc280b4541e01"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/fb/d2/8920e102050a0de7bfabeb4c4614a49248cf8d5d7a8d01885fbb24dc767a/rich-14.2.0.tar.gz"
    sha256 "73ff50c7c0c1c77c8243079283f4edb376f0f6442433aecb8ce7e6d0b92d1fe4"
  end

  resource "rich-rst" do
    url "https://files.pythonhosted.org/packages/bc/6d/a506aaa4a9eaa945ed8ab2b7347859f53593864289853c5d6d62b77246e0/rich_rst-1.3.2.tar.gz"
    sha256 "a1196fdddf1e364b02ec68a05e8ff8f6914fee10fbca2e6b6735f166bb0da8d4"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/ca/bb/940d6af975948c1cc18f44545ffb219d3c35d78ec972b42ae229e8e37e08/s3transfer-0.15.0.tar.gz"
    sha256 "d36fac8d0e3603eff9b5bfa4282c7ce6feb0301a633566153cbd0b93d11d8379"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/58/15/8b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58e/shellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "simple-websocket" do
    url "https://files.pythonhosted.org/packages/b0/d4/bfa032f961103eba93de583b161f0e6a5b63cebb8f2c7d0c6e6efe1e3d2e/simple_websocket-1.1.0.tar.gz"
    sha256 "7939234e7aa067c534abdab3a9ed933ec9ce4691b0713c78acb195560aa52ae4"
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
    url "https://files.pythonhosted.org/packages/db/3c/fa6517610dc641262b77cc7bf994ecd17465812c1b0585fe33e11be758ab/sse_starlette-3.0.3.tar.gz"
    sha256 "88cfb08747e16200ea990c8ca876b03910a23b547ab3bd764c0d8eb81019b971"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/ba/b8/73a0e6a6e079a9d9cfa64113d771e421640b6f679a52eeb9b32f72d871a1/starlette-0.50.0.tar.gz"
    sha256 "a2a17b22203254bcbc2e1f926d2d55f3f9497f769416b3190768befe598fa3ca"
  end

  resource "syncer" do
    url "https://files.pythonhosted.org/packages/8d/dd/d4dd75843692690d81f0a4b929212a1614b25d4896aa7c72f4c3546c7e3d/syncer-2.0.3.tar.gz"
    sha256 "4340eb54b54368724a78c5c0763824470201804fe9180129daf3635cb500550f"
  end

  resource "tenacity" do
    url "https://files.pythonhosted.org/packages/0a/d4/2b0cd0fe285e14b36db076e78c93766ff1d529d70408bd1d2a5a84f1d929/tenacity-9.1.2.tar.gz"
    sha256 "1169d376c297e7de388d18b4481760d478b0e99a777cad3a9c86e556f4b697cb"
  end

  resource "tiktoken" do
    url "https://files.pythonhosted.org/packages/7d/ab/4d017d0f76ec3171d469d80fc03dfbb4e48a4bcaddaa831b31d526f05edc/tiktoken-0.12.0.tar.gz"
    sha256 "b18ba7ee2b093863978fcb14f74b3707cdc8d4d4d3836853ce7ec60772139931"
  end

  resource "tokenizers" do
    url "https://files.pythonhosted.org/packages/1c/46/fb6854cec3278fbfa4a75b50232c77622bc517ac886156e6afbfa4d8fc6e/tokenizers-0.22.1.tar.gz"
    sha256 "61de6522785310a309b3407bac22d99c4db5dba349935e99e4d15ea2226af2d9"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/52/ed/3f73f72945444548f33eba9a87fc7a6e969915e7b1acc8260b30e1f76a2f/tomli-2.3.0.tar.gz"
    sha256 "64be704a875d2a59753d80ee8a533c3fe183e3f06807ff7dc2232938ccb01549"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/a8/4b/29b4ef32e036bb34e4ab51796dd745cdba7ed47ad142a9f4a1eb8e0c744d/tqdm-4.67.1.tar.gz"
    sha256 "f8aef9c52c08c13a65f30ea34f4e5aac3fd1a34959879d7e59e63027286627f2"
  end

  resource "traceloop-sdk" do
    url "https://files.pythonhosted.org/packages/e4/f1/bdf609dfb683a643c5ec061cb6cd1e4594484414001d627bff47f5f8a697/traceloop_sdk-0.48.1.tar.gz"
    sha256 "dd96fe1458e9cdbdcb82ea7af89113f8b6266c449ec1fe22aa0003543f2badc6"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/8f/28/7c85c8032b91dbe79725b6f17d2fffc595dff06a35c7a30a37bef73a1ab4/typer-0.20.0.tar.gz"
    sha256 "1aaf6494031793e4876fb0bacfa6a912b551cf43c1e63c800df8b1a866720c37"
  end

  resource "typer-slim" do
    url "https://files.pythonhosted.org/packages/8e/45/81b94a52caed434b94da65729c03ad0fb7665fab0f7db9ee54c94e541403/typer_slim-0.20.0.tar.gz"
    sha256 "9fc6607b3c6c20f5c33ea9590cbeb17848667c51feee27d9e314a579ab07d1a3"
  end

  resource "typing-inspect" do
    url "https://files.pythonhosted.org/packages/dc/74/1789779d91f1961fa9438e9a8710cdae6bd138c80d7303996933d117264a/typing_inspect-0.9.0.tar.gz"
    sha256 "b23fc42ff6f6ef6954e4852c1fb512cdd18dbea03134f91f856a95ccc9461f78"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/cb/ce/f06b84e2697fef4688ca63bdb2fdf113ca0a3be33f94488f2cadb690b0cf/uvicorn-0.38.0.tar.gz"
    sha256 "fd97093bdd120a2609fc0d3afe931d4d4ad688b6e75f0f929fde1bc36fe0e91d"
  end

  resource "watchfiles" do
    url "https://files.pythonhosted.org/packages/c8/27/2ba23c8cc85796e2d41976439b08d52f691655fdb9401362099502d1f0cf/watchfiles-0.24.0.tar.gz"
    sha256 "afb72325b74fa7a428c009c1b8be4b4d7c2afedafb2982827ef2156646df2fe1"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/24/30/6b0809f4510673dc723187aeaf24c7f5459922d01e2f794277a3dfb90345/wcwidth-0.2.14.tar.gz"
    sha256 "4d478375d31bc5395a3c55c40ccdf3354688364cd61c4f6adacaa9215d0b3605"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/21/e6/26d09fab466b7ca9c7737474c52be4f76a40301b08362eb2dbc19dcc16c1/websockets-15.0.1.tar.gz"
    sha256 "82544de02076bafba038ce055ee6412d68da13ab47f0c60cab827346de828dee"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/95/8f/aeb76c5b46e273670962298c23e7ddde79916cb74db802131d49a85e4b7d/wrapt-1.17.3.tar.gz"
    sha256 "f66eb08feaa410fe4eebd17f2a2c8e2e46d3476e9f8c783daa8e09e0faa666d0"
  end

  resource "wsproto" do
    url "https://files.pythonhosted.org/packages/c7/79/12135bdf8b9c9367b8701c2c19a14c913c120b882d50b014ca0d38083c2c/wsproto-1.3.2.tar.gz"
    sha256 "b86885dcf294e15204919950f666e06ffc6c7c114ca900b060d6e16293528294"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/57/63/0c6ebca57330cd313f6102b16dd57ffaf3ec4c83403dcb45dbd15c6f3ea1/yarl-1.22.0.tar.gz"
    sha256 "bebf8557577d4401ba8bd9ff33906f1376c877aa78d1fe216ad01b4d6745af71"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/e3/02/0f2892c661036d50ede074e376733dca2ae7c6eb617489437771209d4180/zipp-3.23.0.tar.gz"
    sha256 "a07157588a12518c9d4034df3fbbee09c814741a33ff63c05fa29d26a2404166"
  end

  def install
    virtualenv_install_with_resources

    # `shellingham` auto-detection doesn't work in Homebrew CI build environment so
    # disable it to allow `typer` to use argument as shell for completions
    # Ref: https://typer.tiangolo.com/features/#user-friendly-cli-apps
    ENV["_TYPER_COMPLETE_TEST_DISABLE_SHELL_DETECTION"] = "1"
    generate_completions_from_executable(bin/"pixelle", "--show-completion")
  end

  test do
    output = shell_output("#{bin}/pixelle status")
    assert_match "Pixelle Version: #{version}", output
    assert_match "Checking Pixelle MCP service status...", output
  end
end
