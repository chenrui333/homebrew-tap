class PubmedMcpServer < Formula
  include Language::Python::Virtualenv

  desc "MCP server for searching and querying PubMed medical papers/research database"
  homepage "https://github.com/andybrandt/mcp-simple-pubmed"
  url "https://files.pythonhosted.org/packages/63/6a/5c5c487ff2de90611a2150f25cba204deca516f6e03eec107ceb8d54def9/mcp_simple_pubmed-0.1.13.tar.gz"
  sha256 "bbaa665daaf929d3f072ddeb6440d6a1761aaf897c476be34ff1314a9a63383c"
  license "MIT"

  depends_on "cmake" => :build # for levenshtein
  depends_on "ninja" => :build # for levenshtein
  depends_on "rust" => :build # for pydantic
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "numpy"
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

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/5a/b0/1367933a8532ee6ff8d63537de4f1177af4bff9f3e829baf7331f595bb24/attrs-25.3.0.tar.gz"
    sha256 "75d7cefc7fb576747b2c81b4442d4d4a1ce0900973527c011d1030fd3bf4af1b"
  end

  resource "authlib" do
    url "https://files.pythonhosted.org/packages/5d/c6/d9a9db2e71957827e23a34322bde8091b51cb778dcc38885b84c772a1ba9/authlib-1.6.3.tar.gz"
    sha256 "9f7a982cc395de719e4c2215c5707e7ea690ecf84f1ab126f28c053f4219e610"
  end

  resource "biopython" do
    url "https://files.pythonhosted.org/packages/db/ca/1d5fab0fedaf5c2f376d9746d447cdce04241c433602c3861693361ce54c/biopython-1.85.tar.gz"
    sha256 "5dafab74059de4e78f49f6b5684eddae6e7ce46f09cfa059c1d1339e8b1ea0a6"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/83/2d/5fd176ceb9b2fc619e63405525573493ca23441330fcdaee6bef9460e924/charset_normalizer-3.4.3.tar.gz"
    sha256 "6fce4b8500244f6fcb71465d4a4930d132ba9ab8e71a7859e6a5d59851068d14"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/60/6c/8ca2efa64cf75a977a0d7fac081354553ebe483345c734fb6b6515d96bbc/click-8.2.1.tar.gz"
    sha256 "27c491cc05d968d271d5a1db13e3b5a184636d9d930f148c50b038f0d0646202"
  end

  resource "coloredlogs" do
    url "https://files.pythonhosted.org/packages/cc/c7/eed8f27100517e8c0e6b923d5f0845d0cb99763da6fdee00478f91db7325/coloredlogs-15.0.1.tar.gz"
    sha256 "7c991aa71a4577af2f82600d8f8f3a89f936baeaf9b50a9c197da014e5bf16b0"
  end

  resource "cssselect" do
    url "https://files.pythonhosted.org/packages/72/0a/c3ea9573b1dc2e151abfe88c7fe0c26d1892fe6ed02d0cdb30f0d57029d5/cssselect-1.3.0.tar.gz"
    sha256 "57f8a99424cfab289a1b6a816a43075a4b00948c86b4dcf3ef4ee7e15f7ab0c7"
  end

  resource "cyclopts" do
    url "https://files.pythonhosted.org/packages/40/8b/87b309117bb0892233d279dc402603c1d44c13912baf54d0a9eb8d6205ce/cyclopts-3.23.0.tar.gz"
    sha256 "e8e28386b600c12a6db8916f2191bfdb4518260fbbceb16177f0fecae7ac7996"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/b5/4a/263763cb2ba3816dd94b08ad3a33d5fdae34ecb856678773cc40a3605829/dnspython-2.7.0.tar.gz"
    sha256 "ce9c432eda0dc91cf618a5cedf1a4e142651196bbcd2c80e89ed5a907e5cfaf1"
  end

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "docstring-parser" do
    url "https://files.pythonhosted.org/packages/b2/9d/c3b43da9515bd270df0f80548d9944e389870713cc1fe2b8fb35fe2bcefd/docstring_parser-0.17.0.tar.gz"
    sha256 "583de4a309722b3315439bb31d64ba3eebada841f2e2cee23b99df001434c912"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/e9/86/5b41c32ecedcfdb4c77b28b6cb14234f252075f8cdb254531727a35547dd/docutils-0.22.tar.gz"
    sha256 "ba9d57750e92331ebe7c08a1bbf7a7f8143b86c476acd51528b042216a6aad0f"
  end

  resource "email-validator" do
    url "https://files.pythonhosted.org/packages/f5/22/900cb125c76b7aaa450ce02fd727f452243f2e91a61af068b40adba60ea9/email_validator-2.3.0.tar.gz"
    sha256 "9fc05c37f2f6cf439ff414f8fc46d917929974a82244c20eb10231ba60c54426"
  end

  resource "eutils" do
    url "https://files.pythonhosted.org/packages/e9/ab/75a1cc7b0f24a568bffb2588f9a783d3d4385102c1910dfb8c9ff7bb3498/eutils-0.6.0.tar.gz"
    sha256 "3515178c0aadb836206a3eee2bc9f340f3213c13b53632e058eb58a9219d03cf"
  end

  resource "exceptiongroup" do
    url "https://files.pythonhosted.org/packages/0b/9f/a65090624ecf468cdca03533906e7c69ed7588582240cfe7cc9e770b50eb/exceptiongroup-1.3.0.tar.gz"
    sha256 "b241f5885f560bc56a59ee63ca4c6a8bfa46ae4ad651af316d4e81817bb9fd88"
  end

  resource "fastmcp" do
    url "https://files.pythonhosted.org/packages/06/80/13aec687ec21727b0fe6d26c6fe2febb33ae24e24c980929a706db3a8bc2/fastmcp-2.11.3.tar.gz"
    sha256 "e8e3834a3e0b513712b8e63a6f0d4cbe19093459a1da3f7fbf8ef2810cfd34e3"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "habanero" do
    url "https://files.pythonhosted.org/packages/7e/79/e1463d0829f1b9d9a140ea78dda9461c13a8d9589797ab1ff5b7fffd133f/habanero-2.3.0.tar.gz"
    sha256 "871e5d088ef641b05514d44b004af512852b309bcd0d81f10545e58d54a654ab"
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

  resource "humanfriendly" do
    url "https://files.pythonhosted.org/packages/cc/3f/2c29224acb2e2df4d2046e4c73ee2662023c58ff5b113c4c1adac0886c43/humanfriendly-10.0.tar.gz"
    sha256 "6b0b831ce8f15f7300721aa49829fc4e83921a9a301cc7f606be6686a2288ddc"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "isodate" do
    url "https://files.pythonhosted.org/packages/54/4d/e940025e2ce31a8ce1202635910747e5a87cc3a6a6bb2d00973375014749/isodate-0.7.2.tar.gz"
    sha256 "4cd1aa0f43ca76f4a6c6c0292a85f40b35ec2e43e315b59f06e6d32171a953e6"
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
    url "https://files.pythonhosted.org/packages/bf/ce/46fbd9c8119cfc3581ee5643ea49464d168028cfb5caff5fc0596d0cf914/jsonschema_specifications-2025.4.1.tar.gz"
    sha256 "630159c9f4dbea161a6a2205c3011cc4f18ff381b189fff48bb39b9bf26ae608"
  end

  resource "lazy-object-proxy" do
    url "https://files.pythonhosted.org/packages/08/a2/69df9c6ba6d316cfd81fe2381e464db3e6de5db45f8c43c6a23504abf8cb/lazy_object_proxy-1.12.0.tar.gz"
    sha256 "1f5a462d92fd0cfb82f1fab28b51bfb209fabbe6aabf7f0d51472c0c124c0c61"
  end

  resource "levenshtein" do
    url "https://files.pythonhosted.org/packages/7e/b3/b5f8011483ba9083a0bc74c4d58705e9cf465fbe55c948a1b1357d0a2aa8/levenshtein-0.27.1.tar.gz"
    sha256 "3e18b73564cfc846eec94dd13fab6cb006b5d2e0cc56bad1fd7d5585881302e3"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/8f/bd/f9d01fd4132d81c6f43ab01983caea69ec9614b913c290a26738431a015d/lxml-6.0.1.tar.gz"
    sha256 "2b3a882ebf27dd026df3801a87cf49ff791336e0f94b0fad195db77e01240690"
  end

  resource "lxml-html-clean" do
    url "https://files.pythonhosted.org/packages/79/b6/466e71db127950fb8d172026a8f0a9f0dc6f64c8e78e2ca79f252e5790b8/lxml_html_clean-0.4.2.tar.gz"
    sha256 "91291e7b5db95430abf461bc53440964d58e06cc468950f9e47db64976cebcb3"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/5b/f5/4ec618ed16cc4f8fb3b701563655a69816155e79e24a17b651541804721d/markdown_it_py-4.0.0.tar.gz"
    sha256 "cb0a2b4aa34f932c007117b194e945bd74e0ec24133ceb5bac59009cda1cb9f3"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b2/97/5d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62/markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "mcp" do
    url "https://files.pythonhosted.org/packages/66/3c/82c400c2d50afdac4fbefb5b4031fd327e2ad1f23ccef8eee13c5909aa48/mcp-1.13.1.tar.gz"
    sha256 "165306a8fd7991dc80334edd2de07798175a56461043b7ae907b279794a834c5"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "metapub" do
    url "https://files.pythonhosted.org/packages/9a/d8/46d5df44628c86153217b1ffd5b0e81993235e6b4cb39021f001c7c96da8/metapub-0.6.3.tar.gz"
    sha256 "341bf8cecaf28f02307fba2f0538d504f3d68cf4f94a2001127afcfb0014d8a4"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/ce/a0/834b0cebabbfc7e311f30b46c8188790a37f89fc8d756660346fe5abfd09/more_itertools-10.7.0.tar.gz"
    sha256 "9fddd5403be01a94b204faadcff459ec3568cf110265d3c54323e1e866ad29d3"
  end

  resource "openapi-core" do
    url "https://files.pythonhosted.org/packages/b1/35/1acaa5f2fcc6e54eded34a2ec74b479439c4e469fc4e8d0e803fda0234db/openapi_core-0.19.5.tar.gz"
    sha256 "421e753da56c391704454e66afe4803a290108590ac8fa6f4a4487f4ec11f2d3"
  end

  resource "openapi-pydantic" do
    url "https://files.pythonhosted.org/packages/02/2e/58d83848dd1a79cb92ed8e63f6ba901ca282c5f09d04af9423ec26c56fd7/openapi_pydantic-0.5.1.tar.gz"
    sha256 "ff6835af6bde7a459fb93eb93bb92b8749b754fc6e51b2f1590a19dc3005ee0d"
  end

  resource "openapi-schema-validator" do
    url "https://files.pythonhosted.org/packages/8b/f3/5507ad3325169347cd8ced61c232ff3df70e2b250c49f0fe140edb4973c6/openapi_schema_validator-0.6.3.tar.gz"
    sha256 "f37bace4fc2a5d96692f4f8b31dc0f8d7400fd04f3a937798eaf880d425de6ee"
  end

  resource "openapi-spec-validator" do
    url "https://files.pythonhosted.org/packages/82/af/fe2d7618d6eae6fb3a82766a44ed87cd8d6d82b4564ed1c7cfb0f6378e91/openapi_spec_validator-0.7.2.tar.gz"
    sha256 "cc029309b5c5dbc7859df0372d55e9d1ff43e96d678b9ba087f7c56fc586f734"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "parse" do
    url "https://files.pythonhosted.org/packages/4f/78/d9b09ba24bb36ef8b83b71be547e118d46214735b6dfb39e4bfde0e9b9dd/parse-1.20.2.tar.gz"
    sha256 "b41d604d16503c79d81af5165155c0b20f6c8d6c559efa66b4b695c3e5a0a0ce"
  end

  resource "pathable" do
    url "https://files.pythonhosted.org/packages/67/93/8f2c2075b180c12c1e9f6a09d1a985bc2036906b13dff1d8917e395f2048/pathable-0.4.4.tar.gz"
    sha256 "6905a3cd17804edfac7875b5f6c9142a218c7caef78693c2dbbbfbac186d88b2"
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

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/30/23/2f0a3efc4d6a32f3b63cdff36cd398d9701d26cda58e3ab97ac79fb5e60d/pyperclip-1.9.0.tar.gz"
    sha256 "b7de0142ddc81bfc5c7507eea19da920b92252b548b96186caf94a5e2527d310"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/f6/b0/4bc07ccd3572a2f9df7e6782f52b0c6c90dcbb803ac4a167702d7d0dfe1e/python_dotenv-1.1.1.tar.gz"
    sha256 "a8a6399716257f45be6a007360200409fce5cda2661e3dec71d23dc15f6189ab"
  end

  resource "python-levenshtein" do
    url "https://files.pythonhosted.org/packages/13/f6/d865a565b7eeef4b5f9a18accafb03d5730c712420fc84a3a40555f7ea6b/python_levenshtein-0.27.1.tar.gz"
    sha256 "3a5314a011016d373d309a68e875fd029caaa692ad3f32e78319299648045f11"
  end

  resource "python-multipart" do
    url "https://files.pythonhosted.org/packages/f3/87/f44d7c9f274c7ee665a29b885ec97089ec5dc034c7f3fafa03da9e39a09e/python_multipart-0.0.20.tar.gz"
    sha256 "8dd0cab45b8e23064ae09147625994d090fa46f5b0d1e13af944c331a7fa9d13"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/f8/bf/abbd3cdfb8fbc7fb3d4d38d320f2441b1e7cbe29be4f23797b4a2b5d8aac/pytz-2025.2.tar.gz"
    sha256 "360b9e3dbb49a209c21ad61809c7fb453643e048b38924c765813546746e81c3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "rapidfuzz" do
    url "https://files.pythonhosted.org/packages/ed/f6/6895abc3a3d056b9698da3199b04c0e56226d530ae44a470edabf8b664f0/rapidfuzz-3.13.0.tar.gz"
    sha256 "d2eaf3839e52cbcc0accbe9817a67b4b0fcf70aaeb229cfddc1c28061f9ce5d8"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/2f/db/98b5c277be99dd18bfd91dd04e1b759cad18d1a338188c936e92f921c7e2/referencing-0.36.2.tar.gz"
    sha256 "df2e89862cd09deabbdba16944cc3f10feb6b3e6f18e902f7cc25609a34775aa"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "rfc3339-validator" do
    url "https://files.pythonhosted.org/packages/28/ea/a9387748e2d111c3c2b275ba970b735e04e15cdb1eb30693b6b5708c4dbd/rfc3339_validator-0.1.4.tar.gz"
    sha256 "138a2abdf93304ad60530167e51d2dfb9549521a836871b88d7f4695d0022f6b"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/fe/75/af448d8e52bf1d8fa6a9d089ca6c07ff4453d86c65c145d0a300bb073b9b/rich-14.1.0.tar.gz"
    sha256 "e497a48b844b0320d45007cdebfeaeed8db2a4f4bcf49f15e455cfc4af11eaa8"
  end

  resource "rich-rst" do
    url "https://files.pythonhosted.org/packages/b0/69/5514c3a87b5f10f09a34bb011bc0927bc12c596c8dae5915604e71abc386/rich_rst-1.3.1.tar.gz"
    sha256 "fad46e3ba42785ea8c1785e2ceaa56e0ffa32dbe5410dec432f37e4107c4f383"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/1e/d9/991a0dee12d9fc53ed027e26a26a64b151d77252ac477e22666b9688bc16/rpds_py-0.27.0.tar.gz"
    sha256 "8b23cf252f180cda89220b378d917180f29d313cd6a07b2431c0d3b776aae86f"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
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
    url "https://files.pythonhosted.org/packages/42/6f/22ed6e33f8a9e76ca0a412405f31abb844b779d52c5f96660766edcd737c/sse_starlette-3.0.2.tar.gz"
    sha256 "ccd60b5765ebb3584d0de2d7a6e4f745672581de4f5005ab31c3a25d10b52b3a"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/15/b9/cc3017f9a9c9b6e27c5106cc10cc7904653c3eec0729793aec10479dd669/starlette-0.47.3.tar.gz"
    sha256 "6bc94f839cc176c4858894f1f8908f0ab79dfec1a6b8402f6da9be26ebea52e9"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/ec/fe/802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1/tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/a8/4b/29b4ef32e036bb34e4ab51796dd745cdba7ed47ad142a9f4a1eb8e0c744d/tqdm-4.67.1.tar.gz"
    sha256 "f8aef9c52c08c13a65f30ea34f4e5aac3fd1a34959879d7e59e63027286627f2"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "typing-inspection" do
    url "https://files.pythonhosted.org/packages/f8/b1/0c11f5058406b3af7609f121aaa6b609744687f1d158b3c3a5bf4cc94238/typing_inspection-0.4.1.tar.gz"
    sha256 "6ae134cc0203c33377d43188d4064e9b357dba58cff3185f22924610e70a9d28"
  end

  resource "unidecode" do
    url "https://files.pythonhosted.org/packages/94/7d/a8a765761bbc0c836e397a2e48d498305a865b70a8600fd7a942e85dcf63/Unidecode-1.4.0.tar.gz"
    sha256 "ce35985008338b676573023acc382d62c264f307c8f7963733405add37ea2b23"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/5e/42/e0e305207bb88c6b8d3061399c6a961ffe5fbb7e2aa63c9234df7259e9cd/uvicorn-0.35.0.tar.gz"
    sha256 "bc662f087f7cf2ce11a1d7fd70b90c9f98ef2e2831556dd078d131b96cc94a01"
  end

  resource "werkzeug" do
    url "https://files.pythonhosted.org/packages/32/af/d4502dc713b4ccea7175d764718d5183caf8d0867a4f0190d5d4a45cea49/werkzeug-3.1.1.tar.gz"
    sha256 "8cd39dfbdfc1e051965f156163e2974e52c210f130810e9ad36858f0fd3edad4"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["PUBMED_EMAIL"] = "test@example.com"
    ENV["PUBMED_API_KEY"] = "testkey"

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-06-18"}}
      {"jsonrpc":"2.0","method":"notifications/initialized","params":{}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list","params":{"cursor":null}}
    JSON

    output = pipe_output("#{bin}/mcp-simple-pubmed 2>&1", json, 0)
    assert_match "Search articles about medical and life sciences research available on PubMed", output
  end
end
