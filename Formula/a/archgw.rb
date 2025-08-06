class Archgw < Formula
  include Language::Python::Virtualenv

  desc "CL for Arch Gateway"
  homepage "https://github.com/katanemo/archgw/tree/main/arch/tools"
  url "https://files.pythonhosted.org/packages/75/22/1fcf44dc8393382fe62ef6c28a108498ed1ee1a964174e39191cb6f5c133/archgw-0.3.7.tar.gz"
  sha256 "b8c69fcb3844beaaafcbc15b151e65d7acf49951402ecd5ec468cc0c509cb943"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "b55d912a9641960a52c84d61b0113209a81d2a2925be14fe07b42c52c8f71ebc"
    sha256 cellar: :any,                 arm64_sonoma:  "70e4f93e25a7ade78915447753edbdc74ff918e9dae2c30d9ccaf28a7c40bc1a"
    sha256 cellar: :any,                 ventura:       "1e4164890a2286664f722799fea00aa140fd8a9a8f419f2fdd018f54e2d03110"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6bf115670b047702ed49ce629140e7cadc204d7a140bdffd6c9d791362995cd"
  end

  depends_on "rust" => :build # for pydantic
  depends_on "certifi"
  depends_on "libyaml"
  depends_on "numpy"
  depends_on "python@3.13"
  depends_on "pytorch"

  resource "accelerate" do
    url "https://files.pythonhosted.org/packages/c4/25/969456a95a90ed38f73f68d0f0915bdf1d76145d05054c59ad587b171150/accelerate-1.9.0.tar.gz"
    sha256 "0e8c61f81af7bf37195b6175a545ed292617dd90563c88f49020aea5b6a0b47f"
  end

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/ee/67/531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5/annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/f1/b4/636b3b65173d3ce9a38ef5f0522789614e590dab6a8d505340a4efe4c567/anyio-4.10.0.tar.gz"
    sha256 "3f3fae35c96039744587aa5b8371e7e8e603c0702999535961dd336026973ba6"
  end

  resource "archgw-modelserver" do
    url "https://files.pythonhosted.org/packages/1d/84/3832a1c79bd9b7eaf2e916286ecf2cfa71ae8d58a05b8135235409e620c5/archgw_modelserver-0.3.7.tar.gz"
    sha256 "0bba550e7b29deec0d84fe4b1bf868212673df35f590553edbda37dd00aa8f3c"
  end

  resource "asgiref" do
    url "https://files.pythonhosted.org/packages/90/61/0aa957eec22ff70b830b22ff91f825e70e1ef732c06666a805730f28b36b/asgiref-3.9.1.tar.gz"
    sha256 "a5ab6582236218e5ef1648f242fd9f10626cfd4de8dc377db215d5d5098e3142"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/5a/b0/1367933a8532ee6ff8d63537de4f1177af4bff9f3e829baf7331f595bb24/attrs-25.3.0.tar.gz"
    sha256 "75d7cefc7fb576747b2c81b4442d4d4a1ce0900973527c011d1030fd3bf4af1b"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e4/33/89c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12d/charset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/60/6c/8ca2efa64cf75a977a0d7fac081354553ebe483345c734fb6b6515d96bbc/click-8.2.1.tar.gz"
    sha256 "27c491cc05d968d271d5a1db13e3b5a184636d9d930f148c50b038f0d0646202"
  end

  resource "dateparser" do
    url "https://files.pythonhosted.org/packages/a9/30/064144f0df1749e7bb5faaa7f52b007d7c2d08ec08fed8411aba87207f68/dateparser-1.2.2.tar.gz"
    sha256 "986316f17cb8cdc23ea8ce563027c5ef12fc725b6fb1d137c14ca08777c5ecf7"
  end

  resource "deprecated" do
    url "https://files.pythonhosted.org/packages/98/97/06afe62762c9a8a86af0cfb7bfdab22a43ad17138b07af5b1a58442690a2/deprecated-1.2.18.tar.gz"
    sha256 "422b6f6d859da6f2ef57857761bfb392480502a64c3028ca9bbe86085d72115d"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/fc/f8/98eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3/distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "fastapi" do
    url "https://files.pythonhosted.org/packages/7b/5e/bf0471f14bf6ebfbee8208148a3396d1a23298531a6cc10776c59f4c0f87/fastapi-0.115.0.tar.gz"
    sha256 "f93b4ca3529a8ebc6fc3fcf710e5efa8de3df9b41570958abf1d97d843138004"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/0a/10/c23352565a6544bdc5353e0b15fc1c563352101f30e24bf500207a54df9a/filelock-3.18.0.tar.gz"
    sha256 "adbc88eabb99d2fec8c9c1b229b171f18afa655400173ddc653d5d01501fb9f2"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/39/24/33db22342cf4a2ea27c9955e6713140fedd51e8b141b5ce5260897020f1a/googleapis_common_protos-1.70.0.tar.gz"
    sha256 "0e1b44e0ea153e6594f9f394fef15193a68aaaea2d843f83e2742717ca753257"
  end

  resource "grpcio" do
    url "https://files.pythonhosted.org/packages/38/b4/35feb8f7cab7239c5b94bd2db71abb3d6adb5f335ad8f131abb6060840b6/grpcio-1.74.0.tar.gz"
    sha256 "80d1f4fbb35b0742d3e3d3bb654b7381cd5f015f8497279a1e9c21ba623e01b1"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "hf-xet" do
    url "https://files.pythonhosted.org/packages/b2/0a/a0f56735940fde6dd627602fec9ab3bad23f66a272397560abd65aba416e/hf_xet-1.1.7.tar.gz"
    sha256 "20cec8db4561338824a3b5f8c19774055b04a8df7fff0cb1ff2cb1a0c1607b80"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/06/94/82699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cb/httpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/78/82/08f8c936781f67d9e6b9eeb8a0c8b4e406136ea4c3d1f89a5db71d42e0e6/httpx-0.27.2.tar.gz"
    sha256 "f7c2be1d2f3c3c3160d441802406b206c2b76f5947b11115e6df10c6c65e66c2"
  end

  resource "huggingface-hub" do
    url "https://files.pythonhosted.org/packages/91/b4/e6b465eca5386b52cf23cb6df8644ad318a6b0e12b4b96a7e0be09cbfbcc/huggingface_hub-0.34.3.tar.gz"
    sha256 "d58130fd5aa7408480681475491c0abd7e835442082fbc3ef4d45b6c39f83853"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/cd/12/33e59336dca5be0c398a7482335911a33aa0e20776128f038019f1a95f1b/importlib_metadata-8.5.0.tar.gz"
    sha256 "71522656f0abace1d072b9e5481a48f07c138e00f079c38c8f883823f9c26bd7"
  end

  resource "iniconfig" do
    url "https://files.pythonhosted.org/packages/f2/97/ebf4da567aa6827c909642694d71c9fcf53e5b504f2d96afea02718862f3/iniconfig-2.1.0.tar.gz"
    sha256 "3abbd2e30b36733fee78f9c7f7308f2d0050e88f0087fd25c2645f63c773e1c7"
  end

  resource "jiter" do
    url "https://files.pythonhosted.org/packages/ee/9d/ae7ddb4b8ab3fb1b51faf4deb36cb48a4fbbd7cb36bad6a5fca4741306f7/jiter-0.10.0.tar.gz"
    sha256 "07a7142c38aacc85194391108dc91b5b57093c978a9932bd86a36862759d9500"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/d5/00/a297a868e9d0784450faa7365c2172a7d6110c763e30ba861867c32ae6a9/jsonschema-4.25.0.tar.gz"
    sha256 "e63acf5c11762c0e6672ffb61482bdf57f0876684d8d249c0fe2d730d48bc55f"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/bf/ce/46fbd9c8119cfc3581ee5643ea49464d168028cfb5caff5fc0596d0cf914/jsonschema_specifications-2025.4.1.tar.gz"
    sha256 "630159c9f4dbea161a6a2205c3011cc4f18ff381b189fff48bb39b9bf26ae608"
  end

  resource "openai" do
    url "https://files.pythonhosted.org/packages/03/30/f0fb7907a77e733bb801c7bdcde903500b31215141cdb261f04421e6fbec/openai-1.99.1.tar.gz"
    sha256 "2c9d8e498c298f51bb94bcac724257a3a6cac6139ccdfc1186c6708f7a93120f"
  end

  resource "opentelemetry-api" do
    url "https://files.pythonhosted.org/packages/51/34/e4e9245c868c6490a46ffedf6bd5b0f512bbc0a848b19e3a51f6bbad648c/opentelemetry_api-1.28.2.tar.gz"
    sha256 "ecdc70c7139f17f9b0cf3742d57d7020e3e8315d6cffcdf1a12a905d45b19cc0"
  end

  resource "opentelemetry-exporter-otlp" do
    url "https://files.pythonhosted.org/packages/8a/eb/ad88c61b4e51cdd294ad4ae7c45b35120fb381eb019675954c4fc15b6c4c/opentelemetry_exporter_otlp-1.28.2.tar.gz"
    sha256 "45f8d7fe4cdd41526464b542ce91b1fd1ae661be92d2c6cba71a3d948b2bdf70"
  end

  resource "opentelemetry-exporter-otlp-proto-common" do
    url "https://files.pythonhosted.org/packages/60/cd/cd990f891b64e7698b8a6b6ab90dfac7f957db5a3d06788acd52f73ad4c0/opentelemetry_exporter_otlp_proto_common-1.28.2.tar.gz"
    sha256 "7aebaa5fc9ff6029374546df1f3a62616fda07fccd9c6a8b7892ec130dd8baca"
  end

  resource "opentelemetry-exporter-otlp-proto-grpc" do
    url "https://files.pythonhosted.org/packages/f7/4c/b5374467e97f2b290611de746d0e6cab3a07aec865d6b99d11535cd60059/opentelemetry_exporter_otlp_proto_grpc-1.28.2.tar.gz"
    sha256 "07c10378380bbb01a7f621a5ce833fc1fab816e971140cd3ea1cd587840bc0e6"
  end

  resource "opentelemetry-exporter-otlp-proto-http" do
    url "https://files.pythonhosted.org/packages/b1/91/4e32e52d13dbdf9560bc095dfe66a2c09e0034a886f7725fcda8fe10a052/opentelemetry_exporter_otlp_proto_http-1.28.2.tar.gz"
    sha256 "d9b353d67217f091aaf4cfe8693c170973bb3e90a558992570d97020618fda79"
  end

  resource "opentelemetry-instrumentation" do
    url "https://files.pythonhosted.org/packages/6f/1f/9fa51f6f64f4d179f4e3370eb042176ff7717682428552f5e1f4c5efcc09/opentelemetry_instrumentation-0.49b2.tar.gz"
    sha256 "8cf00cc8d9d479e4b72adb9bd267ec544308c602b7188598db5a687e77b298e2"
  end

  resource "opentelemetry-instrumentation-asgi" do
    url "https://files.pythonhosted.org/packages/84/42/079079bd7c0423bfab987a6457e34468b6ddccf501d3c91d2795c200d65d/opentelemetry_instrumentation_asgi-0.49b2.tar.gz"
    sha256 "2af5faf062878330714efe700127b837038c4d9d3b70b451ab2424d5076d6c1c"
  end

  resource "opentelemetry-instrumentation-fastapi" do
    url "https://files.pythonhosted.org/packages/87/ed/a1275d5aac63edfad0afb012d2d5917412f09ac5f773c86b465b2b0d2549/opentelemetry_instrumentation_fastapi-0.49b2.tar.gz"
    sha256 "3aa81ed7acf6aa5236d96e90a1218c5e84a9c0dce8fa63bf34ceee6218354b63"
  end

  resource "opentelemetry-proto" do
    url "https://files.pythonhosted.org/packages/d0/45/96c4f34c79fd87dc8a1c0c432f23a5a202729f21e4e63c8b36fc8e57767a/opentelemetry_proto-1.28.2.tar.gz"
    sha256 "7c0d125a6b71af88bfeeda16bfdd0ff63dc2cf0039baf6f49fa133b203e3f566"
  end

  resource "opentelemetry-sdk" do
    url "https://files.pythonhosted.org/packages/4b/f4/840a5af4efe48d7fb4c456ad60fd624673e871a60d6494f7ff8a934755d4/opentelemetry_sdk-1.28.2.tar.gz"
    sha256 "5fed24c5497e10df30282456fe2910f83377797511de07d14cec0d3e0a1a3110"
  end

  resource "opentelemetry-semantic-conventions" do
    url "https://files.pythonhosted.org/packages/7d/0a/e3b93f94aa3223c6fd8e743502a1fefd4fb3a753d8f501ce2a418f7c0bd4/opentelemetry_semantic_conventions-0.49b2.tar.gz"
    sha256 "44e32ce6a5bb8d7c0c617f84b9dc1c8deda1045a07dc16a688cc7cbeab679997"
  end

  resource "opentelemetry-util-http" do
    url "https://files.pythonhosted.org/packages/96/28/ac5b1a0fd210ecb6c86c5e04256ba09c8308eb41e116097b9e2714d4b8dd/opentelemetry_util_http-0.49b2.tar.gz"
    sha256 "5958c7009f79146bbe98b0fdb23d9d7bf1ea9cd154a1c199029b1a89e0557199"
  end

  resource "overrides" do
    url "https://files.pythonhosted.org/packages/36/86/b585f53236dec60aba864e050778b25045f857e17f6e5ea0ae95fe80edd2/overrides-7.7.0.tar.gz"
    sha256 "55158fa3d93b98cc75299b1e67078ad9003ca27945c76162c1c0766d6f91820a"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f9/e2/3e91f31a7d2b083fe6ef3fa267035b518369d9511ffab804f839851d2779/pluggy-1.6.0.tar.gz"
    sha256 "7dcc130b76258d33b90f61b658791dede3486c3e6bfb003ee5c9bfb396dd22f3"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/43/29/d09e70352e4e88c9c7a198d5645d7277811448d76c23b00345670f7c8a38/protobuf-5.29.5.tar.gz"
    sha256 "bc1463bafd4b0929216c35f437a8e28731a2b7fe3d98bb77a600efced5a15c84"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/2a/80/336820c1ad9286a4ded7e845b2eccfcb27851ab8ac6abece774a6ff4d3de/psutil-7.0.0.tar.gz"
    sha256 "7be9c3eba38beccb6495ea33afd982a44074b78f28c434a1f51cc07fd315c456"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/00/dd/4325abf92c39ba8623b5af936ddb36ffcfe0beae70405d456ab1fb2f5b8c/pydantic-2.11.7.tar.gz"
    sha256 "d989c3c6cb79469287b1569f7447a17848c998458d49ebe294e975b9baf0f0db"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/ad/88/5f2260bdfae97aabf98f1778d43f69574390ad787afb646292a638c923d4/pydantic_core-2.33.2.tar.gz"
    sha256 "7cb8bc3605c29176e1b105350d2e6474142d7c1bd1d9327c4a9bdb46bf827acc"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "pytest" do
    url "https://files.pythonhosted.org/packages/08/ba/45911d754e8eba3d5a841a5ce61a65a685ff1798421ac054f85aa8747dfb/pytest-8.4.1.tar.gz"
    sha256 "7c67fd69174877359ed9371ec3af8a3d2b04741818c51e5e99cc1742251fa93c"
  end

  resource "pytest-asyncio" do
    url "https://files.pythonhosted.org/packages/4e/51/f8794af39eeb870e87a8c8068642fc07bce0c854d6865d7dd0f2a9d338c2/pytest_asyncio-1.1.0.tar.gz"
    sha256 "796aa822981e01b68c12e4827b8697108f7205020f24b5793b3c41555dab68ea"
  end

  resource "pytest-httpserver" do
    url "https://files.pythonhosted.org/packages/f1/d8/def15ba33bd696dd72dd4562a5287c0cba4d18a591eeb82e0b08ab385afc/pytest_httpserver-1.1.3.tar.gz"
    sha256 "af819d6b533f84b4680b9416a5b3f67f1df3701f1da54924afd4d6e4ba5917ec"
  end

  resource "pytest-retry" do
    url "https://files.pythonhosted.org/packages/c5/5b/607b017994cca28de3a1ad22a3eee8418e5d428dcd8ec25b26b18e995a73/pytest_retry-1.7.0.tar.gz"
    sha256 "f8d52339f01e949df47c11ba9ee8d5b362f5824dff580d3870ec9ae0057df80f"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
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
    url "https://files.pythonhosted.org/packages/e1/0a/929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8/requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/a5/aa/4456d84bbb54adc6a916fb10c9b374f78ac840337644e4a5eda229c81275/rpds_py-0.26.0.tar.gz"
    sha256 "20dae58a859b0906f0685642e591056f1e787f3a8b39c8e8749a45dc7d26bdb0"
  end

  resource "safetensors" do
    url "https://files.pythonhosted.org/packages/6c/d2/94fe37355a1d4ff86b0f43b9a018515d5d29bf7ad6d01318a80f5db2fd6a/safetensors-0.6.1.tar.gz"
    sha256 "a766ba6e19b198eff09be05f24cd89eda1670ed404ae828e2aa3fc09816ba8d8"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/42/b4/e25c3b688ef703d85e55017c6edd0cbf38e5770ab748234363d54ff0251a/starlette-0.38.6.tar.gz"
    sha256 "863a1588f5574e70a821dadefb41e4881ea451a47a3cd1b4df359d4ffefe5ead"
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
    url "https://files.pythonhosted.org/packages/27/5d/f7dc746eef83336a6b34197311fe0c1da0d1192f637c726c6a5cf0d83502/transformers-4.55.0.tar.gz"
    sha256 "15aa138a05d07a15b30d191ea2c45e23061ebf9fcc928a1318e03fe2234f3ae1"
  end

  resource "typing-inspection" do
    url "https://files.pythonhosted.org/packages/f8/b1/0c11f5058406b3af7609f121aaa6b609744687f1d158b3c3a5bf4cc94238/typing_inspection-0.4.1.tar.gz"
    sha256 "6ae134cc0203c33377d43188d4064e9b357dba58cff3185f22924610e70a9d28"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/8b/2e/c14812d3d4d9cd1773c6be938f89e5735a1f11a9f184ac3639b93cef35d5/tzlocal-5.3.1.tar.gz"
    sha256 "cceffc7edecefea1f595541dbd6e990cb1ea3d19bf01b2809f362a03dd7921fd"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/0a/96/ee52d900f8e41cc35eaebfda76f3619c2e45b741f3ee957d6fe32be1b2aa/uvicorn-0.31.0.tar.gz"
    sha256 "13bc21373d103859f68fe739608e2eb054a816dea79189bc3ca08ea89a275906"
  end

  resource "werkzeug" do
    url "https://files.pythonhosted.org/packages/9f/69/83029f1f6300c5fb2471d621ab06f6ec6b3324685a2ce0f9777fd4a8b71e/werkzeug-3.1.3.tar.gz"
    sha256 "60723ce945c19328679790e3282cc758aa4a6040e4bb330f53d30fa546d44746"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/c3/fc/e91cc220803d7bc4db93fb02facd8461c37364151b8494762cc88b0fbcef/wrapt-1.17.2.tar.gz"
    sha256 "41388e9d4d1522446fe79d3213196bd9e3b301a336965b9e27ca2788ebd122f3"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/e3/02/0f2892c661036d50ede074e376733dca2ae7c6eb617489437771209d4180/zipp-3.23.0.tar.gz"
    sha256 "a07157588a12518c9d4034df3fbbee09c814741a33ff63c05fa29d26a2404166"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/archgw --version")

    output = shell_output("#{bin}/archgw up 2>&1")
    assert_match "INFO - Error: #{testpath}/arch_config.yaml does not exist.", output
  end
end
