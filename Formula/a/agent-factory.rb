class AgentFactory < Formula
  include Language::Python::Virtualenv

  desc "Generate agents by simply describing your task in natural language"
  homepage "https://github.com/mozilla-ai/agent-factory"
  url "https://github.com/mozilla-ai/agent-factory/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "001e3e0c8a61b47990b253babedf8e01692c138f52acf8256af79ef746ed82b0"
  license "Apache-2.0"

  depends_on "rust" => :build # for pydantic
  depends_on "certifi"
  depends_on "geos" # for shapely
  depends_on "libyaml"
  depends_on "numpy" # for shapely
  depends_on "numpy"
  depends_on "pillow"
  depends_on "python@3.13"

  on_linux do
    depends_on "patchelf" => :build # for shapely
  end

  resource "a2a-sdk" do
    url "https://files.pythonhosted.org/packages/1b/43/57b3f7b45cc19dc52fcae2b9b59a8d7acabe933ae48a8fcf261cd6ff75ae/a2a_sdk-0.3.2.tar.gz"
    sha256 "b18dcee03678ba6d881a20e0bf1312ad34833a81bed9b060813ee254227e69a4"
  end

  resource "absolufy-imports" do
    url "https://files.pythonhosted.org/packages/74/0f/9da9dc9a12ebf4622ec96d9338d221e0172699e7574929f65ec8fdb30f9c/absolufy_imports-0.3.1.tar.gz"
    sha256 "c90638a6c0b66826d1fb4880ddc20ef7701af34192c94faf40b95d32b59f9793"
  end

  resource "agno" do
    url "https://files.pythonhosted.org/packages/8c/52/7afcebfe54c41b254c6b70cebf518836823d4e88640e59101eeb1975f0ae/agno-1.8.0.tar.gz"
    sha256 "53682e35da6e9babed8eb7db04e4295aaf41f92057fbb20311ba460a66884370"
  end

  resource "aiohappyeyeballs" do
    url "https://files.pythonhosted.org/packages/26/30/f84a107a9c4331c14b2b586036f40965c128aa4fee4dda5d3d51cb14ad54/aiohappyeyeballs-2.6.1.tar.gz"
    sha256 "c3f9d0113123803ccadfdf3f0faa505bc78e6a72d1cc4806cbd719826e943558"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/9b/e7/d92a237d8802ca88483906c388f7c201bbe96cd80a165ffd0ac2f6a8d59f/aiohttp-3.12.15.tar.gz"
    sha256 "4fc61385e9c98d72fcdf47e6dd81833f47b2f77c114c29cd64a361be57a763a2"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/61/62/06741b579156360248d1ec624842ad0edf697050bbaf7c3e46394e106ad1/aiosignal-1.4.0.tar.gz"
    sha256 "f47eecd9468083c2029cc99945502cb7708b082c232f9aca65da147157b251c7"
  end

  resource "aiosqlite" do
    url "https://files.pythonhosted.org/packages/13/7d/8bca2bf9a247c2c5dfeec1d7a5f40db6518f88d314b8bca9da29670d2671/aiosqlite-0.21.0.tar.gz"
    sha256 "131bb8056daa3bc875608c631c678cda73922a2d4ba8aec373b19f18c17e7aa3"
  end

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/ee/67/531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5/annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "any-agent" do
    url "https://files.pythonhosted.org/packages/f9/52/dc511eb67c02fa8bf6880d2d35b928c99c2b3c7ba154a41e85849ab37e25/any_agent-1.2.0.tar.gz"
    sha256 "43ef36e1800d59bda5ebc357cfcefd3fc6c4446cf32bffcd75a3e70cd05b6452"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/f1/b4/636b3b65173d3ce9a38ef5f0522789614e590dab6a8d505340a4efe4c567/anyio-4.10.0.tar.gz"
    sha256 "3f3fae35c96039744587aa5b8371e7e8e603c0702999535961dd336026973ba6"
  end

  resource "asgiref" do
    url "https://files.pythonhosted.org/packages/90/61/0aa957eec22ff70b830b22ff91f825e70e1ef732c06666a805730f28b36b/asgiref-3.9.1.tar.gz"
    sha256 "a5ab6582236218e5ef1648f242fd9f10626cfd4de8dc377db215d5d5098e3142"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/5a/b0/1367933a8532ee6ff8d63537de4f1177af4bff9f3e829baf7331f595bb24/attrs-25.3.0.tar.gz"
    sha256 "75d7cefc7fb576747b2c81b4442d4d4a1ce0900973527c011d1030fd3bf4af1b"
  end

  resource "authlib" do
    url "https://files.pythonhosted.org/packages/8a/95/e4f4ab5ce465821fe2229e10985ab80462941fe5d96387ae76bafd36f0ba/authlib-1.6.2.tar.gz"
    sha256 "3bde83ac0392683eeef589cd5ab97e63cbe859e552dd75dca010548e79202cb1"
  end

  resource "autoflake" do
    url "https://files.pythonhosted.org/packages/2a/cb/486f912d6171bc5748c311a2984a301f4e2d054833a1da78485866c71522/autoflake-2.3.1.tar.gz"
    sha256 "c98b75dc5b0a86459c4f01a1d32ac7eb4338ec4317a4469515ff1e687ecd909e"
  end

  resource "banks" do
    url "https://files.pythonhosted.org/packages/7d/f8/25ef24814f77f3fd7f0fd3bd1ef3749e38a9dbd23502fbb53034de49900c/banks-2.2.0.tar.gz"
    sha256 "d1446280ce6e00301e3e952dd754fd8cee23ff277d29ed160994a84d0d7ffe62"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/85/2e/3e5079847e653b1f6dc647aa24549d68c6addb4c595cc0d902d1b19308ad/beautifulsoup4-4.13.5.tar.gz"
    sha256 "5e70131382930e7c3de33450a2f54a63d5e4b19386eab43a5b34d594268f3695"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/ad/d4/ad261cb17f202082ba8598fd6d1d27eac5d11307ce99e3f5867bc9e376ee/boto3-1.40.16.tar.gz"
    sha256 "667bc3a9bd1f26579957d95a2612359103c343dd74d44f202d09a155ed4189c6"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/25/4c/7087a282f10dc2258a107e4a29645678b5d3fa7cbabed05d540370aa8c57/botocore-1.40.16.tar.gz"
    sha256 "522a8b7e3837667aca978b5b2dd2d12c3834f58f13df3c8d3369070d883d608d"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/6c/81/3747dad6b14fa2cf53fcf10548cf5aea6913e96fab41a3c198676f8948a5/cachetools-5.5.2.tar.gz"
    sha256 "1a661caa9175d26759571b2e19580f9d6393969e5dfca11fdb1f947a23e640d4"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/fc/97/c783634659c2920c3fc70419e3af40972dbaf758daa229a7d6ea6135c90d/cffi-1.17.1.tar.gz"
    sha256 "1c39c6016c32bc48dd54561950ebd6836e1670f2ae46128f67cf49e789c52824"
  end

  resource "cfgv" do
    url "https://files.pythonhosted.org/packages/11/74/539e56497d9bd1d484fd863dd69cbbfa653cd2aa27abfe35653494d85e94/cfgv-3.4.0.tar.gz"
    sha256 "e52591d4c5f5dead8e0f673fb16db7949d2cfb3f7da4582893288f0ded8fe560"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/83/2d/5fd176ceb9b2fc619e63405525573493ca23441330fcdaee6bef9460e924/charset_normalizer-3.4.3.tar.gz"
    sha256 "6fce4b8500244f6fcb71465d4a4930d132ba9ab8e71a7859e6a5d59851068d14"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/60/6c/8ca2efa64cf75a977a0d7fac081354553ebe483345c734fb6b6515d96bbc/click-8.2.1.tar.gz"
    sha256 "27c491cc05d968d271d5a1db13e3b5a184636d9d930f148c50b038f0d0646202"
  end

  resource "cloudpickle" do
    url "https://files.pythonhosted.org/packages/52/39/069100b84d7418bc358d81669d5748efb14b9cceacd2f9c75f550424132f/cloudpickle-3.1.1.tar.gz"
    sha256 "b216fa8ae4019d5482a8ac3c95d8f6346115d8835911fd4aefd1a445e4242c64"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/d6/0d/d13399c94234ee8f3df384819dc67e0c5ce215fb751d567a55a1f4b028c7/cryptography-45.0.6.tar.gz"
    sha256 "5c966c732cf6e4a276ce83b6e4c729edda2df6929083a952cc7da973c539c719"
  end

  resource "dataclasses-json" do
    url "https://files.pythonhosted.org/packages/64/a4/f71d9cf3a5ac257c993b5ca3f93df5f7fb395c725e7f1e6479d2514173c3/dataclasses_json-0.6.7.tar.gz"
    sha256 "b6b3e528266ea45b9535223bc53ca645f5208833c29229e847b3f26a1cc55fc0"
  end

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "deprecated" do
    url "https://files.pythonhosted.org/packages/98/97/06afe62762c9a8a86af0cfb7bfdab22a43ad17138b07af5b1a58442690a2/deprecated-1.2.18.tar.gz"
    sha256 "422b6f6d859da6f2ef57857761bfb392480502a64c3028ca9bbe86085d72115d"
  end

  resource "dirtyjson" do
    url "https://files.pythonhosted.org/packages/db/04/d24f6e645ad82ba0ef092fa17d9ef7a21953781663648a01c9371d9e8e98/dirtyjson-1.0.8.tar.gz"
    sha256 "90ca4a18f3ff30ce849d100dcf4a003953c79d3a2348ef056f1d9c22231a25fd"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/96/8e/709914eb2b5749865801041647dc7f4e6d00b549cfe88b65ca192995f07c/distlib-0.4.0.tar.gz"
    sha256 "feec40075be03a04501a973d81f633735b4b69f98b05450592310c0f401a4e0d"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/fc/f8/98eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3/distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/b5/4a/263763cb2ba3816dd94b08ad3a33d5fdae34ecb856678773cc40a3605829/dnspython-2.7.0.tar.gz"
    sha256 "ce9c432eda0dc91cf618a5cedf1a4e142651196bbcd2c80e89ed5a907e5cfaf1"
  end

  resource "docstring-parser" do
    url "https://files.pythonhosted.org/packages/b2/9d/c3b43da9515bd270df0f80548d9944e389870713cc1fe2b8fb35fe2bcefd/docstring_parser-0.17.0.tar.gz"
    sha256 "583de4a309722b3315439bb31d64ba3eebada841f2e2cee23b99df001434c912"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/f6/b0/4bc07ccd3572a2f9df7e6782f52b0c6c90dcbb803ac4a167702d7d0dfe1e/python_dotenv-1.1.1.tar.gz"
    sha256 "a8a6399716257f45be6a007360200409fce5cda2661e3dec71d23dc15f6189ab"
  end

  resource "duckdb" do
    url "https://files.pythonhosted.org/packages/47/24/a2e7fb78fba577641c286fe33185789ab1e1569ccdf4d142e005995991d2/duckdb-1.3.2.tar.gz"
    sha256 "c658df8a1bc78704f702ad0d954d82a1edd4518d7a04f00027ec53e40f591ff5"
  end

  resource "email-validator" do
    url "https://files.pythonhosted.org/packages/48/ce/13508a1ec3f8bb981ae4ca79ea40384becc868bfae97fd1c942bb3a001b1/email_validator-2.2.0.tar.gz"
    sha256 "cb690f344c617a714f22e66ae771445a1ceb46821152df8e165c5f9a364582b7"
  end

  resource "exceptiongroup" do
    url "https://files.pythonhosted.org/packages/0b/9f/a65090624ecf468cdca03533906e7c69ed7588582240cfe7cc9e770b50eb/exceptiongroup-1.3.0.tar.gz"
    sha256 "b241f5885f560bc56a59ee63ca4c6a8bfa46ae4ad651af316d4e81817bb9fd88"
  end

  resource "fastapi" do
    url "https://files.pythonhosted.org/packages/78/d7/6c8b3bfe33eeffa208183ec037fee0cce9f7f024089ab1c5d12ef04bd27c/fastapi-0.116.1.tar.gz"
    sha256 "ed52cbf946abfd70c5a0dccb24673f0670deeb517a88b3544d03c2a6bf283143"
  end

  resource "fastmcp" do
    url "https://files.pythonhosted.org/packages/ad/ac/4906336669a643b634b7ecde539c79126dff9f47b1e9e4b312dd170c1715/fastmcp-2.10.2.tar.gz"
    sha256 "1ad519fda8bfde1de7f54a7ed4be0b6353eb66230cc1e35eef29b47666a0027b"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/40/bb/0ab3e58d22305b6f5440629d20683af28959bf793d98d11950e305c1c326/filelock-3.19.1.tar.gz"
    sha256 "66eda1888b0171c998b35be2bcc0f6d75c388a7ce20c3f3f37aa8e96c2dddf58"
  end

  resource "filetype" do
    url "https://files.pythonhosted.org/packages/bb/29/745f7d30d47fe0f251d3ad3dc2978a23141917661998763bebb6da007eb1/filetype-1.2.0.tar.gz"
    sha256 "66b56cd6474bf41d8c54660347d37afcc3f7d1970648de365c102ef77548aadb"
  end

  resource "fire" do
    url "https://files.pythonhosted.org/packages/c0/00/f8d10588d2019d6d6452653def1ee807353b21983db48550318424b5ff18/fire-0.7.1.tar.gz"
    sha256 "3b208f05c736de98fb343310d090dcc4d8c78b2a89ea4f32b837c586270a9cbf"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/79/b1/b64018016eeb087db503b038296fd782586432b9c077fc5c7839e9cb6ef6/frozenlist-1.7.0.tar.gz"
    sha256 "2e310d81923c2437ea8670467121cc3e9b0f76d3043cc1d2331d56c7fb7a3a8f"
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

  resource "google-adk" do
    url "https://files.pythonhosted.org/packages/cf/12/960b2b92803be18ba8a04906c8f6ccd74f6f3b4353da43e223a0970513b4/google_adk-1.12.0.tar.gz"
    sha256 "4ff8e70f63a65ad9e147ec180e5ffe16970721936ec34eda40ae9e1621f70605"
  end

  resource "google-api-core" do
    url "https://files.pythonhosted.org/packages/dc/21/e9d043e88222317afdbdb567165fdbc3b0aad90064c7e0c9eb0ad9955ad8/google_api_core-2.25.1.tar.gz"
    sha256 "d2aaa0b13c78c61cb3f4282c464c046e45fbd75755683c9c525e6e8f7ed0a5e8"
  end

  resource "google-api-python-client" do
    url "https://files.pythonhosted.org/packages/73/ed/6e7865324252ea0a9f7c8171a3a00439a1e8447a5dc08e6d6c483777bb38/google_api_python_client-2.179.0.tar.gz"
    sha256 "76a774a49dd58af52e74ce7114db387e58f0aaf6760c9cf9201ab6d731d8bd8d"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/9e/9b/e92ef23b84fa10a64ce4831390b7a4c2e53c0132568d99d4ae61d04c8855/google_auth-2.40.3.tar.gz"
    sha256 "500c3a29adedeb36ea9cf24b8d10858e152f2412e3ca37829b3fa18e33d63b77"
  end

  resource "google-auth-httplib2" do
    url "https://files.pythonhosted.org/packages/56/be/217a598a818567b28e859ff087f347475c807a5649296fb5a817c58dacef/google-auth-httplib2-0.2.0.tar.gz"
    sha256 "38aa7badf48f974f1eb9861794e9c0cb2a0511a4ec0679b1f886d108f5640e05"
  end

  resource "google-cloud-aiplatform" do
    url "https://files.pythonhosted.org/packages/ee/a4/af1052083e715f4f47b81b9f8139fe188c666f8512f9ca5188b3363797a6/google_cloud_aiplatform-1.110.0.tar.gz"
    sha256 "e77a0d8fb4f58f4cae2e6bea12e63ef277ecceba23ab38d2a3a5c20022e6a6b5"
  end

  resource "google-cloud-appengine-logging" do
    url "https://files.pythonhosted.org/packages/e7/ea/85da73d4f162b29d24ad591c4ce02688b44094ee5f3d6c0cc533c2b23b23/google_cloud_appengine_logging-1.6.2.tar.gz"
    sha256 "4890928464c98da9eecc7bf4e0542eba2551512c0265462c10f3a3d2a6424b90"
  end

  resource "google-cloud-audit-log" do
    url "https://files.pythonhosted.org/packages/85/af/53b4ef636e492d136b3c217e52a07bee569430dda07b8e515d5f2b701b1e/google_cloud_audit_log-0.3.2.tar.gz"
    sha256 "2598f1533a7d7cdd6c7bf448c12e5519c1d53162d78784e10bcdd1df67791bc3"
  end

  resource "google-cloud-bigquery" do
    url "https://files.pythonhosted.org/packages/ac/76/a9bc50b0b14732f81f18b523f273f89c637a5f62187413d7296a91915e57/google_cloud_bigquery-3.36.0.tar.gz"
    sha256 "519d7a16be2119dca1ea8871e6dd45f971a8382c337cbe045319543b9e743bdd"
  end

  resource "google-cloud-bigtable" do
    url "https://files.pythonhosted.org/packages/88/18/52eaef1e08b1570a56a74bb909345bfae082b6915e482df10de1fb0b341d/google_cloud_bigtable-2.32.0.tar.gz"
    sha256 "1dcf8a9fae5801164dc184558cd8e9e930485424655faae254e2c7350fa66946"
  end

  resource "google-cloud-core" do
    url "https://files.pythonhosted.org/packages/d6/b8/2b53838d2acd6ec6168fd284a990c76695e84c65deee79c9f3a4276f6b4f/google_cloud_core-2.4.3.tar.gz"
    sha256 "1fab62d7102844b278fe6dead3af32408b1df3eb06f5c7e8634cbd40edc4da53"
  end

  resource "google-cloud-logging" do
    url "https://files.pythonhosted.org/packages/14/9c/d42ecc94f795a6545930e5f846a7ae59ff685ded8bc086648dd2bee31a1a/google_cloud_logging-3.12.1.tar.gz"
    sha256 "36efc823985055b203904e83e1c8f9f999b3c64270bcda39d57386ca4effd678"
  end

  resource "google-cloud-resource-manager" do
    url "https://files.pythonhosted.org/packages/6e/ca/a4648f5038cb94af4b3942815942a03aa9398f9fb0bef55b3f1585b9940d/google_cloud_resource_manager-1.14.2.tar.gz"
    sha256 "962e2d904c550d7bac48372607904ff7bb3277e3bb4a36d80cc9a37e28e6eb74"
  end

  resource "google-cloud-secret-manager" do
    url "https://files.pythonhosted.org/packages/58/7a/2fa6735ec693d822fe08a76709c4d95d9b5b4c02e83e720497355039d2ee/google_cloud_secret_manager-2.24.0.tar.gz"
    sha256 "ce573d40ffc2fb7d01719243a94ee17aa243ea642a6ae6c337501e58fbf642b5"
  end

  resource "google-cloud-spanner" do
    url "https://files.pythonhosted.org/packages/5e/e8/e008f9ffa2dcf596718d2533d96924735110378853c55f730d2527a19e04/google_cloud_spanner-3.57.0.tar.gz"
    sha256 "73f52f58617449fcff7073274a7f7a798f4f7b2788eda26de3b7f98ad857ab99"
  end

  resource "google-cloud-speech" do
    url "https://files.pythonhosted.org/packages/9a/74/9c5a556f8af19cab461058aa15e1409e7afa453ca2383473a24a12801ef7/google_cloud_speech-2.33.0.tar.gz"
    sha256 "fd08511b5124fdaa768d71a4054e84a5d8eb02531cb6f84f311c0387ea1314ed"
  end

  resource "google-cloud-storage" do
    url "https://files.pythonhosted.org/packages/36/76/4d965702e96bb67976e755bed9828fa50306dca003dbee08b67f41dd265e/google_cloud_storage-2.19.0.tar.gz"
    sha256 "cd05e9e7191ba6cb68934d8eb76054d9be4562aa89dbc4236feee4d7d51342b2"
  end

  resource "google-cloud-trace" do
    url "https://files.pythonhosted.org/packages/c5/ea/0e42e2196fb2bc8c7b25f081a0b46b5053d160b34d5322e7eac2d5f7a742/google_cloud_trace-1.16.2.tar.gz"
    sha256 "89bef223a512465951eb49335be6d60bee0396d576602dbf56368439d303cab4"
  end

  resource "google-crc32c" do
    url "https://files.pythonhosted.org/packages/19/ae/87802e6d9f9d69adfaedfcfd599266bf386a54d0be058b532d04c794f76d/google_crc32c-1.7.1.tar.gz"
    sha256 "2bff2305f98846f3e825dbeec9ee406f89da7962accdb29356e4eadc251bd472"
  end

  resource "google-genai" do
    url "https://files.pythonhosted.org/packages/e0/1b/da30fa6e2966942d7028a58eb7aa7d04544dcc3aa66194365b2e0adac570/google_genai-1.31.0.tar.gz"
    sha256 "8572b47aa684357c3e5e10d290ec772c65414114939e3ad2955203e27cd2fcbc"
  end

  resource "google-resumable-media" do
    url "https://files.pythonhosted.org/packages/58/5a/0efdc02665dca14e0837b62c8a1a93132c264bd02054a15abb2218afe0ae/google_resumable_media-2.7.2.tar.gz"
    sha256 "5280aed4629f2b60b847b0d42f9857fd4935c11af266744df33d8074cae92fe0"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/39/24/33db22342cf4a2ea27c9955e6713140fedd51e8b141b5ce5260897020f1a/googleapis_common_protos-1.70.0.tar.gz"
    sha256 "0e1b44e0ea153e6594f9f394fef15193a68aaaea2d843f83e2742717ca753257"
  end

  resource "graphviz" do
    url "https://files.pythonhosted.org/packages/f8/b3/3ac91e9be6b761a4b30d66ff165e54439dcd48b83f4e20d644867215f6ca/graphviz-0.21.tar.gz"
    sha256 "20743e7183be82aaaa8ad6c93f8893c923bd6658a04c32ee115edb3c8a835f78"
  end

  resource "greenlet" do
    url "https://files.pythonhosted.org/packages/03/b8/704d753a5a45507a7aab61f18db9509302ed3d0a27ac7e0359ec2905b1a6/greenlet-3.2.4.tar.gz"
    sha256 "0dca0d95ff849f9a364385f36ab49f50065d76964944638be9691e1832e9f86d"
  end

  resource "griffe" do
    url "https://files.pythonhosted.org/packages/81/ca/29f36e00c74844ae50d139cf5a8b1751887b2f4d5023af65d460268ad7aa/griffe-1.12.1.tar.gz"
    sha256 "29f5a6114c0aeda7d9c86a570f736883f8a2c5b38b57323d56b3d1c000565567"
  end

  resource "grpc-google-iam-v1" do
    url "https://files.pythonhosted.org/packages/b9/4e/8d0ca3b035e41fe0b3f31ebbb638356af720335e5a11154c330169b40777/grpc_google_iam_v1-0.14.2.tar.gz"
    sha256 "b3e1fc387a1a329e41672197d0ace9de22c78dd7d215048c4c78712073f7bd20"
  end

  resource "grpc-interceptor" do
    url "https://files.pythonhosted.org/packages/9f/28/57449d5567adf4c1d3e216aaca545913fbc21a915f2da6790d6734aac76e/grpc-interceptor-0.15.4.tar.gz"
    sha256 "1f45c0bcb58b6f332f37c637632247c9b02bc6af0fdceb7ba7ce8d2ebbfb0926"
  end

  resource "grpcio" do
    url "https://files.pythonhosted.org/packages/38/b4/35feb8f7cab7239c5b94bd2db71abb3d6adb5f335ad8f131abb6060840b6/grpcio-1.74.0.tar.gz"
    sha256 "80d1f4fbb35b0742d3e3d3bb654b7381cd5f015f8497279a1e9c21ba623e01b1"
  end

  resource "grpcio-status" do
    url "https://files.pythonhosted.org/packages/93/22/238c5f01e6837df54494deb08d5c772bc3f5bf5fb80a15dce254892d1a81/grpcio_status-1.74.0.tar.gz"
    sha256 "c58c1b24aa454e30f1fc6a7e0dbbc194c54a408143971a94b5f4e40bb5831432"
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

  resource "httplib2" do
    url "https://files.pythonhosted.org/packages/3d/ad/2371116b22d616c194aa25ec410c9c6c37f23599dcd590502b74db197584/httplib2-0.22.0.tar.gz"
    sha256 "d7a10bc5ef5ab08322488bde8c726eeee5c8618723fdb399597ec58f3d82df81"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "httpx-sse" do
    url "https://files.pythonhosted.org/packages/6e/fa/66bd985dd0b7c109a3bcb89272ee0bfb7e2b4d06309ad7b38ff866734b2a/httpx_sse-0.4.1.tar.gz"
    sha256 "8f44d34414bc7b21bf3602713005c5df4917884f76072479b21f68befa4ea26e"
  end

  resource "huggingface-hub" do
    url "https://files.pythonhosted.org/packages/45/c9/bdbe19339f76d12985bc03572f330a01a93c04dffecaaea3061bdd7fb892/huggingface_hub-0.34.4.tar.gz"
    sha256 "a4228daa6fb001be3f4f4bdaf9a0db00e1739235702848df00885c9b5742c85c"
  end

  resource "identify" do
    url "https://files.pythonhosted.org/packages/82/ca/ffbabe3635bb839aa36b3a893c91a9b0d368cb4d8073e03a12896970af82/identify-2.6.13.tar.gz"
    sha256 "da8d6c828e773620e13bfa86ea601c5a5310ba4bcd65edf378198b56a1f9fb32"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/76/66/650a33bd90f786193e4de4b3ad86ea60b53c89b669a5c7be931fac31cdb0/importlib_metadata-8.7.0.tar.gz"
    sha256 "d13b81ad223b890aa16c5471f2ac3056cf76c5f10f82d6f9292f0b415f389000"
  end

  resource "iniconfig" do
    url "https://files.pythonhosted.org/packages/f2/97/ebf4da567aa6827c909642694d71c9fcf53e5b504f2d96afea02718862f3/iniconfig-2.1.0.tar.gz"
    sha256 "3abbd2e30b36733fee78f9c7f7308f2d0050e88f0087fd25c2645f63c773e1c7"
  end

  resource "inquirerpy" do
    url "https://files.pythonhosted.org/packages/64/73/7570847b9da026e07053da3bbe2ac7ea6cde6bb2cbd3c7a5a950fa0ae40b/InquirerPy-0.3.4.tar.gz"
    sha256 "89d2ada0111f337483cb41ae31073108b2ec1e618a49d7110b0d7ade89fc197e"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "jiter" do
    url "https://files.pythonhosted.org/packages/ee/9d/ae7ddb4b8ab3fb1b51faf4deb36cb48a4fbbd7cb36bad6a5fca4741306f7/jiter-0.10.0.tar.gz"
    sha256 "07a7142c38aacc85194391108dc91b5b57093c978a9932bd86a36862759d9500"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "joblib" do
    url "https://files.pythonhosted.org/packages/dc/fe/0f5a938c54105553436dbff7a61dc4fed4b1b2c98852f8833beaf4d5968f/joblib-1.5.1.tar.gz"
    sha256 "f4f86e351f39fe3d0d32a9f2c3d8af1ee4cec285aafcb27003dda5205576b444"
  end

  resource "jsonpatch" do
    url "https://files.pythonhosted.org/packages/42/78/18813351fe5d63acad16aec57f94ec2b70a09e53ca98145589e185423873/jsonpatch-1.33.tar.gz"
    sha256 "9fcd4009c41e6d12348b4a0ff2563ba56a2923a7dfee731d004e212e1ee5030c"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/6a/0a/eebeb1fa92507ea94016a2a790b93c2ae41a7e18778f85471dc54475ed25/jsonpointer-3.0.0.tar.gz"
    sha256 "2b2d729f2091522d61c3b31f82e11870f60b68f43fbc705cb76bf4b832af59ef"
  end

  resource "jsonref" do
    url "https://files.pythonhosted.org/packages/aa/0d/c1f3277e90ccdb50d33ed5ba1ec5b3f0a242ed8c1b1a85d3afeb68464dca/jsonref-1.1.0.tar.gz"
    sha256 "32fe8e1d85af0fdefbebce950af85590b22b60f9e95443176adbde4e1ecea552"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/74/69/f7185de793a29082a9f3c7728268ffb31cb5095131a9c139a74078e27336/jsonschema-4.25.1.tar.gz"
    sha256 "e4a9655ce0da0c0b67a085847e00a3a51449e1157f4f75e9fb5aa545e122eb85"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/bf/ce/46fbd9c8119cfc3581ee5643ea49464d168028cfb5caff5fc0596d0cf914/jsonschema_specifications-2025.4.1.tar.gz"
    sha256 "630159c9f4dbea161a6a2205c3011cc4f18ff381b189fff48bb39b9bf26ae608"
  end

  resource "langchain" do
    url "https://files.pythonhosted.org/packages/83/f6/f4f7f3a56626fe07e2bb330feb61254dbdf06c506e6b59a536a337da51cf/langchain-0.3.27.tar.gz"
    sha256 "aa6f1e6274ff055d0fd36254176770f356ed0a8994297d1df47df341953cec62"
  end

  resource "langchain-core" do
    url "https://files.pythonhosted.org/packages/f1/c6/5d755a0f1f4857abbe5ea6f5907ed0e2b5df52bf4dde0a0fd768290e3084/langchain_core-0.3.74.tar.gz"
    sha256 "ff604441aeade942fbcc0a3860a592daba7671345230c2078ba2eb5f82b6ba76"
  end

  resource "langchain-mcp-adapters" do
    url "https://files.pythonhosted.org/packages/b9/74/e36003a43136f9095a5f968c730fbfe894f94284ebe6d2b50bb17d41b8b5/langchain_mcp_adapters-0.1.9.tar.gz"
    sha256 "0018cf7b5f7bc4c044e05ec20fcb9ebe345311c8d1060c61d411188001ab3aab"
  end

  resource "langchain-text-splitters" do
    url "https://files.pythonhosted.org/packages/91/52/d43ad77acae169210cc476cbc1e4ab37a701017c950211a11ab500fe7d7e/langchain_text_splitters-0.3.9.tar.gz"
    sha256 "7cd1e5a3aaf609979583eeca2eb34177622570b8fa8f586a605c6b1c34e7ebdb"
  end

  resource "langgraph" do
    url "https://files.pythonhosted.org/packages/02/2b/59f0b2985467ec84b006dd41ec31c0aae43a7f16722d5514292500b871c9/langgraph-0.6.6.tar.gz"
    sha256 "e7d3cefacf356f8c01721b166b67b3bf581659d5361a3530f59ecd9b8448eca7"
  end

  resource "langgraph-checkpoint" do
    url "https://files.pythonhosted.org/packages/73/3e/d00eb2b56c3846a0cabd2e5aa71c17a95f882d4f799a6ffe96a19b55eba9/langgraph_checkpoint-2.1.1.tar.gz"
    sha256 "72038c0f9e22260cb9bff1f3ebe5eb06d940b7ee5c1e4765019269d4f21cf92d"
  end

  resource "langgraph-prebuilt" do
    url "https://files.pythonhosted.org/packages/d6/21/9b198d11732101ee8cdf30af98d0b4f11254c768de15173e57f5260fd14b/langgraph_prebuilt-0.6.4.tar.gz"
    sha256 "e9e53b906ee5df46541d1dc5303239e815d3ec551e52bb03dd6463acc79ec28f"
  end

  resource "langgraph-sdk" do
    url "https://files.pythonhosted.org/packages/4e/50/1f5e4d129e3969973674db01bf5dcb85e2233e5e4fdffa53eefff1399902/langgraph_sdk-0.2.3.tar.gz"
    sha256 "17398aeae0f937cae1c8eb9027ada2969abdb50fe8ed3246c78f543b679cf959"
  end

  resource "langsmith" do
    url "https://files.pythonhosted.org/packages/a9/fb/a0fab0ce0bb46aaae9703c1fb814b4ac7cbc2d75adc51e8689f1b34ac08d/langsmith-0.4.16.tar.gz"
    sha256 "a94f374c7fa0f406757f95f311e84873258563961e1af0ba8996411822cd7241"
  end

  resource "litellm" do
    url "https://files.pythonhosted.org/packages/8b/03/2a89d9280f595fe293c64adcc3bfbefe7a3677ec0210d293bfac63ae17dc/litellm-1.74.15.post2.tar.gz"
    sha256 "8eddb1c8a6a5a7048f8ba16e652aba23d6ca996dd87cb853c874ba375aa32479"
  end

  resource "llama-cloud" do
    url "https://files.pythonhosted.org/packages/9b/72/816e6e900448e1b4a8137d90e65876b296c5264a23db6ae888bd3e6660ba/llama_cloud-0.1.35.tar.gz"
    sha256 "200349d5d57424d7461f304cdb1355a58eea3e6ca1e6b0d75c66b2e937216983"
  end

  resource "llama-cloud-services" do
    url "https://files.pythonhosted.org/packages/8a/0c/8ca87d33bea0340a8ed791f36390112aeb29fd3eebfd64b6aef6204a03f0/llama_cloud_services-0.6.54.tar.gz"
    sha256 "baf65d9bffb68f9dca98ac6e22908b6675b2038b021e657ead1ffc0e43cbd45d"
  end

  resource "llama-index" do
    url "https://files.pythonhosted.org/packages/ee/21/eea15746c34cdf5cbae1685a6f3ee48c3bbcd92a113f62bb33ad5526aaf6/llama_index-0.13.3.tar.gz"
    sha256 "2a0dd99aae2f9e736b02463134e4c605200d5fc1f1f4b0fb1ca9fc52905f1f4d"
  end

  resource "llama-index-cli" do
    url "https://files.pythonhosted.org/packages/22/5e/549765c3f1afba26a1462ffb442ffaa674dae00710780a35900e0c16b3a3/llama_index_cli-0.5.0.tar.gz"
    sha256 "2eb9426232e8d89ffdf0fa6784ff8da09449d920d71d0fcc81d07be93cf9369f"
  end

  resource "llama-index-core" do
    url "https://files.pythonhosted.org/packages/28/89/2954d6150835c33bad5300e405f8087fbc0a55fd885dccf885f7263d3500/llama_index_core-0.13.3.tar.gz"
    sha256 "bd7fffa7e6793b2c76fe55eb9e9336250b54e94fdee3fd017b354dbb0d6309a1"
  end

  resource "llama-index-embeddings-openai" do
    url "https://files.pythonhosted.org/packages/26/6a/80ed46993c6827786cdec4f6b553f3f4e5fc8741c31e8903c694833d24bf/llama_index_embeddings_openai-0.5.0.tar.gz"
    sha256 "ac587839a111089ea8a6255f9214016d7a813b383bbbbf9207799be1100758eb"
  end

  resource "llama-index-indices-managed-llama-cloud" do
    url "https://files.pythonhosted.org/packages/8f/5c/bd229ed367fa26ea9ddb18972bc84ac021014bf741de454e8b0534bd16fd/llama_index_indices_managed_llama_cloud-0.9.2.tar.gz"
    sha256 "19af55da8f1218d80390fcbe5cdfef6100acc755b0177a4077a924c31a2fb345"
  end

  resource "llama-index-instrumentation" do
    url "https://files.pythonhosted.org/packages/8e/ad/8be7010038c12ec9c0ed41a070527fd880e6181d87ae00d00790aefa50ee/llama_index_instrumentation-0.4.0.tar.gz"
    sha256 "f38ecc1f02b6c1f7ab84263baa6467fac9f86538c0ee25542853de46278abea7"
  end

  resource "llama-index-llms-litellm" do
    url "https://files.pythonhosted.org/packages/ba/9a/8d1a2c648db59c065c13804ae3b2a08c8c66232a9937f96fb7ca68267b8d/llama_index_llms_litellm-0.6.0.tar.gz"
    sha256 "53bde6a63714368c04100d00855bb3f4bb3eb9b84d3e112e7b1630128dc84ccd"
  end

  resource "llama-index-llms-openai" do
    url "https://files.pythonhosted.org/packages/20/59/4c414d79a21189d9db6de58ecbc297cd0f5ea121803b836bd134c67dd7a3/llama_index_llms_openai-0.5.4.tar.gz"
    sha256 "9e36b6d2fc5f056b00ee655901b3bb7e7060b23f7b19439889fb78d696340f54"
  end

  resource "llama-index-readers-file" do
    url "https://files.pythonhosted.org/packages/e7/9c/d86710937b3d14c51bd02fc67f1f4babd77ac3710817fc230778020cd102/llama_index_readers_file-0.5.2.tar.gz"
    sha256 "049d971ac4c936edbf4832915ba7128cfee8f5ead435266792b71edd87f5305c"
  end

  resource "llama-index-readers-llama-parse" do
    url "https://files.pythonhosted.org/packages/be/77/6ca0b2fcdf2ad6c5a36e4374b3380a1e65d216a07f874f27f341c69e2c55/llama_index_readers_llama_parse-0.5.0.tar.gz"
    sha256 "891b21fb63fe1fe722e23cfa263a74d9a7354e5d8d7a01f2d4040a52f8d8feef"
  end

  resource "llama-index-tools-mcp" do
    url "https://files.pythonhosted.org/packages/b2/46/79c221aa66a49e3a9371855150bf341d441a2f87b234b5b44b4ce22f12ff/llama_index_tools_mcp-0.4.0.tar.gz"
    sha256 "135c7d3ce076acf69dd9f578f70d37b2222d2d1164ad44fd51a2def9974222d3"
  end

  resource "llama-index-workflows" do
    url "https://files.pythonhosted.org/packages/00/dc/54fd5dec0ad3c65f3e8a520db7a3024141b71cd41660d0baca3cd6b18707/llama_index_workflows-1.3.0.tar.gz"
    sha256 "9c1688e237efad384f16485af71c6f9456a2eb6d85bf61ff49e5717f10ff286d"
  end

  resource "llama-parse" do
    url "https://files.pythonhosted.org/packages/08/f6/93b5d123c480bc8c93e6dc3ea930f4f8df8da27f829bb011100ba3ce23dc/llama_parse-0.6.54.tar.gz"
    sha256 "c707b31152155c9bae84e316fab790bbc8c85f4d8825ce5ee386ebeb7db258f1"
  end

  resource "loguru" do
    url "https://files.pythonhosted.org/packages/3a/05/a1dae3dffd1116099471c643b8924f5aa6524411dc6c63fdae648c4f1aca/loguru-0.7.3.tar.gz"
    sha256 "19480589e77d47b8d85b2c827ad95d49bf31b0dcde16593892eb51dd18706eb6"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/5b/f5/4ec618ed16cc4f8fb3b701563655a69816155e79e24a17b651541804721d/markdown_it_py-4.0.0.tar.gz"
    sha256 "cb0a2b4aa34f932c007117b194e945bd74e0ec24133ceb5bac59009cda1cb9f3"
  end

  resource "markdownify" do
    url "https://files.pythonhosted.org/packages/83/1b/6f2697b51eaca81f08852fd2734745af15718fea10222a1d40f8a239c4ea/markdownify-1.2.0.tar.gz"
    sha256 "f6c367c54eb24ee953921804dfe6d6575c5e5b42c643955e7242034435de634c"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b2/97/5d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62/markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "marshmallow" do
    url "https://files.pythonhosted.org/packages/ab/5e/5e53d26b42ab75491cda89b871dab9e97c840bf12c63ec58a1919710cd06/marshmallow-3.26.1.tar.gz"
    sha256 "e6d8affb6cb61d39d26402096dc0aee12d5a26d490a121f118d2e81dc0719dc6"
  end

  resource "mcp" do
    url "https://files.pythonhosted.org/packages/66/3c/82c400c2d50afdac4fbefb5b4031fd327e2ad1f23ccef8eee13c5909aa48/mcp-1.13.1.tar.gz"
    sha256 "165306a8fd7991dc80334edd2de07798175a56461043b7ae907b279794a834c5"
  end

  resource "mcpadapt" do
    url "https://files.pythonhosted.org/packages/a6/96/9f423d4317695386f5bf1156574b6505d056fe6509f09cf86e8b99df60dc/mcpadapt-0.1.13.tar.gz"
    sha256 "896f00288eb7515042c3b940d415917d363854f300d29d805ebaa40dc63b5574"
  end

  resource "mcpm" do
    url "https://files.pythonhosted.org/packages/7a/37/ac5365bc2f13a40a6dfd609c3678d56dbeea5adf8e1cefa5b029889dccac/mcpm-2.7.0.tar.gz"
    sha256 "fc54435a052b002c2a580e57c158f2af0fad148934ff85c0f013079f52e471c8"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/69/7f/0652e6ed47ab288e3756ea9c0df8b14950781184d4bd7883f4d87dd41245/multidict-6.6.4.tar.gz"
    sha256 "d2d4e4787672911b48350df02ed3fa3fffdc2f2e8ca06dd6afdf34189b76a9dd"
  end

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/a2/6e/371856a3fb9d31ca8dac321cda606860fa4548858c0cc45d9d1d4ca2628b/mypy_extensions-1.1.0.tar.gz"
    sha256 "52e68efc3284861e772bbcd66823fde5ae21fd2fdb51c62a211403730b916558"
  end

  resource "nest-asyncio" do
    url "https://files.pythonhosted.org/packages/83/f8/51569ac65d696c8ecbee95938f89d4abf00f47d58d48f6fbabfe8f0baefe/nest_asyncio-1.6.0.tar.gz"
    sha256 "6f172d5449aca15afd6c646851f4e31e02c598d553a667e38cafa997cfec55fe"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/6c/4f/ccdb8ad3a38e583f214547fd2f7ff1fc160c43a75af88e6aec213404b96a/networkx-3.5.tar.gz"
    sha256 "d4c6f9cf81f52d69230866796b82afbccdec3db7ae4fbd1b65ea750feed50037"
  end

  resource "nltk" do
    url "https://files.pythonhosted.org/packages/3c/87/db8be88ad32c2d042420b6fd9ffd4a149f9a0d7f0e86b3f543be2eeeedd2/nltk-3.9.1.tar.gz"
    sha256 "87d127bd3de4bd89a4f81265e5fa59cb1b199b27440175370f7417d2bc7ae868"
  end

  resource "nodeenv" do
    url "https://files.pythonhosted.org/packages/43/16/fc88b08840de0e0a72a2f9d8c6bae36be573e475a6326ae854bcc549fc45/nodeenv-1.9.1.tar.gz"
    sha256 "6ec12890a2dab7946721edbfbcd91f3319c6ccc9aec47be7c7e6b7011ee6645f"
  end

  resource "openai" do
    url "https://files.pythonhosted.org/packages/03/30/f0fb7907a77e733bb801c7bdcde903500b31215141cdb261f04421e6fbec/openai-1.99.1.tar.gz"
    sha256 "2c9d8e498c298f51bb94bcac724257a3a6cac6139ccdfc1186c6708f7a93120f"
  end

  resource "openai-agents" do
    url "https://files.pythonhosted.org/packages/60/3f/df1efb95c8c54e5718ff59883214a8afa8f40f03a96aaf8c9aa24bee44fa/openai_agents-0.2.5.tar.gz"
    sha256 "c65aef12dbc236f43a70aae886c38b85dd9c68cbf89373c82f733b476e618ddd"
  end

  resource "openapi-pydantic" do
    url "https://files.pythonhosted.org/packages/02/2e/58d83848dd1a79cb92ed8e63f6ba901ca282c5f09d04af9423ec26c56fd7/openapi_pydantic-0.5.1.tar.gz"
    sha256 "ff6835af6bde7a459fb93eb93bb92b8749b754fc6e51b2f1590a19dc3005ee0d"
  end

  resource "opentelemetry-api" do
    url "https://files.pythonhosted.org/packages/27/d2/c782c88b8afbf961d6972428821c302bd1e9e7bc361352172f0ca31296e2/opentelemetry_api-1.36.0.tar.gz"
    sha256 "9a72572b9c416d004d492cbc6e61962c0501eaf945ece9b5a0f56597d8348aa0"
  end

  resource "opentelemetry-exporter-gcp-trace" do
    url "https://files.pythonhosted.org/packages/c3/15/7556d54b01fb894497f69a98d57faa9caa45ffa59896e0bba6847a7f0d15/opentelemetry_exporter_gcp_trace-1.9.0.tar.gz"
    sha256 "c3fc090342f6ee32a0cc41a5716a6bb716b4422d19facefcb22dc4c6b683ece8"
  end

  resource "opentelemetry-instrumentation" do
    url "https://files.pythonhosted.org/packages/12/37/cf17cf28f945a3aca5a038cfbb45ee01317d4f7f3a0e5209920883fe9b08/opentelemetry_instrumentation-0.57b0.tar.gz"
    sha256 "f2a30135ba77cdea2b0e1df272f4163c154e978f57214795d72f40befd4fcf05"
  end

  resource "opentelemetry-instrumentation-asgi" do
    url "https://files.pythonhosted.org/packages/97/10/7ba59b586eb099fa0155521b387d857de476687c670096597f618d889323/opentelemetry_instrumentation_asgi-0.57b0.tar.gz"
    sha256 "a6f880b5d1838f65688fc992c65fbb1d3571f319d370990c32e759d3160e510b"
  end

  resource "opentelemetry-instrumentation-httpx" do
    url "https://files.pythonhosted.org/packages/01/28/65fea8b8e7f19502a8af1229c62384f9211c1480f5dee1776841810d6551/opentelemetry_instrumentation_httpx-0.57b0.tar.gz"
    sha256 "ea5669cdb17185f8d247c2dbf756ae5b95b53110ca4d58424f2be5cc7223dbdd"
  end

  resource "opentelemetry-instrumentation-starlette" do
    url "https://files.pythonhosted.org/packages/84/2c/bc7533a4b91dcf0e2d76c1f61cf42e90d17bbcb31de9000015284fea3bad/opentelemetry_instrumentation_starlette-0.57b0.tar.gz"
    sha256 "d01c411f0189fe530c574f4392f83941a7845839af7ae6456ad00ac2aeb6441c"
  end

  resource "opentelemetry-resourcedetector-gcp" do
    url "https://files.pythonhosted.org/packages/e1/86/f0693998817779802525a5bcc885a3cdb68d05b636bc6faae5c9ade4bee4/opentelemetry_resourcedetector_gcp-1.9.0a0.tar.gz"
    sha256 "6860a6649d1e3b9b7b7f09f3918cc16b72aa0c0c590d2a72ea6e42b67c9a42e7"
  end

  resource "opentelemetry-sdk" do
    url "https://files.pythonhosted.org/packages/4c/85/8567a966b85a2d3f971c4d42f781c305b2b91c043724fa08fd37d158e9dc/opentelemetry_sdk-1.36.0.tar.gz"
    sha256 "19c8c81599f51b71670661ff7495c905d8fdf6976e41622d5245b791b06fa581"
  end

  resource "opentelemetry-semantic-conventions" do
    url "https://files.pythonhosted.org/packages/7e/31/67dfa252ee88476a29200b0255bda8dfc2cf07b56ad66dc9a6221f7dc787/opentelemetry_semantic_conventions-0.57b0.tar.gz"
    sha256 "609a4a79c7891b4620d64c7aac6898f872d790d75f22019913a660756f27ff32"
  end

  resource "opentelemetry-util-http" do
    url "https://files.pythonhosted.org/packages/9b/1b/6229c45445e08e798fa825f5376f6d6a4211d29052a4088eed6d577fa653/opentelemetry_util_http-0.57b0.tar.gz"
    sha256 "f7417595ead0eb42ed1863ec9b2f839fc740368cd7bbbfc1d0a47bc1ab0aba11"
  end

  resource "orjson" do
    url "https://files.pythonhosted.org/packages/df/1d/5e0ae38788bdf0721326695e65fdf41405ed535f633eb0df0f06f57552fa/orjson-3.11.2.tar.gz"
    sha256 "91bdcf5e69a8fd8e8bdb3de32b31ff01d2bd60c1e8d5fe7d5afabdcf19920309"
  end

  resource "ormsgpack" do
    url "https://files.pythonhosted.org/packages/92/36/44eed5ef8ce93cded76a576780bab16425ce7876f10d3e2e6265e46c21ea/ormsgpack-1.10.0.tar.gz"
    sha256 "7f7a27efd67ef22d7182ec3b7fa7e9d147c3ad9be2a24656b23c989077e08b16"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "pandas" do
    url "https://files.pythonhosted.org/packages/9c/d6/9f8431bacc2e19dca897724cd097b1bb224a6ad5433784a44b587c7c13af/pandas-2.2.3.tar.gz"
    sha256 "4f18ba62b61d7e192368b84517265a99b4d7ee8912f8708660fb4a366cc82667"
  end

  resource "pfzy" do
    url "https://files.pythonhosted.org/packages/d9/5a/32b50c077c86bfccc7bed4881c5a2b823518f5450a30e639db5d3711952e/pfzy-0.3.4.tar.gz"
    sha256 "717ea765dd10b63618e7298b2d98efd819e0b30cd5905c9707223dceeb94b3f1"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/fe/8b/3c73abc9c759ecd3f1f7ceff6685840859e8070c4d947c93fae71f6a0bf2/platformdirs-4.3.8.tar.gz"
    sha256 "3d512d96e16bcb959a814c9f348431070822a6496326a4be0911c40b5a74c2bc"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f9/e2/3e91f31a7d2b083fe6ef3fa267035b518369d9511ffab804f839851d2779/pluggy-1.6.0.tar.gz"
    sha256 "7dcc130b76258d33b90f61b658791dede3486c3e6bfb003ee5c9bfb396dd22f3"
  end

  resource "pre-commit" do
    url "https://files.pythonhosted.org/packages/ff/29/7cf5bbc236333876e4b41f56e06857a87937ce4bf91e117a6991a2dbb02a/pre_commit-4.3.0.tar.gz"
    sha256 "499fe450cc9d42e9d58e606262795ecb64dd05438943c62b66f6a8673da30b16"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/bb/6e/9d084c929dfe9e3bfe0c6a47e31f78a25c54627d64a66e884a8bf5474f1c/prompt_toolkit-3.0.51.tar.gz"
    sha256 "931a162e3b27fc90c86f1b48bb1fb2c528c2761475e57c9c06de13311c7b54ed"
  end

  resource "propcache" do
    url "https://files.pythonhosted.org/packages/a6/16/43264e4a779dd8588c21a70f0709665ee8f611211bdd2c87d952cfa7c776/propcache-0.3.2.tar.gz"
    sha256 "20d7d62e4e7ef05f221e0db2856b979540686342e7dd9973b815599c7057e168"
  end

  resource "proto-plus" do
    url "https://files.pythonhosted.org/packages/f4/ac/87285f15f7cce6d4a008f33f1757fb5a13611ea8914eb58c3d0d26243468/proto_plus-1.26.1.tar.gz"
    sha256 "21a515a4c4c0088a773899e23c7bbade3d18f9c66c73edd4c7ee3816bc96a012"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/c0/df/fb4a8eeea482eca989b51cffd274aac2ee24e825f0bf3cbce5281fa1567b/protobuf-6.32.0.tar.gz"
    sha256 "a81439049127067fc49ec1d36e25c6ee1d1a2b7be930675f919258d03c04e7d2"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/2a/80/336820c1ad9286a4ded7e845b2eccfcb27851ab8ac6abece774a6ff4d3de/psutil-7.0.0.tar.gz"
    sha256 "7be9c3eba38beccb6495ea33afd982a44074b78f28c434a1f51cc07fd315c456"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/ba/e9/01f1a64245b89f039897cb0130016d79f77d52669aae6ee7b159a6c4c018/pyasn1-0.6.1.tar.gz"
    sha256 "6f580d2bdd84365380830acf45550f2511469f673cb4a5ae3857a3170128b034"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/e9/e6/78ebbb10a8c8e4b61a59249394a4a594c1a7af95593dc933a349c8d00964/pyasn1_modules-0.4.2.tar.gz"
    sha256 "677091de870a80aae844b1ca6134f54652fa2c8c5a52aa396440ac3106e941e6"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/1d/b2/31537cf4b1ca988837256c910a668b553fceb8f069bedc4b1c826024b52c/pycparser-2.22.tar.gz"
    sha256 "491c8be9c040f5390f5bf44a5b07752bd07f56edf992381b05c701439eec10f6"
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

  resource "pyflakes" do
    url "https://files.pythonhosted.org/packages/45/dc/fd034dc20b4b264b3d015808458391acbf9df40b1e54750ef175d39180b1/pyflakes-3.4.0.tar.gz"
    sha256 "b24f96fafb7d2ab0ec5075b7350b3d2d2218eab42003821c06344973d3ea2f58"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/bb/22/f1129e69d94ffff626bdb5c835506b3a5b4f3d070f17ea295e12c2c6f60f/pyparsing-3.2.3.tar.gz"
    sha256 "b9c13f1ab8b3b542f72e28f634bad4de758ab3ce4546e4301970ad6fa77c38be"
  end

  resource "pypdf" do
    url "https://files.pythonhosted.org/packages/20/ac/a300a03c3b34967c050677ccb16e7a4b65607ee5df9d51e8b6d713de4098/pypdf-6.0.0.tar.gz"
    sha256 "282a99d2cc94a84a3a3159f0d9358c0af53f85b4d28d76ea38b96e9e5ac2a08d"
  end

  resource "pytest" do
    url "https://files.pythonhosted.org/packages/08/ba/45911d754e8eba3d5a841a5ce61a65a685ff1798421ac054f85aa8747dfb/pytest-8.4.1.tar.gz"
    sha256 "7c67fd69174877359ed9371ec3af8a3d2b04741818c51e5e99cc1742251fa93c"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/f6/b0/4bc07ccd3572a2f9df7e6782f52b0c6c90dcbb803ac4a167702d7d0dfe1e/python_dotenv-1.1.1.tar.gz"
    sha256 "a8a6399716257f45be6a007360200409fce5cda2661e3dec71d23dc15f6189ab"
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

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/2f/db/98b5c277be99dd18bfd91dd04e1b759cad18d1a338188c936e92f921c7e2/referencing-0.36.2.tar.gz"
    sha256 "df2e89862cd09deabbdba16944cc3f10feb6b3e6f18e902f7cc25609a34775aa"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/0b/de/e13fa6dc61d78b30ba47481f99933a3b49a57779d625c392d8036770a60d/regex-2025.7.34.tar.gz"
    sha256 "9ead9765217afd04a86822dfcd4ed2747dfe426e887da413b15ff0ac2457e21a"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "requests-toolbelt" do
    url "https://files.pythonhosted.org/packages/f3/61/d7545dafb7ac2230c70d38d31cbfe4cc64f7144dc41f6e4e4b78ecd9f5bb/requests-toolbelt-1.0.0.tar.gz"
    sha256 "7681a0a3d047012b5bdc0ee37d7f8f07ebe76ab08caeccfc3921ce23c88d5bc6"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/fe/75/af448d8e52bf1d8fa6a9d089ca6c07ff4453d86c65c145d0a300bb073b9b/rich-14.1.0.tar.gz"
    sha256 "e497a48b844b0320d45007cdebfeaeed8db2a4f4bcf49f15e455cfc4af11eaa8"
  end

  resource "rich-click" do
    url "https://files.pythonhosted.org/packages/b7/a8/dcc0a8ec9e91d76ecad9413a84b6d3a3310c6111cfe012d75ed385c78d96/rich_click-1.8.9.tar.gz"
    sha256 "fd98c0ab9ddc1cf9c0b7463f68daf28b4d0033a74214ceb02f761b3ff2af3136"
  end

  resource "rich-color-ext" do
    url "https://files.pythonhosted.org/packages/30/54/74ef0e1f57b87b71a3c425dc3ba69c3a308279ffb4ed38bdeffc789f655d/rich_color_ext-0.1.3.tar.gz"
    sha256 "501296cb66d75413f29a25cee1606a1fd38ead2d95c97428e5b226d679a6ea7d"
  end

  resource "rich-gradient" do
    url "https://files.pythonhosted.org/packages/bd/90/fe0cd9d18358294c681beeb51bbeb3505f53c6fca1cc119f06d1ab51f3b7/rich_gradient-0.3.3.tar.gz"
    sha256 "4351050e45fe4c23ed80448e13637aa15a72e2d998925c2234896529a209820e"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/1e/d9/991a0dee12d9fc53ed027e26a26a64b151d77252ac477e22666b9688bc16/rpds_py-0.27.0.tar.gz"
    sha256 "8b23cf252f180cda89220b378d917180f29d313cd6a07b2431c0d3b776aae86f"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/da/8a/22b7beea3ee0d44b1916c0c1cb0ee3af23b700b6da9f04991899d0c555d4/rsa-4.9.1.tar.gz"
    sha256 "e7bdbfdb5497da4c07dfd35530e1a902659db6ff241e39d9953cad06ebd0ae75"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/3e/db/f3950f5e5031b618aae9f423a39bf81a55c148aecd15a34527898e752cf4/ruamel.yaml-0.18.15.tar.gz"
    sha256 "dbfca74b018c4c3fba0b9cc9ee33e53c371194a9000e694995e620490fd40700"
  end

  resource "ruamel-yaml-clib" do
    url "https://files.pythonhosted.org/packages/20/84/80203abff8ea4993a87d823a5f632e4d92831ef75d404c9fc78d0176d2b5/ruamel.yaml.clib-0.2.12.tar.gz"
    sha256 "6c8fbb13ec503f99a91901ab46e0b07ae7941cd527393187039aec586fdfd36f"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/6d/05/d52bf1e65044b4e5e27d4e63e8d1579dbdec54fce685908ae09bc3720030/s3transfer-0.13.1.tar.gz"
    sha256 "c3fdba22ba1bd367922f27ec8032d6a1cf5f10c934fb5d68cf60fd5a23d936cf"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
  end

  resource "shapely" do
    url "https://files.pythonhosted.org/packages/ca/3c/2da625233f4e605155926566c0e7ea8dda361877f48e8b1655e53456f252/shapely-2.1.1.tar.gz"
    sha256 "500621967f2ffe9642454808009044c21e5b35db89ce69f8a2042c2ffd0e2772"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/58/15/8b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58e/shellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/44/cd/a040c4b3119bbe532e5b0732286f805445375489fceaec1f48306068ee3b/smmap-5.0.2.tar.gz"
    sha256 "26ea65a03958fa0c8a1c7e8c7a58fdc77221b8910f6be2131affade476898ad5"
  end

  resource "smolagents" do
    url "https://files.pythonhosted.org/packages/c7/60/fe1b22789f665ff07cf308b9fff480624a3b396c88cc76c6db8f20478875/smolagents-1.21.2.tar.gz"
    sha256 "cb1727dd5081bc8137fd329567eb8ce10321a058c96ddbe5e0dd7c2e6a6c9fa4"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/3f/f4/4a80cd6ef364b2e8b65b15816a843c0980f7a5a2b4dc701fc574952aa19f/soupsieve-2.7.tar.gz"
    sha256 "ad282f9b6926286d2ead4750552c8a6142bc4c783fd66b0293547c8fe6ae126a"
  end

  resource "sqlalchemy" do
    url "https://files.pythonhosted.org/packages/d7/bc/d59b5d97d27229b0e009bd9098cd81af71c2fa5549c580a0a67b9bed0496/sqlalchemy-2.0.43.tar.gz"
    sha256 "788bfcef6787a7764169cfe9859fe425bf44559619e1d9f56f5bddf2ebf6f417"
  end

  resource "sqlparse" do
    url "https://files.pythonhosted.org/packages/e5/40/edede8dd6977b0d3da179a342c198ed100dd2aba4be081861ee5911e4da4/sqlparse-0.5.3.tar.gz"
    sha256 "09f67787f56a0b16ecdbde1bfc7f5d9c3371ca683cfeaa8e6ff60b4807ec9272"
  end

  resource "sse-starlette" do
    url "https://files.pythonhosted.org/packages/42/6f/22ed6e33f8a9e76ca0a412405f31abb844b779d52c5f96660766edcd737c/sse_starlette-3.0.2.tar.gz"
    sha256 "ccd60b5765ebb3584d0de2d7a6e4f745672581de4f5005ab31c3a25d10b52b3a"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/15/b9/cc3017f9a9c9b6e27c5106cc10cc7904653c3eec0729793aec10479dd669/starlette-0.47.3.tar.gz"
    sha256 "6bc94f839cc176c4858894f1f8908f0ab79dfec1a6b8402f6da9be26ebea52e9"
  end

  resource "striprtf" do
    url "https://files.pythonhosted.org/packages/25/20/3d419008265346452d09e5dadfd5d045b64b40d8fc31af40588e6c76997a/striprtf-0.0.26.tar.gz"
    sha256 "fdb2bba7ac440072d1c41eab50d8d74ae88f60a8b6575c6e2c7805dc462093aa"
  end

  resource "tavily-python" do
    url "https://files.pythonhosted.org/packages/04/0e/d4aa0f4dec298298b510ee5209f5ff29352bbbba106fd7ea0221ba8840dc/tavily_python-0.7.10.tar.gz"
    sha256 "c87b4c0549ab2e416cf4ac3da8fe3ce5db106288408b06e197d4b5ba8ec7ead9"
  end

  resource "tenacity" do
    url "https://files.pythonhosted.org/packages/a3/4d/6a19536c50b849338fcbe9290d562b52cbdcf30d8963d3588a68a4107df1/tenacity-8.5.0.tar.gz"
    sha256 "8bc6c0c8a09b31e6cad13c47afbed1a567518250a9a171418582ed8d9c20ca78"
  end

  resource "termcolor" do
    url "https://files.pythonhosted.org/packages/ca/6c/3d75c196ac07ac8749600b60b03f4f6094d54e132c4d94ebac6ee0e0add0/termcolor-3.1.0.tar.gz"
    sha256 "6a6dd7fbee581909eeec6a756cff1d7f7c376063b14e4a298dc4980309e55970"
  end

  resource "tiktoken" do
    url "https://files.pythonhosted.org/packages/a7/86/ad0155a37c4f310935d5ac0b1ccf9bdb635dcb906e0a9a26b616dd55825a/tiktoken-0.11.0.tar.gz"
    sha256 "3c518641aee1c52247c2b97e74d8d07d780092af79d5911a6ab5e79359d9b06a"
  end

  resource "tokenizers" do
    url "https://files.pythonhosted.org/packages/c2/2f/402986d0823f8d7ca139d969af2917fefaa9b947d1fb32f6168c509f2492/tokenizers-0.21.4.tar.gz"
    sha256 "fa23f85fbc9a02ec5c6978da172cdcbac23498c3ca9f3645c5c68740ac007880"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/18/87/302344fed471e44a87289cf4967697d07e532f2421fdaf868a303cbae4ff/tomli-2.2.1.tar.gz"
    sha256 "cd45e1dc79c835ce60f7404ec8119f2eb06d38b1deba146f07ced3bbc44505ff"
  end

  resource "tomli-w" do
    url "https://files.pythonhosted.org/packages/19/75/241269d1da26b624c0d5e110e8149093c759b7a286138f4efd61a60e75fe/tomli_w-1.2.0.tar.gz"
    sha256 "2dd14fac5a47c27be9cd4c976af5a12d87fb1f0b4512f81d69cce3b35ae25021"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/a8/4b/29b4ef32e036bb34e4ab51796dd745cdba7ed47ad142a9f4a1eb8e0c744d/tqdm-4.67.1.tar.gz"
    sha256 "f8aef9c52c08c13a65f30ea34f4e5aac3fd1a34959879d7e59e63027286627f2"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/43/78/d90f616bf5f88f8710ad067c1f8705bf7618059836ca084e5bb2a0855d75/typer-0.16.1.tar.gz"
    sha256 "d358c65a464a7a90f338e3bb7ff0c74ac081449e53884b12ba658cbd72990614"
  end

  resource "types-requests" do
    url "https://files.pythonhosted.org/packages/ed/b0/9355adb86ec84d057fea765e4c49cce592aaf3d5117ce5609a95a7fc3dac/types_requests-2.32.4.20250809.tar.gz"
    sha256 "d8060de1c8ee599311f56ff58010fb4902f462a1470802cf9f6ed27bc46c4df3"
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
    url "https://files.pythonhosted.org/packages/f8/b1/0c11f5058406b3af7609f121aaa6b609744687f1d158b3c3a5bf4cc94238/typing_inspection-0.4.1.tar.gz"
    sha256 "6ae134cc0203c33377d43188d4064e9b357dba58cff3185f22924610e70a9d28"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/95/32/1a225d6164441be760d75c2c42e2780dc0873fe382da3e98a2e1e48361e5/tzdata-2025.2.tar.gz"
    sha256 "b60a638fcc0daffadf82fe0f57e53d06bdec2f36c4df66280ae79bce6bd6f2b9"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/8b/2e/c14812d3d4d9cd1773c6be938f89e5735a1f11a9f184ac3639b93cef35d5/tzlocal-5.3.1.tar.gz"
    sha256 "cceffc7edecefea1f595541dbd6e990cb1ea3d19bf01b2809f362a03dd7921fd"
  end

  resource "uritemplate" do
    url "https://files.pythonhosted.org/packages/98/60/f174043244c5306c9988380d2cb10009f91563fc4b31293d27e17201af56/uritemplate-4.2.0.tar.gz"
    sha256 "480c2ed180878955863323eea31b0ede668795de182617fef9c6ca09e6ec9d0e"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/5e/42/e0e305207bb88c6b8d3061399c6a961ffe5fbb7e2aa63c9234df7259e9cd/uvicorn-0.35.0.tar.gz"
    sha256 "bc662f087f7cf2ce11a1d7fd70b90c9f98ef2e2831556dd078d131b96cc94a01"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/1c/14/37fcdba2808a6c615681cd216fecae00413c9dab44fb2e57805ecf3eaee3/virtualenv-20.34.0.tar.gz"
    sha256 "44815b2c9dee7ed86e387b842a84f20b93f7f417f95886ca1996a72a4138eb1a"
  end

  resource "watchdog" do
    url "https://files.pythonhosted.org/packages/db/7d/7f3d619e951c88ed75c6037b246ddcf2d322812ee8ea189be89511721d54/watchdog-6.0.0.tar.gz"
    sha256 "9ddf7c82fda3ae8e24decda1338ede66e1c99883db93711d8fb941eaa2d8c282"
  end

  resource "watchfiles" do
    url "https://files.pythonhosted.org/packages/2a/9a/d451fcc97d029f5812e898fd30a53fd8c15c7bbd058fd75cfc6beb9bd761/watchfiles-1.1.0.tar.gz"
    sha256 "693ed7ec72cbfcee399e92c895362b6e66d63dac6b91e2c11ae03d10d503e575"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/6c/63/53559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598/wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/21/e6/26d09fab466b7ca9c7737474c52be4f76a40301b08362eb2dbc19dcc16c1/websockets-15.0.1.tar.gz"
    sha256 "82544de02076bafba038ce055ee6412d68da13ab47f0c60cab827346de828dee"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/95/8f/aeb76c5b46e273670962298c23e7ddde79916cb74db802131d49a85e4b7d/wrapt-1.17.3.tar.gz"
    sha256 "f66eb08feaa410fe4eebd17f2a2c8e2e46d3476e9f8c783daa8e09e0faa666d0"
  end

  resource "xxhash" do
    url "https://files.pythonhosted.org/packages/00/5e/d6e5258d69df8b4ed8c83b6664f2b47d30d2dec551a29ad72a6c69eafd31/xxhash-3.5.0.tar.gz"
    sha256 "84f2caddf951c9cbf8dc2e22a89d4ccf5d86391ac6418fe81e3c67d0cf60b45f"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/3c/fb/efaa23fa4e45537b827620f04cf8f3cd658b76642205162e072703a5b963/yarl-1.20.1.tar.gz"
    sha256 "d017a4997ee50c91fd5466cef416231bb82177b93b029906cefc542ce14c35ac"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/e3/02/0f2892c661036d50ede074e376733dca2ae7c6eb617489437771209d4180/zipp-3.23.0.tar.gz"
    sha256 "a07157588a12518c9d4034df3fbbee09c814741a33ff63c05fa29d26a2404166"
  end

  resource "zstandard" do
    url "https://files.pythonhosted.org/packages/09/1b/c20b2ef1d987627765dcd5bf1dadb8ef6564f00a87972635099bb76b7a05/zstandard-0.24.0.tar.gz"
    sha256 "fe3198b81c00032326342d973e526803f183f97aa9e9a98e3f897ebafe21178f"
  end

  def install
    virtualenv_install_with_resources
  end
end
