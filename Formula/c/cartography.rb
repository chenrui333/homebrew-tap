class Cartography < Formula
  include Language::Python::Virtualenv

  desc "Pull infrastructure assets and relationships into a Neo4j graph database"
  homepage "https://github.com/cartography-cncf/cartography"
  url "https://github.com/cartography-cncf/cartography/archive/refs/tags/0.141.0.tar.gz"
  sha256 "f1f7d662b22c9430fb9c9d86ec55c75152283815d3e599ddd4bd18b8791d0a63"
  license "Apache-2.0"
  revision 2
  head "https://github.com/cartography-cncf/cartography.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0284b26f59d117b34b529a44c361d55d98a3e569a593dd10fb77ad89a855b65d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "173ccc90d88f8793122ab752172b9f47bc3a17b71cd23948c0358b9cbe52e19c"
    sha256 cellar: :any,                 arm64_linux:   "b0f4a2c2f9797a46abd7eebdb0d59b44cc520842a82b9a411c00ddd78d0bc0b4"
    sha256 cellar: :any,                 x86_64_linux:  "dec45a9a37436cb168adb78ba31536fd44c5b37fd35fc02f63043617b68d4171"
  end

  depends_on "maturin" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "certifi"
  depends_on "crc32c"
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.14"
  uses_from_macos "xz"

  on_linux do
    depends_on "bzip2"
  end

  resource "adal" do
    url "https://files.pythonhosted.org/packages/90/d7/a829bc5e8ff28f82f9e2dc9b363f3b7b9c1194766d5a75105e3885bfa9a8/adal-1.2.7.tar.gz"
    sha256 "d74f45b81317454d96e982fd1c50e6fb5c99ac2223728aea8764433a39f566f1"
  end

  resource "aenum" do
    url "https://files.pythonhosted.org/packages/07/e9/8b283567c1fef7c24d1f390b37daede8b61593d8cdaffb8e95d571699e83/aenum-3.1.17.tar.gz"
    sha256 "a969a4516b194895de72c875ece355f17c0d272146f7fda346ef74f93cf4d5ba"
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
    url "https://files.pythonhosted.org/packages/ce/f4/eec0465c2f67b2664688d0240b3212d5196fd89e741df67ddb81f8d35658/aiohappyeyeballs-2.7.1.tar.gz"
    sha256 "065665c041c42a5938ed220bdcd7230f22527fbec085e1853d2402c8a3615d9d"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/6c/4c/bdccd81e9ee225b69c60e7766c9a5b05364f118f4d383713b89a682d772d/aiohttp-3.14.5.tar.gz"
    sha256 "5558a7f5a05af9ecf744af91e5baefc436f93c9333e656c27ec253f9a6bbe178"
  end

  resource "aiohttp-retry" do
    url "https://files.pythonhosted.org/packages/9d/61/ebda4d8e3d8cfa1fd3db0fb428db2dd7461d5742cea35178277ad180b033/aiohttp_retry-2.9.1.tar.gz"
    sha256 "8eb75e904ed4ee5c2ec242fefe85bf04240f685391c4879d8f541d6028ff01f1"
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
    url "https://files.pythonhosted.org/packages/5a/8e/38aa427ed5402449e226975b649c5dc73ccadfefeb95e6aecb8f8ea4b6b6/annotated_doc-0.0.5.tar.gz"
    sha256 "c7e58ce09192557605d8bbd92836d7e1d520ac9580096042c0bfd197efacf1bb"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/a1/98/7e457a3b014976887a050561955c0b76e1e7e2d6e27b78ecef2ef80518f2/anyio-4.16.0.tar.gz"
    sha256 "59bb03251907983d1603d27c3087ddb1e93299ea2163adcdba37899a4fb12ffb"
  end

  resource "asn1crypto" do
    url "https://files.pythonhosted.org/packages/de/cf/d547feed25b5244fcb9392e288ff9fdc3280b10260362fc45d37a798a6ee/asn1crypto-1.5.1.tar.gz"
    sha256 "13ae38502be632115abf8a24cbe5f4da52e3b5231990aff31123c805306ccb9c"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "azure-common" do
    url "https://files.pythonhosted.org/packages/3e/71/f6f71a276e2e69264a97ad39ef850dca0a04fce67b12570730cb38d0ccac/azure-common-1.1.28.zip"
    sha256 "4ac0cd3214e36b6a1b6a442686722a5d8cc449603aa833f3f0f40bda836704a3"
  end

  resource "azure-core" do
    url "https://files.pythonhosted.org/packages/a6/f3/b416179e408990df5db0d516283022dde0f5d0111d98c1a848e41853e81c/azure_core-1.41.0.tar.gz"
    sha256 "f46ff5dfcd230f25cf1c19e8a34b8dc08a337b2503e268bb600a16c00db8ad5a"
  end

  resource "azure-identity" do
    url "https://files.pythonhosted.org/packages/cf/33/0b881d0093d64c965bb20fcf71b806c7097881b544a2a55d519cdcf3bab9/azure_identity-1.27.0.tar.gz"
    sha256 "6a4c50e25e8e9a47b324a95ad024897e56cb3c6241e0094e93b126a2bf71edc5"
  end

  resource "azure-keyvault-certificates" do
    url "https://files.pythonhosted.org/packages/88/68/ef38756d4a2fba3e71501bba422562b2a3a4a352b50869448b47c55e67fc/azure_keyvault_certificates-4.12.0.tar.gz"
    sha256 "ec5589c28889dce360d3ff9e9ec419db0fac4e127be1580f8a4a8e87384da4ea"
  end

  resource "azure-keyvault-keys" do
    url "https://files.pythonhosted.org/packages/6e/d4/e0ba8e8d661fcb2f536e1ba572369053aa37e3bc5c0bdb9aaab6603248ab/azure_keyvault_keys-4.11.3.tar.gz"
    sha256 "abe258a46937ab69b148d1832150192f6a300578451d69304a0c3be24b9881aa"
  end

  resource "azure-keyvault-secrets" do
    url "https://files.pythonhosted.org/packages/39/24/ef81175436814f088cb1b9c4252f580f1c29e8ae1ca7d01cce7f9f6c3b7a/azure_keyvault_secrets-4.12.0.tar.gz"
    sha256 "435ea0abb5280baaad9553da7a19e73e1b581048783b852210352bfcb0316aff"
  end

  resource "azure-mgmt-authorization" do
    url "https://files.pythonhosted.org/packages/9e/ab/e79874f166eed24f4456ce4d532b29a926fb4c798c2c609eefd916a3f73d/azure-mgmt-authorization-4.0.0.zip"
    sha256 "69b85abc09ae64fc72975bd43431170d8c7eb5d166754b98aac5f3845de57dc4"
  end

  resource "azure-mgmt-compute" do
    url "https://files.pythonhosted.org/packages/67/d9/dd0efc9a4d74f19f860b2eeae7635b0a2da72229220d8324b0b06d1f01ce/azure_mgmt_compute-39.0.0.tar.gz"
    sha256 "0187dd028afcbab87d435498cd169f9e54fbb57c08785bcd59008a9a012861fa"
  end

  resource "azure-mgmt-containerinstance" do
    url "https://files.pythonhosted.org/packages/4c/19/cdb22d87560238893f5c014176b4e6868c3befbd6585bb5c44bdb1ddc997/azure-mgmt-containerinstance-10.1.0.zip"
    sha256 "78d437adb28574f448c838ed5f01f9ced378196098061deb59d9f7031704c17e"
  end

  resource "azure-mgmt-containerservice" do
    url "https://files.pythonhosted.org/packages/16/e5/898d665952d31d90adb1cb38ec5b9df32efb3e2a88c0b7aca04ea569512a/azure_mgmt_containerservice-41.8.0.tar.gz"
    sha256 "87fdc0fcc517853b382127ca8bb1c746f6a1d3ac5bf6de58e60c86754e810d58"
  end

  resource "azure-mgmt-core" do
    url "https://files.pythonhosted.org/packages/3e/99/fa9e7551313d8c7099c89ebf3b03cd31beb12e1b498d575aa19bb59a5d04/azure_mgmt_core-1.6.0.tar.gz"
    sha256 "b26232af857b021e61d813d9f4ae530465255cb10b3dde945ad3743f7a58e79c"
  end

  resource "azure-mgmt-cosmosdb" do
    url "https://files.pythonhosted.org/packages/e4/f9/0d236f870f7b5187e4ead98b2387af07a633832e246be8fbcba13b4529db/azure_mgmt_cosmosdb-10.0.0.tar.gz"
    sha256 "f9f5e9cbc984ad3cf3f9bdfb853ec3e868b0e89e9c2597de4d429fa6602ca8d9"
  end

  resource "azure-mgmt-datafactory" do
    url "https://files.pythonhosted.org/packages/56/f9/81397c6afd0fed926ffe3093d108d0392745bddc05c5dfc69880dfb70bb2/azure_mgmt_datafactory-10.0.0.tar.gz"
    sha256 "c83eeb2b092c1f1e5bb2499ffbba6fd7809a1274739930f9db1e336273405587"
  end

  resource "azure-mgmt-eventgrid" do
    url "https://files.pythonhosted.org/packages/bb/68/24a2921b66827a571a3da75cc12289b7029a7c436087c0c5b2b4ca387aa3/azure_mgmt_eventgrid-10.4.0.tar.gz"
    sha256 "303e5e27cf4bb5ec833ba4e5a9ef70b5bc410e190412ec47cde59d82e413fb7e"
  end

  resource "azure-mgmt-eventhub" do
    url "https://files.pythonhosted.org/packages/32/f5/3c7e0ba5318ca889aabc53fafb23473dbcb6009a492a65759a02726f3d78/azure_mgmt_eventhub-12.0.0.tar.gz"
    sha256 "86b1e5aa64eabaa6b78a679c7911f162d5dc1633f369c71e0f642ffb889ba19f"
  end

  resource "azure-mgmt-keyvault" do
    url "https://files.pythonhosted.org/packages/72/d7/9b72ab97a5a1faddf9c13659fb1f39cb82a2423879f57968b4ed8c237b58/azure_mgmt_keyvault-14.1.0.tar.gz"
    sha256 "d27d412e6d7b5b76bfc7a8267b8e3d30852c7c6dc560609ec7d93d4816bd29fc"
  end

  resource "azure-mgmt-logic" do
    url "https://files.pythonhosted.org/packages/fc/89/47e9b71d49ee05782cebcf3a9e4b04e974c76b19f4b2d68fd9ea9c4e358a/azure-mgmt-logic-10.0.0.zip"
    sha256 "b3fa4864f14aaa7af41d778d925f051ed29b6016f46344765ecd0f49d0f04dd6"
  end

  resource "azure-mgmt-managementgroups" do
    url "https://files.pythonhosted.org/packages/09/12/c80cc24e4a05d5617a8896d87093beffc1db6149b57c062d908f20f129dc/azure_mgmt_managementgroups-2.0.0.tar.gz"
    sha256 "02d008fadfd7610b1c7059e3c3a8a33dedaef4b654749b81978b437baf264f1d"
  end

  resource "azure-mgmt-monitor" do
    url "https://files.pythonhosted.org/packages/0e/12/25874f6b894e972646244f570a23298969b58f57cfb7a188e2740017b43a/azure_mgmt_monitor-7.0.0.tar.gz"
    sha256 "b75f536441d430f69ff873a1646e5f5dbcb3080a10768a59d0adc01541623816"
  end

  resource "azure-mgmt-network" do
    url "https://files.pythonhosted.org/packages/a4/64/745a47ed48aa3c193d6941c6d9d314f61043cd777bfe4f380c04a8819329/azure_mgmt_network-33.1.0.tar.gz"
    sha256 "ca44e95967e530bdac32ff7d7e6476c84e852225e5aae148eef2694f34f9710b"
  end

  resource "azure-mgmt-resource" do
    url "https://files.pythonhosted.org/packages/61/e1/c6196381cc6bb3eff9e24f5bf31b7fd962651ddbd6120bc2a4c482a7af16/azure_mgmt_resource-26.0.0.tar.gz"
    sha256 "54227c5db06d3be4dd4b77ad885b273e9eb2606d1de653c5b534066cfbb60c0c"
  end

  resource "azure-mgmt-resource-subscriptions" do
    url "https://files.pythonhosted.org/packages/bc/8a/e87473d051b73871f2e0df16c9141a3e998b7fb2bc4478ae06989b57a81a/azure_mgmt_resource_subscriptions-1.0.0.tar.gz"
    sha256 "8c1251c54ef4fa9851fccf4aae5300f4dabd319357783152b930fd961f4d04eb"
  end

  resource "azure-mgmt-security" do
    url "https://files.pythonhosted.org/packages/3d/90/13186657355452bdce44f27db6b194b99f78f8c185301b47624fff6d9531/azure-mgmt-security-7.0.0.tar.gz"
    sha256 "5912eed7e9d3758fdca8d26e1dc26b41943dc4703208a1184266e2c252e1ad66"
  end

  resource "azure-mgmt-sql" do
    url "https://files.pythonhosted.org/packages/83/b0/a99bf130e8cf3b9d7e43464fa5fe30deccee43605846c02be517c12a17ed/azure_mgmt_sql-4.0.0.tar.gz"
    sha256 "b39756f9cf8acee72764f1c745211c6c635fa5f6bfc27174de2a58690917262b"
  end

  resource "azure-mgmt-storage" do
    url "https://files.pythonhosted.org/packages/8b/8c/fab588ef865839d8e4e14118142433dca61190161c2a860b7d072c5f28ab/azure_mgmt_storage-25.3.0.tar.gz"
    sha256 "bc4fe1ea26f8c58bf9ca6b365095cfd326d65cefa135dd5f29e09353cb6313ec"
  end

  resource "azure-mgmt-synapse" do
    url "https://files.pythonhosted.org/packages/af/fa/5a7c375d305ec0ec06978db07ac34c4894d2b8a00087ff3dd9e1435e397f/azure-mgmt-synapse-2.0.0.zip"
    sha256 "bec6bdfaeb55b4fdd159f2055e8875bf50a720bb0fce80a816e92a2359b898c8"
  end

  resource "azure-mgmt-web" do
    url "https://files.pythonhosted.org/packages/bf/89/5d55d6e403a797d7b44b3526774af0f2c72e24b4ce5464703d273a033ecb/azure_mgmt_web-11.0.1.tar.gz"
    sha256 "1ce8ed7fd69e1dd4c820a29765643e9394b58f428b501336413d517c027a1459"
  end

  resource "azure-storage-blob" do
    url "https://files.pythonhosted.org/packages/6f/18/eb2ade6eede419d33493016ec3243ca9860f67d0bc71aa0461cda2cad0c4/azure_storage_blob-12.31.1.tar.gz"
    sha256 "0d6e5b860a1357efc602db04cfa7c9950ac86126edcf7db89320cde281555fe5"
  end

  resource "azure-synapse-artifacts" do
    url "https://files.pythonhosted.org/packages/7a/c1/61c88b6ba66e7042602b79cbb84e5c3785dee41e67e22f7362bcd55d91cc/azure_synapse_artifacts-0.22.0.tar.gz"
    sha256 "ddc0fb622738c3eab7465ce428cfa0cd41ad01a870fbd45361e4d58d175c623c"
  end

  resource "backoff" do
    url "https://files.pythonhosted.org/packages/47/d7/5bbeb12c44d7c4f2fb5b56abce497eb5ed9f34d85701de869acedd602619/backoff-2.2.1.tar.gz"
    sha256 "03f829f5bb1923180821643f8753b0502c3b682293992485b0eef2807afa5cba"
  end

  resource "blinker" do
    url "https://files.pythonhosted.org/packages/21/28/9b3f50ce0e048515135495f198351908d99540d69bfdc8c1d15b73dc55ce/blinker-1.9.0.tar.gz"
    sha256 "b4ce2265a7abece45e7cc896e98dbebe6cead56bcf805a3d23136d145f5445bf"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/ed/f9/6ef8feb52c3cce5ec3967a535a6114b57ac7949fd166b0f3090c2b06e4e5/boto3-1.40.61.tar.gz"
    sha256 "d6c56277251adf6c2bdd25249feae625abe4966831676689ff23b4694dea5b12"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/28/a3/81d3a47c2dbfd76f185d3b894f2ad01a75096c006a2dd91f237dca182188/botocore-1.40.61.tar.gz"
    sha256 "a2487ad69b090f9cccd64cf07c7021cd80ee9c0655ad974f87045b02f3ef52cd"
  end

  resource "calver" do
    url "https://files.pythonhosted.org/packages/4a/96/0c57e3e228ffc54074867406b659b197678674f1f0bf600d114965289834/calver-2025.10.20.tar.gz"
    sha256 "c98b376c2424642224d456b2f70c51402343e008c63d204634665e1a2a2835f5"
  end

  resource "cbor2" do
    url "https://files.pythonhosted.org/packages/1b/2f/bf52daccd1027ffdfad3f04ae1730383e5b406abb8a9a98963584dd39563/cbor2-6.2.1.tar.gz"
    sha256 "086c1588bd407a46739da704b5ee7d15225dc998d9582a0519fc6c9a114b25f7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/33/1c/f41d4e74c28ab327ff3acd36053f7ea506c55872d7a90b0fa71aa3ab0c89/charset_normalizer-3.5.2.tar.gz"
    sha256 "39de2a259fc954455c57274dc94c79d5842774e1247a016aff30bc0efed0f4ef"
  end

  resource "circuitbreaker" do
    url "https://files.pythonhosted.org/packages/df/ac/de7a92c4ed39cba31fe5ad9203b76a25ca67c530797f6bb420fff5f65ccb/circuitbreaker-2.1.3.tar.gz"
    sha256 "1a4baee510f7bea3c91b194dcce7c07805fe96c4423ed5594b75af438531d084"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/45/37/edbf1b0707709013c0cf2e8317e03d97ed29bf4cac709fe328904ae92a38/click-8.5.1.tar.gz"
    sha256 "9bbfada76703fd1d784b83eea012e3e8c6a001a876543ef104fa56aaaeb072b4"
  end

  resource "cloudflare" do
    url "https://files.pythonhosted.org/packages/0c/e8/5188c42b346a29f018b397d3b4cd587cf386902b459d04bed5774915c525/cloudflare-5.10.0.tar.gz"
    sha256 "3e1ac8f71f5098dc3541bfd77ae0d3abd710aebef48093021e7d37f6bb584ca0"
  end

  resource "coherent-licensed" do
    url "https://files.pythonhosted.org/packages/cd/e9/63d2dcccb5496cc99d96f29a8a5f3e2c6ed0bba7fedb840862f92816ee17/coherent_licensed-0.5.2.tar.gz"
    sha256 "d8071403ce742d3ac3592ddc4fb7057a46caffb415b928b4d52802e5f208416d"
  end

  resource "crc32c" do
    url "https://files.pythonhosted.org/packages/e3/66/7e97aa77af7cf6afbff26e3651b564fe41932599bc2d3dce0b2f73d4829a/crc32c-2.8.tar.gz"
    sha256 "578728964e59c47c356aeeedee6220e021e124b9d3e8631d95d9a5e5f06e261c"
  end

  resource "crowdstrike-falconpy" do
    url "https://files.pythonhosted.org/packages/4c/bf/c738015a568ead4e866fe9a44d23388ce363696cff5562d0eb3f54627a60/crowdstrike_falconpy-1.6.6.tar.gz"
    sha256 "8f36ac6c3d4e536cdef319f109e7077f92c4c9a2cb316814a5402eca5aaaa9b6"
  end

  resource "cython" do
    url "https://files.pythonhosted.org/packages/f6/de/db48b8870e766cfea809986cc50c1e986c663a9ab7bafd0ac1a2512c4a26/cython-3.2.9.tar.gz"
    sha256 "d249c9022ab13286b17bd66f30609e800c5f95efeecb06168990c7a66cecde6c"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/fc/f8/98eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3/distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/76/49/900383b471c645a3c397f47b3211d1fcecb3a540c98f683494cdf86b33de/dnspython-2.9.2.tar.gz"
    sha256 "8d4d39a513e649d634004ce4d39ade2352efcea472a0247535a5c2d18a9d7ba9"
  end

  resource "docstring-parser" do
    url "https://files.pythonhosted.org/packages/e0/4d/f332313098c1de1b2d2ff91cf2674415cc7cddab2ca1b01ae29774bd5fdf/docstring_parser-0.18.0.tar.gz"
    sha256 "292510982205c12b1248696f44959db3cdd1740237a968ea1e2e7a900eeb2015"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/39/a4/5180d9afc57e8fca05601dd652bdff19604c218814037fe90ffc7625a50a/docutils-0.23.tar.gz"
    sha256 "746f5060322511280a1e50eb76846ed6bf2342984b2ac04dc42caa1a8d78799e"
  end

  resource "dunamai" do
    url "https://files.pythonhosted.org/packages/18/82/51a4e2ed9a7fef19888e5e0ba9a493c8f1878ab89b10b05cc9564b4f5df8/dunamai-1.26.5.tar.gz"
    sha256 "b1435d8d2b0aceef240cde8e8f6ba910e85b1aa0e22fa9e21454d2d22fb0a89c"
  end

  resource "duo-client" do
    url "https://files.pythonhosted.org/packages/98/23/8e65f0b414eb5cf90c0c30dcee023935a954fdc81cfb6e284483533a4be7/duo_client-5.7.0.tar.gz"
    sha256 "8ae0feb93226b13e9b7b29f6970118a52386b9500d410c2b9775fd21a34dd293"
  end

  resource "durationpy" do
    url "https://files.pythonhosted.org/packages/b0/5d/5f8571bd5dedc80863191621ac4be001f3f3dd8315d2ec078705dab7dec1/durationpy-0.11.tar.gz"
    sha256 "181898e1ae282e288f0a2291829656bf1b6b3aadf30a97993b85db4943642905"
  end

  resource "expandvars" do
    url "https://files.pythonhosted.org/packages/9c/64/a9d8ea289d663a44b346203a24bf798507463db1e76679eaa72ee6de1c7a/expandvars-1.1.2.tar.gz"
    sha256 "6c5822b7b756a99a356b915dd1267f52ab8a4efaa135963bd7f4bd5d368f71d7"
  end

  resource "flit-core" do
    url "https://files.pythonhosted.org/packages/69/59/b6fc2188dfc7ea4f936cd12b49d707f66a1cb7a1d2c16172963534db741b/flit_core-3.12.0.tar.gz"
    sha256 "18f63100d6f94385c6ed57a72073443e1a71a4acb4339491615d0f16d6ff01b2"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/2d/f5/c831fac6cc817d26fd54c7eaccd04ef7e0288806943f7cc5bbf69f3ac1f0/frozenlist-1.8.0.tar.gz"
    sha256 "3ede829ed8d842f6cd48fc7081d7a41001a56f1f38603f9d49bf3020d59a31ad"
  end

  resource "google-api-core" do
    url "https://files.pythonhosted.org/packages/72/ef/63d89cb580f3a42c51db53b3d151352aa61b9c87ea8cfdd8d24ee6caa09d/google_api_core-2.44.0.tar.gz"
    sha256 "5ab9a396965c1227d7dea4581e562b7018aa2bca96d2de0be5eb70dc9c8ab3a1"
  end

  resource "google-api-python-client" do
    url "https://files.pythonhosted.org/packages/b6/47/077e889d3c618d971d3bce4ab198c645a607276b8d4bb151cfe78d2c92bb/google_api_python_client-2.201.0.tar.gz"
    sha256 "d5691982abd7287f53cb0b0e0c6a9984d4103cf864ea0a88cb6e4347bbaf70de"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/c4/38/d79ab09dcfc1e1638d887c8f65657619d3ebc454165c558ef79355971ce3/google_auth-2.62.1.tar.gz"
    sha256 "3c8e1ce2553784ae17fd220e6f88df3281d86ab98019278f436d06dffab17a9e"
  end

  resource "google-auth-httplib2" do
    url "https://files.pythonhosted.org/packages/bb/6d/a511ca64d5412850e351bdec6bb224e5090749bd85c186135e8fdb4fd85a/google_auth_httplib2-0.4.4.tar.gz"
    sha256 "b931de392c20cfaa351cd789274922bd8cdc001e0e9e96de31b39d71347f8e16"
  end

  resource "google-cloud-access-context-manager" do
    url "https://files.pythonhosted.org/packages/26/1b/faeb0a823daac87e168ed9580ba025329911db92b0b00a0313a973432439/google_cloud_access_context_manager-0.6.2.tar.gz"
    sha256 "d579d53c9ee69735fc49ff50784eb1bd50041c9dba06bbbf412de9abf04dea01"
  end

  resource "google-cloud-aiplatform" do
    url "https://files.pythonhosted.org/packages/18/5b/d8a5c1033a92c729a5fdb387dcfe0c575bb2c6c4d89e35f8d7c9eba7ffa7/google_cloud_aiplatform-2.7.0.tar.gz"
    sha256 "af89c8b7ff8bfaa3361a4d88224a886e8d2a9f22853d4e3c5d047e46367b6008"
  end

  resource "google-cloud-artifact-registry" do
    url "https://files.pythonhosted.org/packages/2a/33/1bb2908435420b24e51cc080938f6105b3b5d861a22247051043e290c9c1/google_cloud_artifact_registry-1.23.0.tar.gz"
    sha256 "3de036f4374431f742a7c147e819bb160a54d098ae11c567ab65ef1df5fd2734"
  end

  resource "google-cloud-asset" do
    url "https://files.pythonhosted.org/packages/9d/12/bb9e03e64e4a6bed7ac794526a5e5234b1ca8110bb0ba5d6c94bca66552e/google_cloud_asset-4.5.0.tar.gz"
    sha256 "55ca670d06046d6e8cf80f5fcd680c10d31c7d8407659904975fbbd41b757c97"
  end

  resource "google-cloud-bigquery" do
    url "https://files.pythonhosted.org/packages/b0/96/482bde8e8b87b65f80aa9c0a4fa86e6e92ae407b6f50da574f264b923b64/google_cloud_bigquery-3.47.0.tar.gz"
    sha256 "bca7a5ff52326172dc8c292e4592a5b46b491b6872010d242d7663d8ea89b12f"
  end

  resource "google-cloud-core" do
    url "https://files.pythonhosted.org/packages/55/71/d6081acadf55d4233271c39860f0d140ef61fbdb4bceb2075e9c2905d947/google_cloud_core-2.8.0.tar.gz"
    sha256 "365f8e4518ae81c8101b8dea5fc1c32a960badedb8b511f19db2843cbbd285d2"
  end

  resource "google-cloud-org-policy" do
    url "https://files.pythonhosted.org/packages/18/40/9a00a3ae19f7d8d3cbad014979b405b099ec8119993a9e412f56c8cab1e8/google_cloud_org_policy-1.19.0.tar.gz"
    sha256 "56dd15ff736c8358d3c67c33ba26839b09c7a1e871d6b6b2da2cb1e1becd7224"
  end

  resource "google-cloud-os-config" do
    url "https://files.pythonhosted.org/packages/10/5f/c7fdeb689380e2c67a1f480c70190b031fd5364316d83ea93549e9c92616/google_cloud_os_config-1.26.0.tar.gz"
    sha256 "51f5a90115afb60ea84e0f0e4b938c4067cff15cafcd18a3e09bcb923c24a6d0"
  end

  resource "google-cloud-resource-manager" do
    url "https://files.pythonhosted.org/packages/f4/1f/a2f23d2c2c0a34dab2e689d11ac4f20d77ac51c4832953beece2bc39e48a/google_cloud_resource_manager-1.19.0.tar.gz"
    sha256 "68e5d28ed9091ab1adf04a77876b09d553e97a440fba78163f6ce2b5fe5f2558"
  end

  resource "google-cloud-run" do
    url "https://files.pythonhosted.org/packages/cb/95/303555b84bc111068c1ea9bd5a792c049b09f641ecf89b8e87d6dc048f10/google_cloud_run-0.16.2.tar.gz"
    sha256 "480ecde89b18dc99aac4584048f6477e856002af4d7a8e7a6eb894801d01190b"
  end

  resource "google-cloud-storage" do
    url "https://files.pythonhosted.org/packages/1d/d8/9d6444c1bc301bd4bad36cc91306524e8aba670cbefcc0d2fc184c88fbea/google_cloud_storage-3.17.1.tar.gz"
    sha256 "b24df37900f5e0a93518bd7d3a2a7b7b48d8a1e72add8eb57d53a38b8b2b0640"
  end

  resource "google-crc32c" do
    url "https://files.pythonhosted.org/packages/fa/25/9cb0c1c31c45b893eb8f11ae70b3f4309432d59b5acaebca5dbe791729a4/google_crc32c-1.9.0.tar.gz"
    sha256 "7b8c84c3d159ab6817fe3f74e6e6cef099c3f95dcec3abc0d8afb1404642efbe"
  end

  resource "google-genai" do
    url "https://files.pythonhosted.org/packages/22/89/4621aee9cb183efa5b8a187f0e315c49fddcfb8cd7f238b4a3bf4946dcd0/google_genai-2.34.0.tar.gz"
    sha256 "8e182cf3f73384167b96861cf0aef5102b5070f2db1ea11002879e913806ef37"
  end

  resource "google-resumable-media" do
    url "https://files.pythonhosted.org/packages/cf/64/df6a482d5aa39d7f7be186d892377d605cae6c88525fd851d456e8bbe9c9/google_resumable_media-2.11.0.tar.gz"
    sha256 "febd83686752799661b4de575f0b993c5c25c349a5362556fc4d7be164056a37"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/62/b6/bc095b23a3e0d978e75c8c18cabe4c11f791837410670e4486f0d539bfba/googleapis_common_protos-1.76.0.tar.gz"
    sha256 "71db0e44a1d4c2dd024ebad44ca67129cc1e2892e4861df466764749d5ef8642"
  end

  resource "grpc-google-iam-v1" do
    url "https://files.pythonhosted.org/packages/97/24/0ef24ccdd91ce07be7d6466d39becdd4fbb33e52426ba2391fe334d24bca/grpc_google_iam_v1-0.14.6.tar.gz"
    sha256 "fc0a683ace0a149184fcd08d667dd64d51ae65e5698e86f7136aa6002a8b5373"
  end

  resource "grpcio" do
    url "https://files.pythonhosted.org/packages/f0/03/f9e805772d4d01da2a1754a5f63c58601eacaf8f1e878729217188de7d16/grpcio-1.85.1.tar.gz"
    sha256 "5f530287d5de5f7f66089ead81de44f6787162944dab3922efa65dfdff108a1d"
  end

  resource "grpcio-status" do
    url "https://files.pythonhosted.org/packages/fe/16/0a161d0016f6e318ebf217780a91e007a67d9d244a06f79caeef689f5f02/grpcio_status-1.85.1.tar.gz"
    sha256 "3f6ba6090d794b7148b23f03355addd56bee2b78174a12784c4d9b4e28c8928e"
  end

  resource "grpclib" do
    url "https://files.pythonhosted.org/packages/5b/28/5a2c299ec82a876a252c5919aa895a6f1d1d35c96417c5ce4a4660dc3a80/grpclib-0.4.9.tar.gz"
    sha256 "cc589c330fa81004c6400a52a566407574498cb5b055fa927013361e21466c46"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "h2" do
    url "https://files.pythonhosted.org/packages/e7/85/7c366e69d84c17bb778fe41419e1fbcce3033d5b7ce29bbffff0a98b859f/h2-4.4.1.tar.gz"
    sha256 "4e866ffb1a869ae14dd9b5e6beb5c24a13da0495ad72b65925ded182521c1516"
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
    url "https://files.pythonhosted.org/packages/7a/f1/e47b937226ae3b093bbd0132eb0b7ee5bfad12c2b5324afd10ae49946b05/hatchling-1.33.0.tar.gz"
    sha256 "4c422bd4d554fcff5de5b73e9596f85e41e9f97f7e553d8f7595ecb31a627bef"
  end

  resource "hpack" do
    url "https://files.pythonhosted.org/packages/26/5b/fcabf6028144a8723726318b07a32c2f3314acdff6265743cf08a344b18e/hpack-4.2.0.tar.gz"
    sha256 "0895cfa3b5531fc65fe439c05eb65144f123bf7a394fcaa56aa423548d8e45c0"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/06/94/82699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cb/httpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httpcore2" do
    url "https://files.pythonhosted.org/packages/c0/61/afa9d6b7452f9eca73f73d45324eb0bb52f098fd5e6049bf6b8263be9b4e/httpcore2-2.16.0.tar.gz"
    sha256 "c72cd0413563b17e1cd8354677dff887466f8ec2551679759e93126534428643"
  end

  resource "httplib2" do
    url "https://files.pythonhosted.org/packages/93/da/affa4b2adc11468c7d88d9b4258cac432479046edcf212284b55d4528593/httplib2-0.32.1.tar.gz"
    sha256 "37900eb8a74576bd99fc39ae1dc8409f95f965d45b56cbcb2194bb55f58a90e1"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "httpx2" do
    url "https://files.pythonhosted.org/packages/43/73/5ca2cedf5e4e50423d1c258877865a6b62793633b561c58499f8aeb33b7e/httpx2-2.16.0.tar.gz"
    sha256 "0d54c98128e8f2ff7fbbde0fca8c359e5f032edeaaaac443cdb7f31f685bcd7f"
  end

  resource "hyperframe" do
    url "https://files.pythonhosted.org/packages/02/e7/94f8232d4a74cc99514c13a9f995811485a6903d48e5d952771ef6322e30/hyperframe-6.1.0.tar.gz"
    sha256 "f630908a00854a7adeabd6382b43923a4c4cd4b821fcb527e6ab9e15382a3b08"
  end

  resource "id" do
    url "https://files.pythonhosted.org/packages/6d/04/c2156091427636080787aac190019dc64096e56a23b7364d3c1764ee3a06/id-1.6.1.tar.gz"
    sha256 "d0732d624fb46fd4e7bc4e5152f00214450953b9e772c182c1c22964def1a069"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "isodate" do
    url "https://files.pythonhosted.org/packages/54/4d/e940025e2ce31a8ce1202635910747e5a87cc3a6a6bb2d00973375014749/isodate-0.7.2.tar.gz"
    sha256 "4cd1aa0f43ca76f4a6c6c0292a85f40b35ec2e43e315b59f06e6d32171a953e6"
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

  resource "jeepney" do
    url "https://files.pythonhosted.org/packages/7b/6f/357efd7602486741aa73ffc0617fb310a29b588ed0fd69c2399acbb85b0c/jeepney-0.9.0.tar.gz"
    sha256 "cf0e9e845622b81e4a28df94c40345400256ec608d0e55bb8a3feaa9163f5732"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/d3/59/322338183ecda247fb5d1763a6cbe46eff7222eaeebafd9fa65d4bf5cb11/jmespath-1.1.0.tar.gz"
    sha256 "472c87d80f36026ae83c6ddd0f1d05d4e510134ed462851fd5f754c8c3cbb88d"
  end

  resource "jwcrypto" do
    url "https://files.pythonhosted.org/packages/13/8f/e802d77957903483129813ce6fa01a72a906f9cdd454039d1ec1e6d1e44a/jwcrypto-1.6.1.tar.gz"
    sha256 "a1e1570da5c2e35dbcd375ec1d2891a24de8eb35ee2c1fe8e91978efb72cfe90"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/43/4b/674af6ef2f97d56f0ab5153bf0bfa28ccb6c3ed4d1babf4305449668807b/keyring-25.7.0.tar.gz"
    sha256 "fe01bd85eb3f8fb3dd0405defdeac9a5b4f6f0439edbb3149577f244a2e8245b"
  end

  resource "kubernetes" do
    url "https://files.pythonhosted.org/packages/b9/c3/efd33fa9ae254ecdc35ebc128f99e8034d5a5a8c625f92e5d2173f929b53/kubernetes-37.0.1.tar.gz"
    sha256 "e41db0a95615c2388680a2d556df33fd0f27a5717c9b5df5857e475c196c2f10"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/38/9b/e422a865e1d5d57d0e509b4e0bf1c1a70a7f6382c29a5aa428df994c8bc8/markupsafe-3.0.4.tar.gz"
    sha256 "2e9ad7dd851bf45fab9f75cbff4cb493fee9979e8d8c7c9c3ee119022518edd6"
  end

  resource "marshmallow" do
    url "https://files.pythonhosted.org/packages/0d/3e/2b75ae631789fc13191ab82bc08957af381c00fffc5fefc6248b719bc9d2/marshmallow-4.4.0.tar.gz"
    sha256 "9e6ffa8511012ca89732324c1c253efd7b4d35632dcbdf80aa793fe01804af3e"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "microsoft-kiota-abstractions" do
    url "https://files.pythonhosted.org/packages/96/4b/552c5b6bf61d2dc6453e97ad207af694e8fd40258c1f2687329e921ed647/microsoft_kiota_abstractions-1.17.0.tar.gz"
    sha256 "80abade9214a094f2e0f6aa2d9f1f378286904df782dd62026695d73cc8cd135"
  end

  resource "microsoft-kiota-authentication-azure" do
    url "https://files.pythonhosted.org/packages/04/4d/ebf38d4e7f5284ada2819ebbd975f9b0525a5fbdeac69331e8716d05c40a/microsoft_kiota_authentication_azure-1.17.0.tar.gz"
    sha256 "9051ea9336f9fdb6d9f01590c100e69424587330038cecefa090240991941e8f"
  end

  resource "microsoft-kiota-http" do
    url "https://files.pythonhosted.org/packages/bb/ba/dbc238cfca3a980751a1c9acabeffb76aa3c578668faf787aa0c098bf450/microsoft_kiota_http-1.17.0.tar.gz"
    sha256 "d7f3563a718bef72c9333b5944f6cb0b67cede86425ada0b7e3f837b8f37e373"
  end

  resource "microsoft-kiota-serialization-form" do
    url "https://files.pythonhosted.org/packages/f8/d8/3f9dae5e8de1759072e2256119e4251280d7aa714b67487de503530880fd/microsoft_kiota_serialization_form-1.17.0.tar.gz"
    sha256 "b66b3c873c7aac0303d24931660c85dc6ba820a476d5093cbddbc435b5d1e0a4"
  end

  resource "microsoft-kiota-serialization-json" do
    url "https://files.pythonhosted.org/packages/a8/7e/ba5789d5bcae268265eefe8fa1415126a79a89ad0b9b4243e83bdfd74417/microsoft_kiota_serialization_json-1.17.0.tar.gz"
    sha256 "73268ed6f307cf14e568ebb25a9c5f4423501816a7daa13ad24aee226a79fded"
  end

  resource "microsoft-kiota-serialization-multipart" do
    url "https://files.pythonhosted.org/packages/5e/9b/b393909a8b2d7fe57de33cc96608717aa2cae0c671f3d1a4fe7e2a2dc39b/microsoft_kiota_serialization_multipart-1.17.0.tar.gz"
    sha256 "3522ec228ecda9b05245a7d54214b23d36655c724721bcf16a1657a61adafbc1"
  end

  resource "microsoft-kiota-serialization-text" do
    url "https://files.pythonhosted.org/packages/6a/04/7d31e6423a0a5dc6508f34d62af368b3b0a7e662a128f282b04759e4e6d6/microsoft_kiota_serialization_text-1.17.0.tar.gz"
    sha256 "a9d37fb0c89901f5ea38da8ecc38c20ec6a0b554e4e6fd792e59e459f18e2a0d"
  end

  resource "modal" do
    url "https://files.pythonhosted.org/packages/37/d5/17154c55985e3f7971bc8babc5afcbad2cb2e70f656f49090ef414f4f98d/modal-1.6.3.tar.gz"
    sha256 "f6c1c59172274357e260a6f3d24254dddb472a6d4202cabce87452c127a1779c"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/52/b8/c63995bebbb9ac9c059350e0fb8c82c2420c85aeca7d34e40aecf3df9281/more_itertools-11.2.1.tar.gz"
    sha256 "cbf08fd0af284dc69718b9b76a8e6203df624d70209ea511e4219d350c856f63"
  end

  resource "msal" do
    url "https://files.pythonhosted.org/packages/bb/85/747d28986a44b715cc51cf57aa021c8fd94e9614064261ceec77320e8b0b/msal-1.39.0.tar.gz"
    sha256 "6ab7de335e6d7f5717e2c7e1dbf86e4dda2f6acf3c56773b78dc53ebc6395b5f"
  end

  resource "msal-extensions" do
    url "https://files.pythonhosted.org/packages/01/99/5d239b6156eddf761a636bded1118414d161bd6b7b37a9335549ed159396/msal_extensions-1.3.1.tar.gz"
    sha256 "c5b0fd10f65ef62b5f1d62f4251d51cbcaf003fcedae8c91b040a488614be1a4"
  end

  resource "msgraph-core" do
    url "https://files.pythonhosted.org/packages/b6/bc/7519821548ddcc2b887dbd15f45a7859ca3d14d80e63ebb9c9feda4fafef/msgraph_core-1.5.2.tar.gz"
    sha256 "8ce6a4ffa76d0b4801c2b20df872dd85d4d925b8eceb9809e08d21daba3762cf"
  end

  resource "msgraph-sdk" do
    url "https://files.pythonhosted.org/packages/ed/fc/d2370f160e2453d2fc4e329a7a41f711407b0d098968a1417ce16095ff1a/msgraph_sdk-1.65.0.tar.gz"
    sha256 "4725563a199234ff360089ed632e71dfb0d718107ed08ac1e16e29d2214503f3"
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
    url "https://files.pythonhosted.org/packages/d6/99/1d4d69c3512d0ddbfa3a1b69cfd9a151012ab2eb4eabbb096201b1f0b7d8/multidict-6.9.1.tar.gz"
    sha256 "0f06e60fa190aa7abd0914c2a766736fdc8e9f34878c4346338534b73d1b20e2"
  end

  resource "neo4j" do
    url "https://files.pythonhosted.org/packages/d1/d1/bc40a291c60b06738ce92d5f0259d348eee1f07ba10d569a881c848c8afe/neo4j-6.4.1.tar.gz"
    sha256 "fac99b7cb9679b93ef97dc23f22a3f0e7c3feb2db223eddfd2521f27005cfeaf"
  end

  resource "nh3" do
    url "https://files.pythonhosted.org/packages/18/2f/022b27146d52d24b1b353b003359134788ecbcd6fcdf6283adbd57c0fbc8/nh3-0.3.7.tar.gz"
    sha256 "71860d01c16f4d8c72e334e0674beb2b0899dbd0bf760de18932ef4390303848"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/33/17/2bb072de0b990303c985f26869fd47bb179024a051f47e7f9d208eb92f8e/oauthlib-4.0.1.tar.gz"
    sha256 "3d73febdb6faa00f277c81fb04be7b7586fb96fc3b7f0b9c772dada69a25ede7"
  end

  resource "oci" do
    url "https://files.pythonhosted.org/packages/3a/98/b1033d07a33c19c092bb734a40df3e72d5839b7a162bd360833c8d61eafc/oci-2.190.0.tar.gz"
    sha256 "91570849c5f1920abd24e893435ccd78bef861951b846cbabde78c3a7be175c9"
  end

  resource "okta" do
    url "https://files.pythonhosted.org/packages/19/3e/918d7029f618993b0cf33e35f5a5247a05123b907a95e25d49e66582d3ce/okta-3.4.7.tar.gz"
    sha256 "bb08d11a86b7b5133896128ab9b54bafb16961d18ffbe85689f2ff994023f953"
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

  resource "packageurl-python" do
    url "https://files.pythonhosted.org/packages/f5/d6/3b5a4e3cfaef7a53869a26ceb034d1ff5e5c27c814ce77260a96d50ab7bb/packageurl_python-0.17.6.tar.gz"
    sha256 "1252ce3a102372ca6f86eb968e16f9014c4ba511c5c37d95a7f023e2ca6e5c25"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "pagerduty" do
    url "https://files.pythonhosted.org/packages/03/76/3c50a37bc1660e8237cf693a55cdbd321e7ca7b05b28b7e3220f2b06a21c/pagerduty-7.2.0.tar.gz"
    sha256 "f044baa362bce964af3b716562801b4cc94addc5047b54773d5605bc58dd0603"
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

  resource "pkginfo" do
    url "https://files.pythonhosted.org/packages/30/37/7580f0accc77d450a53ff7856fe142a89fc11467c2f22105dd06e088a5d1/pkginfo-2.0.tar.gz"
    sha256 "f7b4f267881785582c923631a0fa7e275b0d390a5cbab54aa4ec0ecc7eddb375"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/bf/db/7fc19e6f2dc92a966727031389fc2e08b558f0f25eb7403c1119ad4713cd/pluggy-1.7.0.tar.gz"
    sha256 "d1eaa46ebb595891b860ab086b4d09c8588af65ebd4361b8e8f4bb8920b90ba8"
  end

  resource "poetry-core" do
    url "https://files.pythonhosted.org/packages/42/b5/50f1fda26c4fe5b1d6ce5cdf0391bdfa1ca12fdcb8ad68344d5cf678fc90/poetry_core-2.5.0.tar.gz"
    sha256 "81d04c9253b19d0604718268d781867c8f7b2128e5b25bbf1e84141eec6b89c4"
  end

  resource "policyuniverse" do
    url "https://files.pythonhosted.org/packages/03/a2/6cf14186b746fbcab73e507968e0b1927ad2e91dcb67af967f65d6cbe6c1/policyuniverse-1.5.1.20231109.tar.gz"
    sha256 "74e56d410560915c2c5132e361b0130e4bffe312a2f45230eac50d7c094bc40a"
  end

  resource "propcache" do
    url "https://files.pythonhosted.org/packages/b3/9a/9fbf4e4ec0c2d7f1c32519fff782ef467859b8faa9fbc5331a96f6395d43/propcache-0.5.4.tar.gz"
    sha256 "ff6b113f50bc066a698db5d944d2c6dc7507168dd3341e255a8892fd0715a558"
  end

  resource "proto-plus" do
    url "https://files.pythonhosted.org/packages/46/70/783e33ffbb4466cc154a94f79b869b92a451e2bd45605054e68ff68b7af6/proto_plus-1.29.0.tar.gz"
    sha256 "cfb4e62ad7e13dd18f346cabbda00cab39930d36a05791fd81ddb074d6ee884f"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/d9/89/5b8517baa72f84a67b8a307ba953c91057af618bf40bf676f3c03551f8f0/protobuf-7.36.2.tar.gz"
    sha256 "497d0463ff3316681da6c0b9e8d06cb465d61abce00b613ab42226175644d1bb"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/88/7e/3c0da41061a2021cac7cd524fd57092adbe5b515e8bf9005702e366802e2/pyasn1-0.6.5.tar.gz"
    sha256 "6b11616a6bcf3a40e635f082bb232fa57b5e0dd7f517bd7ddd69ec3794508a47"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/e9/e6/78ebbb10a8c8e4b61a59249394a4a594c1a7af95593dc933a349c8d00964/pyasn1_modules-0.4.2.tar.gz"
    sha256 "677091de870a80aae844b1ca6134f54652fa2c8c5a52aa396440ac3106e941e6"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/f3/c2/f5855412372e47d635599a97c00cfcf9fc40accac9436a11bf9ded19f859/pycryptodomex-3.24.2.tar.gz"
    sha256 "e4dbc29e2575365d15e272f769329106277649aea081e2119cf43d66950f8f8f"
  end

  resource "pydash" do
    url "https://files.pythonhosted.org/packages/ae/49/45cd795ce88bde203c7b4cfd7c911c9078b32582afa3b9af579824d8789d/pydash-8.1.0.tar.gz"
    sha256 "30914c3e9d377ea2cd0d3c0a4f252889b08392f730a5eb4d117e5b598cdf1d52"
  end

  resource "pydo" do
    url "https://files.pythonhosted.org/packages/5a/df/56761fc0e7969a2bc19abba077e2bbffefeb99bf27757c6dcf445520f8c3/pydo-0.45.0.tar.gz"
    sha256 "7e1d87a0bbcb6f0de0077b1181980fc22a2a5daf258a27ae0aee82f57693ce89"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/43/ea/5194e52748b0da83d71e082d75496eaec6e58f419f5e184786ded517e6a9/pyjwt-2.15.1.tar.gz"
    sha256 "4f259e80cdfb6b3fc18a7de51fd1ef9ec79652f25019bae68975ca2468a34df8"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/3f/e8/7325d258199b159eb2c03fe32107533e2832e70e63f4fb88a6aa00023201/pyopenssl-26.4.0.tar.gz"
    sha256 "28dfcce0162b9211413e26dfbfdf1d24317fbeba18fc93c12400a1856b2a0bc7"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/e4/11/b213bebff182584360cb8d17c72c1677fec5c5c228de439e63bcf8ab1c8f/pyparsing-3.3.3.tar.gz"
    sha256 "928ae7e20211f3b6f3915a72f06a0cfd29ab9d24279dd6346b6b1a7146397d36"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-pkcs11" do
    url "https://files.pythonhosted.org/packages/89/33/4287ebdcbdcae6f93521be56ffdd5f474b6aebda1a50df4c4b9870a140fa/python_pkcs11-0.9.4.tar.gz"
    sha256 "3d950aadefa473b880dc75f01539133487e65ec2a97db1e955c4f6bef1bd71d5"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/f5/b0/168030b0bfcc334cf09fa3313afdb888d892c8a0027324683d1de0ec277e/pytz-2026.6.tar.gz"
    sha256 "3b0fc2727707663d6e517936f444fd8a8b240f1fc32f4bf7ee03274245945284"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "readme-renderer" do
    url "https://files.pythonhosted.org/packages/25/d7/9309494fad74ee831d4546f69325b5519f37c6dfb2d9ba495db8c6d4f4ca/readme_renderer-46.0.tar.gz"
    sha256 "af3e964914f6310a33ff67b72a4bdd940bed8d7c3bdecd2d14f40edf284bfe90"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/42/f2/05f29bc3913aea15eb670be136045bf5c5bbf4b99ecb839da9b422bb2c85/requests-oauthlib-2.0.0.tar.gz"
    sha256 "b3dffaebd884d8cd778494369603a9e7b58d29111bf6b41bdc2dcd87203af4e9"
  end

  resource "requests-toolbelt" do
    url "https://files.pythonhosted.org/packages/f3/61/d7545dafb7ac2230c70d38d31cbfe4cc64f7144dc41f6e4e4b78ecd9f5bb/requests-toolbelt-1.0.0.tar.gz"
    sha256 "7681a0a3d047012b5bdc0ee37d7f8f07ebe76ab08caeccfc3921ce23c88d5bc6"
  end

  resource "rfc3986" do
    url "https://files.pythonhosted.org/packages/85/40/1520d68bfa07ab5a6f065a186815fb6610c86fe957bc065754e47f7b0840/rfc3986-2.0.0.tar.gz"
    sha256 "97aacf9dbd4bfd829baad6e6309fa6573aaf1be3f6fa735c8ab05e46cecb261c"
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
    url "https://files.pythonhosted.org/packages/5f/67/9cc8aa4465408206ed5153c27e110e4249c6563fd8a834c19fd772e1e2b4/scaleway-2.12.0.tar.gz"
    sha256 "25d4fcd8ef00ec6ea1fd581ca84c4d5d5cc2558d0b493c476c5651e130d76ffa"
  end

  resource "scaleway-core" do
    url "https://files.pythonhosted.org/packages/69/3a/5368271c808d117f6097c72fccfc8724e82142cfdcca3663bdafe9cab01c/scaleway_core-2.12.0.tar.gz"
    sha256 "654c35630b9213152b5c9b522a74f86e7c01b8c97f154dc8c372f7d1579fde4d"
  end

  resource "secretstorage" do
    url "https://files.pythonhosted.org/packages/1c/03/e834bcd866f2f8a49a85eaff47340affa3bfa391ee9912a952a1faa68c7b/secretstorage-3.5.0.tar.gz"
    sha256 "f04b8e4689cbce351744d5537bf6b1329c6fc68f91fa666f60a380edddcd11be"
  end

  resource "semantic-version" do
    url "https://files.pythonhosted.org/packages/7d/31/f2289ce78b9b473d582568c234e104d2a342fd658cc288a7553d83bb8595/semantic_version-2.10.0.tar.gz"
    sha256 "bdabb6d336998cbb378d4b9db3a4b56a1e3235701dc05ea2690d9a997ed5041c"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/70/b3/c19426f783614d625699a4b247faf628ea9ab1db228674491767b417f9e1/setuptools-84.2.1.tar.gz"
    sha256 "3ff8b3b5492a0aa66960f4419365a86b84e013070d4313e4d4a6894f5d64d6bc"
  end

  resource "setuptools-rust" do
    url "https://files.pythonhosted.org/packages/68/ba/b31781d61bf9ee3c232a1d1160db11c11cdeae1d44e06c90723b25a8279f/setuptools_rust-1.13.0.tar.gz"
    sha256 "f2afcf4baeee689910ce49cfa8aad4e08cce72f417449bcc32891b8664fdc726"
  end

  resource "setuptools-scm" do
    url "https://files.pythonhosted.org/packages/85/d8/fc143f88819ccf10ba2388ba86732ee2de193e578234e25a783f6cc14bf7/setuptools_scm-10.3.4.tar.gz"
    sha256 "a69f28bfc245608781205e912faae437c2b2165773afa4e7b979d77447a69dd2"
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
    url "https://files.pythonhosted.org/packages/7a/43/9eb4f5172ec64d8c25f9fa397d3ca283782d356a60809e4b68ade81fde1a/slack_sdk-3.46.0.tar.gz"
    sha256 "25215ca293d2954ed759b87573b4c833cb3f82ebff371355936515c688411dbb"
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
    url "https://files.pythonhosted.org/packages/e6/13/856481251de9bf56c2190d10a2533a0407bc748e3bdbfd0f0c7982950e8c/std_uritemplate-2.0.13.tar.gz"
    sha256 "acdb8df280986572572a438877a90a243136042a7379152d3b2e05bd6507f989"
  end

  resource "synchronicity" do
    url "https://files.pythonhosted.org/packages/f2/0d/68d6a97dead45e2704cd431df2ed5f92c9bdea620239d6129b16becc7508/synchronicity-0.12.7.tar.gz"
    sha256 "6d86ba0fb797cc3cb7637f97cf9472a3ed20e50e85130b44c3292b43e2389b90"
  end

  resource "tenacity" do
    url "https://files.pythonhosted.org/packages/47/c6/ee486fd809e357697ee8a44d3d69222b344920433d3b6666ccd9b374630c/tenacity-9.1.4.tar.gz"
    sha256 "adb31d4c263f2bd041081ab33b498309a57c77f9acf2db65aadf0898179cf93a"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/08/72/fc01563df95c189a9f65850096bdc205bc2fe37da6c740cd64afaf18d07e/tomlkit-0.15.2.tar.gz"
    sha256 "83e32755ba1d20d9340bd069ee97e9f6232ba2346b63ffcba425de01f7e327a6"
  end

  resource "trove-classifiers" do
    url "https://files.pythonhosted.org/packages/bf/93/af436dfaa845cab5d96f0adbc1e4f3730532d37fa249e4eb796fb1d7fc82/trove_classifiers-2026.9.21.13.tar.gz"
    sha256 "0a9ebc8d4e2f3e8a22848c5258033035bec17a3012ac3fea16dbaa764489eb71"
  end

  resource "truststore" do
    url "https://files.pythonhosted.org/packages/ee/9f/c5201d42a484c061e528825fc8e2d565f5abd50a4ced6fb7d29c4ec99b2b/truststore-0.10.5.tar.gz"
    sha256 "30d36967ccaded5cbb38d602c433f53600036c79d502f4533a49b60a03bbefcd"
  end

  resource "twine" do
    url "https://files.pythonhosted.org/packages/92/3c/58f808a359700f39a967dffede33efeac809262c03303fa3eec6afff8f49/twine-7.0.0.tar.gz"
    sha256 "85cdb29c518efef867360ae4acd4b0dfd61c8654a22fca08e6f8539f05022177"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/ed/db/401793a0d5345409a28de2c571d4ef8bea9a08700c20ea7f7b6af3b050d2/typer-0.29.0.tar.gz"
    sha256 "6871960a1603fba66af2ff751be48a6735af6480a67660afaf2fab2f7e008ed4"
  end

  resource "types-aiobotocore-ecr" do
    url "https://files.pythonhosted.org/packages/5e/03/1b171c73f4abab823445e788e501e395044e7e3c8eab0b018a7a258d5f4d/types_aiobotocore_ecr-3.10.0.tar.gz"
    sha256 "df2e58919d91dcc25110596640891623a7c90a0774e50175deb226ec54215d2a"
  end

  resource "types-certifi" do
    url "https://files.pythonhosted.org/packages/52/68/943c3aeaf14624712a0357c4a67814dba5cea36d194f5c764dad7959a00c/types-certifi-2021.10.8.3.tar.gz"
    sha256 "72cf7798d165bc0b76e1c10dd1ea3097c7063c42c21d664523b928e88b554a4f"
  end

  resource "types-toml" do
    url "https://files.pythonhosted.org/packages/4b/11/6ece999e91f2ccb848ab4420f3f4816e78ac0541f739e6864affdaaa5737/types_toml-0.10.8.20260518.tar.gz"
    sha256 "80e10facd24fdeda9d5c672187d72be3ac284843788d67f5aae59e3e016db6fe"
  end

  resource "uritemplate" do
    url "https://files.pythonhosted.org/packages/98/60/f174043244c5306c9988380d2cb10009f91563fc4b31293d27e17201af56/uritemplate-4.2.0.tar.gz"
    sha256 "480c2ed180878955863323eea31b0ede668795de182617fef9c6ca09e6ec9d0e"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  resource "uv-dynamic-versioning" do
    url "https://files.pythonhosted.org/packages/6f/c8/fa500ee29af69cfeeea5ff6d6597919f1989b2e3f1a236c3006bdb21d320/uv_dynamic_versioning-0.14.1.tar.gz"
    sha256 "8642db686ce5c50417035e7a257ac73b7e5c3a7a32c33e45bd7e36ba22eeb648"
  end

  resource "vcs-versioning" do
    url "https://files.pythonhosted.org/packages/ad/e7/2a691db7d076b75d099fdba1a14cd966931f2aeb591e77f6d22f15097326/vcs_versioning-2.6.0.tar.gz"
    sha256 "22e9159288e2d8bca2fa6f6c31c34c9c66aec157f60e9e526f5d160d2516d60f"
  end

  resource "watchfiles" do
    url "https://files.pythonhosted.org/packages/b3/68/e6aa0b77d217b31f8f486ec0cdfe5e00e6e38dc0be657e7d85819b9faf0a/watchfiles-1.3.0.tar.gz"
    sha256 "99aee4a07847c06820765fd7b1b49ceac4f3f711ccb7d104655a33231de1c207"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/d8/cb/a5abcc2891249f393827c650c6296660ce40374ac22d99ab9aea41f9d2a2/websocket_client-1.9.2.tar.gz"
    sha256 "0fcb57545848be86992e128218fd96dd87a6769ffdb1a968dff79632b85604d0"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/75/79/590c5f0cc7d1661195aeefccb0e342b79f4c77d368d526d028821a390332/websockets-17.4.tar.gz"
    sha256 "09d3939b70df0c8ad2da145ebd50978bccaee1d565e838b0e7921a34d38571eb"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/d0/20/50ed6bdf27dec98b568a8ae25dc599f35baa3d9709f9e83fd1edb56b9a90/wheel-0.48.0.tar.gz"
    sha256 "94800765601e9171bf5d58d066e640662842bcedcbab982b2c90787a2c987322"
  end

  resource "workos" do
    url "https://files.pythonhosted.org/packages/b9/78/f7025e6ae9fc49fe614dcf8f53cebb93470df962925cbb7ab6cffab74c3b/workos-10.8.0.tar.gz"
    sha256 "146cd00a31c9e511c9f229763ac58815cdf44227664dd89a20ec2c9d5ebc7a3b"
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
    url "https://files.pythonhosted.org/packages/75/16/e8be8e2fb175bbf41a0680381a319f1199fae256588241a2ac8677eafb49/yarl-1.25.1.tar.gz"
    sha256 "03dd38de09bc213e9a8b29761eec33ee1d5318dac0e49d8af36e4d27830e23a7"
  end

  resource "uv-build" do
    url "https://github.com/astral-sh/uv/archive/refs/tags/0.11.33.tar.gz"
    sha256 "81911281e0f2fe5307c0b85e884f47cb6ca867932fb61871d339854edf3b4dcc"
  end

  resource "build-setuptools-83.0.0" do
    self.name = "setuptools"
    url "https://files.pythonhosted.org/packages/34/26/f5d29e25ffdb535afef2d35cdb55b325298f96debd670da4c325e08d70f4/setuptools-83.0.0.tar.gz"
    sha256 "025bccbbf0fa05b6192bc64ae1e7b16e001fd6d6d4d5de03c97b1c1ade523bef"
  end

  resource "build-setuptools-84.0.0" do
    self.name = "setuptools"
    url "https://files.pythonhosted.org/packages/6d/44/f5da03a8ef95d369145c5bb53050e7877c9f3d312e128605fd9504829143/setuptools-84.0.0.tar.gz"
    sha256 "f4695c21257f0d9b537ec2692c941d02ee143b7cc1276941349a546573b2ef73"
  end

  resource "build-setuptools-scm-7.1.0" do
    self.name = "setuptools-scm"
    url "https://files.pythonhosted.org/packages/98/12/2c1e579bb968759fc512391473340d0661b1a8c96a59fb7c65b02eec1321/setuptools_scm-7.1.0.tar.gz"
    sha256 "6c508345a771aad7d56ebff0e70628bf2b0ec7573762be9960214730de278f27"
  end

  resource "build-flit-core-4.2.0" do
    self.name = "flit-core"
    url "https://files.pythonhosted.org/packages/d3/8b/0370578a456986d6995344967a479dd5c9d4e064681550c2a9594bb58b4a/flit_core-4.2.0.tar.gz"
    sha256 "84e4e4d8fdd45ba2613800a3ebc6834de26d47ec9746efc3719f94181137b460"
  end

  resource "build-hatchling-1.26.3" do
    self.name = "hatchling"
    url "https://files.pythonhosted.org/packages/e1/47/7ec270a9567262ae3cb32dd420d2b53bf7aee769aca1f240eae0426b5bbc/hatchling-1.26.3.tar.gz"
    sha256 "b672a9c36a601a06c4e88a1abb1330639ee8e721e0535a37536e546a667efc7a"
  end

  deny_network_access!

  def fetch
    %w[uv-build watchfiles nh3].each do |name|
      resource(name).stage { system "cargo", "fetch", "--locked" }
    end
    resource("cbor2").stage do
      cd "rust" do
        system "cargo", "fetch", "--locked"
      end
    end
  end

  def install
    ENV.append_path "PYTHONPATH", formula_opt_prefix("maturin")/Language::Python.site_packages("python3.14")
    ENV.prepend_path "PATH", libexec/"bin"
    ENV["CARGO_NET_OFFLINE"] = "true"
    ENV["GRPC_PYTHON_BUILD_EXT_COMPILER_JOBS"] = ENV.make_jobs.to_s
    ENV["SETUPTOOLS_SCM_PRETEND_VERSION_FOR_CARTOGRAPHY"] = version.to_s
    # Cython is a source-build SDK, not part of the application's runtime.
    ENV["NO_CYTHON_COMPILE"] = "true"
    ENV["CHARSET_NORMALIZER_USE_CYTHON"] = "1"
    ENV["WRAPT_INSTALL_EXTENSIONS"] = "true"
    ENV["PYYAML_FORCE_LIBYAML"] = "1"
    ENV["CRC32C_PURE_PYTHON"] = "0"
    ENV["CRC32C_INSTALL_PREFIX"] = formula_opt_prefix("crc32c")
    ENV.append "CPPFLAGS", "-I#{formula_opt_include("libyaml")}"
    ENV.append "LDFLAGS", "-L#{formula_opt_lib("libyaml")}"

    venv = virtualenv_create(libexec, "python3.14")
    ENV["PYO3_PYTHON"] = libexec/"bin/python"
    ENV["MATURIN_PYTHON"] = libexec/"bin/python"
    installed = []
    install_resources = lambda do |names|
      names.each do |name|
        r = resource(name)
        venv.pip_install r, build_isolation: false
        installed << r
      end
    end
    replace_sdk = lambda do |name, key|
      system formula_opt_bin("python@3.14")/"python3.14", "-m", "pip",
             "--python", libexec/"bin/python", "uninstall", "-y", name
      install_resources.call [key]
    end

    install_resources.call %w[flit-core packaging wheel build-setuptools-83.0.0]
    install_resources.call %w[
      poetry-core tomlkit vcs-versioning setuptools-scm calver trove-classifiers pathspec pluggy
      hatchling hatch-fancy-pypi-readme hatch-vcs expandvars cython semantic-version setuptools-rust
      pdm-backend pkgconfig markupsafe jinja2 dunamai uv-dynamic-versioning
    ]

    # Flit 4 is required by these sources, while other sources still explicitly require Flit 3.
    replace_sdk.call "flit-core", "build-flit-core-4.2.0"
    install_resources.call %w[more-itertools marshmallow]
    replace_sdk.call "flit-core", "flit-core"

    # google-genai declares Twine and pkginfo as build requirements. Keep their full source SDK closure.
    install_resources.call %w[
      docutils id mdurl markdown-it-py pygments rich charset-normalizer idna urllib3 requests
      requests-toolbelt rfc3986 jaraco-classes jeepney secretstorage
    ]
    # Only these SDK consumers declare the licensing plugin; do not apply it to unrelated sources.
    install_resources.call %w[coherent-licensed jaraco-context jaraco-functools keyring]
    system formula_opt_bin("python@3.14")/"python3.14", "-m", "pip",
           "--python", libexec/"bin/python", "uninstall", "-y", "coherent-licensed"
    install_resources.call %w[nh3 readme-renderer twine pkginfo]
    # Use the unchanged official subproject: the PyPI sdist omits its workspace crates.
    resource("uv-build").stage do
      cd "crates/uv-build" do
        venv.pip_install Pathname.pwd, build_isolation: false
      end
    end
    installed << resource("uv-build")

    # These releases declare older SDK bounds; replace rather than shadow dist-info metadata.
    replace_sdk.call "hatchling", "build-hatchling-1.26.3"
    install_resources.call %w[cloudflare crowdstrike-falconpy]
    replace_sdk.call "hatchling", "hatchling"
    replace_sdk.call "setuptools-scm", "build-setuptools-scm-7.1.0"
    install_resources.call %w[python-dateutil]
    replace_sdk.call "setuptools-scm", "setuptools-scm"

    deferred = %w[setuptools neo4j build-setuptools-84.0.0].map { |name| resource(name) }
    venv.pip_install resources - installed - deferred, build_isolation: false
    replace_sdk.call "setuptools", "build-setuptools-84.0.0"
    install_resources.call %w[neo4j]
    replace_sdk.call "setuptools", "setuptools"
    venv.pip_install_and_link buildpath, build_isolation: false
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cartography --version 2>&1")

    # Selection is rejected before Config construction, provider discovery or Neo4j driver creation.
    assert_match "not-a-module", shell_output("#{bin}/cartography --selected-modules not-a-module 2>&1", 1)
    system libexec/"bin/python", "-I", "-c", <<~PYTHON
      import hashlib
      import cbor2
      import google_crc32c
      from Cryptodome.Hash import SHA256
      from cryptography.hazmat.primitives import hashes
      from google.protobuf.internal import api_implementation
      from google.protobuf.struct_pb2 import Struct
      from pydantic import BaseModel, ValidationError
      from wrapt._wrappers import ObjectProxy
      from cartography.sync import parse_and_validate_selected_modules

      modules = "azure, gcp, okta, workos, modal, digitalocean"
      assert parse_and_validate_selected_modules(modules) == modules.replace(" ", "").split(",")
      assert parse_and_validate_selected_modules("aws, aws, analysis") == ["aws", "analysis"]
      try:
          parse_and_validate_selected_modules("not-a-module")
      except ValueError:
          pass
      else:
          raise AssertionError("Unknown module was accepted")

      class Asset(BaseModel):
          count: int

      assert Asset(count="42").model_dump() == {"count": 42}
      try:
          Asset(count="invalid")
      except ValidationError:
          pass
      else:
          raise AssertionError("Invalid asset count was accepted")

      asset = {"provider": "owned-fixture", "count": 3}
      assert cbor2.loads(cbor2.dumps(asset)) == asset
      assert api_implementation.Type() == "upb"
      message = Struct()
      message.update(asset)
      assert Struct.FromString(message.SerializeToString()) == message
      assert google_crc32c.implementation == "c"
      assert google_crc32c.value(b"123456789") == 0xe3069283
      proxy = ObjectProxy([1, 2])
      proxy.append(3)
      assert list(proxy) == [1, 2, 3]
      payload = b"owned asset fixture"
      digest = hashes.Hash(hashes.SHA256())
      digest.update(payload)
      assert digest.finalize() == hashlib.sha256(payload).digest()
      assert SHA256.new(payload).digest() == hashlib.sha256(payload).digest()
    PYTHON
    system formula_opt_bin("python@3.14")/"python3.14", "-m", "pip",
           "--python", libexec/"bin/python", "check"
  end
end
