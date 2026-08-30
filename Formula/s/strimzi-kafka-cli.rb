class StrimziKafkaCli < Formula
  include Language::Python::Virtualenv

  desc "CLI for the Strimzi Kafka Operator"
  homepage "https://github.com/SystemCraftsman/strimzi-kafka-cli"
  url "https://files.pythonhosted.org/packages/84/37/4199817701f0a8d366640abe03339d293c737fba8a65fdbc67535c400792/strimzi_kafka_cli-1.0.0b13.tar.gz"
  sha256 "970df9d0952dd10b2e16c524f762b4f51d6e694df0d1e98d0fc831c16b54ae74"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bad3f004281db1124dc7221f18910425dbd6bbcd134cd498cc0db5124b965b84"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd68a395d64e0bc84fc894cfd5ed32c17d95489a6a9e494a8f2e4829867bbcab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce586d2a21483e4ca5c376ebc3fabf606ece2a9058049307bd07a056d2a0efdc"
    sha256 cellar: :any,                 arm64_linux:   "0f1e82ea19238803d4478f43eb72235d0390dcf0b1a13628b392b958418e3d9d"
    sha256 cellar: :any,                 x86_64_linux:  "a062b5f9303989f45a341786df5ec715dcf60fb2c480a079dffd69f2c9fb5a2f"
  end

  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.13"

  pypi_packages exclude_packages: %w[certifi cffi cryptography pycparser]

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cb/31/4971872b3ed8715346231fb6eb4da8fcba65a4143c189db151ee28a2812b/charset_normalizer-3.5.0.tar.gz"
    sha256 "49bd5feb59b0bf3cbf6ebcf4352e371c95b9da9bacd4449f8b64d0ad2c10a26e"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/76/d4/81420972a676e8ffea40450d8c8c92943e7218a78fe9b64359836cc9876b/click-8.4.2.tar.gz"
    sha256 "9a6cea6e60b17ebe0a44c5cc636d94f09bd66142c1cd7d8b4cd731c4917a15f6"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/db/4c/fa42116a48bab3f7a143cf5042ecff7df9c8b73f8a376203cd534d1dc966/google_auth-2.56.3.tar.gz"
    sha256 "40e229fc901f0a305b553050e5fce562d509bee0435be053abfa91582b51b90c"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cd/63/9496c57188a2ee585e0f1db071d75089a11e98aa86eb99d9d7618fc1edce/idna-3.18.tar.gz"
    sha256 "ffb385a7e039654cef1ab9ef32c6fafe283c0c0467bba1d9029738ce4a14a848"
  end

  resource "jproperties" do
    url "https://files.pythonhosted.org/packages/3a/ae/5b445c77b36b5b8ec75d2bf35dc9fd54cc93b391219ab43fdb0b523c2c41/jproperties-2.1.1.tar.gz"
    sha256 "40b71124e8d257e8954899a91cd2d5c0f72e0f67f1b72048a5ba264567604f29"
  end

  resource "kubernetes" do
    url "https://files.pythonhosted.org/packages/3c/5e/d27f39f447137a9a3d1f31142c77ce74bcedfda7dafe922d725c7ef2da33/kubernetes-28.1.0.tar.gz"
    sha256 "1468069a573430fb1cb5ad22876868f57977930f80a6749405da31cd6086a7e9"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/0b/5f/19930f824ffeb0ad4372da4812c50edbd1434f678c90c2733e1188edfc63/oauthlib-3.3.1.tar.gz"
    sha256 "0f0f8aa759826a193cf66c12ea1af1637f87b9b4622d46e866952bb022e538c9"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/a4/9a/23310166d960def5897e91fe20e5b724601b02a22e84ba1f94232c0b7f67/pyasn1-0.6.4.tar.gz"
    sha256 "9c447d8431c947fe4c8febc4ed9e760bc29011a5b01e5c74b67025bd9fb8ce81"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/e9/e6/78ebbb10a8c8e4b61a59249394a4a594c1a7af95593dc933a349c8d00964/pyasn1_modules-0.4.2.tar.gz"
    sha256 "677091de870a80aae844b1ca6134f54652fa2c8c5a52aa396440ac3106e941e6"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
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

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e4/e8/6ff5e6bc22095cfc59b6ea711b687e2b7ed4bdb373f7eeec370a97d7392f/urllib3-1.26.20.tar.gz"
    sha256 "40c2dc0c681e47eb8f90e7e27bf6ff7df2e677421fd46756da1161c39ca70d32"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/2c/41/aa4bf9664e4cda14c3b39865b12251e8e7d239f4cd0e3cc1b6c2ccde25c1/websocket_client-1.9.0.tar.gz"
    sha256 "9e813624b6eb619999a97dc7958469217c3176312b3a16a4bd1bc7e08a46ec98"
  end

  resource "wget" do
    url "https://files.pythonhosted.org/packages/47/6a/62e288da7bcda82b935ff0c6cfe542970f04e29c756b0e147251b2fb251f/wget-3.2.zip"
    sha256 "35e630eca2aa50ce998b9b1a127bb26b30dfee573702782aa982f875e3f16061"
  end

  def install
    venv = virtualenv_install_with_resources without: "jproperties"

    resource("jproperties").stage do
      # `jproperties` builds with legacy `setuptools_scm` pinning that breaks
      # with modern setuptools where `pkg_resources` is removed.
      inreplace "setup.py", "    use_scm_version=True,\n", "    version=\"2.1.1\",\n"
      inreplace "setup.py", /setup_requires=\[\n\s+"setuptools_scm ~= 3\.3"\n\s+\],\n/m, ""

      venv.pip_install Pathname.pwd
    end
  end

  test do
    output = shell_output("#{bin}/kfk --version 2>&1", 1)
    assert_match "Invalid kube-config file. No configuration found", output
  end
end
