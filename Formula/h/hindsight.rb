class Hindsight < Formula
  include Language::Python::Virtualenv

  desc "Agent memory API server that learns from past interactions"
  homepage "https://github.com/vectorize-io/hindsight"
  url "https://github.com/vectorize-io/hindsight/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "0bddb5599945c757b096a071b7d0b5fd5c5f753bd71f2bcdd435b2d43de81800"
  license "MIT"
  head "https://github.com/vectorize-io/hindsight.git", branch: "main"

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "certifi" => :no_linkage
  depends_on "cffi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "libpq"
  depends_on "libxml2"
  depends_on "libxslt"
  depends_on "libyaml"
  depends_on "numpy" => :no_linkage
  depends_on "pgvector"
  depends_on "pillow" => :no_linkage
  depends_on "postgresql@18"
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.14"
  depends_on "rpds-py" => :no_linkage

  on_macos do
    depends_on xcode: :build
  end

  on_linux do
    depends_on "gcc" => :build
    depends_on "libaio"
  end

  resource "aiofile" do
    url "https://files.pythonhosted.org/packages/67/e2/d7cb819de8df6b5c1968a2756c3cb4122d4fa2b8fc768b53b7c9e5edb646/aiofile-3.9.0.tar.gz"
    sha256 "e5ad718bb148b265b6df1b3752c4d1d83024b93da9bd599df74b9d9ffcf7919b"
  end

  resource "aiohappyeyeballs" do
    url "https://files.pythonhosted.org/packages/26/30/f84a107a9c4331c14b2b586036f40965c128aa4fee4dda5d3d51cb14ad54/aiohappyeyeballs-2.6.1.tar.gz"
    sha256 "c3f9d0113123803ccadfdf3f0faa505bc78e6a72d1cc4806cbd719826e943558"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/6c/4c/bdccd81e9ee225b69c60e7766c9a5b05364f118f4d383713b89a682d772d/aiohttp-3.14.5.tar.gz"
    sha256 "5558a7f5a05af9ecf744af91e5baefc436f93c9333e656c27ec253f9a6bbe178"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/61/62/06741b579156360248d1ec624842ad0edf697050bbaf7c3e46394e106ad1/aiosignal-1.4.0.tar.gz"
    sha256 "f47eecd9468083c2029cc99945502cb7708b082c232f9aca65da147157b251c7"
  end

  resource "alembic" do
    url "https://files.pythonhosted.org/packages/6e/b6/2a81d7724c0c124edc5ec7a167e85858b6fd31b9611c6fb8ecf617b7e2d3/alembic-1.17.1.tar.gz"
    sha256 "8a289f6778262df31571d29cca4c7fbacd2f0f582ea0816f4c399b6da7528486"
  end

  resource "annotated-doc" do
    url "https://files.pythonhosted.org/packages/57/ba/046ceea27344560984e26a590f90bc7f4a75b06701f653222458922b558c/annotated_doc-0.0.4.tar.gz"
    sha256 "fbcda96e87e9c92ad167c2e53839e57503ecfda18804ea28102353485033faa4"
  end

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/ee/67/531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5/annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "anthropic" do
    url "https://files.pythonhosted.org/packages/0d/c9/e8a3a1caeab575e80551b30b084096b5a430abc52739a526a1daaadd038c/anthropic-0.99.0.tar.gz"
    sha256 "16f41e00f215ed2d193b146be3dd567c4319c32ed3af6c8725d68ba875257c1c"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/61/cc/a381afa6efea9f496eff839d4a6a1aed3bfafc7b3ab4b0d1b243a12573dd/anyio-4.14.2.tar.gz"
    sha256 "cfa139f3ed1a23ee8f88a145ddb5ac7605b8bbfd8592baacd7ce3d8bb4313c7f"
  end

  resource "asgiref" do
    url "https://files.pythonhosted.org/packages/76/b9/4db2509eabd14b4a8c71d1b24c8d5734c52b8560a7b1e1a8b56c8d25568b/asgiref-3.11.0.tar.gz"
    sha256 "13acff32519542a1736223fb79a715acdebe24286d98e8b164a73085f40da2c4"
  end

  resource "asyncpg" do
    url "https://files.pythonhosted.org/packages/fe/cc/d18065ce2380d80b1bcce927c24a2642efd38918e33fd724bc4bca904877/asyncpg-0.31.0.tar.gz"
    sha256 "c989386c83940bfbd787180f2b1519415e2d3d6277a70d9d0f0145ac73500735"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/6b/5c/685e6633917e101e5dcb62b9dd76946cbb57c26e133bae9e0cd36033c0a9/attrs-25.4.0.tar.gz"
    sha256 "16d5969b87f0859ef33a48b35d55ac1be6e42ae49d5e853b597db70c35c57e11"
  end

  resource "authlib" do
    url "https://files.pythonhosted.org/packages/d3/30/6691fdc63b35f54a5a65e04fa1e59d827f4d4e8f4a39678ba7d3088ce0c8/authlib-1.6.12.tar.gz"
    sha256 "0656d8482f28fc8221929d5f35b2bde5d13e10555ebc06b4561b0d622e83b1bd"
  end

  resource "beartype" do
    url "https://files.pythonhosted.org/packages/a6/09/9003e5662691056e0e8b2e6f57c799e71875fac0be0e785d8cb11557cd2a/beartype-0.22.5.tar.gz"
    sha256 "516a9096cc77103c96153474fa35c3ebcd9d36bd2ec8d0e3a43307ced0fa6341"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/77/e9/df2358efd7659577435e2177bfa69cba6c33216681af51a707193dec162a/beautifulsoup4-4.14.2.tar.gz"
    sha256 "2a98ab9f944a11acee9cc848508ec28d9228abfd522ef0fad6a02a72e0ded69e"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/48/59/fb93b6ebd9ad43eb9a58c7a6da51a0fe24ab0c04bc4d534a0bfc5eba7f59/boto3-1.43.108.tar.gz"
    sha256 "03341f089158368acf83e921aca98b706095322ca52bc4c039a616940aa5ad41"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/61/16/6b4477f433da2c11193802f538330ce080076c2f38d817ad437ed3cd1465/botocore-1.43.108.tar.gz"
    sha256 "ee4f75cf3bdbb0da7912e089950e8112f692016539d939312c771499958e6cfd"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/cc/7e/b975b5814bd36faf009faebe22c1072a1fa1168db34d285ef0ba071ad78c/cachetools-6.2.1.tar.gz"
    sha256 "3f391e4bd8f8bf0931169baf7456cc822705f4e2a31f840d218f445b9a854201"
  end

  resource "caio" do
    url "https://files.pythonhosted.org/packages/92/88/b8527e1b00c1811db339a1df8bd1ae49d146fcea9d6a5c40e3a80aaeb38d/caio-0.9.25.tar.gz"
    sha256 "16498e7f81d1d0f5a4c0ad3f2540e65fe25691376e0a5bd367f558067113ed10"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "claude-agent-sdk" do
    url "https://files.pythonhosted.org/packages/9a/ee/31e159daf956f0c5503eac67d02743da692c0999fef046cdde3cc52702b9/claude_agent_sdk-0.2.168.tar.gz"
    sha256 "80388054a09c137d76fc29caa6e46bc90d2ae2ef09fac5ee1c38fc36d2762fda"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/b9/2e/0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8b/click-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
  end

  resource "cobble" do
    url "https://files.pythonhosted.org/packages/54/7a/a507c709be2c96e1bb6102eb7b7f4026c5e5e223ef7d745a17d239e9d844/cobble-0.1.4.tar.gz"
    sha256 "de38be1539992c8a06e569630717c485a5f91be2192c461ea2b220607dfa78aa"
  end

  resource "cohere" do
    url "https://files.pythonhosted.org/packages/4b/ed/bb02083654bdc089ae4ef1cd7691fd2233f1fd9f32bcbfacc80ff57d9775/cohere-5.20.1.tar.gz"
    sha256 "50973f63d2c6138ff52ce37d8d6f78ccc539af4e8c43865e960d68e0bf835b6f"
  end

  resource "croniter" do
    url "https://files.pythonhosted.org/packages/df/de/5832661ed55107b8a09af3f0a2e71e0957226a59eb1dcf0a445cce6daf20/croniter-6.2.2.tar.gz"
    sha256 "ba60832a5ec8e12e51b8691c3309a113d1cf6526bdf1a48150ce8ec7a532d0ab"
  end

  resource "cyclopts" do
    url "https://files.pythonhosted.org/packages/34/ab/67bd1b010aaa09c6b627a535cbb0c6453920c290df83cbdccb0b097227d9/cyclopts-4.2.2.tar.gz"
    sha256 "d5eb7d5ab688f8e86bc6fc7b8ab85951b2fe34aebcf1a48c4c9a6b43c14cb78b"
  end

  resource "dateparser" do
    url "https://files.pythonhosted.org/packages/59/6a/9f06999c4f27e9192c5eb38bfffadc2e6752df8178e97e88b10b9eb4c682/dateparser-1.4.2.tar.gz"
    sha256 "bed2a3fd9bad8f2fb2d72b57748bada260b3a9349a264c22ffc23c3249d7049a"
  end

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
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

  resource "et-xmlfile" do
    url "https://files.pythonhosted.org/packages/d3/38/af70d7ab1ae9d4da450eeec1fa3918940a5fafb9055e934af8d6eb0c2313/et_xmlfile-2.0.0.tar.gz"
    sha256 "dab3f4764309081ce75662649be815c4c9081e88f0837825f90fd28317d4da54"
  end

  resource "exceptiongroup" do
    url "https://files.pythonhosted.org/packages/0b/9f/a65090624ecf468cdca03533906e7c69ed7588582240cfe7cc9e770b50eb/exceptiongroup-1.3.0.tar.gz"
    sha256 "b241f5885f560bc56a59ee63ca4c6a8bfa46ae4ad651af316d4e81817bb9fd88"
  end

  resource "fastapi" do
    url "https://files.pythonhosted.org/packages/81/2d/ff8d91d7b564d464629a0fd50a4489c97fcb836ac230bf3a7269232a9b1f/fastapi-0.136.3.tar.gz"
    sha256 "e487fae93ad408e6f47641ee4dfe389864fd7bec92e547ea8498fc13f43e83ab"
  end

  resource "fastapi-cli" do
    url "https://files.pythonhosted.org/packages/99/75/9407a6b452be4c988feacec9c9d2f58d8f315162a6c7258d5a649d933ebe/fastapi_cli-0.0.16.tar.gz"
    sha256 "e8a2a1ecf7a4e062e3b2eec63ae34387d1e142d4849181d936b23c4bdfe29073"
  end

  resource "fastapi-cloud-cli" do
    url "https://files.pythonhosted.org/packages/f9/48/0f14d8555b750dc8c04382804e4214f1d7f55298127f3a0237ba566e69dd/fastapi_cloud_cli-0.3.1.tar.gz"
    sha256 "8c7226c36e92e92d0c89827e8f56dbf164ab2de4444bd33aa26b6c3f7675db69"
  end

  resource "fastar" do
    url "https://files.pythonhosted.org/packages/03/0f/0aeb3fc50046617702acc0078b277b58367fd62eb727b9ec733ae0e8bbcc/fastar-0.11.0.tar.gz"
    sha256 "aa7f100f7313c03fdb20f1385927ba95671071ba308ad0c1763fef295e1895ce"
  end

  resource "fastavro" do
    url "https://files.pythonhosted.org/packages/65/8b/fa2d3287fd2267be6261d0177c6809a7fa12c5600ddb33490c8dc29e77b2/fastavro-1.12.1.tar.gz"
    sha256 "2f285be49e45bc047ab2f6bed040bb349da85db3f3c87880e4b92595ea093b2b"
  end

  resource "fastmcp" do
    url "https://files.pythonhosted.org/packages/d0/32/4f1b2cfd7b50db89114949f90158b1dcc2c92a1917b9f57c0ff24e47a2f4/fastmcp-3.2.0.tar.gz"
    sha256 "d4830b8ffc3592d3d9c76dc0f398904cf41f04910e41a0de38cc1004e0903bef"
  end

  resource "fastuuid" do
    url "https://files.pythonhosted.org/packages/c3/7d/d9daedf0f2ebcacd20d599928f8913e9d2aea1d56d2d355a93bfa2b611d7/fastuuid-0.14.0.tar.gz"
    sha256 "178947fc2f995b38497a74172adee64fdeb8b7ec18f2a5934d037641ba265d26"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/1d/65/ce7f1b70157833bf3cb851b556a37d4547ceafc158aa9b34b36782f23696/filelock-3.20.3.tar.gz"
    sha256 "18c57ee915c7ec61cff0ecf7f0f869936c7c30191bb0cf406f1341778d0834e1"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/2d/f5/c831fac6cc817d26fd54c7eaccd04ef7e0288806943f7cc5bbf69f3ac1f0/frozenlist-1.8.0.tar.gz"
    sha256 "3ede829ed8d842f6cd48fc7081d7a41001a56f1f38603f9d49bf3020d59a31ad"
  end

  resource "fsspec" do
    url "https://files.pythonhosted.org/packages/77/cd/9be253869fc42e764de7f3dedd6969af7d44ff9c3375214a3442a6f3fc08/fsspec-2026.9.0.tar.gz"
    sha256 "0f08147951c8cb31d844c3547d631053b127863b60be04cf06e121333ee0e2fe"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/db/4c/fa42116a48bab3f7a143cf5042ecff7df9c8b73f8a376203cd534d1dc966/google_auth-2.56.3.tar.gz"
    sha256 "40e229fc901f0a305b553050e5fce562d509bee0435be053abfa91582b51b90c"
  end

  resource "google-genai" do
    url "https://files.pythonhosted.org/packages/19/e3/1dd592243a0dfc3487ddfff7995f12686d0557ec953173dd9bdbeba2cb96/google_genai-2.18.1.tar.gz"
    sha256 "a1e2be75c16234adc6641afd1ad4dd44218c9eec005d938bdc428585a048918a"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/b5/c8/f439cffde755cffa462bfbb156278fa6f9d09119719af9814b858fd4f81f/googleapis_common_protos-1.75.0.tar.gz"
    sha256 "53a062ff3c32552fbd62c11fe23768b78e4ddf0494d5e5fd97d3f4689c75fbbd"
  end

  resource "greenlet" do
    url "https://files.pythonhosted.org/packages/03/b8/704d753a5a45507a7aab61f18db9509302ed3d0a27ac7e0359ec2905b1a6/greenlet-3.2.4.tar.gz"
    sha256 "0dca0d95ff849f9a364385f36ab49f50065d76964944638be9691e1832e9f86d"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "h2" do
    url "https://files.pythonhosted.org/packages/e7/85/7c366e69d84c17bb778fe41419e1fbcce3033d5b7ce29bbffff0a98b859f/h2-4.4.1.tar.gz"
    sha256 "4e866ffb1a869ae14dd9b5e6beb5c24a13da0495ad72b65925ded182521c1516"
  end

  resource "hf-xet" do
    url "https://files.pythonhosted.org/packages/8b/cb/9bb543bd987ffa1ee48202cc96a756951b734b79a542335c566148ade36c/hf_xet-1.3.2.tar.gz"
    sha256 "e130ee08984783d12717444e538587fa2119385e5bd8fc2bb9f930419b73a7af"
  end

  resource "hpack" do
    url "https://files.pythonhosted.org/packages/26/5b/fcabf6028144a8723726318b07a32c2f3314acdff6265743cf08a344b18e/hpack-4.2.0.tar.gz"
    sha256 "0895cfa3b5531fc65fe439c05eb65144f123bf7a394fcaa56aa423548d8e45c0"
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

  resource "httpx-sse" do
    url "https://files.pythonhosted.org/packages/0f/4c/751061ffa58615a32c31b2d82e8482be8dd4a89154f003147acee90f2be9/httpx_sse-0.4.3.tar.gz"
    sha256 "9b1ed0127459a66014aec3c56bebd93da3c1bc8bb6618c8082039a44889a755d"
  end

  resource "huggingface-hub" do
    url "https://files.pythonhosted.org/packages/d5/7a/304cec37112382c4fe29a43bcb0d5891f922785d18745883d2aa4eb74e4b/huggingface_hub-1.6.0.tar.gz"
    sha256 "d931ddad8ba8dfc1e816bf254810eb6f38e5c32f60d4184b5885662a3b167325"
  end

  resource "hyperframe" do
    url "https://files.pythonhosted.org/packages/02/e7/94f8232d4a74cc99514c13a9f995811485a6903d48e5d952771ef6322e30/hyperframe-6.1.0.tar.gz"
    sha256 "f630908a00854a7adeabd6382b43923a4c4cd4b821fcb527e6ab9e15382a3b08"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/82/77/7b3966d0b9d1d31a36ddf1746926a11dface89a83409bf1483f0237aa758/idna-3.15.tar.gz"
    sha256 "ca962446ea538f7092a95e057da437618e886f4d349216d2b1e294abfdb65fdc"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/cd/12/33e59336dca5be0c398a7482335911a33aa0e20776128f038019f1a95f1b/importlib_metadata-8.5.0.tar.gz"
    sha256 "71522656f0abace1d072b9e5481a48f07c138e00f079c38c8f883823f9c26bd7"
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
    url "https://files.pythonhosted.org/packages/f7/ed/1aa2d585304ec07262e1a83a9889880701079dde796ac7b1d1826f40c63d/jaraco_functools-4.3.0.tar.gz"
    sha256 "cfd13ad0dd2c47a3600b439ef72d8615d482cedcff1632930d6f28924d92f294"
  end

  resource "jeepney" do
    url "https://files.pythonhosted.org/packages/7b/6f/357efd7602486741aa73ffc0617fb310a29b588ed0fd69c2399acbb85b0c/jeepney-0.9.0.tar.gz"
    sha256 "cf0e9e845622b81e4a28df94c40345400256ec608d0e55bb8a3feaa9163f5732"
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
    url "https://files.pythonhosted.org/packages/d3/59/322338183ecda247fb5d1763a6cbe46eff7222eaeebafd9fa65d4bf5cb11/jmespath-1.1.0.tar.gz"
    sha256 "472c87d80f36026ae83c6ddd0f1d05d4e510134ed462851fd5f754c8c3cbb88d"
  end

  resource "json-repair" do
    url "https://files.pythonhosted.org/packages/f7/1b/c23bee35d532ea9c2038f31245fd2b50e6a8308d38a8b965bf0f9c6d49ba/json_repair-0.63.2.tar.gz"
    sha256 "8385ca04afbf411eebd9f0ba064155d1afe37442aaad52f693825c65cc314586"
  end

  resource "jsonref" do
    url "https://files.pythonhosted.org/packages/aa/0d/c1f3277e90ccdb50d33ed5ba1ec5b3f0a242ed8c1b1a85d3afeb68464dca/jsonref-1.1.0.tar.gz"
    sha256 "32fe8e1d85af0fdefbebce950af85590b22b60f9e95443176adbde4e1ecea552"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/38/2e/03362ee4034a4c917f697890ccd4aec0800ccf9ded7f511971c75451deec/jsonschema-4.23.0.tar.gz"
    sha256 "d71497fef26351a33265337fa77ffeb82423f3ea21283cd9467bb03999266bc4"
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
    url "https://files.pythonhosted.org/packages/70/09/d904a6e96f76ff214be59e7aa6ef7190008f52a0ab6689760a98de0bf37d/keyring-25.6.0.tar.gz"
    sha256 "0b39998aa941431eb3d9b0d4b2460bc773b9df6fed7621c2dfb291a7e0187a66"
  end

  resource "litellm" do
    url "https://files.pythonhosted.org/packages/55/9f/7cc04ca18e936ef9b61b99f25164c71ca1ae0b586c1a3f52ec9397d603a2/litellm-1.104.0.tar.gz"
    sha256 "df550ab471974edefd7cb0cc6b88b42db453f0de6b91db3cc570f5e1e8d8b173"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/28/30/9abc9e34c657c33834eaf6cd02124c61bdf5944d802aa48e69be8da3585d/lxml-6.1.0.tar.gz"
    sha256 "bfd57d8008c4965709a919c3e9a98f76c2c7cb319086b3d26858250620023b13"
  end

  resource "magika" do
    url "https://files.pythonhosted.org/packages/a3/f3/3d1dcdd7b9c41d589f5cff252d32ed91cdf86ba84391cfc81d9d8773571d/magika-0.6.3.tar.gz"
    sha256 "7cc52aa7359af861957043e2bf7265ed4741067251c104532765cd668c0c0cb1"
  end

  resource "mako" do
    url "https://files.pythonhosted.org/packages/5a/09/e07c4b5579a79f4b16f8d4f29f6c54514ac787c4ad506b8c4f28a0e6b0bf/mako-1.4.3.tar.gz"
    sha256 "cd6537fe88d5fec315c55c2f8529bc4ce7a9a352ad7db3eeaa6a66e2dd4ec37a"
  end

  resource "mammoth" do
    url "https://files.pythonhosted.org/packages/ed/3c/a58418d2af00f2da60d4a51e18cd0311307b72d48d2fffec36a97b4a5e44/mammoth-1.11.0.tar.gz"
    sha256 "a0f59e442f34d5b6447f4b0999306cbf3e67aaabfa8cb516f878fb1456744637"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/5b/f5/4ec618ed16cc4f8fb3b701563655a69816155e79e24a17b651541804721d/markdown_it_py-4.0.0.tar.gz"
    sha256 "cb0a2b4aa34f932c007117b194e945bd74e0ec24133ceb5bac59009cda1cb9f3"
  end

  resource "markdownify" do
    url "https://files.pythonhosted.org/packages/3f/bc/c8c8eea5335341306b0fa7e1cb33c5e1c8d24ef70ddd684da65f41c49c92/markdownify-1.2.2.tar.gz"
    sha256 "b274f1b5943180b031b699b199cbaeb1e2ac938b75851849a31fd0c3d6603d09"
  end

  resource "markitdown" do
    url "https://files.pythonhosted.org/packages/23/ae/c1f5e3fbd63883f27aec6bb6f8af2852253928bc673617bd02f2740a3057/markitdown-0.1.5b1.tar.gz"
    sha256 "d5bffdb9d7aff9cac423a6d80d9e3a970937cec61338167bd855555f8a1c591c"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "mcp" do
    url "https://files.pythonhosted.org/packages/ba/93/0142dc84a666daf8ad51a34268f34c12fd6fda4f3810c4be2504eecc8212/mcp-1.30.0.tar.gz"
    sha256 "445414625fce5c295faa505bb11bacece661ab6f4028d57c935db57820b7a3e4"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/ea/5d/38b681d3fce7a266dd9ab73c66959406d565b3e85f21d5e66e1181d93721/more_itertools-10.8.0.tar.gz"
    sha256 "f638ddf8a1a0d134181275fb5d58b086ead7c6a72429ad725c67503f13ba30bd"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/d6/99/1d4d69c3512d0ddbfa3a1b69cfd9a151012ab2eb4eabbb096201b1f0b7d8/multidict-6.9.1.tar.gz"
    sha256 "0f06e60fa190aa7abd0914c2a766736fdc8e9f34878c4346338534b73d1b20e2"
  end

  resource "obstore" do
    url "https://files.pythonhosted.org/packages/a3/8c/9ec984edd0f3b72226adfaa19b1c61b15823b35b52f311ca4af36d009d15/obstore-0.8.2.tar.gz"
    sha256 "a467bc4e97169e2ba749981b4fd0936015428d9b8f3fb83a5528536b1b6f377f"
  end

  resource "openai" do
    url "https://files.pythonhosted.org/packages/55/13/17e87641b89b74552ed408a92b231283786523edddc95f3545809fab673c/openai-2.24.0.tar.gz"
    sha256 "1e5769f540dbd01cb33bc4716a23e67b9d695161a734aff9c5f925e2bf99a673"
  end

  resource "openapi-pydantic" do
    url "https://files.pythonhosted.org/packages/02/2e/58d83848dd1a79cb92ed8e63f6ba901ca282c5f09d04af9423ec26c56fd7/openapi_pydantic-0.5.1.tar.gz"
    sha256 "ff6835af6bde7a459fb93eb93bb92b8749b754fc6e51b2f1590a19dc3005ee0d"
  end

  resource "openpyxl" do
    url "https://files.pythonhosted.org/packages/3d/f9/88d94a75de065ea32619465d2f77b29a0469500e99012523b91cc4141cd1/openpyxl-3.1.5.tar.gz"
    sha256 "cf0e3cf56142039133628b5acffe8ef0c12bc902d2aadd3e0fe5878dc08d1050"
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

  resource "opentelemetry-exporter-prometheus" do
    url "https://files.pythonhosted.org/packages/f4/85/3a1af7b90a76d6c069bcbbc86cc641c93d15057f2674cc8226f47c5260e8/opentelemetry_exporter_prometheus-0.65b0.tar.gz"
    sha256 "2777cbf41c403c119e10f418fce5d645c956b47f673a2ee120285d1d0c6df2d5"
  end

  resource "opentelemetry-instrumentation" do
    url "https://files.pythonhosted.org/packages/13/91/3c58961cb0360cd60509064734f0be4275383c8681d73c580a40ca83ddce/opentelemetry_instrumentation-0.65b0.tar.gz"
    sha256 "071d9d9eced9bd6460444ec3b0c77229870ed05a881c22c84fdede58e4eed09b"
  end

  resource "opentelemetry-instrumentation-asgi" do
    url "https://files.pythonhosted.org/packages/17/83/8e8e83b7ac285281687c7be2fd305213ccccbb8c0a2dd4fb45a8ccaf12c7/opentelemetry_instrumentation_asgi-0.65b0.tar.gz"
    sha256 "892bca67c56522ffa85a8a83cf934d7b50b3be2132e45cbee705825f0a5ba426"
  end

  resource "opentelemetry-instrumentation-fastapi" do
    url "https://files.pythonhosted.org/packages/30/23/b057f8196d06efdc1b50e3ff11fbc499a7d96b35c87f217eb7885542f4ea/opentelemetry_instrumentation_fastapi-0.65b0.tar.gz"
    sha256 "10a3a95486036230413a58fe4fdf4a83fa6bba46918407e527476994bd92bd97"
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

  resource "opentelemetry-util-http" do
    url "https://files.pythonhosted.org/packages/32/a9/d7525a59fdd240e69b5af4a6338e78fafa1b4203394122cbd6701fb5f84a/opentelemetry_util_http-0.65b0.tar.gz"
    sha256 "84f82d826978bba416ab453460ff6a7391cdc3534c93a786595e4068680016b7"
  end

  resource "orjson" do
    url "https://files.pythonhosted.org/packages/0f/f3/742fb1f62b825f2c010697eaf4e828004bc2a81e7e806666989c132c7c42/orjson-3.12.0.tar.gz"
    sha256 "d14203fb1aae2ad9b3d52f8a0e82aeb10197ef1c9bc61da7f358bd70b00123d5"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "pandas" do
    url "https://files.pythonhosted.org/packages/33/01/d40b85317f86cf08d853a4f495195c73815fdf205eef3993821720274518/pandas-2.3.3.tar.gz"
    sha256 "e05e1af93b977f7eafa636d043f9f94c7ee3ac81af99c13508215942e64c993b"
  end

  resource "pathable" do
    url "https://files.pythonhosted.org/packages/67/93/8f2c2075b180c12c1e9f6a09d1a985bc2036906b13dff1d8917e395f2048/pathable-0.4.4.tar.gz"
    sha256 "6905a3cd17804edfac7875b5f6c9142a218c7caef78693c2dbbbfbac186d88b2"
  end

  resource "pdfminer-six" do
    url "https://files.pythonhosted.org/packages/46/9a/d79d8fa6d47a0338846bb558b39b9963b8eb2dfedec61867c138c1b17eeb/pdfminer_six-20251230.tar.gz"
    sha256 "e8f68a14c57e00c2d7276d26519ea64be1b48f91db1cdc776faa80528ca06c1e"
  end

  resource "pdfplumber" do
    url "https://files.pythonhosted.org/packages/38/37/9ca3519e92a8434eb93be570b131476cc0a4e840bb39c62ddb7813a39d53/pdfplumber-0.11.9.tar.gz"
    sha256 "481224b678b2bbdbf376e2c39bf914144eef7c3d301b4a28eebf0f7f6109d6dc"
  end

  resource "pgvector" do
    url "https://files.pythonhosted.org/packages/44/43/9a0fb552ab4fd980680c2037962e331820f67585df740bedc4a2b50faf20/pgvector-0.4.1.tar.gz"
    sha256 "83d3a1c044ff0c2f1e95d13dfb625beb0b65506cfec0941bfe81fd0ad44f4003"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/61/33/9611380c2bdb1225fdef633e2a9610622310fed35ab11dac9620972ee088/platformdirs-4.5.0.tar.gz"
    sha256 "70ddccdd7c99fc5942e9fc25636a8b34d04c24b335100223152c2803e4063312"
  end

  resource "prometheus-client" do
    url "https://files.pythonhosted.org/packages/23/53/3edb5d68ecf6b38fcbcc1ad28391117d2a322d9a1a3eff04bfdb184d8c3b/prometheus_client-0.23.1.tar.gz"
    sha256 "6ae8f9081eaaaf153a2e959d2e6c4f4fb57b12ef76c8c7980202f1e57b48b2ce"
  end

  resource "propcache" do
    url "https://files.pythonhosted.org/packages/9e/da/e9fc233cf63743258bff22b3dfa7ea5baef7b5bc324af47a0ad89b8ffc6f/propcache-0.4.1.tar.gz"
    sha256 "f48107a8c637e80362555f37ecf49abe20370e557cc4ab374f04ec4423c97c3d"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/da/01/9ef0afd7999eb9badb3a768b4aedd78c86d4c65cfaf1958ab276199e76b4/protobuf-7.35.1.tar.gz"
    sha256 "ce115a26fe0c39a2c29973d914d327e516a6455464489fe3cd1e51a1b354f81a"
  end

  resource "psycopg2" do
    url "https://files.pythonhosted.org/packages/89/8d/9d12bc8677c24dad342ec777529bce705b3e785fa05d85122b5502b9ab55/psycopg2-2.9.11.tar.gz"
    sha256 "964d31caf728e217c697ff77ea69c2ba0865fa41ec20bb00f0977e62fdcc52e3"
  end

  resource "py-key-value-aio" do
    url "https://files.pythonhosted.org/packages/04/3c/0397c072a38d4bc580994b42e0c90c5f44f679303489e4376289534735e5/py_key_value_aio-0.4.4.tar.gz"
    sha256 "e3012e6243ed7cc09bb05457bd4d03b1ba5c2b1ca8700096b3927db79ffbbe55"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/a4/9a/23310166d960def5897e91fe20e5b724601b02a22e84ba1f94232c0b7f67/pyasn1-0.6.4.tar.gz"
    sha256 "9c447d8431c947fe4c8febc4ed9e760bc29011a5b01e5c74b67025bd9fb8ce81"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/e9/e6/78ebbb10a8c8e4b61a59249394a4a594c1a7af95593dc933a349c8d00964/pyasn1_modules-0.4.2.tar.gz"
    sha256 "677091de870a80aae844b1ca6134f54652fa2c8c5a52aa396440ac3106e941e6"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/fe/cf/d2d3b9f5699fb1e4615c8e32ff220203e43b248e1dfcc6736ad9057731ca/pycparser-2.23.tar.gz"
    sha256 "78816d4f24add8f10a06d6f05b4d424ad9e96cfebf68a4ddc99c65c0720d00c2"
  end

  resource "pydantic-extra-types" do
    url "https://files.pythonhosted.org/packages/66/71/dba38ee2651f84f7842206adbd2233d8bbdb59fb85e9fa14232486a8c471/pydantic_extra_types-2.11.1.tar.gz"
    sha256 "46792d2307383859e923d8fcefa82108b1a141f8a9c0198982b3832ab5ef1049"
  end

  resource "pydantic-settings" do
    url "https://files.pythonhosted.org/packages/5c/b5/8f48e906c3e0205276e8bd8cb7512217a87b2685304d64be27cad5b3019f/pydantic_settings-2.14.2.tar.gz"
    sha256 "c19dd64b19097f1de80184f0cc7b0272a13ae6e170cbf240a3e27e381ed14a5f"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/43/ea/5194e52748b0da83d71e082d75496eaec6e58f419f5e184786ded517e6a9/pyjwt-2.15.1.tar.gz"
    sha256 "4f259e80cdfb6b3fc18a7de51fd1ef9ec79652f25019bae68975ca2468a34df8"
  end

  resource "pypdfium2" do
    url "https://files.pythonhosted.org/packages/99/23/b3979a1d4f536fabce02e3d9f332e8aeeed064d9df9391f2a77160f4ab36/pypdfium2-5.4.0.tar.gz"
    sha256 "7219e55048fb3999fc8adcaea467088507207df4676ff9e521a3ae15a67d99c4"
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
    url "https://files.pythonhosted.org/packages/82/ed/0301aeeac3e5353ef3d94b6ec08bbcabd04a72018415dcb29e588514bba8/python_dotenv-1.2.2.tar.gz"
    sha256 "2c371a91fbd7ba082c2c1dc1f8bf89ca22564a087c2c287cd9b662adde799cf3"
  end

  resource "python-multipart" do
    url "https://files.pythonhosted.org/packages/5b/42/55c32bb9b12693c092ad250a0e82edb5b31ddeda6eb772de5f308b3804ad/python_multipart-0.0.32.tar.gz"
    sha256 "be54b7f3fa167bb83e4fcd936b887b708f4e57fe75911c02aebf53efaf8d938e"
  end

  resource "python-pptx" do
    url "https://files.pythonhosted.org/packages/52/a9/0c0db8d37b2b8a645666f7fd8accea4c6224e013c42b1d5c17c93590cd06/python_pptx-1.0.2.tar.gz"
    sha256 "479a8af0eaf0f0d76b6f00b0887732874ad2e3188230315290cd1f9dd9cc7095"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/f8/bf/abbd3cdfb8fbc7fb3d4d38d320f2441b1e7cbe29be4f23797b4a2b5d8aac/pytz-2025.2.tar.gz"
    sha256 "360b9e3dbb49a209c21ad61809c7fb453643e048b38924c765813546746e81c3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/2f/db/98b5c277be99dd18bfd91dd04e1b759cad18d1a338188c936e92f921c7e2/referencing-0.36.2.tar.gz"
    sha256 "df2e89862cd09deabbdba16944cc3f10feb6b3e6f18e902f7cc25609a34775aa"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/19/c1/6b30b775c7bcc6cf6506a4d4741c2123e8d99cd50f3fe8cbd731f5fef526/regex-2026.9.3.tar.gz"
    sha256 "aabd43208e335f4c3f0b56de3464b066dd425983a58f6eeb5738bcd7465403db"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/fb/d2/8920e102050a0de7bfabeb4c4614a49248cf8d5d7a8d01885fbb24dc767a/rich-14.2.0.tar.gz"
    sha256 "73ff50c7c0c1c77c8243079283f4edb376f0f6442433aecb8ce7e6d0b92d1fe4"
  end

  resource "rich-rst" do
    url "https://files.pythonhosted.org/packages/bc/6d/a506aaa4a9eaa945ed8ab2b7347859f53593864289853c5d6d62b77246e0/rich_rst-1.3.2.tar.gz"
    sha256 "a1196fdddf1e364b02ec68a05e8ff8f6914fee10fbca2e6b6735f166bb0da8d4"
  end

  resource "rich-toolkit" do
    url "https://files.pythonhosted.org/packages/67/33/1a18839aaa8feef7983590c05c22c9c09d245ada6017d118325bbfcc7651/rich_toolkit-0.15.1.tar.gz"
    sha256 "6f9630eb29f3843d19d48c3bd5706a086d36d62016687f9d0efa027ddc2dd08a"
  end

  resource "rignore" do
    url "https://files.pythonhosted.org/packages/e5/f5/8bed2310abe4ae04b67a38374a4d311dd85220f5d8da56f47ae9361be0b0/rignore-0.7.6.tar.gz"
    sha256 "00d3546cd793c30cb17921ce674d2c8f3a4b00501cb0e3dd0e82217dbeba2671"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/76/43/35e4d8aa320bffe8287fe8f65f578fa2d2db0a64212f0e710dce58267854/s3transfer-0.19.2.tar.gz"
    sha256 "ba0309fd86be3c27dbf78cdd813c13c5e1df16e5874b99d2535ebbdfb9892993"
  end

  resource "secretstorage" do
    url "https://files.pythonhosted.org/packages/32/8a/ed6747b1cc723c81f526d4c12c1b1d43d07190e1e8258dbf934392fc850e/secretstorage-3.4.1.tar.gz"
    sha256 "a799acf5be9fb93db609ebaa4ab6e8f1f3ed5ae640e0fa732bfea59e9c3b50e8"
  end

  resource "sentry-sdk" do
    url "https://files.pythonhosted.org/packages/62/26/ff7d93a14a0ec309021dca2fb7c62669d4f6f5654aa1baf60797a16681e0/sentry_sdk-2.44.0.tar.gz"
    sha256 "5b1fe54dfafa332e900b07dd8f4dfe35753b64e78e7d9b1655a28fd3065e2493"
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
    url "https://files.pythonhosted.org/packages/69/99/a6ca3beb3ccacb41fb3321d8a60e5566f9e6467601ef8eba6a17e1b89778/soupsieve-2.9.2.tar.gz"
    sha256 "4a55d8cf158a9c2e587fa4922f1bbb91d68ac829e2d6f25403a85747c71daf74"
  end

  resource "sqlalchemy" do
    url "https://files.pythonhosted.org/packages/f0/f2/840d7b9496825333f532d2e3976b8eadbf52034178aac53630d09fe6e1ef/sqlalchemy-2.0.44.tar.gz"
    sha256 "0ae7454e1ab1d780aee69fd2aae7d6b8670a581d8847f2d1e0f7ddfbf47e5a22"
  end

  resource "sse-starlette" do
    url "https://files.pythonhosted.org/packages/db/3c/fa6517610dc641262b77cc7bf994ecd17465812c1b0585fe33e11be758ab/sse_starlette-3.0.3.tar.gz"
    sha256 "88cfb08747e16200ea990c8ca876b03910a23b547ab3bd764c0d8eb81019b971"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/eb/e3/7c1dc7381d9f8ab7d854328ebfa884e62cb3f3d8549ddfd37c7814f42afa/starlette-1.3.1.tar.gz"
    sha256 "05d0213193f2fbaae60e2ecb593b4add4262ad4e46536b54abe36f11a71724e0"
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
    url "https://files.pythonhosted.org/packages/73/6f/f80cfef4a312e1fb34baf7d85c72d4411afde10978d4657f8cdd811d3ccc/tokenizers-0.22.2.tar.gz"
    sha256 "473b83b915e547aa366d1eee11806deaf419e17be16310ac0a14077f1e28f917"
  end

  resource "toktok-rs" do
    url "https://files.pythonhosted.org/packages/b9/17/e8c5745ebc307b2c2e65ccd9661cbdefab122a32cb0eed63a6aee6eba830/toktok_rs-0.3.0.tar.gz"
    sha256 "a90106c50802f94b885416b667bde2db23f0778f7ea602a040bd6eb015a89b9c"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/a8/4b/29b4ef32e036bb34e4ab51796dd745cdba7ed47ad142a9f4a1eb8e0c744d/tqdm-4.67.1.tar.gz"
    sha256 "f8aef9c52c08c13a65f30ea34f4e5aac3fd1a34959879d7e59e63027286627f2"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/8f/28/7c85c8032b91dbe79725b6f17d2fffc595dff06a35c7a30a37bef73a1ab4/typer-0.20.0.tar.gz"
    sha256 "1aaf6494031793e4876fb0bacfa6a912b551cf43c1e63c800df8b1a866720c37"
  end

  resource "types-requests" do
    url "https://files.pythonhosted.org/packages/0f/f3/a0663907082280664d745929205a89d41dffb29e89a50f753af7d57d0a96/types_requests-2.32.4.20260107.tar.gz"
    sha256 "018a11ac158f801bfa84857ddec1650750e393df8a004a8a9ae2a9bec6fcb24f"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "typing-inspection" do
    url "https://files.pythonhosted.org/packages/a3/26/b09b8010994eccc3c09092e6b34058f36a460eea2d4c3e8b910c695975a0/typing_inspection-0.4.4.tar.gz"
    sha256 "547274fa6b0a561ccf549cc9524b999a578e737d015d8709d021f9d0d13bea47"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/95/32/1a225d6164441be760d75c2c42e2780dc0873fe382da3e98a2e1e48361e5/tzdata-2025.2.tar.gz"
    sha256 "b60a638fcc0daffadf82fe0f57e53d06bdec2f36c4df66280ae79bce6bd6f2b9"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/8b/2e/c14812d3d4d9cd1773c6be938f89e5735a1f11a9f184ac3639b93cef35d5/tzlocal-5.3.1.tar.gz"
    sha256 "cceffc7edecefea1f595541dbd6e990cb1ea3d19bf01b2809f362a03dd7921fd"
  end

  resource "uncalled-for" do
    url "https://files.pythonhosted.org/packages/02/7c/b5b7d8136f872e3f13b0584e576886de0489d7213a12de6bebf29ff6ebfc/uncalled_for-0.2.0.tar.gz"
    sha256 "b4f8fdbcec328c5a113807d653e041c5094473dd4afa7c34599ace69ccb7e69f"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/cb/ce/f06b84e2697fef4688ca63bdb2fdf113ca0a3be33f94488f2cadb690b0cf/uvicorn-0.38.0.tar.gz"
    sha256 "fd97093bdd120a2609fc0d3afe931d4d4ad688b6e75f0f929fde1bc36fe0e91d"
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

  resource "xlrd" do
    url "https://files.pythonhosted.org/packages/07/5a/377161c2d3538d1990d7af382c79f3b2372e880b65de21b01b1a2b78691e/xlrd-2.0.2.tar.gz"
    sha256 "08b5e25de58f21ce71dc7db3b3b8106c1fa776f3024c54e45b45b374e89234c9"
  end

  resource "xlsxwriter" do
    url "https://files.pythonhosted.org/packages/46/2c/c06ef49dc36e7954e55b802a8b231770d286a9758b3d936bd1e04ce5ba88/xlsxwriter-3.2.9.tar.gz"
    sha256 "254b1c37a368c444eac6e2f867405cc9e461b0ed97a3233b2ac1e574efb4140c"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/75/16/e8be8e2fb175bbf41a0680381a319f1199fae256588241a2ac8677eafb49/yarl-1.25.1.tar.gz"
    sha256 "03dd38de09bc213e9a8b29761eec33ee1d5318dac0e49d8af36e4d27830e23a7"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/e3/02/0f2892c661036d50ede074e376733dca2ae7c6eb617489437771209d4180/zipp-3.23.0.tar.gz"
    sha256 "a07157588a12518c9d4034df3fbbee09c814741a33ff63c05fa29d26a2404166"
  end

  # PEP 517 needs multiple backend versions: lookup keys encode the build role,
  # while Resource.name remains the canonical source-distribution identity.
  resource "build-calver-2025.10.20" do
    self.name = "calver"
    url "https://files.pythonhosted.org/packages/4a/96/0c57e3e228ffc54074867406b659b197678674f1f0bf600d114965289834/calver-2025.10.20.tar.gz"
    sha256 "c98b376c2424642224d456b2f70c51402343e008c63d204634665e1a2a2835f5"
  end

  resource "build-certifi-2026.10.23" do
    self.name = "certifi"
    url "https://files.pythonhosted.org/packages/fd/11/b524cbd9bbdaca58608e4cf4053fd463417549e1959fa8d3aa18319f9555/certifi-2026.10.23.tar.gz"
    sha256 "a9895e6e2758b371e0545e321a3a8fd1fcfd9829ada8824a936dfb16aaaf36cd"
  end

  resource "build-cffi-2.1.1" do
    self.name = "cffi"
    url "https://files.pythonhosted.org/packages/9e/ef/008a1939e372c06329a3fce4279c02f328488f3526744906eeec3da7ad5f/cffi-2.1.1.tar.gz"
    sha256 "dd31f52ea1086513bb9df30f8fcee9b8918323ae067a3d5b78bc826a000712be"
  end

  resource "build-charset-normalizer-3.5.2" do
    self.name = "charset-normalizer"
    url "https://files.pythonhosted.org/packages/33/1c/f41d4e74c28ab327ff3acd36053f7ea506c55872d7a90b0fa71aa3ab0c89/charset_normalizer-3.5.2.tar.gz"
    sha256 "39de2a259fc954455c57274dc94c79d5842774e1247a016aff30bc0efed0f4ef"
  end

  resource "build-coherent-licensed-0.5.2" do
    self.name = "coherent-licensed"
    url "https://files.pythonhosted.org/packages/cd/e9/63d2dcccb5496cc99d96f29a8a5f3e2c6ed0bba7fedb840862f92816ee17/coherent_licensed-0.5.2.tar.gz"
    sha256 "d8071403ce742d3ac3592ddc4fb7057a46caffb415b928b4d52802e5f208416d"
  end

  resource "build-cryptography-50.0.2" do
    self.name = "cryptography"
    url "https://files.pythonhosted.org/packages/9d/af/182eb91b0df3fe75c4d9f26fe70684569566745f6ba7e5c9c73a862c5252/cryptography-50.0.2.tar.gz"
    sha256 "7b46165bb56eb4704e2eaaf86f3c940d19154535d9b0ca7d6d590b04060e00d5"
  end

  # propcache's isolated backend requires the 3.1 release line independently of newer roles.
  resource "build-cython-3.1.8" do
    self.name = "cython"
    url "https://files.pythonhosted.org/packages/b4/a4/ec55945b52d0b888e2a090450a5524001bfa17c8b68348379a154badb850/cython-3.1.8.tar.gz"
    sha256 "518475fbe633ba30c1577669f417440f41e1a23ad6b6e2dbb20703cd457f04ef"
  end

  resource "build-cython-3.3.0" do
    self.name = "cython"
    url "https://files.pythonhosted.org/packages/a9/d8/4981ef716ad0e3ff0d3ef383aefc6b03c4a88dee33b272bf8e0d833001ca/cython-3.3.0.tar.gz"
    sha256 "eed0d93fbca7087f143b42c34b05a825849bdf17f101572c2105acfa49aa88b8"
  end

  resource "build-docutils-0.23" do
    self.name = "docutils"
    url "https://files.pythonhosted.org/packages/39/a4/5180d9afc57e8fca05601dd652bdff19604c218814037fe90ffc7625a50a/docutils-0.23.tar.gz"
    sha256 "746f5060322511280a1e50eb76846ed6bf2342984b2ac04dc42caa1a8d78799e"
  end

  resource "build-dunamai-1.26.3" do
    self.name = "dunamai"
    url "https://files.pythonhosted.org/packages/c5/62/edf5352d8ce1371129ccfe971e6de3a1ce4dc7f9bdc80390fb79856b78d4/dunamai-1.26.3.tar.gz"
    sha256 "fe2f732186710ee5048044fdbef6c76c6afbb9ee7de4f6d00cf34256e9ec2e7f"
  end

  resource "build-expandvars-1.1.2" do
    self.name = "expandvars"
    url "https://files.pythonhosted.org/packages/9c/64/a9d8ea289d663a44b346203a24bf798507463db1e76679eaa72ee6de1c7a/expandvars-1.1.2.tar.gz"
    sha256 "6c5822b7b756a99a356b915dd1267f52ab8a4efaa135963bd7f4bd5d368f71d7"
  end

  resource "build-flit-core-3.12.0" do
    self.name = "flit-core"
    url "https://files.pythonhosted.org/packages/69/59/b6fc2188dfc7ea4f936cd12b49d707f66a1cb7a1d2c16172963534db741b/flit_core-3.12.0.tar.gz"
    sha256 "18f63100d6f94385c6ed57a72073443e1a71a4acb4339491615d0f16d6ff01b2"
  end

  resource "build-flit-core-4.2.0" do
    self.name = "flit-core"
    url "https://files.pythonhosted.org/packages/d3/8b/0370578a456986d6995344967a479dd5c9d4e064681550c2a9594bb58b4a/flit_core-4.2.0.tar.gz"
    sha256 "84e4e4d8fdd45ba2613800a3ebc6834de26d47ec9746efc3719f94181137b460"
  end

  resource "build-flit-scm-1.7.0" do
    self.name = "flit-scm"
    url "https://files.pythonhosted.org/packages/e2/99/961b062461652435b6ad9042d2ffdd75e327b36936987c2073aa784334d5/flit_scm-1.7.0.tar.gz"
    sha256 "961bd6fb24f31bba75333c234145fff88e6de0a90fc0f7e5e7c79deca69f6bb2"
  end

  resource "build-hatch-fancy-pypi-readme-25.1.0" do
    self.name = "hatch-fancy-pypi-readme"
    url "https://files.pythonhosted.org/packages/f3/0f/aed57c301f339936eb91cb4d8c1e5088a101081854bd3ec18a889df32365/hatch_fancy_pypi_readme-25.1.0.tar.gz"
    sha256 "9c58ed3dff90d51f43414ce37009ad1d5b0f08ffc9fc216998a06380f01c0045"
  end

  resource "build-hatch-vcs-0.5.0" do
    self.name = "hatch-vcs"
    url "https://files.pythonhosted.org/packages/6b/b0/4cc743d38adbee9d57d786fa496ed1daadb17e48589b6da8fa55717a0746/hatch_vcs-0.5.0.tar.gz"
    sha256 "0395fa126940340215090c344a2bf4e2a77bcbe7daab16f41b37b98c95809ff9"
  end

  resource "build-hatchling-1.26.3" do
    self.name = "hatchling"
    url "https://files.pythonhosted.org/packages/e1/47/7ec270a9567262ae3cb32dd420d2b53bf7aee769aca1f240eae0426b5bbc/hatchling-1.26.3.tar.gz"
    sha256 "b672a9c36a601a06c4e88a1abb1330639ee8e721e0535a37536e546a667efc7a"
  end

  resource "build-hatchling-1.29.0" do
    self.name = "hatchling"
    url "https://files.pythonhosted.org/packages/cf/9c/b4cfe330cd4f49cff17fd771154730555fa4123beb7f292cf0098b4e6c20/hatchling-1.29.0.tar.gz"
    sha256 "793c31816d952cee405b83488ce001c719f325d9cda69f1fc4cd750527640ea6"
  end

  resource "build-hatchling-1.33.0" do
    self.name = "hatchling"
    url "https://files.pythonhosted.org/packages/7a/f1/e47b937226ae3b093bbd0132eb0b7ee5bfad12c2b5324afd10ae49946b05/hatchling-1.33.0.tar.gz"
    sha256 "4c422bd4d554fcff5de5b73e9596f85e41e9f97f7e553d8f7595ecb31a627bef"
  end

  resource "build-httplib2-0.22.0" do
    self.name = "httplib2"
    url "https://files.pythonhosted.org/packages/3d/ad/2371116b22d616c194aa25ec410c9c6c37f23599dcd590502b74db197584/httplib2-0.22.0.tar.gz"
    sha256 "d7a10bc5ef5ab08322488bde8c726eeee5c8618723fdb399597ec58f3d82df81"
  end

  resource "build-id-1.6.1" do
    self.name = "id"
    url "https://files.pythonhosted.org/packages/6d/04/c2156091427636080787aac190019dc64096e56a23b7364d3c1764ee3a06/id-1.6.1.tar.gz"
    sha256 "d0732d624fb46fd4e7bc4e5152f00214450953b9e772c182c1c22964def1a069"
  end

  resource "build-idna-3.20" do
    self.name = "idna"
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "build-jaraco-classes-3.4.0" do
    self.name = "jaraco-classes"
    url "https://files.pythonhosted.org/packages/06/c0/ed4a27bc5571b99e3cff68f8a9fa5b56ff7df1c2251cc715a652ddd26402/jaraco.classes-3.4.0.tar.gz"
    sha256 "47a024b51d0239c0dd8c8540c6c7f484be3b8fcf0b2d85c13825780d3b3f3acd"
  end

  resource "build-jaraco-context-6.1.2" do
    self.name = "jaraco-context"
    url "https://files.pythonhosted.org/packages/af/50/4763cd07e722bb6285316d390a164bc7e479db9d90daa769f22578f698b4/jaraco_context-6.1.2.tar.gz"
    sha256 "f1a6c9d391e661cc5b8d39861ff077a7dc24dc23833ccee564b234b81c82dfe3"
  end

  resource "build-jaraco-functools-4.6.0" do
    self.name = "jaraco-functools"
    url "https://files.pythonhosted.org/packages/6c/1f/c23395957d41ccf27c4e535c3d334c4051e5395b3752057ba4cbaec35c56/jaraco_functools-4.6.0.tar.gz"
    sha256 "880c577ec9720b3a052d5bc611fb9f2269b3d87902ef42440df443b88e443280"
  end

  resource "build-jeepney-0.9.0" do
    self.name = "jeepney"
    url "https://files.pythonhosted.org/packages/7b/6f/357efd7602486741aa73ffc0617fb310a29b588ed0fd69c2399acbb85b0c/jeepney-0.9.0.tar.gz"
    sha256 "cf0e9e845622b81e4a28df94c40345400256ec608d0e55bb8a3feaa9163f5732"
  end

  resource "build-jinja2-3.1.6" do
    self.name = "jinja2"
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "build-keyring-25.7.0" do
    self.name = "keyring"
    url "https://files.pythonhosted.org/packages/43/4b/674af6ef2f97d56f0ab5153bf0bfa28ccb6c3ed4d1babf4305449668807b/keyring-25.7.0.tar.gz"
    sha256 "fe01bd85eb3f8fb3dd0405defdeac9a5b4f6f0439edbb3149577f244a2e8245b"
  end

  resource "build-markdown-it-py-4.2.0" do
    self.name = "markdown-it-py"
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "build-markupsafe-3.0.4" do
    self.name = "markupsafe"
    url "https://files.pythonhosted.org/packages/38/9b/e422a865e1d5d57d0e509b4e0bf1c1a70a7f6382c29a5aa428df994c8bc8/markupsafe-3.0.4.tar.gz"
    sha256 "2e9ad7dd851bf45fab9f75cbff4cb493fee9979e8d8c7c9c3ee119022518edd6"
  end

  resource "build-maturin-1.15.0" do
    self.name = "maturin"
    url "https://files.pythonhosted.org/packages/b9/c8/22e5e21b2679c9bce6415ca578034ca2cc9316be0642ae21e051a2d5198c/maturin-1.15.0.tar.gz"
    sha256 "94b26cc8e8aba61a5f2099715fe640e18c5f678e9a500408b38761263954228a"
  end

  resource "build-maturin-1.16.0" do
    self.name = "maturin"
    url "https://files.pythonhosted.org/packages/bd/71/eb078174335ff30bde1be2ad54fb6256db4b160eb3efa81163fa30f8c814/maturin-1.16.0.tar.gz"
    sha256 "13e69ca12542999d8c5467131de72a49bb76e4c284b9a45c5783df7c0fcb3a8a"
  end

  resource "build-mdurl-0.1.2" do
    self.name = "mdurl"
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "build-meson-1.12.1" do
    self.name = "meson"
    url "https://files.pythonhosted.org/packages/f9/c9/8c9983f4f3d9c4e22fd76bcf8cd053e4472aefae45fd044669b6daa34b53/meson-1.12.1.tar.gz"
    sha256 "ab0a6ca09f8ef70c564c8241fb5a23957886a0b53fb58412b5e07eaf07dba743"
  end

  resource "build-meson-python-0.22.1" do
    self.name = "meson-python"
    url "https://files.pythonhosted.org/packages/b4/40/343ae23722d5d66a7b94b752d1b194202640995296379333b274b1860871/meson_python-0.22.1.tar.gz"
    sha256 "52c88628b0e5671592dc2306613fb5f6f3615fd24def059b9894f143b7f9a139"
  end

  resource "build-more-itertools-11.2.1" do
    self.name = "more-itertools"
    url "https://files.pythonhosted.org/packages/52/b8/c63995bebbb9ac9c059350e0fb8c82c2420c85aeca7d34e40aecf3df9281/more_itertools-11.2.1.tar.gz"
    sha256 "cbf08fd0af284dc69718b9b76a8e6203df624d70209ea511e4219d350c856f63"
  end

  resource "build-nh3-0.3.7" do
    self.name = "nh3"
    url "https://files.pythonhosted.org/packages/18/2f/022b27146d52d24b1b353b003359134788ecbcd6fcdf6283adbd57c0fbc8/nh3-0.3.7.tar.gz"
    sha256 "71860d01c16f4d8c72e334e0674beb2b0899dbd0bf760de18932ef4390303848"
  end

  resource "build-numpy-2.5.4" do
    self.name = "numpy"
    url "https://files.pythonhosted.org/packages/95/b0/c7453d0b6e2073c3264468b106ee1563750cecc910965e67357e3698c83e/numpy-2.5.4.tar.gz"
    sha256 "9a94cf751c9ad8ebaa835bcd3d40dacf8534ad086b88c38029b65123c7999d2a"
  end

  resource "build-packaging-26.0" do
    self.name = "packaging"
    url "https://files.pythonhosted.org/packages/65/ee/299d360cdc32edc7d2cf530f3accf79c4fca01e96ffc950d8a52213bd8e4/packaging-26.0.tar.gz"
    sha256 "00243ae351a257117b6a241061796684b084ed1c516a08c48a3f7e147a9d80b4"
  end

  resource "build-packaging-26.3" do
    self.name = "packaging"
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "build-pathspec-1.0.4" do
    self.name = "pathspec"
    url "https://files.pythonhosted.org/packages/fa/36/e27608899f9b8d4dff0617b2d9ab17ca5608956ca44461ac14ac48b44015/pathspec-1.0.4.tar.gz"
    sha256 "0210e2ae8a21a9137c0d470578cb0e595af87edaa6ebf12ff176f14a02e0e645"
  end

  resource "build-pathspec-1.1.1" do
    self.name = "pathspec"
    url "https://files.pythonhosted.org/packages/5a/82/42f767fc1c1143d6fd36efb827202a2d997a375e160a71eb2888a925aac1/pathspec-1.1.1.tar.gz"
    sha256 "17db5ecd524104a120e173814c90367a96a98d07c45b2e10c2f3919fff91bf5a"
  end

  resource "build-pdm-backend-2.5.0" do
    self.name = "pdm-backend"
    url "https://files.pythonhosted.org/packages/fc/d5/a82f533ed51f91a2183faf67a1fcb3b759615ffeca95d05b3e7648bf84bf/pdm_backend-2.5.0.tar.gz"
    sha256 "7953b994563d3151755e3364b9d0cfe817ed0eaecdf27c8f777f412d26bcd98a"
  end

  resource "build-pdm-pep517-1.1.4" do
    self.name = "pdm-pep517"
    url "https://files.pythonhosted.org/packages/43/42/5c8818b70fc4b25c99e56aeeb3484ede076114c8a0772675b44a3b7891cc/pdm-pep517-1.1.4.tar.gz"
    sha256 "7f49121e70b42dca296fac962210dd2da07a39575fc5673137ad661633b2cf3f"
  end

  resource "build-pkgconfig-1.6.0" do
    self.name = "pkgconfig"
    url "https://files.pythonhosted.org/packages/52/fd/0adde075cd3bfecd557bc7d757e00e231d34d8a6edb4c8d1642759254c21/pkgconfig-1.6.0.tar.gz"
    sha256 "4a5a6631ce937fafac457104a40d558785a658bbdca5c49b6295bc3fd651907f"
  end

  resource "build-pkginfo-2.0" do
    self.name = "pkginfo"
    url "https://files.pythonhosted.org/packages/30/37/7580f0accc77d450a53ff7856fe142a89fc11467c2f22105dd06e088a5d1/pkginfo-2.0.tar.gz"
    sha256 "f7b4f267881785582c923631a0fa7e275b0d390a5cbab54aa4ec0ecc7eddb375"
  end

  resource "build-pluggy-1.6.0" do
    self.name = "pluggy"
    url "https://files.pythonhosted.org/packages/f9/e2/3e91f31a7d2b083fe6ef3fa267035b518369d9511ffab804f839851d2779/pluggy-1.6.0.tar.gz"
    sha256 "7dcc130b76258d33b90f61b658791dede3486c3e6bfb003ee5c9bfb396dd22f3"
  end

  resource "build-pluggy-1.7.0" do
    self.name = "pluggy"
    url "https://files.pythonhosted.org/packages/bf/db/7fc19e6f2dc92a966727031389fc2e08b558f0f25eb7403c1119ad4713cd/pluggy-1.7.0.tar.gz"
    sha256 "d1eaa46ebb595891b860ab086b4d09c8588af65ebd4361b8e8f4bb8920b90ba8"
  end

  resource "build-poetry-core-2.5.0" do
    self.name = "poetry-core"
    url "https://files.pythonhosted.org/packages/42/b5/50f1fda26c4fe5b1d6ce5cdf0391bdfa1ca12fdcb8ad68344d5cf678fc90/poetry_core-2.5.0.tar.gz"
    sha256 "81d04c9253b19d0604718268d781867c8f7b2128e5b25bbf1e84141eec6b89c4"
  end

  resource "build-pybind11-3.1.0" do
    self.name = "pybind11"
    url "https://files.pythonhosted.org/packages/76/f3/95b0f40b31df41dbfe6bb0857419c9442c15839cbac4796f1c26ae0b6081/pybind11-3.1.0.tar.gz"
    sha256 "a1cc06b524ab3edca51f8ad3895f9c4fa20b8b19283173dff4ae781449dc9639"
  end

  resource "build-pycparser-3.12" do
    self.name = "pycparser"
    url "https://files.pythonhosted.org/packages/cb/27/eeb9f307bf07060f3d9f9aa0fb8c15b01bdfded0a941e4b2719c7f94cacd/pycparser-3.12.tar.gz"
    sha256 "f03387877eab82ce01bbdfd0ba7252ee55a90b1c708d5129e2ce915475cf1db6"
  end

  resource "build-pygments-2.21.0" do
    self.name = "pygments"
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "build-pyparsing-3.3.3" do
    self.name = "pyparsing"
    url "https://files.pythonhosted.org/packages/e4/11/b213bebff182584360cb8d17c72c1677fec5c5c228de439e63bcf8ab1c8f/pyparsing-3.3.3.tar.gz"
    sha256 "928ae7e20211f3b6f3915a72f06a0cfd29ab9d24279dd6346b6b1a7146397d36"
  end

  resource "build-pyproject-metadata-0.12.1" do
    self.name = "pyproject-metadata"
    url "https://files.pythonhosted.org/packages/4f/76/1cae539918a7b1746d624c2f01560b793c22cd8c081157505bb9bbf0e34d/pyproject_metadata-0.12.1.tar.gz"
    sha256 "8809a4df6fe08279b39a8890669506ed3158e0617855ac9aff098fcbe772ae4c"
  end

  resource "build-readme-renderer-46.0" do
    self.name = "readme-renderer"
    url "https://files.pythonhosted.org/packages/25/d7/9309494fad74ee831d4546f69325b5519f37c6dfb2d9ba495db8c6d4f4ca/readme_renderer-46.0.tar.gz"
    sha256 "af3e964914f6310a33ff67b72a4bdd940bed8d7c3bdecd2d14f40edf284bfe90"
  end

  resource "build-requests-2.34.2" do
    self.name = "requests"
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "build-requests-toolbelt-1.0.0" do
    self.name = "requests-toolbelt"
    url "https://files.pythonhosted.org/packages/f3/61/d7545dafb7ac2230c70d38d31cbfe4cc64f7144dc41f6e4e4b78ecd9f5bb/requests-toolbelt-1.0.0.tar.gz"
    sha256 "7681a0a3d047012b5bdc0ee37d7f8f07ebe76ab08caeccfc3921ce23c88d5bc6"
  end

  resource "build-rfc3986-2.0.0" do
    self.name = "rfc3986"
    url "https://files.pythonhosted.org/packages/85/40/1520d68bfa07ab5a6f065a186815fb6610c86fe957bc065754e47f7b0840/rfc3986-2.0.0.tar.gz"
    sha256 "97aacf9dbd4bfd829baad6e6309fa6573aaf1be3f6fa735c8ab05e46cecb261c"
  end

  resource "build-rich-15.0.0" do
    self.name = "rich"
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "build-scikit-build-core-1.1.1" do
    self.name = "scikit-build-core"
    url "https://files.pythonhosted.org/packages/b2/1a/8c00b19c0a1e7acf890676af2efa430339d38e59fa9437f2aab8517af3f4/scikit_build_core-1.1.1.tar.gz"
    sha256 "e347a59193c878ac56a363e57506938652a6dd8c965790cb1cbc6bc7e8d5abad"
  end

  resource "build-secretstorage-3.5.0" do
    self.name = "secretstorage"
    url "https://files.pythonhosted.org/packages/1c/03/e834bcd866f2f8a49a85eaff47340affa3bfa391ee9912a952a1faa68c7b/secretstorage-3.5.0.tar.gz"
    sha256 "f04b8e4689cbce351744d5537bf6b1329c6fc68f91fa666f60a380edddcd11be"
  end

  resource "build-semantic-version-2.10.0" do
    self.name = "semantic-version"
    url "https://files.pythonhosted.org/packages/7d/31/f2289ce78b9b473d582568c234e104d2a342fd658cc288a7553d83bb8595/semantic_version-2.10.0.tar.gz"
    sha256 "bdabb6d336998cbb378d4b9db3a4b56a1e3235701dc05ea2690d9a997ed5041c"
  end

  resource "build-setuptools-80.9.0" do
    self.name = "setuptools"
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
  end

  resource "build-setuptools-81.0.0" do
    self.name = "setuptools"
    url "https://files.pythonhosted.org/packages/0d/1c/73e719955c59b8e424d015ab450f51c0af856ae46ea2da83eba51cc88de1/setuptools-81.0.0.tar.gz"
    sha256 "487b53915f52501f0a79ccfd0c02c165ffe06631443a886740b91af4b7a5845a"
  end

  resource "build-setuptools-84.0.0" do
    self.name = "setuptools"
    url "https://files.pythonhosted.org/packages/6d/44/f5da03a8ef95d369145c5bb53050e7877c9f3d312e128605fd9504829143/setuptools-84.0.0.tar.gz"
    sha256 "f4695c21257f0d9b537ec2692c941d02ee143b7cc1276941349a546573b2ef73"
  end

  resource "build-setuptools-84.2.1" do
    self.name = "setuptools"
    url "https://files.pythonhosted.org/packages/70/b3/c19426f783614d625699a4b247faf628ea9ab1db228674491767b417f9e1/setuptools-84.2.1.tar.gz"
    sha256 "3ff8b3b5492a0aa66960f4419365a86b84e013070d4313e4d4a6894f5d64d6bc"
  end

  resource "build-setuptools-rust-1.13.0" do
    self.name = "setuptools-rust"
    url "https://files.pythonhosted.org/packages/68/ba/b31781d61bf9ee3c232a1d1160db11c11cdeae1d44e06c90723b25a8279f/setuptools_rust-1.13.0.tar.gz"
    sha256 "f2afcf4baeee689910ce49cfa8aad4e08cce72f417449bcc32891b8664fdc726"
  end

  resource "build-setuptools-scm-10.3.4" do
    self.name = "setuptools-scm"
    url "https://files.pythonhosted.org/packages/85/d8/fc143f88819ccf10ba2388ba86732ee2de193e578234e25a783f6cc14bf7/setuptools_scm-10.3.4.tar.gz"
    sha256 "a69f28bfc245608781205e912faae437c2b2165773afa4e7b979d77447a69dd2"
  end

  resource "build-setuptools-scm-7.1.0" do
    self.name = "setuptools-scm"
    url "https://files.pythonhosted.org/packages/98/12/2c1e579bb968759fc512391473340d0661b1a8c96a59fb7c65b02eec1321/setuptools_scm-7.1.0.tar.gz"
    sha256 "6c508345a771aad7d56ebff0e70628bf2b0ec7573762be9960214730de278f27"
  end

  resource "build-tomlkit-0.15.2" do
    self.name = "tomlkit"
    url "https://files.pythonhosted.org/packages/08/72/fc01563df95c189a9f65850096bdc205bc2fe37da6c740cd64afaf18d07e/tomlkit-0.15.2.tar.gz"
    sha256 "83e32755ba1d20d9340bd069ee97e9f6232ba2346b63ffcba425de01f7e327a6"
  end

  resource "build-trove-classifiers-2026.1.14.14" do
    self.name = "trove-classifiers"
    url "https://files.pythonhosted.org/packages/d8/43/7935f8ea93fcb6680bc10a6fdbf534075c198eeead59150dd5ed68449642/trove_classifiers-2026.1.14.14.tar.gz"
    sha256 "00492545a1402b09d4858605ba190ea33243d361e2b01c9c296ce06b5c3325f3"
  end

  resource "build-trove-classifiers-2026.9.21.13" do
    self.name = "trove-classifiers"
    url "https://files.pythonhosted.org/packages/bf/93/af436dfaa845cab5d96f0adbc1e4f3730532d37fa249e4eb796fb1d7fc82/trove_classifiers-2026.9.21.13.tar.gz"
    sha256 "0a9ebc8d4e2f3e8a22848c5258033035bec17a3012ac3fea16dbaa764489eb71"
  end

  resource "build-twine-7.0.0" do
    self.name = "twine"
    url "https://files.pythonhosted.org/packages/92/3c/58f808a359700f39a967dffede33efeac809262c03303fa3eec6afff8f49/twine-7.0.0.tar.gz"
    sha256 "85cdb29c518efef867360ae4acd4b0dfd61c8654a22fca08e6f8539f05022177"
  end

  resource "build-typing-extensions-4.16.0" do
    self.name = "typing-extensions"
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "build-urllib3-2.8.0" do
    self.name = "urllib3"
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  resource "build-uv-build-0.8.24" do
    self.name = "uv-build"
    url "https://files.pythonhosted.org/packages/50/60/6d96c3dd49223156b7f7b7eb4b79f94727cb529806b2c086f75d4dfb7ca6/uv_build-0.8.24.tar.gz"
    sha256 "02e1256ac4524b06319a7fbfa30aa4959d9ef0b63076a959cce20a588448def8"
  end

  resource "build-uv-dynamic-versioning-0.14.1" do
    self.name = "uv-dynamic-versioning"
    url "https://files.pythonhosted.org/packages/6f/c8/fa500ee29af69cfeeea5ff6d6597919f1989b2e3f1a236c3006bdb21d320/uv_dynamic_versioning-0.14.1.tar.gz"
    sha256 "8642db686ce5c50417035e7a257ac73b7e5c3a7a32c33e45bd7e36ba22eeb648"
  end

  resource "build-vcs-versioning-2.6.0" do
    self.name = "vcs-versioning"
    url "https://files.pythonhosted.org/packages/ad/e7/2a691db7d076b75d099fdba1a14cd966931f2aeb591e77f6d22f15097326/vcs_versioning-2.6.0.tar.gz"
    sha256 "22e9159288e2d8bca2fa6f6c31c34c9c66aec157f60e9e526f5d160d2516d60f"
  end

  resource "build-versioneer-0.29" do
    self.name = "versioneer"
    url "https://files.pythonhosted.org/packages/32/d7/854e45d2b03e1a8ee2aa6429dd396d002ce71e5d88b77551b2fb249cb382/versioneer-0.29.tar.gz"
    sha256 "5ab283b9857211d61b53318b7c792cf68e798e765ee17c27ade9f6c924235731"
  end

  resource "build-wheel-0.48.0" do
    self.name = "wheel"
    url "https://files.pythonhosted.org/packages/d0/20/50ed6bdf27dec98b568a8ae25dc599f35baa3d9709f9e83fd1edb56b9a90/wheel-0.48.0.tar.gz"
    sha256 "94800765601e9171bf5d58d066e640662842bcedcbab982b2c90787a2c987322"
  end

  resource "github-copilot-sdk" do
    url "https://github.com/github/copilot-sdk/archive/refs/tags/v1.0.11.tar.gz"
    sha256 "e23fa5b468b886309211a1f5d606aab650e9f725c9c3234f07d66d6c4d170b5a"
  end

  resource "flatbuffers" do
    url "https://github.com/google/flatbuffers/archive/refs/tags/v25.12.19.tar.gz"
    sha256 "f81c3162b1046fe8b84b9a0dbdd383e24fdbcf88583b9cb6028f90d04d90696a"
  end

  resource "onnxruntime" do
    url "https://github.com/microsoft/onnxruntime/archive/refs/tags/v1.31.0.tar.gz"
    sha256 "a7e84230b5d509e48fbd6b73c2453a56345ccb22da34a46dac1f0cb4a2d6507b"
  end

  # Native builds fetch source dependencies; the test runs a disposable loopback PostgreSQL server.
  allow_network_access! [:build, :test]

  def install
    ENV.prepend_path "PATH", formula_opt_bin("libpq")
    ENV["PYTHONUSERBASE"] = buildpath/"build-tools"
    (buildpath/"build-tools/bin").mkpath
    ENV.prepend_path "PATH", buildpath/"build-tools/bin"

    # Keep AWS-LC's entropy collector unoptimized without disabling it or bypassing superenv.
    aws_lc_cc = buildpath/"build-tools/bin/aws-lc-cc"
    aws_lc_cc.write <<~SH
      #!/bin/bash
      last_opt=
      for arg in "$@"; do
        case "$arg" in -O|-O[0-9]|-Os|-Oz|-Og|-Ofast) last_opt="$arg" ;; esac
      done
      if [[ "$last_opt" == "-O0" ]]; then
        export HOMEBREW_OPTIMIZATION_LEVEL=O0
      fi
      exec "#{ENV.cc}" "$@"
    SH
    chmod 0755, aws_lc_cc
    ENV["AWS_LC_SYS_CC"] = aws_lc_cc.to_s

    sdists = buildpath/"sdists"
    sdists.mkpath
    resources.each do |r|
      next if %w[github-copilot-sdk flatbuffers onnxruntime].include?(r.name)

      sdists.install_symlink r.cached_download => File.basename(URI.parse(r.url).path)
    end
    ENV["PIP_NO_INDEX"] = "1"
    ENV["PIP_FIND_LINKS"] = sdists
    ENV["PIP_NO_BINARY"] = ":all:"
    venv = virtualenv_create(libexec, "python3.14")

    resource("flatbuffers").stage do
      venv.pip_install Pathname.pwd/"python"
    end
    resource("github-copilot-sdk").stage do
      # Upstream injects this sentinel version in its release publishing workflow.
      inreplace "python/pyproject.toml", 'version = "0.0.0.dev0"', 'version = "1.0.11"'
      venv.pip_install Pathname.pwd/"python"
    end

    # Core's pydantic requires typing-extensions >=4.16; keep older source roles for isolated backends.
    venv.pip_install resource("build-typing-extensions-4.16.0")

    %w[
      aiofile aiohappyeyeballs aiohttp aiosignal alembic annotated-doc annotated-types anthropic anyio
      asgiref asyncpg attrs authlib beartype beautifulsoup4 boto3 botocore cachetools caio
      charset-normalizer claude-agent-sdk click cobble cohere croniter cyclopts dateparser defusedxml
      distro dnspython docstring-parser docutils email-validator et-xmlfile exceptiongroup fastapi
      fastapi-cli fastapi-cloud-cli fastar fastavro fastmcp fastuuid filelock frozenlist fsspec
      google-auth google-genai googleapis-common-protos greenlet h11 h2 hf-xet hpack httpcore
      httptools httpx httpx-sse huggingface-hub hyperframe idna importlib-metadata jaraco-classes
      jaraco-context jaraco-functools jeepney jinja2 jiter jmespath json-repair jsonref jsonschema
      jsonschema-path jsonschema-specifications keyring litellm lxml magika mako mammoth
      markdown-it-py markdownify markitdown markupsafe mcp mdurl more-itertools multidict obstore
      openai openapi-pydantic openpyxl opentelemetry-api opentelemetry-exporter-otlp-proto-common
      opentelemetry-exporter-otlp-proto-http opentelemetry-exporter-prometheus
      opentelemetry-instrumentation opentelemetry-instrumentation-asgi
      opentelemetry-instrumentation-fastapi opentelemetry-proto opentelemetry-sdk
      opentelemetry-semantic-conventions opentelemetry-util-http orjson packaging pandas pathable
      pdfminer-six pdfplumber pgvector platformdirs prometheus-client propcache protobuf psycopg2
      py-key-value-aio pyasn1 pyasn1-modules pycparser pydantic-extra-types pydantic-settings pygments
      pyjwt pypdfium2 pyperclip python-dateutil python-dotenv python-multipart python-pptx pytz pyyaml
      referencing regex requests rich rich-rst rich-toolkit rignore s3transfer secretstorage
      sentry-sdk shellingham six sniffio soupsieve sqlalchemy sse-starlette starlette tenacity
      tiktoken tokenizers toktok-rs tqdm typer types-requests typing-inspection
      tzdata tzlocal uncalled-for urllib3 uvicorn uvloop watchfiles websockets wrapt wsproto xlrd
      xlsxwriter yarl zipp
    ].each do |id|
      r = resource(id)
      if r.name == "pypdfium2"
        # Never take pypdfium2's default downloaded PDFium binary path.
        r.stage do
          # The toolchained wrapper has no jobs option; honor Homebrew's source-build capacity.
          inreplace "setupsrc/build_toolchained.py",
                    'run_cmd([*Ninja, "-C", PDFiumOutDir, target], cwd=PDFiumDir)',
                    "run_cmd([*Ninja, \"-j\", \"#{ENV.make_jobs}\", " \
                    "\"-C\", PDFiumOutDir, target], cwd=PDFiumDir)"
          with_env(PDFIUM_PLATFORM: "sourcebuild-toolchained:7191") { venv.pip_install Pathname.pwd }
        end
      elsif r.name == "claude-agent-sdk"
        r.stage do
          # Provider CLIs remain operator-supplied; only the MIT Python SDK is bundled.
          rm_r "src/claude_agent_sdk/_bundled"
          venv.pip_install Pathname.pwd
        end
      else
        venv.pip_install r
      end
    end

    resource("onnxruntime").stage do
      # The Python bindings are not provided by the brewed C++ ONNX Runtime library.
      # Build both from the public source, rather than using PyPI's binary-only wheel.
      system "cmake", "-S", "cmake", "-B", "build", *std_cmake_args,
                      "-DCMAKE_POLICY_VERSION_MINIMUM=3.5",
                      "-DHOMEBREW_ALLOW_FETCHCONTENT=ON",
                      "-DFETCHCONTENT_TRY_FIND_PACKAGE_MODE=NEVER",
                      "-DPython_EXECUTABLE=#{libexec}/bin/python",
                      "-Donnxruntime_ENABLE_PYTHON=ON",
                      "-Donnxruntime_BUILD_SHARED_LIB=ON",
                      "-Donnxruntime_BUILD_UNIT_TESTS=OFF",
                      "-Donnxruntime_RUN_ONNX_TESTS=OFF",
                      "-Donnxruntime_USE_COREML=OFF"
      system "cmake", "--build", "build"
      cp "setup.py", "build"
      cp "VERSION_NUMBER", "build"
      cp "requirements.txt", "build"
      cp_r "docs", "build"
      mkdir_p "build/onnxruntime/python"
      cp "onnxruntime/python/onnxruntime_collect_build_info.py", "build/onnxruntime/python"
      venv.pip_install Pathname.pwd/"build"
    end

    cd "hindsight-api-slim" do
      inreplace "pyproject.toml", "psycopg2-binary", "psycopg2"
      venv.pip_install_and_link Pathname.pwd
    end
  end

  def caveats
    <<~EOS
      This is the source-built API/CLI component (hindsight-api-slim), matching Nix.
      Local-ML and downloaded embedded PostgreSQL are not included.
      Configure HINDSIGHT_API_DATABASE_URL and remote embeddings/reranker providers
      in #{var}/hindsight/.env before starting the service. PostgreSQL and pgvector
      are provided by Homebrew; create your database and configure model credentials.
      Claude and Copilot providers use separately installed provider executables.
    EOS
  end

  service do
    run [opt_bin/"hindsight-api", "--host", "127.0.0.1", "--port", "8888"]
    working_dir var/"hindsight"
    log_path var/"log/hindsight.log"
    error_log_path var/"log/hindsight.log"
  end

  test do
    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    code = 'import importlib.metadata; print(importlib.metadata.version("hindsight-api-slim"))'
    assert_equal version.to_s, shell_output("#{libexec}/bin/python -c '#{code}'").strip
    output = shell_output("#{bin}/hindsight-api --port invalid 2>&1", 2)
    assert_match "invalid int value", output

    port = free_port
    pg_ctl = formula_opt_bin("postgresql@18")/"pg_ctl"
    psql = formula_opt_bin("postgresql@18")/"psql"
    system pg_ctl, "initdb", "-D", testpath/"database"
    (testpath/"database/postgresql.conf").write <<~EOS, mode: "a+"
      port = #{port}
      unix_socket_directories = '#{testpath}'
      listen_addresses = '127.0.0.1'
    EOS
    system pg_ctl, "start", "-D", testpath/"database", "-l", testpath/"postgresql.log"
    begin
      ENV["HINDSIGHT_API_DATABASE_URL"] = "postgresql://#{ENV.fetch("USER")}@127.0.0.1:#{port}/postgres"
      system bin/"hindsight-admin", "run-db-migration"
      query = "SELECT extname FROM pg_extension WHERE extname = 'vector'"
      assert_match "vector", shell_output("#{psql} -h 127.0.0.1 -p #{port} -d postgres -Atc \"#{query}\"")
      assert_match "1", shell_output("#{psql} -h 127.0.0.1 -p #{port} -d postgres " \
                                     "-Atc 'SELECT count(*) FROM alembic_version'")
    ensure
      system pg_ctl, "stop", "-D", testpath/"database"
    end
  end
end
