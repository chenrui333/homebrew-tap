class Cartography < Formula
  include Language::Python::Virtualenv

  desc "Pull infrastructure assets and relationships into a Neo4j graph database"
  homepage "https://github.com/cartography-cncf/cartography"
  url "https://github.com/cartography-cncf/cartography/archive/refs/tags/0.139.1.tar.gz"
  sha256 "13d43636a7bf94368a101b750d2bfd406a83d04c48107af65ced55400fb993eb"
  license "Apache-2.0"
  head "https://github.com/cartography-cncf/cartography.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "c6ce42088a46eb798ba3f381e034de80b7029e17bd911e1c421f515476bf350e"
    sha256 cellar: :any, arm64_sequoia: "1ecbce0b3316d18e76b35d07741fdc14272b29aef3c208738523998f9793ee19"
    sha256 cellar: :any, arm64_sonoma:  "ef750be12c022189fa7de974dc84810beaf3c1e6f8bb1a46e74b0c95757ce0b8"
    sha256 cellar: :any, arm64_linux:   "689e4c62dbe1b5d8cfeb8fceadf41d7383735cb6e8cd175dbc8454c5c1747c32"
    sha256 cellar: :any, x86_64_linux:  "353e84f938fc2f7236c30d66bce8b651d054c08c52e164c6d8ec3f6327ac2ba7"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "adal" do
    url "https://files.pythonhosted.org/packages/90/d7/a829bc5e8ff28f82f9e2dc9b363f3b7b9c1194766d5a75105e3885bfa9a8/adal-1.2.7.tar.gz"
    sha256 "d74f45b81317454d96e982fd1c50e6fb5c99ac2223728aea8764433a39f566f1"
  end

  resource "aioboto3" do
    url "https://files.pythonhosted.org/packages/a2/01/92e9ab00f36e2899315f49eefcd5b4685fbb19016c7f19a9edf06da80bb0/aioboto3-15.5.0.tar.gz"
    sha256 "ea8d8787d315594842fbfcf2c4dce3bac2ad61be275bc8584b2ce9a3402a6979"
  end

  resource "aiobotocore" do
    url "https://files.pythonhosted.org/packages/62/94/2e4ec48cf1abb89971cb2612d86f979a6240520f0a659b53a43116d344dc/aiobotocore-2.25.1.tar.gz"
    sha256 "ea9be739bfd7ece8864f072ec99bb9ed5c7e78ebb2b0b15f29781fbe02daedbc"
  end

  resource "aiofiles" do
    url "https://files.pythonhosted.org/packages/41/c3/534eac40372d8ee36ef40df62ec129bee4fdb5ad9706e58a29be53b2c970/aiofiles-25.1.0.tar.gz"
    sha256 "a8d728f0a29de45dc521f18f07297428d56992a742f0cd2701ba86e44d23d5b2"
  end

  resource "aiohappyeyeballs" do
    url "https://files.pythonhosted.org/packages/33/c6/61a2d7b7572279226bb2e7f61d7a19ca7c90da0329c93fa0d560cbf288d8/aiohappyeyeballs-2.6.2.tar.gz"
    sha256 "e202810ee718bd01fc6ef49e8ea53d023d5cb6b581076d7925aa499fa55dbe64"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/82/78/8ea7308cac6934de8c74a14f3d5f65d1c89287426688be79538d0e5c013d/aiohttp-3.14.1.tar.gz"
    sha256 "307f2cff90a764d329e77040603fa032db89c5c24fdad50c4c15334cba744035"
  end

  resource "aioitertools" do
    url "https://files.pythonhosted.org/packages/fd/3c/53c4a17a05fb9ea2313ee1777ff53f5e001aefd5cc85aa2f4c2d982e1e38/aioitertools-0.13.0.tar.gz"
    sha256 "620bd241acc0bbb9ec819f1ab215866871b4bbd1f73836a55f799200ee86950c"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/61/62/06741b579156360248d1ec624842ad0edf697050bbaf7c3e46394e106ad1/aiosignal-1.4.0.tar.gz"
    sha256 "f47eecd9468083c2029cc99945502cb7708b082c232f9aca65da147157b251c7"
  end

  resource "annotated-doc" do
    url "https://files.pythonhosted.org/packages/57/ba/046ceea27344560984e26a590f90bc7f4a75b06701f653222458922b558c/annotated_doc-0.0.4.tar.gz"
    sha256 "fbcda96e87e9c92ad167c2e53839e57503ecfda18804ea28102353485033faa4"
  end

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/ee/67/531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5/annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/19/14/2c5dd9f512b66549ae92767a9c7b330ae88e1932ca57876909410251fe13/anyio-4.13.0.tar.gz"
    sha256 "334b70e641fd2221c1505b3890c69882fe4a2df910cba14d97019b90b24439dc"
  end

  resource "applicationinsights" do
    url "https://files.pythonhosted.org/packages/d3/f2/46a75ac6096d60da0e71a068015b610206e697de01fa2fb5bba8564b0798/applicationinsights-0.11.10.tar.gz"
    sha256 "0b761f3ef0680acf4731906dfc1807faa6f2a57168ae74592db0084a6099f7b3"
  end

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/0c/be/6c23d80cb966fb8f83fb1ebfb988351ae6b0554d0c3a613ee4531c026597/argcomplete-3.5.3.tar.gz"
    sha256 "c12bf50eded8aebb298c7b7da7a5ff3ee24dffd9f5281867dfe1424b58c55392"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "azure-cli-core" do
    url "https://files.pythonhosted.org/packages/56/a2/a496705cd4ead834459e57d177d8fa4c81f8737b667dfa32f0231c848631/azure_cli_core-2.87.0.tar.gz"
    sha256 "3e2511eac61b3c8b5481630fdd631adb21bd650a173273759f32e30f61872b47"
  end

  resource "azure-cli-telemetry" do
    url "https://files.pythonhosted.org/packages/09/1d/c1cf3663391a271864d866e17f911b913ec257386aef7cac35121ed180a6/azure-cli-telemetry-1.1.0.tar.gz"
    sha256 "d922379cda1b48952be75fb3bd2ac5e7ceecf569492a6088bab77894c624a278"
  end

  resource "azure-common" do
    url "https://files.pythonhosted.org/packages/3e/71/f6f71a276e2e69264a97ad39ef850dca0a04fce67b12570730cb38d0ccac/azure-common-1.1.28.zip"
    sha256 "4ac0cd3214e36b6a1b6a442686722a5d8cc449603aa833f3f0f40bda836704a3"
  end

  resource "azure-core" do
    url "https://files.pythonhosted.org/packages/34/83/bbde3faa84ddcb8eb0eca4b3ffb3221252281db4ce351300fe248c5c70b1/azure_core-1.39.0.tar.gz"
    sha256 "8a90a562998dd44ce84597590fff6249701b98c0e8797c95fcdd695b54c35d74"
  end

  resource "azure-identity" do
    url "https://files.pythonhosted.org/packages/c5/0e/3a63efb48aa4a5ae2cfca61ee152fbcb668092134d3eb8bfda472dd5c617/azure_identity-1.25.3.tar.gz"
    sha256 "ab23c0d63015f50b630ef6c6cf395e7262f439ce06e5d07a64e874c724f8d9e6"
  end

  resource "azure-keyvault-certificates" do
    url "https://files.pythonhosted.org/packages/40/59/8024c8b631baa2000bf0cb52f61688f9e9569646420a22da574b3949d4ad/azure_keyvault_certificates-4.11.1.tar.gz"
    sha256 "734d9a65faa0f2bd45b9e162d317acadec71056934ebf4bbfe058b23d74bd073"
  end

  resource "azure-keyvault-keys" do
    url "https://files.pythonhosted.org/packages/f4/03/5ce6db28b545427d4ab572f6a4ef2a727b6b4e7bf6941cedddf98822535b/azure_keyvault_keys-4.11.1.tar.gz"
    sha256 "90caa3a7b2c8f6b53c247ec115cf1c1dad7f107cc3aa9f35aff4838bbce7e562"
  end

  resource "azure-keyvault-secrets" do
    url "https://files.pythonhosted.org/packages/f1/b8/03c7b4edd1e3355ad5fffb70e68af70cd09542963f45cf3a2aa9fb3930b5/azure_keyvault_secrets-4.11.0.tar.gz"
    sha256 "ac14727b9159cca353173ec5a454d8d7b192a6f2f5e7eb540f9fbcf914fa0ca0"
  end

  resource "azure-mgmt-authorization" do
    url "https://files.pythonhosted.org/packages/9e/ab/e79874f166eed24f4456ce4d532b29a926fb4c798c2c609eefd916a3f73d/azure-mgmt-authorization-4.0.0.zip"
    sha256 "69b85abc09ae64fc72975bd43431170d8c7eb5d166754b98aac5f3845de57dc4"
  end

  resource "azure-mgmt-compute" do
    url "https://files.pythonhosted.org/packages/4f/ee/a143c8395267aea8d735c5336519ef94eeaa45f235c89c06f417d1d2ce60/azure_mgmt_compute-38.0.0.tar.gz"
    sha256 "46cb0864f943b88463ed50ad006738023120cf7e53f50f7e4a740ccd5337abaf"
  end

  resource "azure-mgmt-containerinstance" do
    url "https://files.pythonhosted.org/packages/4c/19/cdb22d87560238893f5c014176b4e6868c3befbd6585bb5c44bdb1ddc997/azure-mgmt-containerinstance-10.1.0.zip"
    sha256 "78d437adb28574f448c838ed5f01f9ced378196098061deb59d9f7031704c17e"
  end

  resource "azure-mgmt-containerservice" do
    url "https://files.pythonhosted.org/packages/00/0d/8021bbb2735869e7b4f868f96eda6de5fa3e097bdec59cf270460cec37d6/azure_mgmt_containerservice-41.3.0.tar.gz"
    sha256 "6414756e2802fb31a62bda900a6a9f99bb5e275b1b3181ca708be5db1977ce54"
  end

  resource "azure-mgmt-core" do
    url "https://files.pythonhosted.org/packages/3e/99/fa9e7551313d8c7099c89ebf3b03cd31beb12e1b498d575aa19bb59a5d04/azure_mgmt_core-1.6.0.tar.gz"
    sha256 "b26232af857b021e61d813d9f4ae530465255cb10b3dde945ad3743f7a58e79c"
  end

  resource "azure-mgmt-cosmosdb" do
    url "https://files.pythonhosted.org/packages/05/e3/8687e481a34c83f5a6e6d9d3a084c8344920aaf6a505b19a299e58f20421/azure_mgmt_cosmosdb-9.9.0.tar.gz"
    sha256 "4678bf042bdc208aa24fca71767ac29b6f2a2722ac7872608371a5922f3b6c37"
  end

  resource "azure-mgmt-datafactory" do
    url "https://files.pythonhosted.org/packages/e8/5e/c28a8a50885185a9a06ff659594fec24f1a840622f21883b376358dd1188/azure_mgmt_datafactory-9.3.0.tar.gz"
    sha256 "f5fdd5cd416f0ed71dfedf05dc7677b8f0e52f3428fd5b17b04c9200dd8d36b3"
  end

  resource "azure-mgmt-eventgrid" do
    url "https://files.pythonhosted.org/packages/bb/68/24a2921b66827a571a3da75cc12289b7029a7c436087c0c5b2b4ca387aa3/azure_mgmt_eventgrid-10.4.0.tar.gz"
    sha256 "303e5e27cf4bb5ec833ba4e5a9ef70b5bc410e190412ec47cde59d82e413fb7e"
  end

  resource "azure-mgmt-eventhub" do
    url "https://files.pythonhosted.org/packages/04/41/5080742de3a0c7a2c579fcf6995c531d48a83f9c588b52334b41bd84d666/azure_mgmt_eventhub-11.2.0.tar.gz"
    sha256 "31c47f18f73d2d83345cde5909568e28858c2548a35b10e23194b4767a9ce7e3"
  end

  resource "azure-mgmt-keyvault" do
    url "https://files.pythonhosted.org/packages/df/dd/e74f82797ee3ff7001832427a218f3079e6174b9fa8b354b84434172d89d/azure_mgmt_keyvault-14.0.1.tar.gz"
    sha256 "d141a8084ae4c7c5bd1cafeca49a8f3fbebc58dc5bc5290f322ea73d8b307ef7"
  end

  resource "azure-mgmt-logic" do
    url "https://files.pythonhosted.org/packages/fc/89/47e9b71d49ee05782cebcf3a9e4b04e974c76b19f4b2d68fd9ea9c4e358a/azure-mgmt-logic-10.0.0.zip"
    sha256 "b3fa4864f14aaa7af41d778d925f051ed29b6016f46344765ecd0f49d0f04dd6"
  end

  resource "azure-mgmt-monitor" do
    url "https://files.pythonhosted.org/packages/0e/12/25874f6b894e972646244f570a23298969b58f57cfb7a188e2740017b43a/azure_mgmt_monitor-7.0.0.tar.gz"
    sha256 "b75f536441d430f69ff873a1646e5f5dbcb3080a10768a59d0adc01541623816"
  end

  resource "azure-mgmt-network" do
    url "https://files.pythonhosted.org/packages/9a/e5/31cf174ef67087532f159083e2e007507fe163f58c58fbd0e08d05209cf4/azure_mgmt_network-30.2.0.tar.gz"
    sha256 "9b17c259e6344808aaa80a34bbc4b13f16bc01185dd9db137eaa0ae26664861a"
  end

  resource "azure-mgmt-resource" do
    url "https://files.pythonhosted.org/packages/50/4c/b27a3dfbedebbcc8e346a956a803528bd94a19fdf14b1de4bd781b03a6cc/azure_mgmt_resource-24.0.0.tar.gz"
    sha256 "cf6b8995fcdd407ac9ff1dd474087129429a1d90dbb1ac77f97c19b96237b265"
  end

  resource "azure-mgmt-security" do
    url "https://files.pythonhosted.org/packages/3d/90/13186657355452bdce44f27db6b194b99f78f8c185301b47624fff6d9531/azure-mgmt-security-7.0.0.tar.gz"
    sha256 "5912eed7e9d3758fdca8d26e1dc26b41943dc4703208a1184266e2c252e1ad66"
  end

  resource "azure-mgmt-sql" do
    url "https://files.pythonhosted.org/packages/3f/af/398c57d15064ea23475076cd087b1a143b66d33a029e6e47c4688ca32310/azure-mgmt-sql-3.0.1.zip"
    sha256 "129042cc011225e27aee6ef2697d585fa5722e5d1aeb0038af6ad2451a285457"
  end

  resource "azure-mgmt-storage" do
    url "https://files.pythonhosted.org/packages/47/6a/62d21f86b62cf990cb7d63f470dd4a766277a68a71543ef9331e0ee16f7d/azure_mgmt_storage-25.0.0.tar.gz"
    sha256 "52c4bb1fb395fcfa7a2e8fb024c1dabc5a67bd6fa23c0d2d5a7fb29314f172d2"
  end

  resource "azure-mgmt-synapse" do
    url "https://files.pythonhosted.org/packages/af/fa/5a7c375d305ec0ec06978db07ac34c4894d2b8a00087ff3dd9e1435e397f/azure-mgmt-synapse-2.0.0.zip"
    sha256 "bec6bdfaeb55b4fdd159f2055e8875bf50a720bb0fce80a816e92a2359b898c8"
  end

  resource "azure-mgmt-web" do
    url "https://files.pythonhosted.org/packages/71/dd/581afc7b4e6e2a86859e1323d654f58a7e3f63cfaa69ddbdb0baa8419d0a/azure_mgmt_web-11.0.0.tar.gz"
    sha256 "1f98b29283ecb9c36ede7309c0da8d26db0455d77ae37e1cb6cdcd244044d6de"
  end

  resource "azure-storage-blob" do
    url "https://files.pythonhosted.org/packages/3b/48/84a820d898267f662b5c06f7cd76fdb8a9e272b44aa9376cef3ec0f6a294/azure_storage_blob-12.30.0.tar.gz"
    sha256 "2cd74d4d5731e5eb6b8d5c5056ee115a5e88f8fdf22517b739836fda685018be"
  end

  resource "azure-synapse-artifacts" do
    url "https://files.pythonhosted.org/packages/7a/c1/61c88b6ba66e7042602b79cbb84e5c3785dee41e67e22f7362bcd55d91cc/azure_synapse_artifacts-0.22.0.tar.gz"
    sha256 "ddc0fb622738c3eab7465ce428cfa0cd41ad01a870fbd45361e4d58d175c623c"
  end

  resource "backoff" do
    url "https://files.pythonhosted.org/packages/47/d7/5bbeb12c44d7c4f2fb5b56abce497eb5ed9f34d85701de869acedd602619/backoff-2.2.1.tar.gz"
    sha256 "03f829f5bb1923180821643f8753b0502c3b682293992485b0eef2807afa5cba"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/ed/f9/6ef8feb52c3cce5ec3967a535a6114b57ac7949fd166b0f3090c2b06e4e5/boto3-1.40.61.tar.gz"
    sha256 "d6c56277251adf6c2bdd25249feae625abe4966831676689ff23b4694dea5b12"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/28/a3/81d3a47c2dbfd76f185d3b894f2ad01a75096c006a2dd91f237dca182188/botocore-1.40.61.tar.gz"
    sha256 "a2487ad69b090f9cccd64cf07c7021cd80ee9c0655ad974f87045b02f3ef52cd"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e7/a1/67fe25fac3c7642725500a3f6cfe5821ad557c3abb11c9d20d12c7008d3e/charset_normalizer-3.4.7.tar.gz"
    sha256 "ae89db9e5f98a11a4bf50407d4363e7b09b31e55bc117b4f7d80aab97ba009e5"
  end

  resource "circuitbreaker" do
    url "https://files.pythonhosted.org/packages/df/ac/de7a92c4ed39cba31fe5ad9203b76a25ca67c530797f6bb420fff5f65ccb/circuitbreaker-2.1.3.tar.gz"
    sha256 "1a4baee510f7bea3c91b194dcce7c07805fe96c4423ed5594b75af438531d084"
  end

  resource "cloudflare" do
    url "https://files.pythonhosted.org/packages/61/64/ba01193be8e31bda89974f0f33d1084b44b34a2d2d96031e3fb704340182/cloudflare-5.3.0.tar.gz"
    sha256 "695538d02bc57e2a3c1dbe88ba09f0d5e80fc87b41acf5cf99bb62aa13775748"
  end

  resource "crc32c" do
    url "https://files.pythonhosted.org/packages/7f/4c/4e40cc26347ac8254d3f25b9f94710b8e8df24ee4dddc1ba41907a88a94d/crc32c-2.7.1.tar.gz"
    sha256 "f91b144a21eef834d64178e01982bb9179c354b3e9e5f4c803b0e5096384968c"
  end

  resource "crowdstrike-falconpy" do
    url "https://files.pythonhosted.org/packages/33/e3/eb1f9218c4ce68a398d69356d78558d79040ce796d09e3f3e744f747599c/crowdstrike_falconpy-1.6.2.tar.gz"
    sha256 "c86ac31a37175cb31dc0171feceb8cf0cb3e323ca1f84e2863938aef8153b119"
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

  resource "duo-client" do
    url "https://files.pythonhosted.org/packages/c8/20/48842c3cc8b2c60129e1e52f0ab5c72ac0a30a3a345ea6d6e9aa8c94c093/duo_client-5.6.1.tar.gz"
    sha256 "5b9bfba3bd995178cebf51db605190bdc84fec8e4b6935210e7abde4ae97cef5"
  end

  resource "durationpy" do
    url "https://files.pythonhosted.org/packages/9d/a4/e44218c2b394e31a6dd0d6b095c4e1f32d0be54c2a4b250032d717647bab/durationpy-0.10.tar.gz"
    sha256 "1fa6893409a6e739c9c72334fc65cca1f355dbdd93405d30f726deb5bde42fba"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/2d/f5/c831fac6cc817d26fd54c7eaccd04ef7e0288806943f7cc5bbf69f3ac1f0/frozenlist-1.8.0.tar.gz"
    sha256 "3ede829ed8d842f6cd48fc7081d7a41001a56f1f38603f9d49bf3020d59a31ad"
  end

  resource "google-api-core" do
    url "https://files.pythonhosted.org/packages/c6/22/155cadf1d49272a9cf48f3168c0f3874fa13397297e611a5ea00cd093880/google_api_core-2.31.0.tar.gz"
    sha256 "2be84ee0f584c48e6bde1b36766e23348b361fb7e55e56135fc76ce1c397f9c2"
  end

  resource "google-api-python-client" do
    url "https://files.pythonhosted.org/packages/22/09/081d66357118bd260f8f182cb1b2dd5bd32ca88e3714d7c93896cab946fc/google_api_python_client-2.197.0.tar.gz"
    sha256 "32e03977eda4a66eafc6ae58dc9ec46426b6025636d5ef019c5703013eddd4e5"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/15/f6/494e18317546d7def90c957b71d68b025d24f0e22e486c2606bc57765c48/google_auth-2.54.0.tar.gz"
    sha256 "130f6fd5e3f497fdad897a23ed9489973437edf561238c4b92a4d02c435f8af9"
  end

  resource "google-auth-httplib2" do
    url "https://files.pythonhosted.org/packages/1c/b3/f192c8bc7e41e0ebdbd95afcae4783417a34b6a6af62d22daf22c3fd38fc/google_auth_httplib2-0.4.0.tar.gz"
    sha256 "d5b030a204b7a4b4d553ba9ca701b62481ee2b74419325580be70f7d85ffed35"
  end

  resource "google-cloud-access-context-manager" do
    url "https://files.pythonhosted.org/packages/35/38/99786d542d1c1efb9fc6f70179efac4dc23b8d5d8d0b1d12ec90b98e436b/google_cloud_access_context_manager-0.6.0.tar.gz"
    sha256 "760267fba1f8be8636e2a8d7c302027f310260fff8051c46b8b09b97d5468ee0"
  end

  resource "google-cloud-aiplatform" do
    url "https://files.pythonhosted.org/packages/e0/d9/e2a5f5a8535bbc8f68729796f3fc2d68d59a72818fb44f6544edbc2592e4/google_cloud_aiplatform-1.157.0.tar.gz"
    sha256 "ce8413ed3584c4896f7656b663214c24e91c2c89426f1c91fbd1d220ffda23af"
  end

  resource "google-cloud-artifact-registry" do
    url "https://files.pythonhosted.org/packages/af/9c/a78d175a0484c500063696b1b923920392de6e5e4c1bd509210721554242/google_cloud_artifact_registry-1.22.0.tar.gz"
    sha256 "0e8173a97ae695dfcf02c83277a0fd574e1a39be409da6345b945bebe577ad94"
  end

  resource "google-cloud-asset" do
    url "https://files.pythonhosted.org/packages/4c/d4/92b37789e99dc416b2d17f6d3be5a32a50049ffe6c350953abda85c4a0fd/google_cloud_asset-4.4.0.tar.gz"
    sha256 "350d564db6edb2d9521d4776fc44d559765fecd06bdb7284017cf24261039c8d"
  end

  resource "google-cloud-bigquery" do
    url "https://files.pythonhosted.org/packages/ce/13/6515c7aab55a4a0cf708ffd309fb9af5bab54c13e32dc22c5acd6497193c/google_cloud_bigquery-3.41.0.tar.gz"
    sha256 "2217e488b47ed576360c9b2cc07d59d883a54b83167c0ef37f915c26b01a06fe"
  end

  resource "google-cloud-core" do
    url "https://files.pythonhosted.org/packages/a8/dd/1eef226e470369b26824a505c34482c0b493bc35fe8e0c6b003b5feca21a/google_cloud_core-2.6.0.tar.gz"
    sha256 "e76149739f90fac1fc6757c09f47eaccb3145b54adbd7759b0f7c4b235f46c83"
  end

  resource "google-cloud-org-policy" do
    url "https://files.pythonhosted.org/packages/a2/44/df6d39606b3ff6cf1779debdfd4f4af1801fc71f072e896515f90c3b0751/google_cloud_org_policy-1.17.0.tar.gz"
    sha256 "f77189ee7f65a28f3755f855f710b8b67b9862e2a6b6a93b075e6f9da93bff20"
  end

  resource "google-cloud-os-config" do
    url "https://files.pythonhosted.org/packages/a6/3a/4bf339ca4103739cb6977696e31a4fc3cb2c6204443855df77f4236043fb/google_cloud_os_config-1.24.0.tar.gz"
    sha256 "ddf64eac47c0da9483d573b7de9abed48a5a6cbe27931ae94396899f598e0192"
  end

  resource "google-cloud-resource-manager" do
    url "https://files.pythonhosted.org/packages/b2/1a/13060cabf553d52d151d2afc26b39561e82853380d499dd525a0d422d9f0/google_cloud_resource_manager-1.17.0.tar.gz"
    sha256 "0f486b62e2c58ff992a3a50fa0f4a96eef7750aa6c971bb373398ccb91828660"
  end

  resource "google-cloud-run" do
    url "https://files.pythonhosted.org/packages/b7/89/dcaf0dc97e39b41e446456ceb60657ab025de79cfccd39cbd739d1a9849e/google_cloud_run-0.16.0.tar.gz"
    sha256 "d52cf4e6ad3702ae48caccf6abcab543afee6f61c2a6ec753cc62a31e5b629f1"
  end

  resource "google-cloud-storage" do
    url "https://files.pythonhosted.org/packages/58/72/86f94e1639a8bcd9d33e8e01b49afcaa1c3a13bda7683c681717e0901e15/google_cloud_storage-3.12.0.tar.gz"
    sha256 "03ae9847c6babb368f35f054126b8a08cbc0e3266efb990eb17b9926a45cf3be"
  end

  resource "google-crc32c" do
    url "https://files.pythonhosted.org/packages/03/41/4b9c02f99e4c5fb477122cd5437403b552873f014616ac1d19ac8221a58d/google_crc32c-1.8.0.tar.gz"
    sha256 "a428e25fb7691024de47fecfbff7ff957214da51eddded0da0ae0e0f03a2cf79"
  end

  resource "google-genai" do
    url "https://files.pythonhosted.org/packages/5b/52/0244e310812f3063d09d60b30ae29ab7df9343bd005744cd5eeaa6ba39b4/google_genai-2.8.0.tar.gz"
    sha256 "37a9b3cb127d763e7f4ca47452ae3562c87728773bd1b149f7b559c239da2bc1"
  end

  resource "google-resumable-media" do
    url "https://files.pythonhosted.org/packages/48/f8/1ca5781d6be9cb9f73f7d40f4958c4bd1226a60598e3e39e1d6aaf838c4b/google_resumable_media-2.10.0.tar.gz"
    sha256 "e324bc9d0fdae4c52a08ae90456edc4e71ece858399e1217ac0eb3a51d6bc6ee"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/b5/c8/f439cffde755cffa462bfbb156278fa6f9d09119719af9814b858fd4f81f/googleapis_common_protos-1.75.0.tar.gz"
    sha256 "53a062ff3c32552fbd62c11fe23768b78e4ddf0494d5e5fd97d3f4689c75fbbd"
  end

  resource "grpc-google-iam-v1" do
    url "https://files.pythonhosted.org/packages/44/4f/d098419ad0bfc06c9ce440575f05aa22d8973b6c276e86ac7890093d3c37/grpc_google_iam_v1-0.14.4.tar.gz"
    sha256 "392b3796947ed6334e61171d9ab06bf7eb357f554e5fc7556ad7aab6d0e17038"
  end

  resource "grpcio" do
    url "https://files.pythonhosted.org/packages/b0/b5/1ff353970a87eda4c98251e34d2dfd214abd4982dc89119c9252a2a482d2/grpcio-1.81.1.tar.gz"
    sha256 "6fa10a767143a5e82e8eaab53918af0cd8909a57a27f8cb2288b80a613ac671b"
  end

  resource "grpcio-status" do
    url "https://files.pythonhosted.org/packages/32/26/0aa9168c87882381fd810d140c279a2490ed6aee655f0515d6f56c5ca404/grpcio_status-1.81.1.tar.gz"
    sha256 "9389a03e746017b10f0630c064289201458f3ce01f5d7ef4b0bebc1ef6cf82ad"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "h2" do
    url "https://files.pythonhosted.org/packages/1d/17/afa56379f94ad0fe8defd37d6eb3f89a25404ffc71d4d848893d270325fc/h2-4.3.0.tar.gz"
    sha256 "6c59efe4323fa18b47a632221a1888bd7fde6249819beda254aeca909f221bf1"
  end

  resource "hpack" do
    url "https://files.pythonhosted.org/packages/2c/48/71de9ed269fdae9c8057e5a4c0aa7402e8bb16f2c6e90b3aa53327b113f8/hpack-4.1.0.tar.gz"
    sha256 "ec5eca154f7056aa06f196a557655c5b009b382873ac8d1e66e79e87535f1dca"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/06/94/82699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cb/httpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httplib2" do
    url "https://files.pythonhosted.org/packages/c1/1f/e86365613582c027dda5ddb64e1010e57a3d53e99ab8a72093fa13d565ec/httplib2-0.31.2.tar.gz"
    sha256 "385e0869d7397484f4eab426197a4c020b606edd43372492337c0b4010ae5d24"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "humanfriendly" do
    url "https://files.pythonhosted.org/packages/cc/3f/2c29224acb2e2df4d2046e4c73ee2662023c58ff5b113c4c1adac0886c43/humanfriendly-10.0.tar.gz"
    sha256 "6b0b831ce8f15f7300721aa49829fc4e83921a9a301cc7f606be6686a2288ddc"
  end

  resource "hyperframe" do
    url "https://files.pythonhosted.org/packages/02/e7/94f8232d4a74cc99514c13a9f995811485a6903d48e5d952771ef6322e30/hyperframe-6.1.0.tar.gz"
    sha256 "f630908a00854a7adeabd6382b43923a4c4cd4b821fcb527e6ab9e15382a3b08"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cd/63/9496c57188a2ee585e0f1db071d75089a11e98aa86eb99d9d7618fc1edce/idna-3.18.tar.gz"
    sha256 "ffb385a7e039654cef1ab9ef32c6fafe283c0c0467bba1d9029738ce4a14a848"
  end

  resource "isodate" do
    url "https://files.pythonhosted.org/packages/54/4d/e940025e2ce31a8ce1202635910747e5a87cc3a6a6bb2d00973375014749/isodate-0.7.2.tar.gz"
    sha256 "4cd1aa0f43ca76f4a6c6c0292a85f40b35ec2e43e315b59f06e6d32171a953e6"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/d3/59/322338183ecda247fb5d1763a6cbe46eff7222eaeebafd9fa65d4bf5cb11/jmespath-1.1.0.tar.gz"
    sha256 "472c87d80f36026ae83c6ddd0f1d05d4e510134ed462851fd5f754c8c3cbb88d"
  end

  resource "jsonpickle" do
    url "https://files.pythonhosted.org/packages/8d/c0/dde9b4b42cc415b9579573f967f12efbb034e427a2a37e93ad5139891d87/jsonpickle-4.1.2.tar.gz"
    sha256 "8afed18aa189fd81e2e833b426bb4af485594921f0b1d36c2001fc5637a2f210"
  end

  resource "knack" do
    url "https://files.pythonhosted.org/packages/58/ce/0e9597a4b2348dade473d3e177ce32ca570f67b479ab9a292a90cb88f892/knack-0.14.0.tar.gz"
    sha256 "2ddd32fd6343ec9b6ed0da729b212362d0e6b1208c0162633c90cb6f94a05877"
  end

  resource "kubernetes" do
    url "https://files.pythonhosted.org/packages/2f/57/8b538af5076bc3372949d76f70ba3449bdfe52f9e6488170fa5d4f7cbe70/kubernetes-36.0.2.tar.gz"
    sha256 "03551fcb49cae1f708f63624041e37403545b7aaed10cbf54e2b01a37a5438e3"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "marshmallow" do
    url "https://files.pythonhosted.org/packages/25/7e/1dbd4096eb7c148cd2841841916f78820bb85a4d80a0c25c02d30815a7fb/marshmallow-4.3.0.tar.gz"
    sha256 "fb43c53b3fe240b8f6af37223d6ef1636f927ad9bea8ab323afad95dff090880"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "microsoft-kiota-abstractions" do
    url "https://files.pythonhosted.org/packages/c9/0f/e8f6ccdc2f22e6cd73da9dd2e5dd2f302664bf8ad6e775f0bf4cde08092e/microsoft_kiota_abstractions-1.10.3.tar.gz"
    sha256 "07367351399396c1f1713a4ab112fd499f84fe019696ba477cf63d4ce48b8165"
  end

  resource "microsoft-kiota-authentication-azure" do
    url "https://files.pythonhosted.org/packages/fc/df/f95ebb712b99e4002558b5e60e2b066d98472257f7cf31f4f696b9c76100/microsoft_kiota_authentication_azure-1.10.3.tar.gz"
    sha256 "7750bb002d2ab435cffcf609e9f35154ba391d5fa2452aea4fa6e673e2173b75"
  end

  resource "microsoft-kiota-http" do
    url "https://files.pythonhosted.org/packages/cd/86/2d3fea265a2b8ae6b552ff84884baf76a5a49aed0259d004b969bf3960ca/microsoft_kiota_http-1.10.3.tar.gz"
    sha256 "56e0e0799f6de04d56346b4ee6b18f6c79af02e6bd08064d875a3b05e375e7b4"
  end

  resource "microsoft-kiota-serialization-form" do
    url "https://files.pythonhosted.org/packages/d2/d8/9281bb1c46b4c818d7f91f10c9bd8e33340004f53079bf52e419342b3510/microsoft_kiota_serialization_form-1.10.3.tar.gz"
    sha256 "323ad8856bcd3db74c9cf5950e22dc83e52713ad5aa4d7353d5650c518697c0e"
  end

  resource "microsoft-kiota-serialization-json" do
    url "https://files.pythonhosted.org/packages/45/7c/81306c46b4c8b897d4d663bd1937376921029e163b9869e4ee7127076060/microsoft_kiota_serialization_json-1.10.3.tar.gz"
    sha256 "84feb6b683289b7a8ca0495201050d36ce5ff28f384c24389f9e3fe221a38c93"
  end

  resource "microsoft-kiota-serialization-multipart" do
    url "https://files.pythonhosted.org/packages/05/aa/7cda18ec4dbf5ade90fd0ab7b5c40490fdb2107db9b80da1a4a44f2f8920/microsoft_kiota_serialization_multipart-1.10.3.tar.gz"
    sha256 "916fc578522985876f615f35ba676ee4d1abdae26304bc0d248fb2e34212b897"
  end

  resource "microsoft-kiota-serialization-text" do
    url "https://files.pythonhosted.org/packages/ff/69/2e135c222fffffc4ff42b7046da6e0be7c3ad91d946d313da70eb8a81815/microsoft_kiota_serialization_text-1.10.3.tar.gz"
    sha256 "0db370ccbbfded4e9e01c2f967850478cd1198c748f3baef60abec0c10e58e0f"
  end

  resource "microsoft-security-utilities-secret-masker" do
    url "https://files.pythonhosted.org/packages/e8/1a/6fa5c0ba55ed62e17df010af8a3a71ffea701c3d414b4688834c527d5aeb/microsoft_security_utilities_secret_masker-1.0.0b4.tar.gz"
    sha256 "a30bd361ac18c8b52f6844076bc26465335949ea9c7a004d95f5196ec6fdef3e"
  end

  resource "msal" do
    url "https://files.pythonhosted.org/packages/de/cb/b02b0f748ac668922364ccb3c3bff5b71628a05f5adfec2ba2a5c3031483/msal-1.36.0.tar.gz"
    sha256 "3f6a4af2b036b476a4215111c4297b4e6e236ed186cd804faefba23e4990978b"
  end

  resource "msal-extensions" do
    url "https://files.pythonhosted.org/packages/01/99/5d239b6156eddf761a636bded1118414d161bd6b7b37a9335549ed159396/msal_extensions-1.3.1.tar.gz"
    sha256 "c5b0fd10f65ef62b5f1d62f4251d51cbcaf003fcedae8c91b040a488614be1a4"
  end

  resource "msgraph-core" do
    url "https://files.pythonhosted.org/packages/b6/92/e74e204ac240a1817817d50074599af1e0331608c5ee58a1836e40f39c2e/msgraph_core-1.4.0.tar.gz"
    sha256 "5f0dee9564a0e20edfb2eb7137fe189d7d204a80a87d6d83d69d31269376e1b1"
  end

  resource "msgraph-sdk" do
    url "https://files.pythonhosted.org/packages/26/94/a7c46a574e01f13421e54186ec68d6fbe92e7a887bf6ba54e28ce4ba5fe1/msgraph_sdk-1.58.0.tar.gz"
    sha256 "beee4dda22dd8e709a33871fd9aadfcac908a1870a2dab9350734616b59403b1"
  end

  resource "msrest" do
    url "https://files.pythonhosted.org/packages/68/77/8397c8fb8fc257d8ea0fa66f8068e073278c65f05acb17dcb22a02bfdc42/msrest-0.7.1.zip"
    sha256 "6e7661f46f3afd88b75667b7187a92829924446c7ea1d169be8c4bb7eeb788b9"
  end

  resource "msrestazure" do
    url "https://files.pythonhosted.org/packages/5d/86/06a086e4ed3523765a1917665257b1828f1bf882130768445f082a4c3484/msrestazure-0.6.4.post1.tar.gz"
    sha256 "39842007569e8c77885ace5c46e4bf2a9108fcb09b1e6efdf85b6e2c642b55d4"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/1a/c2/c2d94cbe6ac1753f3fc980da97b3d930efe1da3af3c9f5125354436c073d/multidict-6.7.1.tar.gz"
    sha256 "ec6652a1bee61c53a3e5776b6049172c53b6aaba34f18c9ad04f82712bac623d"
  end

  resource "neo4j" do
    url "https://files.pythonhosted.org/packages/ce/f4/aaa4ac19adae4b01bc742b63afd2672a77e7351566f02721e713e4b863ee/neo4j-6.2.0.tar.gz"
    sha256 "e1e246b65b572bd8ea97f9e0e721b7d40a5ce53e53d0007c29aef63e4f9124d9"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/0b/5f/19930f824ffeb0ad4372da4812c50edbd1434f678c90c2733e1188edfc63/oauthlib-3.3.1.tar.gz"
    sha256 "0f0f8aa759826a193cf66c12ea1af1637f87b9b4622d46e866952bb022e538c9"
  end

  resource "oci" do
    url "https://files.pythonhosted.org/packages/d0/c8/25eb226edcd2ede3fb5bedf5bfa5054cde98006414b3cd76b82111ec8126/oci-2.178.0.tar.gz"
    sha256 "d3a19859d80aa5c4988905e1a30b46dcc2af146c76f3d8c813129d71247d1a94"
  end

  resource "okta" do
    url "https://files.pythonhosted.org/packages/e8/2a/1c1bae7ed0b429cfe04caaff4ec06383669b651b315328b15f87ab67d347/okta-0.0.4.tar.gz"
    sha256 "53e792c68d3684ff4140b4cb1c02af3821090368f8110fde54c0bdb638449332"
  end

  resource "opentelemetry-api" do
    url "https://files.pythonhosted.org/packages/b4/1c/125e1c936c0873796771b7f04f6c93b9f1bf5d424cea90fda94a99f61da8/opentelemetry_api-1.42.1.tar.gz"
    sha256 "56c63bea9f77b62856be8c47600474acad853b2924b99b1687c4cb6297166716"
  end

  resource "opentelemetry-sdk" do
    url "https://files.pythonhosted.org/packages/40/f7/b390bd9bfd703bf98a68fea1f27786c6872331fd617164a54b8a59bdc008/opentelemetry_sdk-1.42.1.tar.gz"
    sha256 "8c834e8f8c9ba4171d4ec843d0cb8a67e4c7394d3f9e9297e582cbd9456ddbf7"
  end

  resource "opentelemetry-semantic-conventions" do
    url "https://files.pythonhosted.org/packages/93/99/4d7dd6df64795951413ce6e815f8cf1eb191daf7196ae86574589643d5f3/opentelemetry_semantic_conventions-0.63b1.tar.gz"
    sha256 "3daf963611334b365e98a57438183eb012d3bfb40b2d931a9af613476b8701a9"
  end

  resource "packageurl-python" do
    url "https://files.pythonhosted.org/packages/f5/d6/3b5a4e3cfaef7a53869a26ceb034d1ff5e5c27c814ce77260a96d50ab7bb/packageurl_python-0.17.6.tar.gz"
    sha256 "1252ce3a102372ca6f86eb968e16f9014c4ba511c5c37d95a7f023e2ca6e5c25"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
    sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
  end

  resource "pagerduty" do
    url "https://files.pythonhosted.org/packages/15/36/bd614651ea128057a47fab486ca8f647351320ac19aa998e5aa11ba2cadd/pagerduty-6.2.2.tar.gz"
    sha256 "c8a7ea625f72b47624decd282c925c8b7fab0568aaae7ad3bd430ce9a15c99d6"
  end

  resource "pkginfo" do
    url "https://files.pythonhosted.org/packages/24/03/e26bf3d6453b7fda5bd2b84029a426553bb373d6277ef6b5ac8863421f87/pkginfo-1.12.1.2.tar.gz"
    sha256 "5cd957824ac36f140260964eba3c6be6442a8359b8c48f4adf90210f33a04b7b"
  end

  resource "policyuniverse" do
    url "https://files.pythonhosted.org/packages/03/a2/6cf14186b746fbcab73e507968e0b1927ad2e91dcb67af967f65d6cbe6c1/policyuniverse-1.5.1.20231109.tar.gz"
    sha256 "74e56d410560915c2c5132e361b0130e4bffe312a2f45230eac50d7c094bc40a"
  end

  resource "portalocker" do
    url "https://files.pythonhosted.org/packages/ed/d3/c6c64067759e87af98cc668c1cc75171347d0f1577fab7ca3749134e3cd4/portalocker-2.10.1.tar.gz"
    sha256 "ef1bf844e878ab08aee7e40184156e1151f228f103aa5c6bd0724cc330960f8f"
  end

  resource "propcache" do
    url "https://files.pythonhosted.org/packages/ec/44/c87281c333769159c50594f22610f77398a47ccbfbbf23074e744e86f87c/propcache-0.5.2.tar.gz"
    sha256 "01c4fc7480cd0598bb4b57022df55b9ca296da7fc5a8760bd8451a7e63a7d427"
  end

  resource "proto-plus" do
    url "https://files.pythonhosted.org/packages/c9/56/e647b0c675392d2da368da7b6f158f7368b18542fd6f7d7400a2f39de000/proto_plus-1.28.0.tar.gz"
    sha256 "38e5696342835b08fc116f30a25665b29531cda9d5d5643e9b81fc312385abd9"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/66/70/e908e9c5e52ef7c3a6c7902c9dfbb34c7e29c25d2f81ade3856445fd5c94/protobuf-6.33.6.tar.gz"
    sha256 "a6768d25248312c297558af96a9f9c929e8c4cee0659cb07e780731095f38135"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/aa/c6/d1ddf4abb55e93cebc4f2ed8b5d6dbad109ecb8d63748dd2b20ab5e57ebe/psutil-7.2.2.tar.gz"
    sha256 "0746f5f8d406af344fd547f1c8daa5f5c33dbc293bb8d6a16d80b4bb88f59372"
  end

  resource "py-deviceid" do
    url "https://files.pythonhosted.org/packages/0c/fe/1beb99282853f4f6fd32af50dc1f77d15e8883627bf5014a14a7eb024963/py_deviceid-0.1.1.tar.gz"
    sha256 "c3e7577ada23666e7f39e69370dfdaa76fe9de79c02635376d6aa0229bfa30e3"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/5c/5f/6583902b6f79b399c9c40674ac384fd9cd77805f9e6205075f828ef11fb2/pyasn1-0.6.3.tar.gz"
    sha256 "697a8ecd6d98891189184ca1fa05d1bb00e2f84b5977c481452050549c8a72cf"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/e9/e6/78ebbb10a8c8e4b61a59249394a4a594c1a7af95593dc933a349c8d00964/pyasn1_modules-0.4.2.tar.gz"
    sha256 "677091de870a80aae844b1ca6134f54652fa2c8c5a52aa396440ac3106e941e6"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/18/a5/b60d21ac674192f8ab0ba4e9fd860690f9b4a6e51ca5df118733b487d8d6/pydantic-2.13.4.tar.gz"
    sha256 "c40756b57adaa8b1efeeced5c196f3f3b7c435f90e84ea7f443901bec8099ef6"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/9d/56/921726b776ace8d8f5db44c4ef961006580d91dc52b803c489fafd1aa249/pydantic_core-2.46.4.tar.gz"
    sha256 "62f875393d7f270851f20523dd2e29f082bcc82292d66db2b64ea71f64b6e1c1"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/3b/81/58d0ac84e1ef3a3843791d6954d94c0b33d526c75eeb1efbce9d0a4c4077/pyjwt-2.13.0.tar.gz"
    sha256 "41571c89ca91598c79e8ef18a2d07367d4810fbbd6f637794879baf1b7703423"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/1a/51/27a5ad5f939d08f690a326ef9582cda7140555180db71695f6fb747d6a36/pyopenssl-26.2.0.tar.gz"
    sha256 "8c6fcecd1183a7fc897548dfe388b0cdb7f37e018200d8409cf33959dbe35387"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/f3/91/9c6ee907786a473bf81c5f53cf703ba0957b23ab84c264080fb5a450416f/pyparsing-3.3.2.tar.gz"
    sha256 "c777f4d763f140633dcb6d8a3eda953bf7a214dc4eff598413c070bcdc117cbc"
  end

  resource "pysocks" do
    url "https://files.pythonhosted.org/packages/bd/11/293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11/PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-digitalocean" do
    url "https://files.pythonhosted.org/packages/f8/f7/43cb73fb393c4c0da36294b6040c7424bc904042d55c1b37c73ecc9e7714/python-digitalocean-1.17.0.tar.gz"
    sha256 "107854fde1aafa21774e8053cf253b04173613c94531f75d5a039ad770562b24"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/ff/46/dd499ec9038423421951e4fad73051febaa13d2df82b4064f87af8b8c0c3/pytz-2026.2.tar.gz"
    sha256 "0e60b47b29f21574376f218fe21abc009894a2321ea16c6754f3cad6eb7cdd6a"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/42/f2/05f29bc3913aea15eb670be136045bf5c5bbf4b99ecb839da9b422bb2c85/requests-oauthlib-2.0.0.tar.gz"
    sha256 "b3dffaebd884d8cd778494369603a9e7b58d29111bf6b41bdc2dcd87203af4e9"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/62/74/8d69dcb7a9efe8baa2046891735e5dfe433ad558ae23d9e3c14c633d1d58/s3transfer-0.14.0.tar.gz"
    sha256 "eff12264e7c8b4985074ccce27a3b38a485bb7f7422cc8046fee9be4983e4125"
  end

  resource "scaleway" do
    url "https://files.pythonhosted.org/packages/77/74/f43e1577ac3d819ce861018fd81729a31a00bdeb8717e993d00229121ee1/scaleway-2.11.0.tar.gz"
    sha256 "f3a48253c44814c704edf2f3c7235eb2996085d54d2e08a459871358ec309dfb"
  end

  resource "scaleway-core" do
    url "https://files.pythonhosted.org/packages/42/a2/e8962b08519b03b5d7c80d2946ba4caf1ff2ab603165e2d31f7819a794d0/scaleway_core-2.11.0.tar.gz"
    sha256 "b86bb472032e039b7aab3b115aee952c62e39e360ead9c49e9b58589b125e43a"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/4f/db/cfac1baf10650ab4d1c111714410d2fbb77ac5a616db26775db562c8fab2/setuptools-82.0.1.tar.gz"
    sha256 "7d872682c5d01cfde07da7bccc7b65469d3dca203318515ada1de5eda35efbf9"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/58/15/8b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58e/shellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "slack-sdk" do
    url "https://files.pythonhosted.org/packages/0e/00/16258bfa547559b2c936b50c882b4f0a36ebf6b69639eb763d8fa5e8d6cb/slack_sdk-3.42.0.tar.gz"
    sha256 "873db9e1f632ac650ffdbf9d8ba825f3e9e7e576a1e4f9604ccb2a15b3727e3d"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "statsd" do
    url "https://files.pythonhosted.org/packages/27/29/05e9f50946f4cf2ed182726c60d9c0ae523bb3f180588c574dd9746de557/statsd-4.0.1.tar.gz"
    sha256 "99763da81bfea8daf6b3d22d11aaccb01a8d0f52ea521daab37e758a4ca7d128"
  end

  resource "std-uritemplate" do
    url "https://files.pythonhosted.org/packages/74/45/575604653c42b26eb693a6564cfbcf38ea8eb1feaa0a1f85df1a0d995a4b/std_uritemplate-2.0.10.tar.gz"
    sha256 "35048a322217aed9766fdffe5a69f0632f7319577a4a265268761cd4ffa3205e"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/46/58/8c37dea7bbf769b20d58e7ace7e5edfe65b849442b00ffcdd56be88697c6/tabulate-0.10.0.tar.gz"
    sha256 "e2cfde8f79420f6deeffdeda9aaec3b6bc5abce947655d17ac662b126e48a60d"
  end

  resource "tenacity" do
    url "https://files.pythonhosted.org/packages/47/c6/ee486fd809e357697ee8a44d3d69222b344920433d3b6666ccd9b374630c/tenacity-9.1.4.tar.gz"
    sha256 "adb31d4c263f2bd041081ab33b498309a57c77f9acf2db65aadf0898179cf93a"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/5e/ed/ef06584ccdd5c410df0837951ecd7e15d9a6144ea1bd4c73cecab1a89891/typer-0.26.7.tar.gz"
    sha256 "e314a34c617e419c091b2830dda3ea1f257134ff593061a8f5b9717ab8dddb3a"
  end

  resource "types-aiobotocore-ecr" do
    url "https://files.pythonhosted.org/packages/66/c6/19eec84ff51f60e6e5deffb086da81ffcbc6efe3de4b30b5482ba4a577a0/types_aiobotocore_ecr-3.7.0.tar.gz"
    sha256 "8f03b5ea7e7797e8cb03fcc7a4d1b73d4fe2594742b93fa6822a728ece08da1c"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "typing-inspection" do
    url "https://files.pythonhosted.org/packages/55/e3/70399cb7dd41c10ac53367ae42139cf4b1ca5f36bb3dc6c9d33acdb43655/typing_inspection-0.4.2.tar.gz"
    sha256 "ba561c48a67c5958007083d386c3295464928b01faa735ab8547c5692e87f464"
  end

  resource "uritemplate" do
    url "https://files.pythonhosted.org/packages/98/60/f174043244c5306c9988380d2cb10009f91563fc4b31293d27e17201af56/uritemplate-4.2.0.tar.gz"
    sha256 "480c2ed180878955863323eea31b0ede668795de182617fef9c6ca09e6ec9d0e"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/2c/41/aa4bf9664e4cda14c3b39865b12251e8e7d239f4cd0e3cc1b6c2ccde25c1/websocket_client-1.9.0.tar.gz"
    sha256 "9e813624b6eb619999a97dc7958469217c3176312b3a16a4bd1bc7e08a46ec98"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/04/24/4b2031d72e840ce4c1ccb255f693b15c334757fc50023e4db9537080b8c4/websockets-16.0.tar.gz"
    sha256 "5f6261a5e56e8d5c42a4497b364ea24d94d9563e8fbd44e78ac40879c60179b5"
  end

  resource "workos" do
    url "https://files.pythonhosted.org/packages/71/ec/12df7e3c81f010241347af19c9f5c20ddc8ac3ca03a77cc0ed156541dfd4/workos-7.0.1.tar.gz"
    sha256 "ad3aa1951a4c6115271c73da6e78e6a1231e63046728dc7f65860f629b84a832"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/95/8f/aeb76c5b46e273670962298c23e7ddde79916cb74db802131d49a85e4b7d/wrapt-1.17.3.tar.gz"
    sha256 "f66eb08feaa410fe4eebd17f2a2c8e2e46d3476e9f8c783daa8e09e0faa666d0"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/19/70/80f3b7c10d2630aa66414bf23d210386700aa390547278c789afa994fd7e/xmltodict-1.0.4.tar.gz"
    sha256 "6d94c9f834dd9e44514162799d344d815a3a4faec913717a9ecbfa5be1bb8e61"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/79/12/1e8f37460ea0f7eb59c221fdaf0ed75e7ac43e97f8093b9c6f411df50a78/yarl-1.24.2.tar.gz"
    sha256 "9ac374123c6fd7abf64d1fec93962b0bd4ee2c19751755a762a72dd96c0378f8"
  end

  resource "adal" do
    url "https://files.pythonhosted.org/packages/90/d7/a829bc5e8ff28f82f9e2dc9b363f3b7b9c1194766d5a75105e3885bfa9a8/adal-1.2.7.tar.gz"
    sha256 "d74f45b81317454d96e982fd1c50e6fb5c99ac2223728aea8764433a39f566f1"
  end

  resource "aioboto3" do
    url "https://files.pythonhosted.org/packages/a2/01/92e9ab00f36e2899315f49eefcd5b4685fbb19016c7f19a9edf06da80bb0/aioboto3-15.5.0.tar.gz"
    sha256 "ea8d8787d315594842fbfcf2c4dce3bac2ad61be275bc8584b2ce9a3402a6979"
  end

  resource "aiobotocore" do
    url "https://files.pythonhosted.org/packages/62/94/2e4ec48cf1abb89971cb2612d86f979a6240520f0a659b53a43116d344dc/aiobotocore-2.25.1.tar.gz"
    sha256 "ea9be739bfd7ece8864f072ec99bb9ed5c7e78ebb2b0b15f29781fbe02daedbc"
  end

  resource "aiofiles" do
    url "https://files.pythonhosted.org/packages/41/c3/534eac40372d8ee36ef40df62ec129bee4fdb5ad9706e58a29be53b2c970/aiofiles-25.1.0.tar.gz"
    sha256 "a8d728f0a29de45dc521f18f07297428d56992a742f0cd2701ba86e44d23d5b2"
  end

  resource "aiohappyeyeballs" do
    url "https://files.pythonhosted.org/packages/33/c6/61a2d7b7572279226bb2e7f61d7a19ca7c90da0329c93fa0d560cbf288d8/aiohappyeyeballs-2.6.2.tar.gz"
    sha256 "e202810ee718bd01fc6ef49e8ea53d023d5cb6b581076d7925aa499fa55dbe64"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/82/78/8ea7308cac6934de8c74a14f3d5f65d1c89287426688be79538d0e5c013d/aiohttp-3.14.1.tar.gz"
    sha256 "307f2cff90a764d329e77040603fa032db89c5c24fdad50c4c15334cba744035"
  end

  resource "aioitertools" do
    url "https://files.pythonhosted.org/packages/fd/3c/53c4a17a05fb9ea2313ee1777ff53f5e001aefd5cc85aa2f4c2d982e1e38/aioitertools-0.13.0.tar.gz"
    sha256 "620bd241acc0bbb9ec819f1ab215866871b4bbd1f73836a55f799200ee86950c"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/61/62/06741b579156360248d1ec624842ad0edf697050bbaf7c3e46394e106ad1/aiosignal-1.4.0.tar.gz"
    sha256 "f47eecd9468083c2029cc99945502cb7708b082c232f9aca65da147157b251c7"
  end

  resource "annotated-doc" do
    url "https://files.pythonhosted.org/packages/57/ba/046ceea27344560984e26a590f90bc7f4a75b06701f653222458922b558c/annotated_doc-0.0.4.tar.gz"
    sha256 "fbcda96e87e9c92ad167c2e53839e57503ecfda18804ea28102353485033faa4"
  end

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/ee/67/531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5/annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/19/14/2c5dd9f512b66549ae92767a9c7b330ae88e1932ca57876909410251fe13/anyio-4.13.0.tar.gz"
    sha256 "334b70e641fd2221c1505b3890c69882fe4a2df910cba14d97019b90b24439dc"
  end

  resource "applicationinsights" do
    url "https://files.pythonhosted.org/packages/d3/f2/46a75ac6096d60da0e71a068015b610206e697de01fa2fb5bba8564b0798/applicationinsights-0.11.10.tar.gz"
    sha256 "0b761f3ef0680acf4731906dfc1807faa6f2a57168ae74592db0084a6099f7b3"
  end

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/0c/be/6c23d80cb966fb8f83fb1ebfb988351ae6b0554d0c3a613ee4531c026597/argcomplete-3.5.3.tar.gz"
    sha256 "c12bf50eded8aebb298c7b7da7a5ff3ee24dffd9f5281867dfe1424b58c55392"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "azure-cli-core" do
    url "https://files.pythonhosted.org/packages/56/a2/a496705cd4ead834459e57d177d8fa4c81f8737b667dfa32f0231c848631/azure_cli_core-2.87.0.tar.gz"
    sha256 "3e2511eac61b3c8b5481630fdd631adb21bd650a173273759f32e30f61872b47"
  end

  resource "azure-cli-telemetry" do
    url "https://files.pythonhosted.org/packages/09/1d/c1cf3663391a271864d866e17f911b913ec257386aef7cac35121ed180a6/azure-cli-telemetry-1.1.0.tar.gz"
    sha256 "d922379cda1b48952be75fb3bd2ac5e7ceecf569492a6088bab77894c624a278"
  end

  resource "azure-common" do
    url "https://files.pythonhosted.org/packages/3e/71/f6f71a276e2e69264a97ad39ef850dca0a04fce67b12570730cb38d0ccac/azure-common-1.1.28.zip"
    sha256 "4ac0cd3214e36b6a1b6a442686722a5d8cc449603aa833f3f0f40bda836704a3"
  end

  resource "azure-core" do
    url "https://files.pythonhosted.org/packages/34/83/bbde3faa84ddcb8eb0eca4b3ffb3221252281db4ce351300fe248c5c70b1/azure_core-1.39.0.tar.gz"
    sha256 "8a90a562998dd44ce84597590fff6249701b98c0e8797c95fcdd695b54c35d74"
  end

  resource "azure-identity" do
    url "https://files.pythonhosted.org/packages/c5/0e/3a63efb48aa4a5ae2cfca61ee152fbcb668092134d3eb8bfda472dd5c617/azure_identity-1.25.3.tar.gz"
    sha256 "ab23c0d63015f50b630ef6c6cf395e7262f439ce06e5d07a64e874c724f8d9e6"
  end

  resource "azure-keyvault-certificates" do
    url "https://files.pythonhosted.org/packages/40/59/8024c8b631baa2000bf0cb52f61688f9e9569646420a22da574b3949d4ad/azure_keyvault_certificates-4.11.1.tar.gz"
    sha256 "734d9a65faa0f2bd45b9e162d317acadec71056934ebf4bbfe058b23d74bd073"
  end

  resource "azure-keyvault-keys" do
    url "https://files.pythonhosted.org/packages/f4/03/5ce6db28b545427d4ab572f6a4ef2a727b6b4e7bf6941cedddf98822535b/azure_keyvault_keys-4.11.1.tar.gz"
    sha256 "90caa3a7b2c8f6b53c247ec115cf1c1dad7f107cc3aa9f35aff4838bbce7e562"
  end

  resource "azure-keyvault-secrets" do
    url "https://files.pythonhosted.org/packages/f1/b8/03c7b4edd1e3355ad5fffb70e68af70cd09542963f45cf3a2aa9fb3930b5/azure_keyvault_secrets-4.11.0.tar.gz"
    sha256 "ac14727b9159cca353173ec5a454d8d7b192a6f2f5e7eb540f9fbcf914fa0ca0"
  end

  resource "azure-mgmt-authorization" do
    url "https://files.pythonhosted.org/packages/9e/ab/e79874f166eed24f4456ce4d532b29a926fb4c798c2c609eefd916a3f73d/azure-mgmt-authorization-4.0.0.zip"
    sha256 "69b85abc09ae64fc72975bd43431170d8c7eb5d166754b98aac5f3845de57dc4"
  end

  resource "azure-mgmt-compute" do
    url "https://files.pythonhosted.org/packages/4f/ee/a143c8395267aea8d735c5336519ef94eeaa45f235c89c06f417d1d2ce60/azure_mgmt_compute-38.0.0.tar.gz"
    sha256 "46cb0864f943b88463ed50ad006738023120cf7e53f50f7e4a740ccd5337abaf"
  end

  resource "azure-mgmt-containerinstance" do
    url "https://files.pythonhosted.org/packages/4c/19/cdb22d87560238893f5c014176b4e6868c3befbd6585bb5c44bdb1ddc997/azure-mgmt-containerinstance-10.1.0.zip"
    sha256 "78d437adb28574f448c838ed5f01f9ced378196098061deb59d9f7031704c17e"
  end

  resource "azure-mgmt-containerservice" do
    url "https://files.pythonhosted.org/packages/00/0d/8021bbb2735869e7b4f868f96eda6de5fa3e097bdec59cf270460cec37d6/azure_mgmt_containerservice-41.3.0.tar.gz"
    sha256 "6414756e2802fb31a62bda900a6a9f99bb5e275b1b3181ca708be5db1977ce54"
  end

  resource "azure-mgmt-core" do
    url "https://files.pythonhosted.org/packages/3e/99/fa9e7551313d8c7099c89ebf3b03cd31beb12e1b498d575aa19bb59a5d04/azure_mgmt_core-1.6.0.tar.gz"
    sha256 "b26232af857b021e61d813d9f4ae530465255cb10b3dde945ad3743f7a58e79c"
  end

  resource "azure-mgmt-cosmosdb" do
    url "https://files.pythonhosted.org/packages/05/e3/8687e481a34c83f5a6e6d9d3a084c8344920aaf6a505b19a299e58f20421/azure_mgmt_cosmosdb-9.9.0.tar.gz"
    sha256 "4678bf042bdc208aa24fca71767ac29b6f2a2722ac7872608371a5922f3b6c37"
  end

  resource "azure-mgmt-datafactory" do
    url "https://files.pythonhosted.org/packages/e8/5e/c28a8a50885185a9a06ff659594fec24f1a840622f21883b376358dd1188/azure_mgmt_datafactory-9.3.0.tar.gz"
    sha256 "f5fdd5cd416f0ed71dfedf05dc7677b8f0e52f3428fd5b17b04c9200dd8d36b3"
  end

  resource "azure-mgmt-eventgrid" do
    url "https://files.pythonhosted.org/packages/bb/68/24a2921b66827a571a3da75cc12289b7029a7c436087c0c5b2b4ca387aa3/azure_mgmt_eventgrid-10.4.0.tar.gz"
    sha256 "303e5e27cf4bb5ec833ba4e5a9ef70b5bc410e190412ec47cde59d82e413fb7e"
  end

  resource "azure-mgmt-eventhub" do
    url "https://files.pythonhosted.org/packages/04/41/5080742de3a0c7a2c579fcf6995c531d48a83f9c588b52334b41bd84d666/azure_mgmt_eventhub-11.2.0.tar.gz"
    sha256 "31c47f18f73d2d83345cde5909568e28858c2548a35b10e23194b4767a9ce7e3"
  end

  resource "azure-mgmt-keyvault" do
    url "https://files.pythonhosted.org/packages/df/dd/e74f82797ee3ff7001832427a218f3079e6174b9fa8b354b84434172d89d/azure_mgmt_keyvault-14.0.1.tar.gz"
    sha256 "d141a8084ae4c7c5bd1cafeca49a8f3fbebc58dc5bc5290f322ea73d8b307ef7"
  end

  resource "azure-mgmt-logic" do
    url "https://files.pythonhosted.org/packages/fc/89/47e9b71d49ee05782cebcf3a9e4b04e974c76b19f4b2d68fd9ea9c4e358a/azure-mgmt-logic-10.0.0.zip"
    sha256 "b3fa4864f14aaa7af41d778d925f051ed29b6016f46344765ecd0f49d0f04dd6"
  end

  resource "azure-mgmt-monitor" do
    url "https://files.pythonhosted.org/packages/0e/12/25874f6b894e972646244f570a23298969b58f57cfb7a188e2740017b43a/azure_mgmt_monitor-7.0.0.tar.gz"
    sha256 "b75f536441d430f69ff873a1646e5f5dbcb3080a10768a59d0adc01541623816"
  end

  resource "azure-mgmt-network" do
    url "https://files.pythonhosted.org/packages/9a/e5/31cf174ef67087532f159083e2e007507fe163f58c58fbd0e08d05209cf4/azure_mgmt_network-30.2.0.tar.gz"
    sha256 "9b17c259e6344808aaa80a34bbc4b13f16bc01185dd9db137eaa0ae26664861a"
  end

  resource "azure-mgmt-resource" do
    url "https://files.pythonhosted.org/packages/50/4c/b27a3dfbedebbcc8e346a956a803528bd94a19fdf14b1de4bd781b03a6cc/azure_mgmt_resource-24.0.0.tar.gz"
    sha256 "cf6b8995fcdd407ac9ff1dd474087129429a1d90dbb1ac77f97c19b96237b265"
  end

  resource "azure-mgmt-security" do
    url "https://files.pythonhosted.org/packages/3d/90/13186657355452bdce44f27db6b194b99f78f8c185301b47624fff6d9531/azure-mgmt-security-7.0.0.tar.gz"
    sha256 "5912eed7e9d3758fdca8d26e1dc26b41943dc4703208a1184266e2c252e1ad66"
  end

  resource "azure-mgmt-sql" do
    url "https://files.pythonhosted.org/packages/3f/af/398c57d15064ea23475076cd087b1a143b66d33a029e6e47c4688ca32310/azure-mgmt-sql-3.0.1.zip"
    sha256 "129042cc011225e27aee6ef2697d585fa5722e5d1aeb0038af6ad2451a285457"
  end

  resource "azure-mgmt-storage" do
    url "https://files.pythonhosted.org/packages/47/6a/62d21f86b62cf990cb7d63f470dd4a766277a68a71543ef9331e0ee16f7d/azure_mgmt_storage-25.0.0.tar.gz"
    sha256 "52c4bb1fb395fcfa7a2e8fb024c1dabc5a67bd6fa23c0d2d5a7fb29314f172d2"
  end

  resource "azure-mgmt-synapse" do
    url "https://files.pythonhosted.org/packages/af/fa/5a7c375d305ec0ec06978db07ac34c4894d2b8a00087ff3dd9e1435e397f/azure-mgmt-synapse-2.0.0.zip"
    sha256 "bec6bdfaeb55b4fdd159f2055e8875bf50a720bb0fce80a816e92a2359b898c8"
  end

  resource "azure-mgmt-web" do
    url "https://files.pythonhosted.org/packages/71/dd/581afc7b4e6e2a86859e1323d654f58a7e3f63cfaa69ddbdb0baa8419d0a/azure_mgmt_web-11.0.0.tar.gz"
    sha256 "1f98b29283ecb9c36ede7309c0da8d26db0455d77ae37e1cb6cdcd244044d6de"
  end

  resource "azure-storage-blob" do
    url "https://files.pythonhosted.org/packages/3b/48/84a820d898267f662b5c06f7cd76fdb8a9e272b44aa9376cef3ec0f6a294/azure_storage_blob-12.30.0.tar.gz"
    sha256 "2cd74d4d5731e5eb6b8d5c5056ee115a5e88f8fdf22517b739836fda685018be"
  end

  resource "azure-synapse-artifacts" do
    url "https://files.pythonhosted.org/packages/7a/c1/61c88b6ba66e7042602b79cbb84e5c3785dee41e67e22f7362bcd55d91cc/azure_synapse_artifacts-0.22.0.tar.gz"
    sha256 "ddc0fb622738c3eab7465ce428cfa0cd41ad01a870fbd45361e4d58d175c623c"
  end

  resource "backoff" do
    url "https://files.pythonhosted.org/packages/47/d7/5bbeb12c44d7c4f2fb5b56abce497eb5ed9f34d85701de869acedd602619/backoff-2.2.1.tar.gz"
    sha256 "03f829f5bb1923180821643f8753b0502c3b682293992485b0eef2807afa5cba"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/ed/f9/6ef8feb52c3cce5ec3967a535a6114b57ac7949fd166b0f3090c2b06e4e5/boto3-1.40.61.tar.gz"
    sha256 "d6c56277251adf6c2bdd25249feae625abe4966831676689ff23b4694dea5b12"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/28/a3/81d3a47c2dbfd76f185d3b894f2ad01a75096c006a2dd91f237dca182188/botocore-1.40.61.tar.gz"
    sha256 "a2487ad69b090f9cccd64cf07c7021cd80ee9c0655ad974f87045b02f3ef52cd"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e7/a1/67fe25fac3c7642725500a3f6cfe5821ad557c3abb11c9d20d12c7008d3e/charset_normalizer-3.4.7.tar.gz"
    sha256 "ae89db9e5f98a11a4bf50407d4363e7b09b31e55bc117b4f7d80aab97ba009e5"
  end

  resource "circuitbreaker" do
    url "https://files.pythonhosted.org/packages/df/ac/de7a92c4ed39cba31fe5ad9203b76a25ca67c530797f6bb420fff5f65ccb/circuitbreaker-2.1.3.tar.gz"
    sha256 "1a4baee510f7bea3c91b194dcce7c07805fe96c4423ed5594b75af438531d084"
  end

  resource "cloudflare" do
    url "https://files.pythonhosted.org/packages/61/64/ba01193be8e31bda89974f0f33d1084b44b34a2d2d96031e3fb704340182/cloudflare-5.3.0.tar.gz"
    sha256 "695538d02bc57e2a3c1dbe88ba09f0d5e80fc87b41acf5cf99bb62aa13775748"
  end

  resource "crc32c" do
    url "https://files.pythonhosted.org/packages/7f/4c/4e40cc26347ac8254d3f25b9f94710b8e8df24ee4dddc1ba41907a88a94d/crc32c-2.7.1.tar.gz"
    sha256 "f91b144a21eef834d64178e01982bb9179c354b3e9e5f4c803b0e5096384968c"
  end

  resource "crowdstrike-falconpy" do
    url "https://files.pythonhosted.org/packages/33/e3/eb1f9218c4ce68a398d69356d78558d79040ce796d09e3f3e744f747599c/crowdstrike_falconpy-1.6.2.tar.gz"
    sha256 "c86ac31a37175cb31dc0171feceb8cf0cb3e323ca1f84e2863938aef8153b119"
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

  resource "duo-client" do
    url "https://files.pythonhosted.org/packages/c8/20/48842c3cc8b2c60129e1e52f0ab5c72ac0a30a3a345ea6d6e9aa8c94c093/duo_client-5.6.1.tar.gz"
    sha256 "5b9bfba3bd995178cebf51db605190bdc84fec8e4b6935210e7abde4ae97cef5"
  end

  resource "durationpy" do
    url "https://files.pythonhosted.org/packages/9d/a4/e44218c2b394e31a6dd0d6b095c4e1f32d0be54c2a4b250032d717647bab/durationpy-0.10.tar.gz"
    sha256 "1fa6893409a6e739c9c72334fc65cca1f355dbdd93405d30f726deb5bde42fba"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/2d/f5/c831fac6cc817d26fd54c7eaccd04ef7e0288806943f7cc5bbf69f3ac1f0/frozenlist-1.8.0.tar.gz"
    sha256 "3ede829ed8d842f6cd48fc7081d7a41001a56f1f38603f9d49bf3020d59a31ad"
  end

  resource "google-api-core" do
    url "https://files.pythonhosted.org/packages/c6/22/155cadf1d49272a9cf48f3168c0f3874fa13397297e611a5ea00cd093880/google_api_core-2.31.0.tar.gz"
    sha256 "2be84ee0f584c48e6bde1b36766e23348b361fb7e55e56135fc76ce1c397f9c2"
  end

  resource "google-api-python-client" do
    url "https://files.pythonhosted.org/packages/22/09/081d66357118bd260f8f182cb1b2dd5bd32ca88e3714d7c93896cab946fc/google_api_python_client-2.197.0.tar.gz"
    sha256 "32e03977eda4a66eafc6ae58dc9ec46426b6025636d5ef019c5703013eddd4e5"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/15/f6/494e18317546d7def90c957b71d68b025d24f0e22e486c2606bc57765c48/google_auth-2.54.0.tar.gz"
    sha256 "130f6fd5e3f497fdad897a23ed9489973437edf561238c4b92a4d02c435f8af9"
  end

  resource "google-auth-httplib2" do
    url "https://files.pythonhosted.org/packages/1c/b3/f192c8bc7e41e0ebdbd95afcae4783417a34b6a6af62d22daf22c3fd38fc/google_auth_httplib2-0.4.0.tar.gz"
    sha256 "d5b030a204b7a4b4d553ba9ca701b62481ee2b74419325580be70f7d85ffed35"
  end

  resource "google-cloud-access-context-manager" do
    url "https://files.pythonhosted.org/packages/35/38/99786d542d1c1efb9fc6f70179efac4dc23b8d5d8d0b1d12ec90b98e436b/google_cloud_access_context_manager-0.6.0.tar.gz"
    sha256 "760267fba1f8be8636e2a8d7c302027f310260fff8051c46b8b09b97d5468ee0"
  end

  resource "google-cloud-aiplatform" do
    url "https://files.pythonhosted.org/packages/e0/d9/e2a5f5a8535bbc8f68729796f3fc2d68d59a72818fb44f6544edbc2592e4/google_cloud_aiplatform-1.157.0.tar.gz"
    sha256 "ce8413ed3584c4896f7656b663214c24e91c2c89426f1c91fbd1d220ffda23af"
  end

  resource "google-cloud-artifact-registry" do
    url "https://files.pythonhosted.org/packages/af/9c/a78d175a0484c500063696b1b923920392de6e5e4c1bd509210721554242/google_cloud_artifact_registry-1.22.0.tar.gz"
    sha256 "0e8173a97ae695dfcf02c83277a0fd574e1a39be409da6345b945bebe577ad94"
  end

  resource "google-cloud-asset" do
    url "https://files.pythonhosted.org/packages/4c/d4/92b37789e99dc416b2d17f6d3be5a32a50049ffe6c350953abda85c4a0fd/google_cloud_asset-4.4.0.tar.gz"
    sha256 "350d564db6edb2d9521d4776fc44d559765fecd06bdb7284017cf24261039c8d"
  end

  resource "google-cloud-bigquery" do
    url "https://files.pythonhosted.org/packages/ce/13/6515c7aab55a4a0cf708ffd309fb9af5bab54c13e32dc22c5acd6497193c/google_cloud_bigquery-3.41.0.tar.gz"
    sha256 "2217e488b47ed576360c9b2cc07d59d883a54b83167c0ef37f915c26b01a06fe"
  end

  resource "google-cloud-core" do
    url "https://files.pythonhosted.org/packages/a8/dd/1eef226e470369b26824a505c34482c0b493bc35fe8e0c6b003b5feca21a/google_cloud_core-2.6.0.tar.gz"
    sha256 "e76149739f90fac1fc6757c09f47eaccb3145b54adbd7759b0f7c4b235f46c83"
  end

  resource "google-cloud-org-policy" do
    url "https://files.pythonhosted.org/packages/a2/44/df6d39606b3ff6cf1779debdfd4f4af1801fc71f072e896515f90c3b0751/google_cloud_org_policy-1.17.0.tar.gz"
    sha256 "f77189ee7f65a28f3755f855f710b8b67b9862e2a6b6a93b075e6f9da93bff20"
  end

  resource "google-cloud-os-config" do
    url "https://files.pythonhosted.org/packages/a6/3a/4bf339ca4103739cb6977696e31a4fc3cb2c6204443855df77f4236043fb/google_cloud_os_config-1.24.0.tar.gz"
    sha256 "ddf64eac47c0da9483d573b7de9abed48a5a6cbe27931ae94396899f598e0192"
  end

  resource "google-cloud-resource-manager" do
    url "https://files.pythonhosted.org/packages/b2/1a/13060cabf553d52d151d2afc26b39561e82853380d499dd525a0d422d9f0/google_cloud_resource_manager-1.17.0.tar.gz"
    sha256 "0f486b62e2c58ff992a3a50fa0f4a96eef7750aa6c971bb373398ccb91828660"
  end

  resource "google-cloud-run" do
    url "https://files.pythonhosted.org/packages/b7/89/dcaf0dc97e39b41e446456ceb60657ab025de79cfccd39cbd739d1a9849e/google_cloud_run-0.16.0.tar.gz"
    sha256 "d52cf4e6ad3702ae48caccf6abcab543afee6f61c2a6ec753cc62a31e5b629f1"
  end

  resource "google-cloud-storage" do
    url "https://files.pythonhosted.org/packages/58/72/86f94e1639a8bcd9d33e8e01b49afcaa1c3a13bda7683c681717e0901e15/google_cloud_storage-3.12.0.tar.gz"
    sha256 "03ae9847c6babb368f35f054126b8a08cbc0e3266efb990eb17b9926a45cf3be"
  end

  resource "google-crc32c" do
    url "https://files.pythonhosted.org/packages/03/41/4b9c02f99e4c5fb477122cd5437403b552873f014616ac1d19ac8221a58d/google_crc32c-1.8.0.tar.gz"
    sha256 "a428e25fb7691024de47fecfbff7ff957214da51eddded0da0ae0e0f03a2cf79"
  end

  resource "google-genai" do
    url "https://files.pythonhosted.org/packages/5b/52/0244e310812f3063d09d60b30ae29ab7df9343bd005744cd5eeaa6ba39b4/google_genai-2.8.0.tar.gz"
    sha256 "37a9b3cb127d763e7f4ca47452ae3562c87728773bd1b149f7b559c239da2bc1"
  end

  resource "google-resumable-media" do
    url "https://files.pythonhosted.org/packages/48/f8/1ca5781d6be9cb9f73f7d40f4958c4bd1226a60598e3e39e1d6aaf838c4b/google_resumable_media-2.10.0.tar.gz"
    sha256 "e324bc9d0fdae4c52a08ae90456edc4e71ece858399e1217ac0eb3a51d6bc6ee"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/b5/c8/f439cffde755cffa462bfbb156278fa6f9d09119719af9814b858fd4f81f/googleapis_common_protos-1.75.0.tar.gz"
    sha256 "53a062ff3c32552fbd62c11fe23768b78e4ddf0494d5e5fd97d3f4689c75fbbd"
  end

  resource "grpc-google-iam-v1" do
    url "https://files.pythonhosted.org/packages/44/4f/d098419ad0bfc06c9ce440575f05aa22d8973b6c276e86ac7890093d3c37/grpc_google_iam_v1-0.14.4.tar.gz"
    sha256 "392b3796947ed6334e61171d9ab06bf7eb357f554e5fc7556ad7aab6d0e17038"
  end

  resource "grpcio" do
    url "https://files.pythonhosted.org/packages/b0/b5/1ff353970a87eda4c98251e34d2dfd214abd4982dc89119c9252a2a482d2/grpcio-1.81.1.tar.gz"
    sha256 "6fa10a767143a5e82e8eaab53918af0cd8909a57a27f8cb2288b80a613ac671b"
  end

  resource "grpcio-status" do
    url "https://files.pythonhosted.org/packages/32/26/0aa9168c87882381fd810d140c279a2490ed6aee655f0515d6f56c5ca404/grpcio_status-1.81.1.tar.gz"
    sha256 "9389a03e746017b10f0630c064289201458f3ce01f5d7ef4b0bebc1ef6cf82ad"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "h2" do
    url "https://files.pythonhosted.org/packages/1d/17/afa56379f94ad0fe8defd37d6eb3f89a25404ffc71d4d848893d270325fc/h2-4.3.0.tar.gz"
    sha256 "6c59efe4323fa18b47a632221a1888bd7fde6249819beda254aeca909f221bf1"
  end

  resource "hpack" do
    url "https://files.pythonhosted.org/packages/2c/48/71de9ed269fdae9c8057e5a4c0aa7402e8bb16f2c6e90b3aa53327b113f8/hpack-4.1.0.tar.gz"
    sha256 "ec5eca154f7056aa06f196a557655c5b009b382873ac8d1e66e79e87535f1dca"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/06/94/82699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cb/httpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httplib2" do
    url "https://files.pythonhosted.org/packages/c1/1f/e86365613582c027dda5ddb64e1010e57a3d53e99ab8a72093fa13d565ec/httplib2-0.31.2.tar.gz"
    sha256 "385e0869d7397484f4eab426197a4c020b606edd43372492337c0b4010ae5d24"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "humanfriendly" do
    url "https://files.pythonhosted.org/packages/cc/3f/2c29224acb2e2df4d2046e4c73ee2662023c58ff5b113c4c1adac0886c43/humanfriendly-10.0.tar.gz"
    sha256 "6b0b831ce8f15f7300721aa49829fc4e83921a9a301cc7f606be6686a2288ddc"
  end

  resource "hyperframe" do
    url "https://files.pythonhosted.org/packages/02/e7/94f8232d4a74cc99514c13a9f995811485a6903d48e5d952771ef6322e30/hyperframe-6.1.0.tar.gz"
    sha256 "f630908a00854a7adeabd6382b43923a4c4cd4b821fcb527e6ab9e15382a3b08"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cd/63/9496c57188a2ee585e0f1db071d75089a11e98aa86eb99d9d7618fc1edce/idna-3.18.tar.gz"
    sha256 "ffb385a7e039654cef1ab9ef32c6fafe283c0c0467bba1d9029738ce4a14a848"
  end

  resource "isodate" do
    url "https://files.pythonhosted.org/packages/54/4d/e940025e2ce31a8ce1202635910747e5a87cc3a6a6bb2d00973375014749/isodate-0.7.2.tar.gz"
    sha256 "4cd1aa0f43ca76f4a6c6c0292a85f40b35ec2e43e315b59f06e6d32171a953e6"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/d3/59/322338183ecda247fb5d1763a6cbe46eff7222eaeebafd9fa65d4bf5cb11/jmespath-1.1.0.tar.gz"
    sha256 "472c87d80f36026ae83c6ddd0f1d05d4e510134ed462851fd5f754c8c3cbb88d"
  end

  resource "jsonpickle" do
    url "https://files.pythonhosted.org/packages/8d/c0/dde9b4b42cc415b9579573f967f12efbb034e427a2a37e93ad5139891d87/jsonpickle-4.1.2.tar.gz"
    sha256 "8afed18aa189fd81e2e833b426bb4af485594921f0b1d36c2001fc5637a2f210"
  end

  resource "knack" do
    url "https://files.pythonhosted.org/packages/58/ce/0e9597a4b2348dade473d3e177ce32ca570f67b479ab9a292a90cb88f892/knack-0.14.0.tar.gz"
    sha256 "2ddd32fd6343ec9b6ed0da729b212362d0e6b1208c0162633c90cb6f94a05877"
  end

  resource "kubernetes" do
    url "https://files.pythonhosted.org/packages/2f/57/8b538af5076bc3372949d76f70ba3449bdfe52f9e6488170fa5d4f7cbe70/kubernetes-36.0.2.tar.gz"
    sha256 "03551fcb49cae1f708f63624041e37403545b7aaed10cbf54e2b01a37a5438e3"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "marshmallow" do
    url "https://files.pythonhosted.org/packages/25/7e/1dbd4096eb7c148cd2841841916f78820bb85a4d80a0c25c02d30815a7fb/marshmallow-4.3.0.tar.gz"
    sha256 "fb43c53b3fe240b8f6af37223d6ef1636f927ad9bea8ab323afad95dff090880"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "microsoft-kiota-abstractions" do
    url "https://files.pythonhosted.org/packages/c9/0f/e8f6ccdc2f22e6cd73da9dd2e5dd2f302664bf8ad6e775f0bf4cde08092e/microsoft_kiota_abstractions-1.10.3.tar.gz"
    sha256 "07367351399396c1f1713a4ab112fd499f84fe019696ba477cf63d4ce48b8165"
  end

  resource "microsoft-kiota-authentication-azure" do
    url "https://files.pythonhosted.org/packages/fc/df/f95ebb712b99e4002558b5e60e2b066d98472257f7cf31f4f696b9c76100/microsoft_kiota_authentication_azure-1.10.3.tar.gz"
    sha256 "7750bb002d2ab435cffcf609e9f35154ba391d5fa2452aea4fa6e673e2173b75"
  end

  resource "microsoft-kiota-http" do
    url "https://files.pythonhosted.org/packages/cd/86/2d3fea265a2b8ae6b552ff84884baf76a5a49aed0259d004b969bf3960ca/microsoft_kiota_http-1.10.3.tar.gz"
    sha256 "56e0e0799f6de04d56346b4ee6b18f6c79af02e6bd08064d875a3b05e375e7b4"
  end

  resource "microsoft-kiota-serialization-form" do
    url "https://files.pythonhosted.org/packages/d2/d8/9281bb1c46b4c818d7f91f10c9bd8e33340004f53079bf52e419342b3510/microsoft_kiota_serialization_form-1.10.3.tar.gz"
    sha256 "323ad8856bcd3db74c9cf5950e22dc83e52713ad5aa4d7353d5650c518697c0e"
  end

  resource "microsoft-kiota-serialization-json" do
    url "https://files.pythonhosted.org/packages/45/7c/81306c46b4c8b897d4d663bd1937376921029e163b9869e4ee7127076060/microsoft_kiota_serialization_json-1.10.3.tar.gz"
    sha256 "84feb6b683289b7a8ca0495201050d36ce5ff28f384c24389f9e3fe221a38c93"
  end

  resource "microsoft-kiota-serialization-multipart" do
    url "https://files.pythonhosted.org/packages/05/aa/7cda18ec4dbf5ade90fd0ab7b5c40490fdb2107db9b80da1a4a44f2f8920/microsoft_kiota_serialization_multipart-1.10.3.tar.gz"
    sha256 "916fc578522985876f615f35ba676ee4d1abdae26304bc0d248fb2e34212b897"
  end

  resource "microsoft-kiota-serialization-text" do
    url "https://files.pythonhosted.org/packages/ff/69/2e135c222fffffc4ff42b7046da6e0be7c3ad91d946d313da70eb8a81815/microsoft_kiota_serialization_text-1.10.3.tar.gz"
    sha256 "0db370ccbbfded4e9e01c2f967850478cd1198c748f3baef60abec0c10e58e0f"
  end

  resource "microsoft-security-utilities-secret-masker" do
    url "https://files.pythonhosted.org/packages/e8/1a/6fa5c0ba55ed62e17df010af8a3a71ffea701c3d414b4688834c527d5aeb/microsoft_security_utilities_secret_masker-1.0.0b4.tar.gz"
    sha256 "a30bd361ac18c8b52f6844076bc26465335949ea9c7a004d95f5196ec6fdef3e"
  end

  resource "msal" do
    url "https://files.pythonhosted.org/packages/de/cb/b02b0f748ac668922364ccb3c3bff5b71628a05f5adfec2ba2a5c3031483/msal-1.36.0.tar.gz"
    sha256 "3f6a4af2b036b476a4215111c4297b4e6e236ed186cd804faefba23e4990978b"
  end

  resource "msal-extensions" do
    url "https://files.pythonhosted.org/packages/01/99/5d239b6156eddf761a636bded1118414d161bd6b7b37a9335549ed159396/msal_extensions-1.3.1.tar.gz"
    sha256 "c5b0fd10f65ef62b5f1d62f4251d51cbcaf003fcedae8c91b040a488614be1a4"
  end

  resource "msgraph-core" do
    url "https://files.pythonhosted.org/packages/b6/92/e74e204ac240a1817817d50074599af1e0331608c5ee58a1836e40f39c2e/msgraph_core-1.4.0.tar.gz"
    sha256 "5f0dee9564a0e20edfb2eb7137fe189d7d204a80a87d6d83d69d31269376e1b1"
  end

  resource "msgraph-sdk" do
    url "https://files.pythonhosted.org/packages/26/94/a7c46a574e01f13421e54186ec68d6fbe92e7a887bf6ba54e28ce4ba5fe1/msgraph_sdk-1.58.0.tar.gz"
    sha256 "beee4dda22dd8e709a33871fd9aadfcac908a1870a2dab9350734616b59403b1"
  end

  resource "msrest" do
    url "https://files.pythonhosted.org/packages/68/77/8397c8fb8fc257d8ea0fa66f8068e073278c65f05acb17dcb22a02bfdc42/msrest-0.7.1.zip"
    sha256 "6e7661f46f3afd88b75667b7187a92829924446c7ea1d169be8c4bb7eeb788b9"
  end

  resource "msrestazure" do
    url "https://files.pythonhosted.org/packages/5d/86/06a086e4ed3523765a1917665257b1828f1bf882130768445f082a4c3484/msrestazure-0.6.4.post1.tar.gz"
    sha256 "39842007569e8c77885ace5c46e4bf2a9108fcb09b1e6efdf85b6e2c642b55d4"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/1a/c2/c2d94cbe6ac1753f3fc980da97b3d930efe1da3af3c9f5125354436c073d/multidict-6.7.1.tar.gz"
    sha256 "ec6652a1bee61c53a3e5776b6049172c53b6aaba34f18c9ad04f82712bac623d"
  end

  resource "neo4j" do
    url "https://files.pythonhosted.org/packages/ce/f4/aaa4ac19adae4b01bc742b63afd2672a77e7351566f02721e713e4b863ee/neo4j-6.2.0.tar.gz"
    sha256 "e1e246b65b572bd8ea97f9e0e721b7d40a5ce53e53d0007c29aef63e4f9124d9"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/0b/5f/19930f824ffeb0ad4372da4812c50edbd1434f678c90c2733e1188edfc63/oauthlib-3.3.1.tar.gz"
    sha256 "0f0f8aa759826a193cf66c12ea1af1637f87b9b4622d46e866952bb022e538c9"
  end

  resource "oci" do
    url "https://files.pythonhosted.org/packages/d0/c8/25eb226edcd2ede3fb5bedf5bfa5054cde98006414b3cd76b82111ec8126/oci-2.178.0.tar.gz"
    sha256 "d3a19859d80aa5c4988905e1a30b46dcc2af146c76f3d8c813129d71247d1a94"
  end

  resource "okta" do
    url "https://files.pythonhosted.org/packages/e8/2a/1c1bae7ed0b429cfe04caaff4ec06383669b651b315328b15f87ab67d347/okta-0.0.4.tar.gz"
    sha256 "53e792c68d3684ff4140b4cb1c02af3821090368f8110fde54c0bdb638449332"
  end

  resource "opentelemetry-api" do
    url "https://files.pythonhosted.org/packages/b4/1c/125e1c936c0873796771b7f04f6c93b9f1bf5d424cea90fda94a99f61da8/opentelemetry_api-1.42.1.tar.gz"
    sha256 "56c63bea9f77b62856be8c47600474acad853b2924b99b1687c4cb6297166716"
  end

  resource "opentelemetry-sdk" do
    url "https://files.pythonhosted.org/packages/40/f7/b390bd9bfd703bf98a68fea1f27786c6872331fd617164a54b8a59bdc008/opentelemetry_sdk-1.42.1.tar.gz"
    sha256 "8c834e8f8c9ba4171d4ec843d0cb8a67e4c7394d3f9e9297e582cbd9456ddbf7"
  end

  resource "opentelemetry-semantic-conventions" do
    url "https://files.pythonhosted.org/packages/93/99/4d7dd6df64795951413ce6e815f8cf1eb191daf7196ae86574589643d5f3/opentelemetry_semantic_conventions-0.63b1.tar.gz"
    sha256 "3daf963611334b365e98a57438183eb012d3bfb40b2d931a9af613476b8701a9"
  end

  resource "packageurl-python" do
    url "https://files.pythonhosted.org/packages/f5/d6/3b5a4e3cfaef7a53869a26ceb034d1ff5e5c27c814ce77260a96d50ab7bb/packageurl_python-0.17.6.tar.gz"
    sha256 "1252ce3a102372ca6f86eb968e16f9014c4ba511c5c37d95a7f023e2ca6e5c25"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
    sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
  end

  resource "pagerduty" do
    url "https://files.pythonhosted.org/packages/15/36/bd614651ea128057a47fab486ca8f647351320ac19aa998e5aa11ba2cadd/pagerduty-6.2.2.tar.gz"
    sha256 "c8a7ea625f72b47624decd282c925c8b7fab0568aaae7ad3bd430ce9a15c99d6"
  end

  resource "pkginfo" do
    url "https://files.pythonhosted.org/packages/24/03/e26bf3d6453b7fda5bd2b84029a426553bb373d6277ef6b5ac8863421f87/pkginfo-1.12.1.2.tar.gz"
    sha256 "5cd957824ac36f140260964eba3c6be6442a8359b8c48f4adf90210f33a04b7b"
  end

  resource "policyuniverse" do
    url "https://files.pythonhosted.org/packages/03/a2/6cf14186b746fbcab73e507968e0b1927ad2e91dcb67af967f65d6cbe6c1/policyuniverse-1.5.1.20231109.tar.gz"
    sha256 "74e56d410560915c2c5132e361b0130e4bffe312a2f45230eac50d7c094bc40a"
  end

  resource "portalocker" do
    url "https://files.pythonhosted.org/packages/ed/d3/c6c64067759e87af98cc668c1cc75171347d0f1577fab7ca3749134e3cd4/portalocker-2.10.1.tar.gz"
    sha256 "ef1bf844e878ab08aee7e40184156e1151f228f103aa5c6bd0724cc330960f8f"
  end

  resource "propcache" do
    url "https://files.pythonhosted.org/packages/ec/44/c87281c333769159c50594f22610f77398a47ccbfbbf23074e744e86f87c/propcache-0.5.2.tar.gz"
    sha256 "01c4fc7480cd0598bb4b57022df55b9ca296da7fc5a8760bd8451a7e63a7d427"
  end

  resource "proto-plus" do
    url "https://files.pythonhosted.org/packages/c9/56/e647b0c675392d2da368da7b6f158f7368b18542fd6f7d7400a2f39de000/proto_plus-1.28.0.tar.gz"
    sha256 "38e5696342835b08fc116f30a25665b29531cda9d5d5643e9b81fc312385abd9"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/66/70/e908e9c5e52ef7c3a6c7902c9dfbb34c7e29c25d2f81ade3856445fd5c94/protobuf-6.33.6.tar.gz"
    sha256 "a6768d25248312c297558af96a9f9c929e8c4cee0659cb07e780731095f38135"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/aa/c6/d1ddf4abb55e93cebc4f2ed8b5d6dbad109ecb8d63748dd2b20ab5e57ebe/psutil-7.2.2.tar.gz"
    sha256 "0746f5f8d406af344fd547f1c8daa5f5c33dbc293bb8d6a16d80b4bb88f59372"
  end

  resource "py-deviceid" do
    url "https://files.pythonhosted.org/packages/0c/fe/1beb99282853f4f6fd32af50dc1f77d15e8883627bf5014a14a7eb024963/py_deviceid-0.1.1.tar.gz"
    sha256 "c3e7577ada23666e7f39e69370dfdaa76fe9de79c02635376d6aa0229bfa30e3"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/5c/5f/6583902b6f79b399c9c40674ac384fd9cd77805f9e6205075f828ef11fb2/pyasn1-0.6.3.tar.gz"
    sha256 "697a8ecd6d98891189184ca1fa05d1bb00e2f84b5977c481452050549c8a72cf"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/e9/e6/78ebbb10a8c8e4b61a59249394a4a594c1a7af95593dc933a349c8d00964/pyasn1_modules-0.4.2.tar.gz"
    sha256 "677091de870a80aae844b1ca6134f54652fa2c8c5a52aa396440ac3106e941e6"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/18/a5/b60d21ac674192f8ab0ba4e9fd860690f9b4a6e51ca5df118733b487d8d6/pydantic-2.13.4.tar.gz"
    sha256 "c40756b57adaa8b1efeeced5c196f3f3b7c435f90e84ea7f443901bec8099ef6"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/9d/56/921726b776ace8d8f5db44c4ef961006580d91dc52b803c489fafd1aa249/pydantic_core-2.46.4.tar.gz"
    sha256 "62f875393d7f270851f20523dd2e29f082bcc82292d66db2b64ea71f64b6e1c1"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/3b/81/58d0ac84e1ef3a3843791d6954d94c0b33d526c75eeb1efbce9d0a4c4077/pyjwt-2.13.0.tar.gz"
    sha256 "41571c89ca91598c79e8ef18a2d07367d4810fbbd6f637794879baf1b7703423"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/1a/51/27a5ad5f939d08f690a326ef9582cda7140555180db71695f6fb747d6a36/pyopenssl-26.2.0.tar.gz"
    sha256 "8c6fcecd1183a7fc897548dfe388b0cdb7f37e018200d8409cf33959dbe35387"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/f3/91/9c6ee907786a473bf81c5f53cf703ba0957b23ab84c264080fb5a450416f/pyparsing-3.3.2.tar.gz"
    sha256 "c777f4d763f140633dcb6d8a3eda953bf7a214dc4eff598413c070bcdc117cbc"
  end

  resource "pysocks" do
    url "https://files.pythonhosted.org/packages/bd/11/293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11/PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-digitalocean" do
    url "https://files.pythonhosted.org/packages/f8/f7/43cb73fb393c4c0da36294b6040c7424bc904042d55c1b37c73ecc9e7714/python-digitalocean-1.17.0.tar.gz"
    sha256 "107854fde1aafa21774e8053cf253b04173613c94531f75d5a039ad770562b24"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/ff/46/dd499ec9038423421951e4fad73051febaa13d2df82b4064f87af8b8c0c3/pytz-2026.2.tar.gz"
    sha256 "0e60b47b29f21574376f218fe21abc009894a2321ea16c6754f3cad6eb7cdd6a"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/42/f2/05f29bc3913aea15eb670be136045bf5c5bbf4b99ecb839da9b422bb2c85/requests-oauthlib-2.0.0.tar.gz"
    sha256 "b3dffaebd884d8cd778494369603a9e7b58d29111bf6b41bdc2dcd87203af4e9"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/62/74/8d69dcb7a9efe8baa2046891735e5dfe433ad558ae23d9e3c14c633d1d58/s3transfer-0.14.0.tar.gz"
    sha256 "eff12264e7c8b4985074ccce27a3b38a485bb7f7422cc8046fee9be4983e4125"
  end

  resource "scaleway" do
    url "https://files.pythonhosted.org/packages/77/74/f43e1577ac3d819ce861018fd81729a31a00bdeb8717e993d00229121ee1/scaleway-2.11.0.tar.gz"
    sha256 "f3a48253c44814c704edf2f3c7235eb2996085d54d2e08a459871358ec309dfb"
  end

  resource "scaleway-core" do
    url "https://files.pythonhosted.org/packages/42/a2/e8962b08519b03b5d7c80d2946ba4caf1ff2ab603165e2d31f7819a794d0/scaleway_core-2.11.0.tar.gz"
    sha256 "b86bb472032e039b7aab3b115aee952c62e39e360ead9c49e9b58589b125e43a"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/4f/db/cfac1baf10650ab4d1c111714410d2fbb77ac5a616db26775db562c8fab2/setuptools-82.0.1.tar.gz"
    sha256 "7d872682c5d01cfde07da7bccc7b65469d3dca203318515ada1de5eda35efbf9"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/58/15/8b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58e/shellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "slack-sdk" do
    url "https://files.pythonhosted.org/packages/0e/00/16258bfa547559b2c936b50c882b4f0a36ebf6b69639eb763d8fa5e8d6cb/slack_sdk-3.42.0.tar.gz"
    sha256 "873db9e1f632ac650ffdbf9d8ba825f3e9e7e576a1e4f9604ccb2a15b3727e3d"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "statsd" do
    url "https://files.pythonhosted.org/packages/27/29/05e9f50946f4cf2ed182726c60d9c0ae523bb3f180588c574dd9746de557/statsd-4.0.1.tar.gz"
    sha256 "99763da81bfea8daf6b3d22d11aaccb01a8d0f52ea521daab37e758a4ca7d128"
  end

  resource "std-uritemplate" do
    url "https://files.pythonhosted.org/packages/74/45/575604653c42b26eb693a6564cfbcf38ea8eb1feaa0a1f85df1a0d995a4b/std_uritemplate-2.0.10.tar.gz"
    sha256 "35048a322217aed9766fdffe5a69f0632f7319577a4a265268761cd4ffa3205e"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/46/58/8c37dea7bbf769b20d58e7ace7e5edfe65b849442b00ffcdd56be88697c6/tabulate-0.10.0.tar.gz"
    sha256 "e2cfde8f79420f6deeffdeda9aaec3b6bc5abce947655d17ac662b126e48a60d"
  end

  resource "tenacity" do
    url "https://files.pythonhosted.org/packages/47/c6/ee486fd809e357697ee8a44d3d69222b344920433d3b6666ccd9b374630c/tenacity-9.1.4.tar.gz"
    sha256 "adb31d4c263f2bd041081ab33b498309a57c77f9acf2db65aadf0898179cf93a"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/5e/ed/ef06584ccdd5c410df0837951ecd7e15d9a6144ea1bd4c73cecab1a89891/typer-0.26.7.tar.gz"
    sha256 "e314a34c617e419c091b2830dda3ea1f257134ff593061a8f5b9717ab8dddb3a"
  end

  resource "types-aiobotocore-ecr" do
    url "https://files.pythonhosted.org/packages/66/c6/19eec84ff51f60e6e5deffb086da81ffcbc6efe3de4b30b5482ba4a577a0/types_aiobotocore_ecr-3.7.0.tar.gz"
    sha256 "8f03b5ea7e7797e8cb03fcc7a4d1b73d4fe2594742b93fa6822a728ece08da1c"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "typing-inspection" do
    url "https://files.pythonhosted.org/packages/55/e3/70399cb7dd41c10ac53367ae42139cf4b1ca5f36bb3dc6c9d33acdb43655/typing_inspection-0.4.2.tar.gz"
    sha256 "ba561c48a67c5958007083d386c3295464928b01faa735ab8547c5692e87f464"
  end

  resource "uritemplate" do
    url "https://files.pythonhosted.org/packages/98/60/f174043244c5306c9988380d2cb10009f91563fc4b31293d27e17201af56/uritemplate-4.2.0.tar.gz"
    sha256 "480c2ed180878955863323eea31b0ede668795de182617fef9c6ca09e6ec9d0e"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/2c/41/aa4bf9664e4cda14c3b39865b12251e8e7d239f4cd0e3cc1b6c2ccde25c1/websocket_client-1.9.0.tar.gz"
    sha256 "9e813624b6eb619999a97dc7958469217c3176312b3a16a4bd1bc7e08a46ec98"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/04/24/4b2031d72e840ce4c1ccb255f693b15c334757fc50023e4db9537080b8c4/websockets-16.0.tar.gz"
    sha256 "5f6261a5e56e8d5c42a4497b364ea24d94d9563e8fbd44e78ac40879c60179b5"
  end

  resource "workos" do
    url "https://files.pythonhosted.org/packages/71/ec/12df7e3c81f010241347af19c9f5c20ddc8ac3ca03a77cc0ed156541dfd4/workos-7.0.1.tar.gz"
    sha256 "ad3aa1951a4c6115271c73da6e78e6a1231e63046728dc7f65860f629b84a832"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/95/8f/aeb76c5b46e273670962298c23e7ddde79916cb74db802131d49a85e4b7d/wrapt-1.17.3.tar.gz"
    sha256 "f66eb08feaa410fe4eebd17f2a2c8e2e46d3476e9f8c783daa8e09e0faa666d0"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/19/70/80f3b7c10d2630aa66414bf23d210386700aa390547278c789afa994fd7e/xmltodict-1.0.4.tar.gz"
    sha256 "6d94c9f834dd9e44514162799d344d815a3a4faec913717a9ecbfa5be1bb8e61"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/79/12/1e8f37460ea0f7eb59c221fdaf0ed75e7ac43e97f8093b9c6f411df50a78/yarl-1.24.2.tar.gz"
    sha256 "9ac374123c6fd7abf64d1fec93962b0bd4ee2c19751755a762a72dd96c0378f8"
  end

  def install
    ENV["SETUPTOOLS_SCM_PRETEND_VERSION_FOR_CARTOGRAPHY"] = version.to_s
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cartography --version 2>&1")

    output = shell_output("#{bin}/cartography --selected-modules not-a-module 2>&1", 1)
    assert_match "not-a-module", output
  end
end
