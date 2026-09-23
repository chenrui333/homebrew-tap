class FastAgentMcp < Formula
  include Language::Python::Virtualenv

  desc "Define, Prompt and Test MCP enabled Agents and Workflows"
  homepage "https://fast-agent.ai/"
  url "https://files.pythonhosted.org/packages/64/41/85ca1232111dec59a672310586eddc73a3f2ec1b8bd2c60fa98c76fe9e1b/fast_agent_mcp-0.10.30.tar.gz"
  sha256 "f82190d83b27b40347617077259b88a45e44d481957bd196a801253d53b303c8"
  license "Apache-2.0"
  head "https://github.com/evalstate/fast-agent.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "98a6b4a9f41ddcfff054917876ac41cda695ceb52581d1c81c367cafeac20c2e"
    sha256 cellar: :any, arm64_sequoia: "f20be70097b7d71648236cff1c58da9a36f4670a12c2c40a31c6455d7d84434e"
    sha256 cellar: :any, arm64_sonoma:  "808e13a179c0481e8f5a47029a207f5181cf2a87452460b92e7773366be71315"
    sha256 cellar: :any, arm64_linux:   "e41821d69d3c18b7705dbbd27293c15dbabcf6a84458cc68505caa9357f54403"
    sha256 cellar: :any, x86_64_linux:  "4ad8094b33955c8c76e2b9a34a247855a124eb1b1179f3496d37c25dc9664137"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "jpeg-turbo"
  depends_on "libyaml"
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.14"
  depends_on "rpds-py" => :no_linkage

  on_linux do
    depends_on "openssl@3"
    depends_on "zlib-ng-compat"
  end

  pypi_packages exclude_packages: %w[certifi cryptography pydantic pydantic-core rpds-py]

  resource "a2a-sdk" do
    url "https://files.pythonhosted.org/packages/5f/9d/a5bb9a22af70a7b66c1589568a77381ac842525bca13beb3d16803f61189/a2a_sdk-1.1.4.tar.gz"
    sha256 "a77d7234d25e4b480626c09580c8cf4967d6beb0433ae139ac0eb15055fef128"
  end

  resource "agent-client-protocol" do
    url "https://files.pythonhosted.org/packages/9d/95/2c28ca34e545ce0282e88272aa3a8abdf8f3f926a0492f567ea11acd071b/agent_client_protocol-0.12.1.tar.gz"
    sha256 "9963ccb590ed96d7dc542c9c023e90676fc76b1c6562e21a9ee112f4fbcb0095"
  end

  resource "aiofile" do
    url "https://files.pythonhosted.org/packages/14/31/edb06aabd8f8f0b56d659f30800795f40b93cba96be946ce179f6931e3a5/aiofile-3.12.3.tar.gz"
    sha256 "caa6aa746b5e47e2165f7abd741b6415e49cf4d44fddc0f61844612cc3924d41"
  end

  resource "aiohappyeyeballs" do
    url "https://files.pythonhosted.org/packages/ce/f4/eec0465c2f67b2664688d0240b3212d5196fd89e741df67ddb81f8d35658/aiohappyeyeballs-2.7.1.tar.gz"
    sha256 "065665c041c42a5938ed220bdcd7230f22527fbec085e1853d2402c8a3615d9d"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/58/d9/22ce5786ac0c1653ae8b6c23bded02c1686d11f0dbb45b31ce128e0df985/aiohttp-3.14.3.tar.gz"
    sha256 "9491196535a88924a60afd5b5f434b5b203b6cc616250878dbdb223a8f7844bc"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/61/62/06741b579156360248d1ec624842ad0edf697050bbaf7c3e46394e106ad1/aiosignal-1.4.0.tar.gz"
    sha256 "f47eecd9468083c2029cc99945502cb7708b082c232f9aca65da147157b251c7"
  end

  resource "annotated-doc" do
    url "https://files.pythonhosted.org/packages/5a/8e/38aa427ed5402449e226975b649c5dc73ccadfefeb95e6aecb8f8ea4b6b6/annotated_doc-0.0.5.tar.gz"
    sha256 "c7e58ce09192557605d8bbd92836d7e1d520ac9580096042c0bfd197efacf1bb"
  end

  resource "anthropic" do
    url "https://files.pythonhosted.org/packages/a4/8b/4210dd090000ba35d07cee9105530794911d955788c3992b4882df49eaac/anthropic-1.7.0.tar.gz"
    sha256 "0ab1b04668606ba1ae93f6d9e8dcc2e0c4f0debebd4eea4773a3a595f0836db1"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/a9/d2/f4d173e22df740bc37b1db102b386ba719b66e95b0f0d751f556b387e6d2/anyio-4.15.1.tar.gz"
    sha256 "9f28306018cbd6d329e64a36d58256edff76dd996fe423bc957326e578b82a94"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "authlib" do
    url "https://files.pythonhosted.org/packages/f1/51/bc1729d3cfdc214b4935f4e886e4dd443c3065fd8e1e66423fe84b490f81/authlib-1.8.0.tar.gz"
    sha256 "f3ecd5f1da737262fb53bf1a4d95c4ea1ad9dd509316587a255c99ab1838a4f0"
  end

  resource "beartype" do
    url "https://files.pythonhosted.org/packages/c7/94/1009e248bbfbab11397abca7193bea6626806be9a327d399810d523a07cb/beartype-0.22.9.tar.gz"
    sha256 "8f82b54aa723a2848a56008d18875f91c1db02c32ef6a62319a002e3e25a975f"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/29/2c/3f18755527b03ca9ff6be724bd5370cb777c76a87f17301377cf04a4729b/cachetools-7.2.0.tar.gz"
    sha256 "bcac1a1b8da6909994a2957238a57b8140dab7c5c5c69a43669654fe87a33c1d"
  end

  resource "caio" do
    url "https://files.pythonhosted.org/packages/d2/c9/ac301b7f86ccf6ad02ee78eb953ce8f75175754cc5e76d398e447af42e3e/caio-0.12.4.tar.gz"
    sha256 "32d8e9f3e2099c8db29446679252766c9bcd806eb88b4fb60ad274f73df2a5e9"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e5/3f/143b048436775b0f76ac3eec145c019e8173ccc2885c8f20319b996d5e83/charset_normalizer-3.5.1.tar.gz"
    sha256 "6117b84ea48435e5356dc737f5121485c30920ba43375fa7b434fd753df0eac3"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/c7/0e/7fa0ef50764b67090eca4114772a2abf8b6148198475e54c660b97caeee6/click-8.5.0.tar.gz"
    sha256 "ba0d2089de75ea0310e2dde03160e6ca10009947fb95a182f9b54021bb272e34"
  end

  resource "cyclopts" do
    url "https://files.pythonhosted.org/packages/c1/08/a444f3cca86cb27bc256831fc8c42b578390f4087bf6631cccb5334bd9ed/cyclopts-4.25.3.tar.gz"
    sha256 "7d3a067bc7699a1a65fe2ea0b092a925855bb711a05adc1e65c5b9ba307acea4"
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
    url "https://files.pythonhosted.org/packages/e0/4d/f332313098c1de1b2d2ff91cf2674415cc7cddab2ca1b01ae29774bd5fdf/docstring_parser-0.18.0.tar.gz"
    sha256 "292510982205c12b1248696f44959db3cdd1740237a968ea1e2e7a900eeb2015"
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
    url "https://files.pythonhosted.org/packages/8a/02/91e3416a8fdd715abb903a952a6bec7cdd8d14eed55d415fc8595524c319/fastapi-0.141.1.tar.gz"
    sha256 "e8822fc40db1e1858054d7a949a888695bc9bdce70139178e33bd2871a453ca1"
  end

  resource "fastmcp-slim" do
    url "https://files.pythonhosted.org/packages/7f/78/fa6a58bfc3d2b218f591f8e8c261639dd6fc56e2d6a70be0d1c42244ffa0/fastmcp_slim-4.0.5.tar.gz"
    sha256 "5dc5395bcacb0eb405787393298891210c821d3f66334c2695e5e435d88fe575"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/1f/f9/f38573ed5844586db374d085911740a501ccfa373b455fc9413f09f85237/filelock-3.29.1.tar.gz"
    sha256 "d97e6b1b9757569626c58caa07dc4beb1613f4a2938b1e8cc81afca398906c9e"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/2d/f5/c831fac6cc817d26fd54c7eaccd04ef7e0288806943f7cc5bbf69f3ac1f0/frozenlist-1.8.0.tar.gz"
    sha256 "3ede829ed8d842f6cd48fc7081d7a41001a56f1f38603f9d49bf3020d59a31ad"
  end

  resource "fsspec" do
    url "https://files.pythonhosted.org/packages/77/cd/9be253869fc42e764de7f3dedd6969af7d44ff9c3375214a3442a6f3fc08/fsspec-2026.9.0.tar.gz"
    sha256 "0f08147951c8cb31d844c3547d631053b127863b60be04cf06e121333ee0e2fe"
  end

  resource "google-api-core" do
    url "https://files.pythonhosted.org/packages/59/e5/18aeff14213db86267a0f79d869352954394ab4ab3a3866d9b9b0e82dc6a/google_api_core-2.38.0.tar.gz"
    sha256 "31e326eafa31b34f1db7a715f50f61dbca7e6e37277762f252ed90e6ce94c246"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/ac/ca/f398a483ce5aad18ca2f735646e45ccee2439bd94a41a4ad0cfa646bd495/google_auth-2.58.0.tar.gz"
    sha256 "55e30cf15e737de92c5323d78cda8a83fcd57e7ffbaf900c4600039fd60a80fd"
  end

  resource "google-genai" do
    url "https://files.pythonhosted.org/packages/35/26/176d04f442e82d60cadc74cfaf81f01017062ce274a790455a57aec48c8f/google_genai-2.24.0.tar.gz"
    sha256 "814b63d05dca4776c5a322699eb30c565040cf8d5fd77c38714076535fb2e019"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/8a/c5/4353a188e2c335aee33269e8b654af228278cca8e5f0b4b5f11e5d0e9adb/googleapis_common_protos-1.75.3.tar.gz"
    sha256 "57c435ac2c68b108999b6db075d9053e4d7a936ba57b4a3d45667b1346f1738a"
  end

  resource "griffelib" do
    url "https://files.pythonhosted.org/packages/27/af/018c10bc9edd42b6ef6db2e96b09542050d5253f9b195e74bc910b2d13ab/griffelib-2.3.0.tar.gz"
    sha256 "7b0952caf5bca6afa4bb5ee8c6a2d183fe3f21b62efc5f6c7243cb2b26d2d115"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "hf-xet" do
    url "https://files.pythonhosted.org/packages/1b/ab/522a2ab67f27971a9d48ca666d4fca85ef7d5282d142e31fd087e27b1bbe/hf_xet-1.6.0.tar.gz"
    sha256 "2e58454a340b3556dfa4972d5451aff4fba8dd42a236600ba1a1d2b1514f0fef"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/06/94/82699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cb/httpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httpcore2" do
    url "https://files.pythonhosted.org/packages/15/8c/e925b1c92018abb3a1863ce1549d76d2381e334d21d65d4ac8f65dabd78a/httpcore2-2.13.0.tar.gz"
    sha256 "2adc8be4fb285fbcd6d894298db3b52c177e74b6674eda3a76bd36be3292a3db"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "httpx2" do
    url "https://files.pythonhosted.org/packages/b9/a0/e9deef4654132857b5a5dbe4eddd0ac59c2814500e11f2f5044cd81103ee/httpx2-2.13.0.tar.gz"
    sha256 "81bd07dc67a3701729ef1f777a3c00c915d4539604fdb5afd327f8682f6b7b44"
  end

  resource "huggingface-hub" do
    url "https://files.pythonhosted.org/packages/fe/0f/e83fdd856da8fca26bf78d71709ebd120432a0ce535e72b9597cab1eb5bf/huggingface_hub-1.32.0.tar.gz"
    sha256 "ed70a45498abe86039df7c2f4e5f7575de524be908d3840e8f828d5525eafd6a"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
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

  resource "jiter" do
    url "https://files.pythonhosted.org/packages/9c/1f/8176d92e001f86505424b41664032ae26a882bc9ca41a32c803f373f9195/jiter-0.17.0.tar.gz"
    sha256 "03e432f226a453851079fb84cd17c6da9991eab723e28d716f14ae3d906e0c12"
  end

  resource "joserfc" do
    url "https://files.pythonhosted.org/packages/19/94/80fea1514b7c6d7d37804d3fe9ca81455f633347fc98731bd71ffe1faa17/joserfc-1.7.5.tar.gz"
    sha256 "d5ff536e658e17664f8c1b1ab60dc4aa62aa973fcef1edd33cc44bda45d6f5ea"
  end

  resource "json-rpc" do
    url "https://files.pythonhosted.org/packages/6d/9e/59f4a5b7855ced7346ebf40a2e9a8942863f644378d956f68bcef2c88b90/json-rpc-1.15.0.tar.gz"
    sha256 "e6441d56c1dcd54241c937d0a2dcd193bdf0bdc539b5316524713f554b7f85b9"
  end

  resource "jsonref" do
    url "https://files.pythonhosted.org/packages/aa/0d/c1f3277e90ccdb50d33ed5ba1ec5b3f0a242ed8c1b1a85d3afeb68464dca/jsonref-1.1.0.tar.gz"
    sha256 "32fe8e1d85af0fdefbebce950af85590b22b60f9e95443176adbde4e1ecea552"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/b3/fc/e067678238fa451312d4c62bf6e6cf5ec56375422aee02f9cb5f909b3047/jsonschema-4.26.0.tar.gz"
    sha256 "0c26707e2efad8aa1bfc5b7ce170f3fccc2e4918ff85989ba9ffa9facb2be326"
  end

  resource "jsonschema-path" do
    url "https://files.pythonhosted.org/packages/39/79/cd02a4df6d9270efdc7d3feefe6edd730b0820c39eeaa107a2faee8322d5/jsonschema_path-0.5.0.tar.gz"
    sha256 "493b156ba895c97602655b620a8456caa2ce08c1aa389f5a7addec065e6e855c"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/19/74/a633ee74eb36c44aa6d1095e7cc5569bebf04342ee146178e2d36600708b/jsonschema_specifications-2025.9.1.tar.gz"
    sha256 "b540987f239e745613c7a9176f3edb72b832a4ac465cf02712288397832b5e8d"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/43/4b/674af6ef2f97d56f0ab5153bf0bfa28ccb6c3ed4d1babf4305449668807b/keyring-25.7.0.tar.gz"
    sha256 "fe01bd85eb3f8fb3dd0405defdeac9a5b4f6f0439edbb3149577f244a2e8245b"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "mcp" do
    url "https://files.pythonhosted.org/packages/76/31/ac54fb0fdd5b37de704486e288bba4fbbb463f24cfcfedbede407b854513/mcp-2.2.0.tar.gz"
    sha256 "2dc37ecb1974becdcebdbf7561e7c15a07dbbf20ba21ba16c3593b3038b3afbd"
  end

  resource "mcp-types" do
    url "https://files.pythonhosted.org/packages/ae/91/762d7755d971aff8a28d75f7961656148edf27875c8026e6385aaab08ae7/mcp_types-2.2.0.tar.gz"
    sha256 "d3ed53703ddd10d9c6399f29d322bb66f3f67ab41348ac8556ba23e07fedefad"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/de/1d/f4da6f02cdffe04d6362210b807146a26044c88d839208aec273bb0d9184/more_itertools-11.1.0.tar.gz"
    sha256 "48e8f4d9e7e5878571ecf6f2b4e57634f93cd474cc8cfbd2376f2d11b396e30d"
  end

  resource "mslex" do
    url "https://files.pythonhosted.org/packages/e0/97/7022667073c99a0fe028f2e34b9bf76b49a611afd21b02527fbfd92d4cd5/mslex-1.3.0.tar.gz"
    sha256 "641c887d1d3db610eee2af37a8e5abda3f70b3006cdfd2d0d29dc0d1ae28a85d"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/d6/99/1d4d69c3512d0ddbfa3a1b69cfd9a151012ab2eb4eabbb096201b1f0b7d8/multidict-6.9.1.tar.gz"
    sha256 "0f06e60fa190aa7abd0914c2a766736fdc8e9f34878c4346338534b73d1b20e2"
  end

  resource "openai" do
    url "https://files.pythonhosted.org/packages/e2/c6/770171ef28854d8092ee2c3df68ef97d127362b28771e6b423c948894e07/openai-3.16.2.tar.gz"
    sha256 "e129455fc6a744276cda63a9e2f0759207bc0cf24afc4cf356bf5029e631e955"
  end

  resource "openapi-pydantic" do
    url "https://files.pythonhosted.org/packages/02/2e/58d83848dd1a79cb92ed8e63f6ba901ca282c5f09d04af9423ec26c56fd7/openapi_pydantic-0.5.1.tar.gz"
    sha256 "ff6835af6bde7a459fb93eb93bb92b8749b754fc6e51b2f1590a19dc3005ee0d"
  end

  resource "opentelemetry-api" do
    url "https://files.pythonhosted.org/packages/ee/8b/aa9e2d8b8dfa7c946f7dec5d1f8f6ba8eca062f43509a06bdb5ce93d26c0/opentelemetry_api-1.44.0.tar.gz"
    sha256 "67647e5e9566edcf421166fdf022b3537f818635daa852b289e34604dc6fb33a"
  end

  resource "opentelemetry-exporter-otlp-proto-common" do
    url "https://files.pythonhosted.org/packages/61/09/4d717852c1cf3f854b76c7110a5d00883bc3c99288b9b0dbcbeb9e306eb6/opentelemetry_exporter_otlp_proto_common-1.44.0.tar.gz"
    sha256 "dc87a5a5bc58f149a56d1547e4691588fa12994cdc3bc039a694ccb3375862ac"
  end

  resource "opentelemetry-exporter-otlp-proto-http" do
    url "https://files.pythonhosted.org/packages/1a/87/95e2a5aaa795b4e2260d74e16df2d5541deb2ea9de010bcd615f4dee2654/opentelemetry_exporter_otlp_proto_http-1.44.0.tar.gz"
    sha256 "c633d7270ad6b57cd4cfbe8b0007a9e2e7c0cb50bd6c50fe2a7b245f721a09d8"
  end

  resource "opentelemetry-instrumentation" do
    url "https://files.pythonhosted.org/packages/13/91/3c58961cb0360cd60509064734f0be4275383c8681d73c580a40ca83ddce/opentelemetry_instrumentation-0.65b0.tar.gz"
    sha256 "071d9d9eced9bd6460444ec3b0c77229870ed05a881c22c84fdede58e4eed09b"
  end

  resource "opentelemetry-instrumentation-anthropic" do
    url "https://files.pythonhosted.org/packages/16/12/4a8a051db553f840eceddb0ab0c5a1fc5c632d0013c24068aa74e7dfb3d9/opentelemetry_instrumentation_anthropic-0.62.3.tar.gz"
    sha256 "54246ab1208aa33e1dd79d4aff1621e73ebc14cd98762798af029e1fc53c0266"
  end

  resource "opentelemetry-instrumentation-google-genai" do
    url "https://files.pythonhosted.org/packages/6e/bf/fd8983789e4c689f5ac8a8f48ebdbc85b5e9babffa10fc3b58f5c65d9c9a/opentelemetry_instrumentation_google_genai-1.1b1.tar.gz"
    sha256 "c670f7f263d59b2d45ec1ee1e9126b7e3e67f2946fa89af89c6cc3041c778b13"
  end

  resource "opentelemetry-instrumentation-openai" do
    url "https://files.pythonhosted.org/packages/17/91/92764e1a330cf27ed29e330c5d6df394bb0ea52374e07648b07352d5bc62/opentelemetry_instrumentation_openai-0.62.3.tar.gz"
    sha256 "b9e1b9a1e6c48cdd436cfaa6fb9af1b393e806debbafd408f4b5232f9ec4df12"
  end

  resource "opentelemetry-proto" do
    url "https://files.pythonhosted.org/packages/64/01/40ac4ae9a149263cc52c2cee200ddd80cb6d8db1a4610abf8eabce0fe771/opentelemetry_proto-1.44.0.tar.gz"
    sha256 "c547a79c2f8c0c515d31509154682e5921c7cfd5ca67b70e1f9266e2c3e103f3"
  end

  resource "opentelemetry-sdk" do
    url "https://files.pythonhosted.org/packages/5d/77/a6592cbc7c8d9bcc9d6757a9df45e04a7c585e3e6e7a13456da522b21109/opentelemetry_sdk-1.44.0.tar.gz"
    sha256 "cebe7f65dc12f26ead75c6064de12fd2a9052e5060c0272d402cfa203aae123b"
  end

  resource "opentelemetry-semantic-conventions" do
    url "https://files.pythonhosted.org/packages/8f/73/0cbdebcb4cf545fdd328da14f5137e37d0770c3f26185e478b0d15d94f50/opentelemetry_semantic_conventions-0.65b0.tar.gz"
    sha256 "f9b2b81e9d5b64f11bc952075e7e9c7fb0aab075c7fd1c46d597f1b919852d60"
  end

  resource "opentelemetry-semantic-conventions-ai" do
    url "https://files.pythonhosted.org/packages/24/02/10aeacc37a38a3a8fa16ff67bec1ae3bf882539f6f9efb0f70acf802ca2d/opentelemetry_semantic_conventions_ai-0.5.1.tar.gz"
    sha256 "153906200d8c1d2f8e09bd78dbef526916023de85ac3dab35912bfafb69ff04c"
  end

  resource "opentelemetry-util-genai" do
    url "https://files.pythonhosted.org/packages/50/1a/2bd5102d38409cf6db92ff0120e035cf971f819a43132887286402420c01/opentelemetry_util_genai-1.1b0.tar.gz"
    sha256 "079c6118dbca9a6f667913ac5f1f4a8477a94e17f30d198a0988d1d52dd6ff10"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "pathable" do
    url "https://files.pythonhosted.org/packages/66/f3/5a20387de9bcd0607871bfc2198ee0e15836da7baa4592ccd7f24c27c986/pathable-0.6.0.tar.gz"
    sha256 "6404b8b82aef5ff0fd478934137128b99b12212ba35afdde5525ca4f8388ea58"
  end

  resource "pillow" do
    url "https://files.pythonhosted.org/packages/1c/3d/bb7fca845737cf9d7dbde16ed1843984665ff2e0a518f5db43e77ec540b9/pillow-12.3.0.tar.gz"
    sha256 "3b8182a766685eaa002637e28b4ec8d6b18819a0c71f579bf0dbaa5830297cce"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/ea/dd/65804b0c2925a1c821a05502ea57517b69a073ff400d25ab9faa3a2cf012/platformdirs-4.11.12.tar.gz"
    sha256 "e8dc1cb58f1153fd7f61db1374317770baababec2480b37b8f01c6cc25b45267"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/7d/ea/39b988c938f75cb75d7045b5c69f8bfed47ee2152c8837fb403de29d6fb8/prompt_toolkit-3.0.53.tar.gz"
    sha256 "9ec8a0ad96d5c56148b3f914aa79c1564c3fde5d2e6b876e7bc327e353cf8fa6"
  end

  resource "propcache" do
    url "https://files.pythonhosted.org/packages/b3/9a/9fbf4e4ec0c2d7f1c32519fff782ef467859b8faa9fbc5331a96f6395d43/propcache-0.5.4.tar.gz"
    sha256 "ff6b113f50bc066a698db5d944d2c6dc7507168dd3341e255a8892fd0715a558"
  end

  resource "proto-plus" do
    url "https://files.pythonhosted.org/packages/40/a6/4fbadcc2044034449b3f8f0ce82dcf3005d53f37c136642103fd4836a31c/proto_plus-1.28.4.tar.gz"
    sha256 "5ff7ecad828e032a491fcb86947801768e32237f99dd049b649965b892ae9a63"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/66/70/e908e9c5e52ef7c3a6c7902c9dfbb34c7e29c25d2f81ade3856445fd5c94/protobuf-6.33.6.tar.gz"
    sha256 "a6768d25248312c297558af96a9f9c929e8c4cee0659cb07e780731095f38135"
  end

  resource "py-key-value-aio" do
    url "https://files.pythonhosted.org/packages/ca/99/c346e3474853801ec5ecf4c3ee60cfc6060327ebc31424df4e346620dde4/py_key_value_aio-0.4.6.tar.gz"
    sha256 "267c03c3e24cb99d3097612f8a5cfd8e11785c6a2975e272db0e303ea1850bfd"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/a4/9a/23310166d960def5897e91fe20e5b724601b02a22e84ba1f94232c0b7f67/pyasn1-0.6.4.tar.gz"
    sha256 "9c447d8431c947fe4c8febc4ed9e760bc29011a5b01e5c74b67025bd9fb8ce81"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/e9/e6/78ebbb10a8c8e4b61a59249394a4a594c1a7af95593dc933a349c8d00964/pyasn1_modules-0.4.2.tar.gz"
    sha256 "677091de870a80aae844b1ca6134f54652fa2c8c5a52aa396440ac3106e941e6"
  end

  resource "pydantic-settings" do
    url "https://files.pythonhosted.org/packages/68/ca/31c57507b13119d7d3cfa1576dad2911a4861e3be07b579395f4e9d393f9/pydantic_settings-2.15.0.tar.gz"
    sha256 "694b793e84f766ba76a90ebdefc01d0a9a045dab0382bee70393da93712ad117"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/af/c3/8a3b59c25070cc61dc517fbdfa5dc0904670c96f605cc69759dc09166b99/pyjwt-2.14.0.tar.gz"
    sha256 "77283c83fb56ecf566a886c757a714bc83668e38156de2cce8263302f42e0b86"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/e8/52/d87eba7cb129b81563019d1679026e7a112ef76855d6159d24754dbd2a51/pyperclip-1.11.0.tar.gz"
    sha256 "244035963e4428530d9e3a6101a1ef97209c6825edab1567beac148ccc1db1b6"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/6a/53/ed9d74092561d4b01a2ef1349d52cdbc135e526c245f366b089cfca6de49/python_dotenv-1.2.3.tar.gz"
    sha256 "a20a594dabeaa385725aa239d5244871c143ecb356add8a20fcf23773a6c3a35"
  end

  resource "python-frontmatter" do
    url "https://files.pythonhosted.org/packages/9d/e8/79cbe69864d44f3b48e70ebee0a872a7d5a4e7150c9f8577ed7a5beefff0/python_frontmatter-1.3.0.tar.gz"
    sha256 "acc73e477a568dc2a25c9e130c6c68ae8daa8c204c8f7e813db47d6a7280dcf2"
  end

  resource "python-multipart" do
    url "https://files.pythonhosted.org/packages/5b/42/55c32bb9b12693c092ad250a0e82edb5b31ddeda6eb772de5f308b3804ad/python_multipart-0.0.32.tar.gz"
    sha256 "be54b7f3fa167bb83e4fcd936b887b708f4e57fe75911c02aebf53efaf8d938e"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/22/f5/df4e9027acead3ecc63e50fe1e36aca1523e1719559c499951bb4b53188f/referencing-0.37.0.tar.gz"
    sha256 "44aefc3142c5b842538163acb373e24cce6632bd54bdb01b21ad5863489f50d8"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/b9/5c/f403115361de25809e8f785686ec7096e30fef73be9ae35aa51da4e80abb/regex-2026.9.10.tar.gz"
    sha256 "1e321e2c84f0e52c457f5ea5944f796d6e8e09cb99738ea98dcc1bfe402a128d"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "rich-rst" do
    url "https://files.pythonhosted.org/packages/e2/d6/d0b9fafc73b65767200da027acab1db1bdb1048f4fea5ebf659df01c700e/rich_rst-2.1.0.tar.gz"
    sha256 "f4d117b49697f338769759fa5cacf5197da4888b347b9fda2e50aef5cd8d93bd"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/c7/3b/ebda527b56beb90cb7652cb1c7e4f91f48649fbcd8d2eb2fb6e77cd3329b/ruamel_yaml-0.19.1.tar.gz"
    sha256 "53eb66cd27849eff968ebf8f0bf61f46cdac2da1d1f3576dd4ccee9b25c31993"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/58/15/8b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58e/shellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "sse-starlette" do
    url "https://files.pythonhosted.org/packages/2b/54/6767bb789b2f2fed6e0f953df949cd39dc263a384c1b65a95232598621d6/sse_starlette-3.4.11.tar.gz"
    sha256 "1bae716c02f3e6f294be41ff333220692dae7c3cbab077c900f159676719dade"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/b5/b4/205b0d5241d934e8add0c38aa924c4f9fb7330834ff11e5444db964ec3f9/starlette-1.6.0.tar.gz"
    sha256 "d4e3ac5e546444960c710297a3c9fc3f7ebae1b7e963f3d36173b49da535be9b"
  end

  resource "tenacity" do
    url "https://files.pythonhosted.org/packages/47/c6/ee486fd809e357697ee8a44d3d69222b344920433d3b6666ccd9b374630c/tenacity-9.1.4.tar.gz"
    sha256 "adb31d4c263f2bd041081ab33b498309a57c77f9acf2db65aadf0898179cf93a"
  end

  resource "textual-image" do
    url "https://files.pythonhosted.org/packages/7d/3f/2cb7f2ca8bcc2d16b207e1c986a26df1dd67695d9f72b17e1a076d0728d0/textual_image-0.14.0.tar.gz"
    sha256 "230e2c38738a3d96ca3bcf99c6680b898917003bb21bd5fa7e22cbb16e843235"
  end

  resource "tiktoken" do
    url "https://files.pythonhosted.org/packages/66/62/167a842aa0429d45f5e797354fd4343a96f6043d67d0513c675c7b8d36e6/tiktoken-0.14.0.tar.gz"
    sha256 "231dec90efcdccf1b565a1416107736f1e09b1a08fe736ef9d6363e626d03874"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/0d/ea/b2a5bd54b28a324dae8211928b2d730b6547500342c7e6c6dea08bd0a485/tqdm-4.70.1.tar.gz"
    sha256 "cefd0eca11b2a37a3aee776544d4f4ae913f02688135b5556b8788dfa474afc4"
  end

  resource "truststore" do
    url "https://files.pythonhosted.org/packages/53/a3/1585216310e344e8102c22482f6060c7a6ea0322b63e026372e6dcefcfd6/truststore-0.10.4.tar.gz"
    sha256 "9d91bd436463ad5e4ee4aba766628dd6cd7010cf3e2461756b3303710eebc301"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/16/f7/57713ba479fd405eb76de31404b2c744c289e336b2d999511ebf51e496f7/typer-0.27.2.tar.gz"
    sha256 "269b7eb9d3c202ca84b4bc9618cb04ebb43d3d4d1e567e4c768607232c05f945"
  end

  resource "uncalled-for" do
    url "https://files.pythonhosted.org/packages/6b/5a/92ce0b3ea5481915f55da994c2c2c5f7a3c09949afde196ee89f8ab961aa/uncalled_for-0.4.0.tar.gz"
    sha256 "335b95bd2422332ec210d518f314a16e4c640921c39fc8bf2ad095bd3538f4af"
  end

  resource "uritemplate" do
    url "https://files.pythonhosted.org/packages/98/60/f174043244c5306c9988380d2cb10009f91563fc4b31293d27e17201af56/uritemplate-4.2.0.tar.gz"
    sha256 "480c2ed180878955863323eea31b0ede668795de182617fef9c6ca09e6ec9d0e"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/5d/ad/04bbb797c84fc1f26cb171f7394716f4865ffb8d8c5e1eef42565c2dfa6b/uvicorn-0.53.0.tar.gz"
    sha256 "a9356f0cb89b3b8621529c5d5eebd69bfe154f4c3f68b4cf2de47e45fa855c2e"
  end

  resource "uvloop" do
    url "https://files.pythonhosted.org/packages/06/f0/18d39dbd1971d6d62c4629cc7fa67f74821b0dc1f5a77af43719de7936a7/uvloop-0.22.1.tar.gz"
    sha256 "6c84bae345b9147082b17371e3dd5d42775bddce91f885499017f4607fdaf39f"
  end

  resource "watchfiles" do
    url "https://files.pythonhosted.org/packages/cd/41/5e1a4bb12aac5f1493fa1bdc11154eca3b258ca4eba65d39c473fe19d8e9/watchfiles-1.2.0.tar.gz"
    sha256 "c995fba777f1ea992f090f9236e9284cf7a5d1a0130dd5a3d82c598cacd76838"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/3d/7a/f98d4ada7c499565ab0c0fcef28a4e54fafa72b8228a6309803c80493c92/wcwidth-0.8.4.tar.gz"
    sha256 "2dae09efa25253ae2874188e86d6861af3b1652aef4118cdf3f0bda288a957fb"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/21/e6/26d09fab466b7ca9c7737474c52be4f76a40301b08362eb2dbc19dcc16c1/websockets-15.0.1.tar.gz"
    sha256 "82544de02076bafba038ce055ee6412d68da13ab47f0c60cab827346de828dee"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/42/a6/6375d56c44d590ef24acf0f8f5bf7ed768ff7a510b959306ec412611e90f/wrapt-2.4.1.tar.gz"
    sha256 "fd6390aab9e8aa40c52eff3c180f098e8d9f5894b1fd4c4fd2c207067b33ed16"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/75/16/e8be8e2fb175bbf41a0680381a319f1199fae256588241a2ac8677eafb49/yarl-1.25.1.tar.gz"
    sha256 "03dd38de09bc213e9a8b29761eec33ee1d5318dac0e49d8af36e4d27830e23a7"
  end

  def install
    ENV.O0

    venv = virtualenv_install_with_resources(without: "hf-xet")

    resource("hf-xet").stage do
      # Use native-tls since building bundled aws-lc is tricky to do indirectly within superenv.
      inreplace "xet_client/Cargo.toml", 'default = ["rustls-tls"]', 'default = ["native-tls"]'

      venv.pip_install Pathname.pwd
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fast-agent --version")

    output = pipe_output("#{bin}/fast-agent scaffold --config-dir #{testpath}", "\n")
    assert_match "Scaffold completed successfully", output
    assert_path_exists testpath/"agent.py"
  end
end
