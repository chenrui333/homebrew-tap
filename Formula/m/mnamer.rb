class Mnamer < Formula
  include Language::Python::Virtualenv

  desc "Media file renaming and organizing tool"
  homepage "https://github.com/jkwill87/mnamer"
  url "https://files.pythonhosted.org/packages/19/d5/edca80dcade48bb598f329fabc239e99b4121be266295b496490d1266bce/mnamer-2.7.2.tar.gz"
  sha256 "46926e4cc49c3163059f2dc8302d5a2eb5b687ada5393600a439a89691c6c7c4"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "1e7ad5c2c5f1e95dca66548bff7a9e59d98bbfd25f28276f76b96192e3b3adc6"
  end

  depends_on "certifi" => :no_linkage
  depends_on "python@3.14"

  pypi_packages exclude_packages: "certifi"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "babelfish" do
    url "https://files.pythonhosted.org/packages/c5/8f/17ff889327f8a1c36a28418e686727dabc06c080ed49c95e3e2424a77aa6/babelfish-0.6.1.tar.gz"
    sha256 "decb67a4660888d48480ab6998309837174158d0f1aa63bebb1c2e11aab97aab"
  end

  resource "cattrs" do
    url "https://files.pythonhosted.org/packages/a0/ec/ba18945e7d6e55a58364d9fb2e46049c1c2998b3d805f19b703f14e81057/cattrs-26.1.0.tar.gz"
    sha256 "fa239e0f0ec0715ba34852ce813986dfed1e12117e209b816ab87401271cdd40"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e7/a1/67fe25fac3c7642725500a3f6cfe5821ad557c3abb11c9d20d12c7008d3e/charset_normalizer-3.4.7.tar.gz"
    sha256 "ae89db9e5f98a11a4bf50407d4363e7b09b31e55bc117b4f7d80aab97ba009e5"
  end

  resource "guessit" do
    url "https://files.pythonhosted.org/packages/d0/07/5a88020bfe2591af2ffc75841200b2c17ff52510779510346af5477e64cd/guessit-3.8.0.tar.gz"
    sha256 "6619fcbbf9a0510ec8c2c33744c4251cad0507b1d573d05c875de17edc5edbed"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/1a/88/bcf9709822fe69d02c2a6a77956c98ce6ea8ca8767a9aadcedc7eb6a2390/idna-3.16.tar.gz"
    sha256 "d7a6da03db833450fca25d2358ac9ff06cd624577a4aea3a596d5c0f77b8e03d"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
    sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/9f/4a/0883b8e3802965322523f0b200ecf33d31f10991d0401162f4b23c698b42/platformdirs-4.9.6.tar.gz"
    sha256 "3bfa75b0ad0db84096ae777218481852c0ebc6c727b3168c1b9e0118e458cf0a"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "rebulk" do
    url "https://files.pythonhosted.org/packages/f2/06/24c69f8d707c9eefc1108a64e079da56b5f351e3f59ed76e8f04b9f3e296/rebulk-3.2.0.tar.gz"
    sha256 "0d30bf80fca00fa9c697185ac475daac9bde5f646ce3338c9ff5d5dc1ebdfebc"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "requests-cache" do
    url "https://files.pythonhosted.org/packages/c3/ae/90a0f931c7f6b5a674b98c25ecb2593a173bcee14f0d8c148471df3d7b26/requests_cache-1.3.2.tar.gz"
    sha256 "bdc3680931f98a1dea509d339ea6b45cea526945b47b250ce63ffd2744ee0b14"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/4f/db/cfac1baf10650ab4d1c111714410d2fbb77ac5a616db26775db562c8fab2/setuptools-82.0.1.tar.gz"
    sha256 "7d872682c5d01cfde07da7bccc7b65469d3dca203318515ada1de5eda35efbf9"
  end

  resource "setuptools-scm" do
    url "https://files.pythonhosted.org/packages/a5/b1/2a6a8ecd6f9e263754036a0b573360bdbd6873b595725e49e11139722041/setuptools_scm-10.0.5.tar.gz"
    sha256 "bbba8fe754516cdefd017f4456721775e6ef9662bd7887fb52ae26813d4838c3"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "teletype" do
    url "https://files.pythonhosted.org/packages/90/a4/eea7f11ff995492743e43319741b21e36762f44fc3cbc7c34b03f6d4322c/teletype-1.3.4.tar.gz"
    sha256 "b81a69338c3d1a532062a2851b0d51723beafa69d4d382b713be230a02bd618a"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "url-normalize" do
    url "https://files.pythonhosted.org/packages/8b/cd/846d87d6d49d963b04ef4429b73d71d3c17468059956bab360866a9b0aec/url_normalize-3.0.0.tar.gz"
    sha256 "0552cbf2831a32a28994a13d29bca58a60e10ff6c0380e343ec6d1c2a0d232d8"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  resource "vcs-versioning" do
    url "https://files.pythonhosted.org/packages/49/42/d97a7795055677961c63a1eef8e7b19d5968ed992ed3a70ab8eb012efad8/vcs_versioning-1.1.1.tar.gz"
    sha256 "fabd75a3cab7dd8ac02fe24a3a9ba936bf258667b5a62ed468c9a1da0f5775bc"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mnamer --version")

    # ===================== Guessit Exception Report =====================
    # version=3.7.1
    # string=/Users/rui/Downloads/you_have_goat_to_be_kidding_me-jow0ka3i62sc1.mp4
    # options={'type': None, 'language': None}
    # --------------------------------------------------------------------
    # Traceback (most recent call last):
    #   File ".../guessit/api.py", line 200, in guessit
    #     config = self.configure(options, sanitize_options=False)
    #   File ".../guessit/api.py", line 175, in configure
    #     self.rebulk = rules_builder(advanced_config)
    #                   ~~~~~~~~~~~~~^^^^^^^^^^^^^^^^^
    #   File ".../guessit/rules/__init__.py", line 62, in rebulk_builder
    #     rebulk.rebulk(website(_config('website')))
    #                   ~~~~~~~^^^^^^^^^^^^^^^^^^^^
    #   File ".../guessit/rules/properties/website.py", line 34, in website
    #     with files('guessit.data') as data_files:
    #          ~~~~~^^^^^^^^^^^^^^^^
    # TypeError: 'PosixPath' object does not support the context manager protocol
    # --------------------------------------------------------------------
    # Please report at https://github.com/guessit-io/guessit/issues.
    # ====================================================================

    # =============================== CRASH REPORT END ===============================

    # (testpath/"test.mp4").write "dummy content"
    # output = shell_output("#{bin}/mnamer test.mp4 2>&1", 1)
    # assert_match "No matches found", output
  end
end
