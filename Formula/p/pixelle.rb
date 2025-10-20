class Pixelle < Formula
  include Language::Python::Virtualenv

  desc "Open-Source Multimodal AIGC Solution based on ComfyUI + MCP + LLM"
  homepage "https://pixelle.ai/"
  url "https://files.pythonhosted.org/packages/cf/6a/77b094ee9f63901e6eeb9adfe3d9e659f8c83586ef3f84c80f5249138045/pixelle-0.1.16.tar.gz"
  sha256 "d40534b739bcb76cb7266530ba65824a6ca73964d7b59b5d97b0d42722fbb0ff"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "3b96bbeb18b25eae809960c1e0f3c8483a63bf4d413cf47d5172287b4b9abf86"
    sha256 cellar: :any,                 arm64_sequoia: "bda72d8a1a66515af5e57cfe5d48d6396a44cd0d155bf5148b4b17ca2ac8d2d9"
    sha256 cellar: :any,                 arm64_sonoma:  "26529f55000aef1076e65a5ea672bb04cc2289f8453651ceae9278f9fcc4b271"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1aabde1d53714a0e2293e5cc90e1d8796fa847715e8607ba1c56bfb57e7aebf"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build # for pydantic
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "pillow"
  depends_on "python@3.13"

  resource "aiofiles" do
    url "https://files.pythonhosted.org/packages/0b/03/a88171e277e8caa88a4c77808c20ebb04ba74cc4681bf1e9416c862de237/aiofiles-24.1.0.tar.gz"
    sha256 "22a075c9e5a3810f0c2e48f3008c94d68c65d763b9b03857924c99e57355166c"
  end

  resource "aiohappyeyeballs" do
    url "https://files.pythonhosted.org/packages/26/30/f84a107a9c4331c14b2b586036f40965c128aa4fee4dda5d3d51cb14ad54/aiohappyeyeballs-2.6.1.tar.gz"
    sha256 "c3f9d0113123803ccadfdf3f0faa505bc78e6a72d1cc4806cbd719826e943558"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/62/f1/8515650ac3121a9e55c7b217c60e7fae3e0134b5acfe65691781b5356929/aiohttp-3.13.0.tar.gz"
    sha256 "378dbc57dd8cf341ce243f13fa1fa5394d68e2e02c15cd5f28eae35a70ec7f67"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/61/62/06741b579156360248d1ec624842ad0edf697050bbaf7c3e46394e106ad1/aiosignal-1.4.0.tar.gz"
    sha256 "f47eecd9468083c2029cc99945502cb7708b082c232f9aca65da147157b251c7"
  end

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/ee/67/531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5/annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "anthropic" do
    url "https://files.pythonhosted.org/packages/c8/9d/9ad1778b95f15c5b04e7d328c1b5f558f1e893857b7c33cd288c19c0057a/anthropic-0.69.0.tar.gz"
    sha256 "c604d287f4d73640f40bd2c0f3265a2eb6ce034217ead0608f6b07a8bc5ae5f2"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/c6/78/7d432127c41b50bccba979505f272c16cbcadcc33645d5fa3a738110ae75/anyio-4.11.0.tar.gz"
    sha256 "82a8d0b81e318cc5ce71a5f1f8b5c4e63619620b63141ef8c995fa0db95a57c4"
  end

  resource "asyncer" do
    url "https://files.pythonhosted.org/packages/51/c7/64a9fa7c2e6740eeb142686c61c009c0820dc03a6526a18f53fc11645d83/asyncer-0.0.9.tar.gz"
    sha256 "9d1d5d688dbf7b3aec182bbf7d4b24ed2f242c727fefab44197c1862a2bb8601"
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

  resource "bidict" do
    url "https://files.pythonhosted.org/packages/9a/6e/026678aa5a830e07cd9498a05d3e7e650a4f56a42f267a53d22bcda1bdc9/bidict-0.23.1.tar.gz"
    sha256 "03069d763bc387bbd20e7d49914e75fc4132a41937fa3405417e1a5a2d006d71"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/a0/5a/8ba08c979926326d961e2384d994d789a2eda3ed281bb6cb333b36e92310/boto3-1.40.52.tar.gz"
    sha256 "96ee720b52be647d8ef5ba92fccfce6b65d6321769430fe6edd10d57ec43c25b"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/83/74/3449d77c002d82586786b91dff6dd2e6fd52c5cdc1793d1ac7ea690ea52c/botocore-1.40.52.tar.gz"
    sha256 "b65d970ca4ccd869639332083da17c3a933bcf495120dcc4f5c7723cb3f6216c"
  end

  resource "chainlit" do
    url "https://files.pythonhosted.org/packages/5a/86/c569ec39fddfaf5166194ff444cbb29367dbd9644cdbeef8c9602d4e83e6/chainlit-2.8.3.tar.gz"
    sha256 "fbd70aa5563e93e148a7fed251c7b4ac79c14f0946ebeb6516c1605fa1ee0b15"
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
    url "https://files.pythonhosted.org/packages/46/61/de6cd827efad202d7057d93e0fed9294b96952e188f7384832791c7b2254/click-8.3.0.tar.gz"
    sha256 "e7b8232224eba16f4ebe410c25ced9f7875cb5f3263ffc93cc3e8da705e229c4"
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
    url "https://files.pythonhosted.org/packages/30/ca/7782da3b03242d5f0a16c20371dff99d4bd1fedafe26bc48ff82e42be8c9/cyclopts-3.24.0.tar.gz"
    sha256 "de6964a041dfb3c57bf043b41e68c43548227a17de1bad246e3a0bfc5c4b7417"
  end

  resource "dataclasses-json" do
    url "https://files.pythonhosted.org/packages/64/a4/f71d9cf3a5ac257c993b5ca3f93df5f7fb395c725e7f1e6479d2514173c3/dataclasses_json-0.6.7.tar.gz"
    sha256 "b6b3e528266ea45b9535223bc53ca645f5208833c29229e847b3f26a1cc55fc0"
  end

  resource "deprecated" do
    url "https://files.pythonhosted.org/packages/98/97/06afe62762c9a8a86af0cfb7bfdab22a43ad17138b07af5b1a58442690a2/deprecated-1.2.18.tar.gz"
    sha256 "422b6f6d859da6f2ef57857761bfb392480502a64c3028ca9bbe86085d72115d"
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
    url "https://files.pythonhosted.org/packages/4a/c0/89fe6215b443b919cb98a5002e107cb5026854ed1ccb6b5833e0768419d1/docutils-0.22.2.tar.gz"
    sha256 "9fdb771707c8784c8f2728b67cb2c691305933d68137ef95a75db5f4dfbc213d"
  end

  resource "email-validator" do
    url "https://files.pythonhosted.org/packages/f5/22/900cb125c76b7aaa450ce02fd727f452243f2e91a61af068b40adba60ea9/email_validator-2.3.0.tar.gz"
    sha256 "9fc05c37f2f6cf439ff414f8fc46d917929974a82244c20eb10231ba60c54426"
  end

  resource "exceptiongroup" do
    url "https://files.pythonhosted.org/packages/0b/9f/a65090624ecf468cdca03533906e7c69ed7588582240cfe7cc9e770b50eb/exceptiongroup-1.3.0.tar.gz"
    sha256 "b241f5885f560bc56a59ee63ca4c6a8bfa46ae4ad651af316d4e81817bb9fd88"
  end

  resource "fastapi" do
    url "https://files.pythonhosted.org/packages/01/64/1296f46d6b9e3b23fb22e5d01af3f104ef411425531376212f1eefa2794d/fastapi-0.116.2.tar.gz"
    sha256 "231a6af2fe21cfa2c32730170ad8514985fc250bec16c9b242d3b94c835ef529"
  end

  resource "fastmcp" do
    url "https://files.pythonhosted.org/packages/a8/b2/57845353a9bc63002995a982e66f3d0be4ec761e7bcb89e7d0638518d42a/fastmcp-2.12.4.tar.gz"
    sha256 "b55fe89537038f19d0f4476544f9ca5ac171033f61811cc8f12bdeadcbea5016"
  end

  resource "fastuuid" do
    url "https://files.pythonhosted.org/packages/15/80/3c16a1edad2e6cd82fbd15ac998cc1b881f478bf1f80ca717d941c441874/fastuuid-0.13.5.tar.gz"
    sha256 "d4976821ab424d41542e1ea39bc828a9d454c3f8a04067c06fca123c5b95a1a1"
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
    url "https://files.pythonhosted.org/packages/de/e0/bab50af11c2d75c9c4a2a26a5254573c0bd97cea152254401510950486fa/fsspec-2025.9.0.tar.gz"
    sha256 "19fd429483d25d28b65ec68f9f4adc16c17ea2c7c7bf54ec61360d478fb19c19"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/39/24/33db22342cf4a2ea27c9955e6713140fedd51e8b141b5ce5260897020f1a/googleapis_common_protos-1.70.0.tar.gz"
    sha256 "0e1b44e0ea153e6594f9f394fef15193a68aaaea2d843f83e2742717ca753257"
  end

  resource "grpcio" do
    url "https://files.pythonhosted.org/packages/9d/f7/8963848164c7604efb3a3e6ee457fdb3a469653e19002bd24742473254f8/grpcio-1.75.1.tar.gz"
    sha256 "3e81d89ece99b9ace23a6916880baca613c03a799925afb2857887efa8b1b3d2"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "hf-xet" do
    url "https://files.pythonhosted.org/packages/74/31/feeddfce1748c4a233ec1aa5b7396161c07ae1aa9b7bdbc9a72c3c7dd768/hf_xet-1.1.10.tar.gz"
    sha256 "408aef343800a2102374a883f283ff29068055c111f003ff840733d3b715bb97"
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
    url "https://files.pythonhosted.org/packages/10/7e/a0a97de7c73671863ca6b3f61fa12518caf35db37825e43d63a70956738c/huggingface_hub-0.35.3.tar.gz"
    sha256 "350932eaa5cc6a4747efae85126ee220e4ef1b54e29d31c3b45c5612ddf0b32a"
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

  resource "isodate" do
    url "https://files.pythonhosted.org/packages/54/4d/e940025e2ce31a8ce1202635910747e5a87cc3a6a6bb2d00973375014749/isodate-0.7.2.tar.gz"
    sha256 "4cd1aa0f43ca76f4a6c6c0292a85f40b35ec2e43e315b59f06e6d32171a953e6"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "jiter" do
    url "https://files.pythonhosted.org/packages/9d/c0/a3bb4cc13aced219dd18191ea66e874266bd8aa7b96744e495e1c733aa2d/jiter-0.11.0.tar.gz"
    sha256 "1d9637eaf8c1d6a63d6562f2a6e5ab3af946c66037eb1b894e8fad75422266e4"
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

  resource "lazify" do
    url "https://files.pythonhosted.org/packages/24/2c/b55c4a27a56dd9a00bb2812c404b57f8b7aec0cdbff9fdc61acdd73359bc/Lazify-0.4.0.tar.gz"
    sha256 "7102bfe63e56de2ab62b3bc661a7190c4056771a8624f04a8b785275c3dd1f9b"
  end

  resource "lazy-object-proxy" do
    url "https://files.pythonhosted.org/packages/08/a2/69df9c6ba6d316cfd81fe2381e464db3e6de5db45f8c43c6a23504abf8cb/lazy_object_proxy-1.12.0.tar.gz"
    sha256 "1f5a462d92fd0cfb82f1fab28b51bfb209fabbe6aabf7f0d51472c0c124c0c61"
  end

  resource "litellm" do
    url "https://files.pythonhosted.org/packages/fd/3e/1a96a3caeeb6092d85e70904e2caa98598abb7179cefe734e2fbffac6978/litellm-1.78.0.tar.gz"
    sha256 "020e40e0d6e16009bb3a6b156d4c1d98cb5c33704aa340fdf9ffd014bfd31f3b"
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
    url "https://files.pythonhosted.org/packages/5a/79/5724a540df19e192e8606c543cdcf162de8eb435077520cca150f7365ec0/mcp-1.17.0.tar.gz"
    sha256 "1b57fabf3203240ccc48e39859faf3ae1ccb0b571ff798bbedae800c73c6df90"
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
    url "https://files.pythonhosted.org/packages/de/90/8f26554d24d63ed4f94d33c24271559863223a67e624f4d2e65ba8e48dca/openai-2.3.0.tar.gz"
    sha256 "8d213ee5aaf91737faea2d7fc1cd608657a5367a18966372a3756ceaabfbd812"
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

  resource "opentelemetry-api" do
    url "https://files.pythonhosted.org/packages/63/04/05040d7ce33a907a2a02257e601992f0cdf11c73b33f13c4492bf6c3d6d5/opentelemetry_api-1.37.0.tar.gz"
    sha256 "540735b120355bd5112738ea53621f8d5edb35ebcd6fe21ada3ab1c61d1cd9a7"
  end

  resource "opentelemetry-exporter-otlp" do
    url "https://files.pythonhosted.org/packages/64/df/47fde1de15a3d5ad410e98710fac60cd3d509df5dc7ec1359b71d6bf7e70/opentelemetry_exporter_otlp-1.37.0.tar.gz"
    sha256 "f85b1929dd0d750751cc9159376fb05aa88bb7a08b6cdbf84edb0054d93e9f26"
  end

  resource "opentelemetry-exporter-otlp-proto-common" do
    url "https://files.pythonhosted.org/packages/dc/6c/10018cbcc1e6fff23aac67d7fd977c3d692dbe5f9ef9bb4db5c1268726cc/opentelemetry_exporter_otlp_proto_common-1.37.0.tar.gz"
    sha256 "c87a1bdd9f41fdc408d9cc9367bb53f8d2602829659f2b90be9f9d79d0bfe62c"
  end

  resource "opentelemetry-exporter-otlp-proto-grpc" do
    url "https://files.pythonhosted.org/packages/d1/11/4ad0979d0bb13ae5a845214e97c8d42da43980034c30d6f72d8e0ebe580e/opentelemetry_exporter_otlp_proto_grpc-1.37.0.tar.gz"
    sha256 "f55bcb9fc848ce05ad3dd954058bc7b126624d22c4d9e958da24d8537763bec5"
  end

  resource "opentelemetry-exporter-otlp-proto-http" do
    url "https://files.pythonhosted.org/packages/5d/e3/6e320aeb24f951449e73867e53c55542bebbaf24faeee7623ef677d66736/opentelemetry_exporter_otlp_proto_http-1.37.0.tar.gz"
    sha256 "e52e8600f1720d6de298419a802108a8f5afa63c96809ff83becb03f874e44ac"
  end

  resource "opentelemetry-instrumentation" do
    url "https://files.pythonhosted.org/packages/f6/36/7c307d9be8ce4ee7beb86d7f1d31027f2a6a89228240405a858d6e4d64f9/opentelemetry_instrumentation-0.58b0.tar.gz"
    sha256 "df640f3ac715a3e05af145c18f527f4422c6ab6c467e40bd24d2ad75a00cb705"
  end

  resource "opentelemetry-instrumentation-alephalpha" do
    url "https://files.pythonhosted.org/packages/14/e5/0bdeb5bc79b1cee379256000922b4278256daccec4aa8bfe3f5e7d858338/opentelemetry_instrumentation_alephalpha-0.47.3.tar.gz"
    sha256 "2ec3c5f6ac2e2385e0dcd0fbef12c2f4818d6201a9a43e3b5fc239c760adf029"
  end

  resource "opentelemetry-instrumentation-anthropic" do
    url "https://files.pythonhosted.org/packages/de/bc/e241871daf8264c7d527cecf18f2d26365f3289e0a2034795692be5d58d7/opentelemetry_instrumentation_anthropic-0.47.3.tar.gz"
    sha256 "e5ea191c354701ff0adcf03144d7d2de1a2408482058f524d4ea84bececd6259"
  end

  resource "opentelemetry-instrumentation-bedrock" do
    url "https://files.pythonhosted.org/packages/04/42/85ed72a36e1af830d39cd643830f66f07c659ac1242213dd06e8caa7a156/opentelemetry_instrumentation_bedrock-0.47.3.tar.gz"
    sha256 "d3585f4d54182f38248d9424d85e82847513c28431caccd27a1357680b3b901a"
  end

  resource "opentelemetry-instrumentation-chromadb" do
    url "https://files.pythonhosted.org/packages/b2/1b/15d52996f350fafee372bf7cc9ac3fe07c49e31878ddfacdb11528aa8e4f/opentelemetry_instrumentation_chromadb-0.47.3.tar.gz"
    sha256 "7d25b356041c18aace9ff9f76e1bc958189df3712c0c69e789895f960c4989d1"
  end

  resource "opentelemetry-instrumentation-cohere" do
    url "https://files.pythonhosted.org/packages/ee/ce/bda8afb3bef6e85be05aecaf48a43e3d69e2a1499948f20cbb28b1bff387/opentelemetry_instrumentation_cohere-0.47.3.tar.gz"
    sha256 "a7e6a889cb7b83ed221fa1212cc4d110c8478903222f53bf05fbc5cc934148ee"
  end

  resource "opentelemetry-instrumentation-crewai" do
    url "https://files.pythonhosted.org/packages/6e/c7/64647122476b18cc17c460d137ddd89feca03df852ea8ba4924cbb6eee97/opentelemetry_instrumentation_crewai-0.47.3.tar.gz"
    sha256 "80af9b6b92e95c729d3fcd5a9778f847538f8b7ce43c71497c20722ddaad3a5f"
  end

  resource "opentelemetry-instrumentation-google-generativeai" do
    url "https://files.pythonhosted.org/packages/38/66/e2fa46c3da43ab3aca4c57ab047093e35a41b62969e71a7a1744dbdb1259/opentelemetry_instrumentation_google_generativeai-0.47.3.tar.gz"
    sha256 "2294c996cf4fdcd64311edb718473a79559951fe73d617ece7b3ebd12191b618"
  end

  resource "opentelemetry-instrumentation-groq" do
    url "https://files.pythonhosted.org/packages/36/7d/324bc707edc36622f5a6c2e9e9f18272dc3285977531b94a141c01aef368/opentelemetry_instrumentation_groq-0.47.3.tar.gz"
    sha256 "d0ecf492e70080278fee4db1dfd0c78426f4769f27a09bb9ba1253396dd199ce"
  end

  resource "opentelemetry-instrumentation-haystack" do
    url "https://files.pythonhosted.org/packages/32/2b/a603167b0d71f7bb4e1efe7986baa3f1eab092f8fceb24e45968e4d24d66/opentelemetry_instrumentation_haystack-0.47.3.tar.gz"
    sha256 "9c61ea6906d754393941dcbc7cbb11809c542b3102687b697e807068b21606f1"
  end

  resource "opentelemetry-instrumentation-lancedb" do
    url "https://files.pythonhosted.org/packages/12/6d/8a2b34d2f972199a79183e219b888151bc3ec82636babec8a91d45f93e6c/opentelemetry_instrumentation_lancedb-0.47.3.tar.gz"
    sha256 "78d6e18e879188cf0a319cfd0a36aab2cecbbf2c33e6416955470918d19c591a"
  end

  resource "opentelemetry-instrumentation-langchain" do
    url "https://files.pythonhosted.org/packages/84/11/671ca5c73c2bb5ebffe10e12bd45dd67a85cd164613227e6a492b94ba884/opentelemetry_instrumentation_langchain-0.47.3.tar.gz"
    sha256 "ffdffde8e7dce9cfd2909ed652cef15226c7b8e27726d41079a079a41f4167e3"
  end

  resource "opentelemetry-instrumentation-llamaindex" do
    url "https://files.pythonhosted.org/packages/9f/ce/9cddb022c836321ea61f21e0cdb3d704021c6f8165dcea6df1cb301424f9/opentelemetry_instrumentation_llamaindex-0.47.3.tar.gz"
    sha256 "77e79d14cf9c3a0e34b8a986a2395c6732d121dba2a37d8ce43de77420d156b9"
  end

  resource "opentelemetry-instrumentation-logging" do
    url "https://files.pythonhosted.org/packages/e2/65/db3ce7a7eda7ae70338339baeb80894e283d24a0036a0021745e54a5b874/opentelemetry_instrumentation_logging-0.58b0.tar.gz"
    sha256 "1475e531cf0e1c03e1c42995fcf312767edaadfe335d04d1d3b27c9a8c8c7049"
  end

  resource "opentelemetry-instrumentation-marqo" do
    url "https://files.pythonhosted.org/packages/3c/00/b0fa9591f788ebb76596c6f4dfd30a390077aa22c89455e39465b599733c/opentelemetry_instrumentation_marqo-0.47.3.tar.gz"
    sha256 "e7c6fd11d14d102f7aeaa25e9f643cb7189ae2b29add8a00da130733d62b7859"
  end

  resource "opentelemetry-instrumentation-mcp" do
    url "https://files.pythonhosted.org/packages/a8/75/61f0d4b058ef4185d69a0d83424b6dc4af459f9417b64aa94345b6590f21/opentelemetry_instrumentation_mcp-0.47.3.tar.gz"
    sha256 "62bcad30d5bcac8dbd17b6b20187d3ca9822f28909e8d214bc1591d20294577d"
  end

  resource "opentelemetry-instrumentation-milvus" do
    url "https://files.pythonhosted.org/packages/aa/e4/b3c1c8a8ba2a849c8c9195ea2e9896bbf59752f0c418a0ce4c32b67ad50a/opentelemetry_instrumentation_milvus-0.47.3.tar.gz"
    sha256 "170099e53f8f3ae006592a006287947f6c41b25268c34a3635f578eae4b7b927"
  end

  resource "opentelemetry-instrumentation-mistralai" do
    url "https://files.pythonhosted.org/packages/bf/54/48940c6336b6efcfc6e8358466a5302b5fc162c2d112908269b08c8d148c/opentelemetry_instrumentation_mistralai-0.47.3.tar.gz"
    sha256 "1e90daca4cda6e38f32615f55fbd60d98194ddd455ba1a3a7d44d89454b0a5dd"
  end

  resource "opentelemetry-instrumentation-ollama" do
    url "https://files.pythonhosted.org/packages/d8/34/691216b7cfca473ac0f75004bc2057902cb81f05bcb870b2c3ee451742b2/opentelemetry_instrumentation_ollama-0.47.3.tar.gz"
    sha256 "4314ed3803a954573ef245940f590ccf7f67221b6436d7acc0b0a9bea23d9b82"
  end

  resource "opentelemetry-instrumentation-openai" do
    url "https://files.pythonhosted.org/packages/3a/6b/4f92bb43a4be136203c72a690ed293fdae1d33492e1e96a224b6bbd020d6/opentelemetry_instrumentation_openai-0.47.3.tar.gz"
    sha256 "e9b4c5a3b119cdf6a023eaf2ebff3feaaf0f3a1fc1616c3ce802b8644d3eab62"
  end

  resource "opentelemetry-instrumentation-openai-agents" do
    url "https://files.pythonhosted.org/packages/05/cc/e5399b4ef906296671336f4c5c00a3b0f77737d1b4ed48ceb3c649f4a01e/opentelemetry_instrumentation_openai_agents-0.47.3.tar.gz"
    sha256 "24fe9aa48e8fb85786677535a0159178e48d22f3bd1f6b8c0e687ec34eb2f27b"
  end

  resource "opentelemetry-instrumentation-pinecone" do
    url "https://files.pythonhosted.org/packages/07/26/15a9d5c0406de7e015e08f9a16f344b66150af839d39961598a3fd2bd5a4/opentelemetry_instrumentation_pinecone-0.47.3.tar.gz"
    sha256 "896a06e03f31b5bd44bd1dcc995fd29c3d4835c0de877209c22eaa2bbb89f3a9"
  end

  resource "opentelemetry-instrumentation-qdrant" do
    url "https://files.pythonhosted.org/packages/3c/67/669d60410de87288b968f0aaec1604290a972ff3e0971ef30c9d23317a08/opentelemetry_instrumentation_qdrant-0.47.3.tar.gz"
    sha256 "eecac4b021f457ea6365c062652fd235fcfd17c449d22813ef5c0ee44b90cb95"
  end

  resource "opentelemetry-instrumentation-redis" do
    url "https://files.pythonhosted.org/packages/e1/1a/780a4db764edf90299dd80ef5846e9ab27870236e5152eacf43e523eac0e/opentelemetry_instrumentation_redis-0.58b0.tar.gz"
    sha256 "6271f10a9ee0572f1c67f630b098326a4fe02b898c46a173942766c00307914a"
  end

  resource "opentelemetry-instrumentation-replicate" do
    url "https://files.pythonhosted.org/packages/53/e2/93315d2f90edefdd3342c39e40b317a54a62cce8076bc98ed9a75867c255/opentelemetry_instrumentation_replicate-0.47.3.tar.gz"
    sha256 "1b253cf9d256eaa14f4824f393c97e0d17c37a46d47c48b511739aa48f8b3d00"
  end

  resource "opentelemetry-instrumentation-requests" do
    url "https://files.pythonhosted.org/packages/36/42/83ee32de763b919779aaa595b60c5a7b9c0a4b33952bbe432c5f6a783085/opentelemetry_instrumentation_requests-0.58b0.tar.gz"
    sha256 "ae9495e6ff64e27bdb839fce91dbb4be56e325139828e8005f875baf41951a2e"
  end

  resource "opentelemetry-instrumentation-sagemaker" do
    url "https://files.pythonhosted.org/packages/e0/67/9aec6e36c17f88f1067e5b50ae5f28007cf06ba4b040d2618cec936c0405/opentelemetry_instrumentation_sagemaker-0.47.3.tar.gz"
    sha256 "bdbb8bbfcc7c341f3ef5c811f5898c412601cc269f8c07849face86fec36cbf8"
  end

  resource "opentelemetry-instrumentation-sqlalchemy" do
    url "https://files.pythonhosted.org/packages/91/6f/fa2c45d5dfb8da0bcc337a421fd12946994cb5e9782c40a21c669e78460d/opentelemetry_instrumentation_sqlalchemy-0.58b0.tar.gz"
    sha256 "3e4b444a05088ba473710df9d5c730bb08969c8ea71e04f2886a0f7efee22c12"
  end

  resource "opentelemetry-instrumentation-threading" do
    url "https://files.pythonhosted.org/packages/70/a9/3888cb0470e6eb48ea17b6802275ae71df411edd6382b9a8e8f391936fda/opentelemetry_instrumentation_threading-0.58b0.tar.gz"
    sha256 "f68c61f77841f9ff6270176f4d496c10addbceacd782af434d705f83e4504862"
  end

  resource "opentelemetry-instrumentation-together" do
    url "https://files.pythonhosted.org/packages/4f/eb/ab134ae814471f597641ba057c30f838942d34d73dcf92ac5489b7ce5065/opentelemetry_instrumentation_together-0.47.3.tar.gz"
    sha256 "436a9f029c6704e40ee2d7b735ba00e8a414892e3bfd3cc7c4326dbecc05ed41"
  end

  resource "opentelemetry-instrumentation-transformers" do
    url "https://files.pythonhosted.org/packages/78/52/583d44d8cbd2df21bf016b611ee6dc37661ad6ca2f706090bc351c1d37dd/opentelemetry_instrumentation_transformers-0.47.3.tar.gz"
    sha256 "f3206c04900cabe12ff4d98e2314ec3cf5987ed3c8db5504a1757375365e3ffe"
  end

  resource "opentelemetry-instrumentation-urllib3" do
    url "https://files.pythonhosted.org/packages/9f/e7/affaeadd974587c6eaab1c8af2dfba776dcc083493c97cb193173570d335/opentelemetry_instrumentation_urllib3-0.58b0.tar.gz"
    sha256 "978b8e3daa076437b1f7ed7509d8156108aee0679556fd355e532c4065dd7635"
  end

  resource "opentelemetry-instrumentation-vertexai" do
    url "https://files.pythonhosted.org/packages/f0/a2/a0bb9b8f8ba7cf15140ddf36cae75dd1a92d9477d10674409af2dfb72b33/opentelemetry_instrumentation_vertexai-0.47.3.tar.gz"
    sha256 "7b1e8d80979e0eaf8db3529324b9d9bd39520cfdbc327f30d1543a2d82165ad9"
  end

  resource "opentelemetry-instrumentation-watsonx" do
    url "https://files.pythonhosted.org/packages/7d/12/3ad7f8a6695f570d7f24fcab48d69c4cc4f068dadf0778c16700bfc9d35d/opentelemetry_instrumentation_watsonx-0.47.3.tar.gz"
    sha256 "19a7891d89444f89a9503f1f849db6406edfa60d83fee0721752649220377b6d"
  end

  resource "opentelemetry-instrumentation-weaviate" do
    url "https://files.pythonhosted.org/packages/b9/14/786d631be1cc76b1e2938d16571580ea20d241186a55acba593fc237cfb3/opentelemetry_instrumentation_weaviate-0.47.3.tar.gz"
    sha256 "90fe78f8a4c2c2ccd5844ec5ac698eeb050c2cccc4849183ee443f763f43ce0d"
  end

  resource "opentelemetry-instrumentation-writer" do
    url "https://files.pythonhosted.org/packages/ec/61/37dac452f7f9fed386cef9551d8ff5408bf213bc73294a5ea8a89bebf582/opentelemetry_instrumentation_writer-0.47.3.tar.gz"
    sha256 "3829e5d387b38098293d7acf7f04d47e3e84dce668590d17d7052dc5c5a38e23"
  end

  resource "opentelemetry-proto" do
    url "https://files.pythonhosted.org/packages/dd/ea/a75f36b463a36f3c5a10c0b5292c58b31dbdde74f6f905d3d0ab2313987b/opentelemetry_proto-1.37.0.tar.gz"
    sha256 "30f5c494faf66f77faeaefa35ed4443c5edb3b0aa46dad073ed7210e1a789538"
  end

  resource "opentelemetry-sdk" do
    url "https://files.pythonhosted.org/packages/f4/62/2e0ca80d7fe94f0b193135375da92c640d15fe81f636658d2acf373086bc/opentelemetry_sdk-1.37.0.tar.gz"
    sha256 "cc8e089c10953ded765b5ab5669b198bbe0af1b3f89f1007d19acd32dc46dda5"
  end

  resource "opentelemetry-semantic-conventions" do
    url "https://files.pythonhosted.org/packages/aa/1b/90701d91e6300d9f2fb352153fb1721ed99ed1f6ea14fa992c756016e63a/opentelemetry_semantic_conventions-0.58b0.tar.gz"
    sha256 "6bd46f51264279c433755767bb44ad00f1c9e2367e1b42af563372c5a6fa0c25"
  end

  resource "opentelemetry-semantic-conventions-ai" do
    url "https://files.pythonhosted.org/packages/ba/e6/40b59eda51ac47009fb47afcdf37c6938594a0bd7f3b9fadcbc6058248e3/opentelemetry_semantic_conventions_ai-0.4.13.tar.gz"
    sha256 "94efa9fb4ffac18c45f54a3a338ffeb7eedb7e1bb4d147786e77202e159f0036"
  end

  resource "opentelemetry-util-http" do
    url "https://files.pythonhosted.org/packages/c6/5f/02f31530faf50ef8a41ab34901c05cbbf8e9d76963ba2fb852b0b4065f4e/opentelemetry_util_http-0.58b0.tar.gz"
    sha256 "de0154896c3472c6599311c83e0ecee856c4da1b17808d39fdc5cce5312e4d89"
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
    url "https://files.pythonhosted.org/packages/fa/a4/cc17347aa2897568beece2e674674359f911d6fe21b0b8d6268cd42727ac/protobuf-6.32.1.tar.gz"
    sha256 "ee2469e4a021474ab9baafea6cd070e5bf27c7d29433504ddea1a4ee5850f68d"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/b3/31/4723d756b59344b643542936e37a31d1d3204bcdc42a7daa8ee9eb06fb50/psutil-7.1.0.tar.gz"
    sha256 "655708b3c069387c8b77b072fc429a57d0e214221d01c0a772df7dfedcb3bcd2"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/8d/35/d319ed522433215526689bad428a94058b6dd12190ce7ddd78618ac14b28/pydantic-2.12.2.tar.gz"
    sha256 "7b8fa15b831a4bbde9d5b84028641ac3080a4ca2cbd4a621a661687e741624fd"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/df/18/d0944e8eaaa3efd0a91b0f1fc537d3be55ad35091b6a87638211ba691964/pydantic_core-2.41.4.tar.gz"
    sha256 "70e47929a9d4a1905a67e4b687d5946026390568a8e952b92824118063cee4d5"
  end

  resource "pydantic-settings" do
    url "https://files.pythonhosted.org/packages/20/c5/dbbc27b814c71676593d1c3f718e6cd7d4f00652cefa24b75f7aa3efb25e/pydantic_settings-2.11.0.tar.gz"
    sha256 "d0e87a1c7d33593beb7194adb8470fc426e95ba02af83a0f23474a04c9a08180"
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
    url "https://files.pythonhosted.org/packages/f6/b0/4bc07ccd3572a2f9df7e6782f52b0c6c90dcbb803ac4a167702d7d0dfe1e/python_dotenv-1.1.1.tar.gz"
    sha256 "a8a6399716257f45be6a007360200409fce5cda2661e3dec71d23dc15f6189ab"
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
    url "https://files.pythonhosted.org/packages/05/c2/a9ae3d0eb4488748a2d9c15defddb7277a852234e29e50c73136834dff1b/python_socketio-5.14.1.tar.gz"
    sha256 "bf49657073b90ee09e4cbd6651044b46bb526694276621e807a1b8fcc0c1b25b"
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
    url "https://files.pythonhosted.org/packages/49/d3/eaa0d28aba6ad1827ad1e716d9a93e1ba963ada61887498297d3da715133/regex-2025.9.18.tar.gz"
    sha256 "c5ba23274c61c6fef447ba6a39333297d0c247f53059dba0bca415cac511edc4"
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
    url "https://files.pythonhosted.org/packages/fb/d2/8920e102050a0de7bfabeb4c4614a49248cf8d5d7a8d01885fbb24dc767a/rich-14.2.0.tar.gz"
    sha256 "73ff50c7c0c1c77c8243079283f4edb376f0f6442433aecb8ce7e6d0b92d1fe4"
  end

  resource "rich-rst" do
    url "https://files.pythonhosted.org/packages/bc/6d/a506aaa4a9eaa945ed8ab2b7347859f53593864289853c5d6d62b77246e0/rich_rst-1.3.2.tar.gz"
    sha256 "a1196fdddf1e364b02ec68a05e8ff8f6914fee10fbca2e6b6735f166bb0da8d4"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/e9/dd/2c0cbe774744272b0ae725f44032c77bdcab6e8bcf544bffa3b6e70c8dba/rpds_py-0.27.1.tar.gz"
    sha256 "26a1c73171d10b7acccbded82bf6a586ab8203601e565badc74bbbf8bc5a10f8"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/62/74/8d69dcb7a9efe8baa2046891735e5dfe433ad558ae23d9e3c14c633d1d58/s3transfer-0.14.0.tar.gz"
    sha256 "eff12264e7c8b4985074ccce27a3b38a485bb7f7422cc8046fee9be4983e4125"
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
    url "https://files.pythonhosted.org/packages/42/6f/22ed6e33f8a9e76ca0a412405f31abb844b779d52c5f96660766edcd737c/sse_starlette-3.0.2.tar.gz"
    sha256 "ccd60b5765ebb3584d0de2d7a6e4f745672581de4f5005ab31c3a25d10b52b3a"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/a7/a5/d6f429d43394057b67a6b5bbe6eae2f77a6bf7459d961fdb224bf206eee6/starlette-0.48.0.tar.gz"
    sha256 "7e8cee469a8ab2352911528110ce9088fdc6a37d9876926e73da7ce4aa4c7a46"
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
    url "https://files.pythonhosted.org/packages/41/ea/c2e4168103fff83fc3218ea568b640ddb6a4e7d3d9bc132049f41d6bc0f3/traceloop_sdk-0.47.3.tar.gz"
    sha256 "53adf0a9e681698b81cdc0a75123a87bd4606b4c9ff301292962e53294791fa0"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/21/ca/950278884e2ca20547ff3eb109478c6baf6b8cf219318e6bc4f666fad8e8/typer-0.19.2.tar.gz"
    sha256 "9ad824308ded0ad06cc716434705f691d4ee0bfd0fb081839d2e426860e7fdca"
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
    url "https://files.pythonhosted.org/packages/55/e3/70399cb7dd41c10ac53367ae42139cf4b1ca5f36bb3dc6c9d33acdb43655/typing_inspection-0.4.2.tar.gz"
    sha256 "ba561c48a67c5958007083d386c3295464928b01faa735ab8547c5692e87f464"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/71/57/1616c8274c3442d802621abf5deb230771c7a0fec9414cb6763900eb3868/uvicorn-0.37.0.tar.gz"
    sha256 "4115c8add6d3fd536c8ee77f0e14a7fd2ebba939fed9b02583a97f80648f9e13"
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

  resource "werkzeug" do
    url "https://files.pythonhosted.org/packages/32/af/d4502dc713b4ccea7175d764718d5183caf8d0867a4f0190d5d4a45cea49/werkzeug-3.1.1.tar.gz"
    sha256 "8cd39dfbdfc1e051965f156163e2974e52c210f130810e9ad36858f0fd3edad4"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/95/8f/aeb76c5b46e273670962298c23e7ddde79916cb74db802131d49a85e4b7d/wrapt-1.17.3.tar.gz"
    sha256 "f66eb08feaa410fe4eebd17f2a2c8e2e46d3476e9f8c783daa8e09e0faa666d0"
  end

  resource "wsproto" do
    url "https://files.pythonhosted.org/packages/c9/4a/44d3c295350d776427904d73c189e10aeae66d7f555bb2feee16d1e4ba5a/wsproto-1.2.0.tar.gz"
    sha256 "ad565f26ecb92588a3e43bc3d96164de84cd9902482b130d0ddbaa9664a85065"
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
  end

  test do
    output = shell_output("#{bin}/pixelle status")
    assert_match "Pixelle Version: #{version}", output
    assert_match "Checking Pixelle MCP service status...", output
  end
end
