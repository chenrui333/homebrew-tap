class Deepteam < Formula
  include Language::Python::Virtualenv

  desc "LLM Red Teaming Framework"
  homepage "https://github.com/confident-ai/deepteam"
  url "https://files.pythonhosted.org/packages/11/eb/def5b5461d6a6483a3495b489b28aa72228ff8622b6bb9ace17d2774af90/deepteam-1.0.9.tar.gz"
  sha256 "d44fb6bc34f02e4ac17cce459bcb9d1590c5589337597b609c4442578336e641"
  license "Apache-2.0"
  revision 2

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "9f06cc2c9707fcf5d8c0817260079d6a7e19c9e6183e9a3eca6ff45215204ff1"
    sha256 cellar: :any, arm64_sequoia: "b309b535865f56b4c6d9826281876ae4d63d4c03ad1c396f708de012d9261fab"
    sha256 cellar: :any, arm64_linux:   "07a39024655018d067e9e4d87f7c99118cadb29add411b0b9400ce576302c4be"
    sha256 cellar: :any, x86_64_linux:  "e7e6e049a190e2f01bd3d4e93a4c4ed651dc5ced013a9b101cd2a1e440e4ea5c"
  end

  depends_on "maturin" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build # for jiter, pydantic-core and uv-build
  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.13"

  # Core's Pydantic extension targets Python 3.14; Deepteam still requires Python <3.14.
  pypi_packages exclude_packages: %w[certifi],
                extra_packages:   %w[
                  calver cython>=3.2 dunamai expandvars flit-core<4 hatch-fancy-pypi-readme hatch-vcs hatchling
                  pdm-backend pkgconfig poetry-core setuptools>=84.1 setuptools-scm tomlkit~=0.13.0
                  trove-classifiers uv-build>=0.11,<0.13 uv-dynamic-versioning vcs-versioning
                ]

  resource "aiohappyeyeballs" do
    url "https://files.pythonhosted.org/packages/ce/f4/eec0465c2f67b2664688d0240b3212d5196fd89e741df67ddb81f8d35658/aiohappyeyeballs-2.7.1.tar.gz"
    sha256 "065665c041c42a5938ed220bdcd7230f22527fbec085e1853d2402c8a3615d9d"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/6c/4c/bdccd81e9ee225b69c60e7766c9a5b05364f118f4d383713b89a682d772d/aiohttp-3.14.5.tar.gz"
    sha256 "5558a7f5a05af9ecf744af91e5baefc436f93c9333e656c27ec253f9a6bbe178"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/61/62/06741b579156360248d1ec624842ad0edf697050bbaf7c3e46394e106ad1/aiosignal-1.4.0.tar.gz"
    sha256 "f47eecd9468083c2029cc99945502cb7708b082c232f9aca65da147157b251c7"
  end

  resource "annotated-doc" do
    url "https://files.pythonhosted.org/packages/5a/8e/38aa427ed5402449e226975b649c5dc73ccadfefeb95e6aecb8f8ea4b6b6/annotated_doc-0.0.5.tar.gz"
    sha256 "c7e58ce09192557605d8bbd92836d7e1d520ac9580096042c0bfd197efacf1bb"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/61/cc/a381afa6efea9f496eff839d4a6a1aed3bfafc7b3ab4b0d1b243a12573dd/anyio-4.14.2.tar.gz"
    sha256 "cfa139f3ed1a23ee8f88a145ddb5ac7605b8bbfd8592baacd7ce3d8bb4313c7f"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "backoff" do
    url "https://files.pythonhosted.org/packages/47/d7/5bbeb12c44d7c4f2fb5b56abce497eb5ed9f34d85701de869acedd602619/backoff-2.2.1.tar.gz"
    sha256 "03f829f5bb1923180821643f8753b0502c3b682293992485b0eef2807afa5cba"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cb/31/4971872b3ed8715346231fb6eb4da8fcba65a4143c189db151ee28a2812b/charset_normalizer-3.5.0.tar.gz"
    sha256 "49bd5feb59b0bf3cbf6ebcf4352e371c95b9da9bacd4449f8b64d0ad2c10a26e"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/bb/63/f9e1ea081ce35720d8b92acde70daaedace594dc93b693c869e0d5910718/click-8.3.3.tar.gz"
    sha256 "398329ad4837b2ff7cbe1dd166a4c0f8900c3ca3a218de04466f38f6497f18a2"
  end

  resource "deepeval" do
    url "https://files.pythonhosted.org/packages/15/dc/ec35e7816e0a7d57d4c0f64f4ecf48c712b6e01bfa45499e9cc39ab3ba7a/deepeval-4.1.8.tar.gz"
    sha256 "509890a9e6d4ece2b3e68ed2441d4dc5a14f5f667027e5da4b9fb5ce45384857"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/fc/f8/98eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3/distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "execnet" do
    url "https://files.pythonhosted.org/packages/bf/89/780e11f9588d9e7128a3f87788354c7946a9cbb1401ad38a48c4db9a4f07/execnet-2.1.2.tar.gz"
    sha256 "63d83bfdd9a23e35b9c6a3261412324f964c2ec8dcd8d3c6916ee9373e0befcd"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/2d/f5/c831fac6cc817d26fd54c7eaccd04ef7e0288806943f7cc5bbf69f3ac1f0/frozenlist-1.8.0.tar.gz"
    sha256 "3ede829ed8d842f6cd48fc7081d7a41001a56f1f38603f9d49bf3020d59a31ad"
  end

  resource "grpcio" do
    url "https://files.pythonhosted.org/packages/0c/98/304898ac4e04e2d5e4e4c2eadc178b1f2a16d5f4bc2f91306c87d64680b9/grpcio-1.83.0.tar.gz"
    sha256 "7674587248fbbb2ac6e4eecf83a8a0f3d91a928f941de571acfd3a2f007fbc24"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "httpcore2" do
    url "https://files.pythonhosted.org/packages/c0/61/afa9d6b7452f9eca73f73d45324eb0bb52f098fd5e6049bf6b8263be9b4e/httpcore2-2.16.0.tar.gz"
    sha256 "c72cd0413563b17e1cd8354677dff887466f8ec2551679759e93126534428643"
  end

  resource "httpx2" do
    url "https://files.pythonhosted.org/packages/43/73/5ca2cedf5e4e50423d1c258877865a6b62793633b561c58499f8aeb33b7e/httpx2-2.16.0.tar.gz"
    sha256 "0d54c98128e8f2ff7fbbde0fca8c359e5f032edeaaaac443cdb7f31f685bcd7f"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cd/63/9496c57188a2ee585e0f1db071d75089a11e98aa86eb99d9d7618fc1edce/idna-3.18.tar.gz"
    sha256 "ffb385a7e039654cef1ab9ef32c6fafe283c0c0467bba1d9029738ce4a14a848"
  end

  resource "iniconfig" do
    url "https://files.pythonhosted.org/packages/72/34/14ca021ce8e5dfedc35312d08ba8bf51fdd999c576889fc2c24cb97f4f10/iniconfig-2.3.0.tar.gz"
    sha256 "c76315c77db068650d49c5b56314774a7804df16fee4402c1f19d6d15d8c4730"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "jiter" do
    url "https://files.pythonhosted.org/packages/1d/1f/10936e16d8860c70698a1aa939a46aa0224813b782bce4e000e637da0b2d/jiter-0.16.0.tar.gz"
    sha256 "7b24c3492c5f4f84a37946ad9cf504910cf6a782d6a4e0689b6673c5894b4a1c"
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

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/7b/6b/29ef8e752f5854dcc267ded0652c475bec99b86f255957a0d4fcad657b18/multidict-7.2.1.tar.gz"
    sha256 "e8af3e6f1bdbc31fd762b094133b478b89988eaebc63cbe82b1d9e3bbd15cede"
  end

  resource "nest-asyncio" do
    url "https://files.pythonhosted.org/packages/83/f8/51569ac65d696c8ecbee95938f89d4abf00f47d58d48f6fbabfe8f0baefe/nest_asyncio-1.6.0.tar.gz"
    sha256 "6f172d5449aca15afd6c646851f4e31e02c598d553a667e38cafa997cfec55fe"
  end

  resource "openai" do
    url "https://files.pythonhosted.org/packages/54/8c/2f500e8be09d1ae98c530467962535198b02cd4550cd418bbbaedc8b2910/openai-3.0.0.tar.gz"
    sha256 "ffd00ef1678d70957e1f1ed98d5bfcf1d661f41ea4482f22e7d0144a66435a49"
  end

  resource "opentelemetry-api" do
    url "https://files.pythonhosted.org/packages/19/14/cf3a6b6448849656e1e5f4e2101f3988dc6789724050096aba1bc5ccf592/opentelemetry_api-1.45.2.tar.gz"
    sha256 "d7b0008e21e5fd61cbe7a7f34ca3b6905a78ab677d9bc395e299359c75cda6b4"
  end

  resource "opentelemetry-sdk" do
    url "https://files.pythonhosted.org/packages/7b/1a/74a21d4d6969fb8b432ac397e66112a8167a6deb267ea4559dbaf2fe91ef/opentelemetry_sdk-1.45.2.tar.gz"
    sha256 "7eec4de13dd21ff3a1670dcb0e02079e692736f94d733dfdce5af461d884248d"
  end

  resource "opentelemetry-semantic-conventions" do
    url "https://files.pythonhosted.org/packages/37/3f/50f95972b50e8e353f5b9342034c9cd17730f1956f009ce6a3fbbd89f9ce/opentelemetry_semantic_conventions-0.66b2.tar.gz"
    sha256 "7da5f1a5dc4383eb66711d4d3d3e71824d9403ac1559fea021cc103c1a4c4976"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f9/e2/3e91f31a7d2b083fe6ef3fa267035b518369d9511ffab804f839851d2779/pluggy-1.6.0.tar.gz"
    sha256 "7dcc130b76258d33b90f61b658791dede3486c3e6bfb003ee5c9bfb396dd22f3"
  end

  resource "portalocker" do
    url "https://files.pythonhosted.org/packages/45/f7/24b2821a077e0d85197a8c4093a4f71f78713d0a6f216c3f7cc90f7a5cc4/portalocker-4.1.0.tar.gz"
    sha256 "91d0ff02d6f5f9a2dbf1ef1367ddb05b83136b2676707a1b2c8746f1f0dcd992"
  end

  resource "posthog" do
    url "https://files.pythonhosted.org/packages/43/34/bcfb02b1dc9db531e7283222b8819b201efd6e0d813bf8f7d2e7872de32d/posthog-7.38.6.tar.gz"
    sha256 "c12ea1b539d51c03c18e361344355c407be736dc55840f8a92fd454039a9796d"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/7d/ea/39b988c938f75cb75d7045b5c69f8bfed47ee2152c8837fb403de29d6fb8/prompt_toolkit-3.0.53.tar.gz"
    sha256 "9ec8a0ad96d5c56148b3f914aa79c1564c3fde5d2e6b876e7bc327e353cf8fa6"
  end

  resource "propcache" do
    url "https://files.pythonhosted.org/packages/ec/44/c87281c333769159c50594f22610f77398a47ccbfbbf23074e744e86f87c/propcache-0.5.2.tar.gz"
    sha256 "01c4fc7480cd0598bb4b57022df55b9ca296da7fc5a8760bd8451a7e63a7d427"
  end

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/5f/56/a8120250d128bed162cd73c76d45f6ef9991f3e068f62a8ee060afa3104a/annotated_types-0.8.0.tar.gz"
    sha256 "13b2beaad985e05e2d6407ee4c4f35590b11f8d693a258a561055cac8f64cab7"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/b4/fc/1203d011145c98ddce3cd2f505bb54375ef8d43223053df6bfcf3c746f46/pydantic-2.14.3.tar.gz"
    sha256 "1054f237f4d4733e5a30e1e2333bd33a2004ab9ab1510bd053a9a31bb48e232d"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/9c/0f/34f9ce4ba701dd0b815033ef94d99b56f66200e578ee6052aa3ac26f064e/pydantic_core-2.50.4.tar.gz"
    sha256 "aead3b74b68396bf0feab5d57e050b730ded7df55853c1e048a87e00aaf033c6"
  end

  resource "pydantic-settings" do
    url "https://files.pythonhosted.org/packages/68/ca/31c57507b13119d7d3cfa1576dad2911a4861e3be07b579395f4e9d393f9/pydantic_settings-2.15.0.tar.gz"
    sha256 "694b793e84f766ba76a90ebdefc01d0a9a045dab0382bee70393da93712ad117"
  end

  resource "pyfiglet" do
    url "https://files.pythonhosted.org/packages/c8/e3/0a86276ad2c383ce08d76110a8eec2fe22e7051c4b8ba3fa163a0b08c428/pyfiglet-1.0.4.tar.gz"
    sha256 "db9c9940ed1bf3048deff534ed52ff2dafbbc2cd7610b17bb5eca1df6d4278ef"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  end

  resource "pytest" do
    url "https://files.pythonhosted.org/packages/e4/47/b9efed96c114afcfa3c9d3fe98a76a1d14c74a9e266d397cf6eb64be5e01/pytest-9.1.1.tar.gz"
    sha256 "1088fbde8f2b49d95a549a195707afa7a76a3ce9bcadc26b6d71f0ffda5fe313"
  end

  resource "pytest-asyncio" do
    url "https://files.pythonhosted.org/packages/43/7c/d36d04db312ecf4298932ef77e6e4a9e8ad017906e24e34f0b0c361a2473/pytest_asyncio-1.4.0.tar.gz"
    sha256 "c6c0d2259945122819f171a32ecea2c349ead889ee28176caaf492143424be42"
  end

  resource "pytest-repeat" do
    url "https://files.pythonhosted.org/packages/80/d4/69e9dbb9b8266df0b157c72be32083403c412990af15c7c15f7a3fd1b142/pytest_repeat-0.9.4.tar.gz"
    sha256 "d92ac14dfaa6ffcfe6917e5d16f0c9bc82380c135b03c2a5f412d2637f224485"
  end

  resource "pytest-rerunfailures" do
    url "https://files.pythonhosted.org/packages/47/60/a90ca1cc6cffcb97b4260ed0ad2b7934b999d7c48abe4ea0840344862a3b/pytest_rerunfailures-16.4.tar.gz"
    sha256 "8222d17c37eb7b9e4d6fc96a3c724ff4e1a5c97a5cc7cbb2c19e9282cfd21a11"
  end

  resource "pytest-xdist" do
    url "https://files.pythonhosted.org/packages/78/b4/439b179d1ff526791eb921115fca8e44e596a13efeda518b9d845a619450/pytest_xdist-3.8.0.tar.gz"
    sha256 "7e578125ec9bc6050861aa93f2d59f1d8d085595d6551c2c90b6f4fad8d3a9f1"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/82/ed/0301aeeac3e5353ef3d94b6ec08bbcabd04a72018415dcb29e588514bba8/python_dotenv-1.2.2.tar.gz"
    sha256 "2c371a91fbd7ba082c2c1dc1f8bf89ca22564a087c2c287cd9b662adde799cf3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "questionary" do
    url "https://files.pythonhosted.org/packages/f6/45/eafb0bba0f9988f6a2520f9ca2df2c82ddfa8d67c95d6625452e97b204a5/questionary-2.1.1.tar.gz"
    sha256 "3d7e980292bb0107abaa79c68dd3eee3c561b83a0f89ae482860b181c8bd412d"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/e9/67/cae617f1351490c25a4b8ac3b8b63a4dda609295d8222bad12242dfdc629/rich-14.3.4.tar.gz"
    sha256 "817e02727f2b25b40ef56f5aa2217f400c8489f79ca8f46ea2b70dd5e14558a9"
  end

  resource "sentry-sdk" do
    url "https://files.pythonhosted.org/packages/60/31/b7341f156a5f6f36f0b4845d6f1c28a2ae4799171dba7007f3a1e9b234b4/sentry_sdk-2.64.0.tar.gz"
    sha256 "68be2c29e14ae310f8a39e1a79916b6d85c6cb41dcce789d14ff05fe293e4c55"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/70/b3/c19426f783614d625699a4b247faf628ea9ab1db228674491767b417f9e1/setuptools-84.2.1.tar.gz"
    sha256 "3ff8b3b5492a0aa66960f4419365a86b84e013070d4313e4d4a6894f5d64d6bc"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/58/15/8b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58e/shellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/ec/fe/802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1/tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "tenacity" do
    url "https://files.pythonhosted.org/packages/47/c6/ee486fd809e357697ee8a44d3d69222b344920433d3b6666ccd9b374630c/tenacity-9.1.4.tar.gz"
    sha256 "adb31d4c263f2bd041081ab33b498309a57c77f9acf2db65aadf0898179cf93a"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/21/3b/6c24bec5be5e743ffd99576daa5cc077722fc7d5bbc00bd133fa0c698dc6/tqdm-4.70.0.tar.gz"
    sha256 "55b0b0dbd97462d06ebee91e4dac24ed4d4702be82b24f07e6c1d27e08cea220"
  end

  resource "truststore" do
    url "https://files.pythonhosted.org/packages/53/a3/1585216310e344e8102c22482f6060c7a6ea0322b63e026372e6dcefcfd6/truststore-0.10.4.tar.gz"
    sha256 "9d91bd436463ad5e4ee4aba766628dd6cd7010cf3e2461756b3303710eebc301"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/ae/40/4a3db7990d1f62a53182aa96eaef57aeb2886a27f90a195bc66713565d31/typer-0.27.1.tar.gz"
    sha256 "a79bef8469a79c45498e7b814ecf8d603cc7644e9acbd9e19cac0334240b18df"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "typing-inspection" do
    url "https://files.pythonhosted.org/packages/ff/50/0195198eb1d75bab716bb0a813abea4cc394bfa17a92a189f021a34859af/typing_inspection-0.4.5.tar.gz"
    sha256 "7f16c411e7930dc79596d42ab44672a3fe5f60eb34b781a1647e7872363120c7"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/34/74/c6428f875774288bec1396f5bfcbc2d925700a4dad61727fd5f2b12f249d/wcwidth-0.8.2.tar.gz"
    sha256 "91fbef97204b96a3d4d421609b80340b760cf33e26da123ff243d76b1fda8dda"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/d0/20/50ed6bdf27dec98b568a8ae25dc599f35baa3d9709f9e83fd1edb56b9a90/wheel-0.48.0.tar.gz"
    sha256 "94800765601e9171bf5d58d066e640662842bcedcbab982b2c90787a2c987322"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/75/16/e8be8e2fb175bbf41a0680381a319f1199fae256588241a2ac8677eafb49/yarl-1.25.1.tar.gz"
    sha256 "03dd38de09bc213e9a8b29761eec33ee1d5318dac0e49d8af36e4d27830e23a7"
  end

  resource "cython" do
    url "https://files.pythonhosted.org/packages/99/ca/18e324972e5cac914816fdd7bb03e19a455b90039c277a538f7781b50c85/cython-3.3.1.tar.gz"
    sha256 "e0e45989e821bef6aa9ae15c7d583ab5e055f7406c4b3624e49e06d24e90375a"
  end

  resource "dunamai" do
    url "https://files.pythonhosted.org/packages/12/18/020d3b27a10450ddb11429f637404e8ea67ecf4d9fd999d4f1d553f25506/dunamai-1.26.2.tar.gz"
    sha256 "84ea45eddf9bb4b40df7610b1b22a03137365e6257dbf9d7b72128fdccca564c"
  end

  resource "expandvars" do
    url "https://files.pythonhosted.org/packages/9c/64/a9d8ea289d663a44b346203a24bf798507463db1e76679eaa72ee6de1c7a/expandvars-1.1.2.tar.gz"
    sha256 "6c5822b7b756a99a356b915dd1267f52ab8a4efaa135963bd7f4bd5d368f71d7"
  end

  resource "flit-core" do
    url "https://files.pythonhosted.org/packages/69/59/b6fc2188dfc7ea4f936cd12b49d707f66a1cb7a1d2c16172963534db741b/flit_core-3.12.0.tar.gz"
    sha256 "18f63100d6f94385c6ed57a72073443e1a71a4acb4339491615d0f16d6ff01b2"
  end

  resource "hatch-fancy-pypi-readme" do
    url "https://files.pythonhosted.org/packages/f3/0f/aed57c301f339936eb91cb4d8c1e5088a101081854bd3ec18a889df32365/hatch_fancy_pypi_readme-25.1.0.tar.gz"
    sha256 "9c58ed3dff90d51f43414ce37009ad1d5b0f08ffc9fc216998a06380f01c0045"
  end

  resource "hatch-vcs" do
    url "https://files.pythonhosted.org/packages/6b/b0/4cc743d38adbee9d57d786fa496ed1daadb17e48589b6da8fa55717a0746/hatch_vcs-0.5.0.tar.gz"
    sha256 "0395fa126940340215090c344a2bf4e2a77bcbe7daab16f41b37b98c95809ff9"
  end

  resource "hatchling" do
    url "https://files.pythonhosted.org/packages/f6/97/b5312f01a8c6daf729a9d272dd442e0c546dbcc630495788786c4b567ed0/hatchling-1.32.4.tar.gz"
    sha256 "c4468f73144c054d2aab4ef0f0378c43b9878bf07f8ffd6b79690e970d375f07"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/5a/82/42f767fc1c1143d6fd36efb827202a2d997a375e160a71eb2888a925aac1/pathspec-1.1.1.tar.gz"
    sha256 "17db5ecd524104a120e173814c90367a96a98d07c45b2e10c2f3919fff91bf5a"
  end

  resource "pdm-backend" do
    url "https://files.pythonhosted.org/packages/fc/d5/a82f533ed51f91a2183faf67a1fcb3b759615ffeca95d05b3e7648bf84bf/pdm_backend-2.5.0.tar.gz"
    sha256 "7953b994563d3151755e3364b9d0cfe817ed0eaecdf27c8f777f412d26bcd98a"
  end

  resource "pkgconfig" do
    url "https://files.pythonhosted.org/packages/52/fd/0adde075cd3bfecd557bc7d757e00e231d34d8a6edb4c8d1642759254c21/pkgconfig-1.6.0.tar.gz"
    sha256 "4a5a6631ce937fafac457104a40d558785a658bbdca5c49b6295bc3fd651907f"
  end

  resource "poetry-core" do
    url "https://files.pythonhosted.org/packages/42/b5/50f1fda26c4fe5b1d6ce5cdf0391bdfa1ca12fdcb8ad68344d5cf678fc90/poetry_core-2.5.0.tar.gz"
    sha256 "81d04c9253b19d0604718268d781867c8f7b2128e5b25bbf1e84141eec6b89c4"
  end

  resource "setuptools-scm" do
    url "https://files.pythonhosted.org/packages/85/d8/fc143f88819ccf10ba2388ba86732ee2de193e578234e25a783f6cc14bf7/setuptools_scm-10.3.4.tar.gz"
    sha256 "a69f28bfc245608781205e912faae437c2b2165773afa4e7b979d77447a69dd2"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/cc/18/0bbf3884e9eaa38819ebe46a7bd25dcd56b67434402b66a58c4b8e552575/tomlkit-0.13.3.tar.gz"
    sha256 "430cf247ee57df2b94ee3fbe588e71d362a941ebb545dec29b53961d61add2a1"
  end

  resource "trove-classifiers" do
    url "https://files.pythonhosted.org/packages/bf/93/af436dfaa845cab5d96f0adbc1e4f3730532d37fa249e4eb796fb1d7fc82/trove_classifiers-2026.9.21.13.tar.gz"
    sha256 "0a9ebc8d4e2f3e8a22848c5258033035bec17a3012ac3fea16dbaa764489eb71"
  end

  # The complete official workspace retains the native backend's locked path dependencies.
  resource "uv-build" do
    url "https://github.com/astral-sh/uv/archive/70fe1196a546e49148a73b1c592b2f74c33af80e.tar.gz"
    version "0.12.22"
    sha256 "baf7d3ce272083f8e8319de164d5e143687af90da6e64b9ae5789829fbfb7340"
  end

  resource "uv-dynamic-versioning" do
    url "https://files.pythonhosted.org/packages/6f/c8/fa500ee29af69cfeeea5ff6d6597919f1989b2e3f1a236c3006bdb21d320/uv_dynamic_versioning-0.14.1.tar.gz"
    sha256 "8642db686ce5c50417035e7a257ac73b7e5c3a7a32c33e45bd7e36ba22eeb648"
  end

  resource "vcs-versioning" do
    url "https://files.pythonhosted.org/packages/6f/a0/6977bb418312ad30f27e522c5040604d4bbf7e40ccd5a11d333afe549354/vcs_versioning-2.5.0.tar.gz"
    sha256 "956a796e31f80fe714d219d6d1df15a6bf247d10f6d851bf4b98279d0a42da55"
  end

  resource "calver" do
    url "https://files.pythonhosted.org/packages/4a/96/0c57e3e228ffc54074867406b659b197678674f1f0bf600d114965289834/calver-2025.10.20.tar.gz"
    sha256 "c98b376c2424642224d456b2f70c51402343e008c63d204634665e1a2a2835f5"
  end

  # Lookup keys describe build roles; distribution names retain their upstream identities.
  resource "build-setuptools-charset" do
    self.name = "setuptools"
    url "https://files.pythonhosted.org/packages/34/26/f5d29e25ffdb535afef2d35cdb55b325298f96debd670da4c325e08d70f4/setuptools-83.0.0.tar.gz"
    sha256 "025bccbbf0fa05b6192bc64ae1e7b16e001fd6d6d4d5de03c97b1c1ade523bef"
  end

  resource "build-hatchling-openai" do
    self.name = "hatchling"
    url "https://files.pythonhosted.org/packages/e1/47/7ec270a9567262ae3cb32dd420d2b53bf7aee769aca1f240eae0426b5bbc/hatchling-1.26.3.tar.gz"
    sha256 "b672a9c36a601a06c4e88a1abb1330639ee8e721e0535a37536e546a667efc7a"
  end

  resource "build-cython-grpc" do
    self.name = "cython"
    url "https://files.pythonhosted.org/packages/5b/d3/bb000603e46144db2e5055219bbddcf7ab3b10012fcb342695694fb88141/cython-3.1.1.tar.gz"
    sha256 "505ccd413669d5132a53834d792c707974248088c4f60c497deb1b416e366397"
  end

  deny_network_access!

  def fetch
    ENV.prepend_path "PATH", formula_opt_bin("rust")
    %w[jiter pydantic-core uv-build].each do |name|
      resource(name).stage { system "cargo", "fetch", "--locked" }
    end
  end

  def install
    ENV.prepend_path "PATH", formula_opt_bin("rust")
    ENV["CARGO_NET_OFFLINE"] = "true"
    ENV["GRPC_PYTHON_BUILD_EXT_COMPILER_JOBS"] = ENV.make_jobs.to_s
    ENV.delete "PYTHONPATH"
    # Keep pip's driver outside the isolated target, even after its bin directory is on PATH.
    build_python = formula_opt_bin("python@3.13")/"python3.13"
    venv = virtualenv_create(libexec, build_python, system_site_packages: false)
    ENV.prepend_path "PATH", libexec/"bin"
    build_resources = %w[
      flit-core packaging wheel cython calver poetry-core pathspec pluggy trove-classifiers
      vcs-versioning setuptools-scm hatchling hatch-vcs hatch-fancy-pypi-readme
      expandvars pdm-backend pkgconfig markupsafe jinja2 dunamai tomlkit uv-dynamic-versioning uv-build
    ]
    # Maturin's pure Python SDK is a build input, never part of the target runtime.
    with_env(PYTHONPATH: formula_opt_prefix("maturin")/Language::Python.site_packages("python3.13")) do
      venv.pip_install resource("flit-core"), build_isolation: false
      venv.pip_install resource("build-setuptools-charset"), build_isolation: false
      %w[packaging wheel].each { |name| venv.pip_install resource(name), build_isolation: false }
      venv.pip_install resource("charset-normalizer"), build_isolation: false
      # Charset-normalizer requires setuptools<83.1; DeepEval's runtime uses the current release.
      system build_python, "-m", "pip", "--python=#{venv.root}/bin/python", "uninstall", "--yes", "setuptools"
      venv.pip_install resource("setuptools"), build_isolation: false
      # gRPC pins Cython 3.1.1; the aio-libs native backends require a newer generation.
      venv.pip_install resource("build-cython-grpc"), build_isolation: false
      venv.pip_install resource("grpcio"), build_isolation: false
      system build_python, "-m", "pip", "--python=#{venv.root}/bin/python", "uninstall", "--yes", "cython"
      %w[calver poetry-core pathspec vcs-versioning setuptools-scm pluggy trove-classifiers].each do |name|
        venv.pip_install resource(name), build_isolation: false
      end
      # OpenAI declares an exact backend; install it before the modern backend generation.
      venv.pip_install resource("build-hatchling-openai"), build_isolation: false
      venv.pip_install resource("hatch-fancy-pypi-readme"), build_isolation: false
      venv.pip_install resource("openai"), build_isolation: false
      system build_python, "-m", "pip", "--python=#{venv.root}/bin/python", "uninstall", "--yes", "hatchling"
      installed = %w[flit-core packaging wheel calver poetry-core pathspec pluggy trove-classifiers
                     vcs-versioning setuptools-scm hatch-fancy-pypi-readme uv-build]
      (build_resources - installed).each { |name| venv.pip_install resource(name), build_isolation: false }
      resource("uv-build").stage do
        venv.pip_install Pathname.pwd/"crates/uv-build", build_isolation: false
      end
      # The sdists have no VCS data. Use the version override declared by their original backend.
      %w[httpcore2 httpx2].each do |name|
        with_env(UV_DYNAMIC_VERSIONING_BYPASS: resource(name).version.to_s) do
          venv.pip_install resource(name), build_isolation: false
        end
      end
      native_resources = %w[typing-extensions annotated-types typing-inspection pydantic-core pydantic]
      native_resources.each { |name| venv.pip_install resource(name), build_isolation: false }
      installed_resources = (build_resources + %w[
        build-setuptools-charset build-hatchling-openai build-cython-grpc charset-normalizer setuptools
        openai grpcio httpcore2 httpx2
      ] + native_resources).map { |name| resource(name) }
      venv.pip_install resources - installed_resources, build_isolation: false
      venv.pip_install_and_link buildpath, build_isolation: false
      system build_python, "-m", "pip", "--python=#{venv.root}/bin/python", "uninstall", "--yes", "uv-build"
    end
    system build_python, "-m", "pip", "--python=#{venv.root}/bin/python", "check"
  end

  test do
    # The version entrypoint imports DeepEval; use its supported opt-outs before any import.
    ENV["DEEPTEAM_TELEMETRY_OPT_OUT"] = "YES"
    ENV["DEEPEVAL_TELEMETRY_OPT_OUT"] = "1"
    ENV["DEEPEVAL_DISABLE_DOTENV"] = "1"
    ENV["DEEPEVAL_UPDATE_WARNING_OPT_IN"] = "0"
    ENV["DEEPEVAL_FILE_SYSTEM"] = "READ_ONLY"
    ENV["DEEPEVAL_HOME"] = testpath/".deepeval"
    ENV["XDG_CONFIG_HOME"] = testpath/"config"
    ENV["XDG_CACHE_HOME"] = testpath/"cache"
    ENV["PYTHONNOUSERSITE"] = "1"
    ENV.delete "PYTHONPATH"
    ENV.delete "ERROR_REPORTING"
    ENV["PYTHONWARNINGS"] = "ignore::SyntaxWarning"
    assert_match version.to_s, shell_output("#{bin}/deepteam --version")

    (testpath/"config.yaml").write <<~YAML
      min_severity: high
      include:
        - owned.py
      diffs_only: true
    YAML
    build_only = %w[build-setuptools-charset build-hatchling-openai build-cython-grpc uv-build]
                 .map { |name| resource(name) }
    expected_versions = (resources - build_only).to_h { |r| [r.name, r.version.to_s] }
    (testpath/"consumer.py").write <<~PYTHON
      import importlib.machinery
      import importlib.metadata
      import json
      from pathlib import Path
      from packaging.version import Version
      import jiter
      import pydantic_core
      import yaml
      from pydantic import ValidationError
      from pydantic_core import SchemaValidator, core_schema
      from deepteam.code_scanner.config import load_config
      from deepteam.code_scanner.schema import CodeChunk

      expected = json.loads(#{expected_versions.to_json.inspect})
      for name, version in expected.items():
          assert Version(importlib.metadata.version(name)) == Version(version), name
      assert isinstance(pydantic_core._pydantic_core.__loader__, importlib.machinery.ExtensionFileLoader)
      assert pydantic_core.__version__ == #{resource("pydantic-core").version.to_s.inspect}
      validator = SchemaValidator(core_schema.int_schema(gt=0))
      assert validator.validate_json(b"7") == 7
      try:
          validator.validate_json(b"-1")
      except ValidationError as error:
          assert error.errors()[0]["type"] == "greater_than"
      else:
          raise AssertionError("native validator accepted a negative integer")

      assert yaml.__with_libyaml__
      config = load_config(path="config.yaml")
      assert config.min_severity == "high" and config.include == ["owned.py"] and config.diffs_only
      chunk = CodeChunk.model_validate_json('{"file_path":"owned.py","content":"value = 7","start_line":3}')
      assert chunk.start_line == 3 and chunk.model_dump()["content"] == "value = 7"
      try:
          CodeChunk.model_validate_json('{"file_path":"owned.py","content":"value = 7","start_line":"invalid"}')
      except ValidationError as error:
          assert error.errors()[0]["loc"] == ("start_line",)
      else:
          raise AssertionError("app schema accepted an invalid line number")
      assert jiter.from_json(b'{"owned":[1,2]}') == {"owned": [1, 2]}
      try:
          jiter.from_json(b'{"owned":')
      except ValueError:
          pass
      else:
          raise AssertionError("native JSON parser accepted incomplete JSON")
      assert not Path(".deepteam/telemetry.txt").exists()
      print("native validation and owned configuration passed")
    PYTHON
    assert_match "native validation and owned configuration passed",
                 shell_output("#{libexec}/bin/python -I #{testpath}/consumer.py")
    system formula_opt_bin("python@3.13")/"python3.13", "-m", "pip",
           "--python=#{libexec}/bin/python", "check"
  end
end
