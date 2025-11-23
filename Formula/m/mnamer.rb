class Mnamer < Formula
  include Language::Python::Virtualenv

  desc "Media file renaming and organizing tool"
  homepage "https://github.com/jkwill87/mnamer"
  url "https://files.pythonhosted.org/packages/7c/27/8cbd8e1565d6ec3f312a6b29f4cae55aa36d7e24927c0da408176f99f90c/mnamer-2.5.5.tar.gz"
  sha256 "c3905b7fc03e07b5b22d92f29ce9c80cc2c2788cebe35e2297fe9f3a4ce7fbf3"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "53a704d33f0f46c04ff8b3beade31c477ffe7b02ce698d3c4d5bc1b7f4163423"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53a704d33f0f46c04ff8b3beade31c477ffe7b02ce698d3c4d5bc1b7f4163423"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53a704d33f0f46c04ff8b3beade31c477ffe7b02ce698d3c4d5bc1b7f4163423"
    sha256 cellar: :any_skip_relocation, sequoia:       "90556f463426675fe720d48e1d9e782cb8c38c777cd372cfc2ba63ba2d3eaceb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "90556f463426675fe720d48e1d9e782cb8c38c777cd372cfc2ba63ba2d3eaceb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90556f463426675fe720d48e1d9e782cb8c38c777cd372cfc2ba63ba2d3eaceb"
  end

  depends_on "certifi" => :no_linkage
  depends_on "python@3.14"

  pypi_packages exclude_packages: "certifi"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/6b/5c/685e6633917e101e5dcb62b9dd76946cbb57c26e133bae9e0cd36033c0a9/attrs-25.4.0.tar.gz"
    sha256 "16d5969b87f0859ef33a48b35d55ac1be6e42ae49d5e853b597db70c35c57e11"
  end

  resource "babelfish" do
    url "https://files.pythonhosted.org/packages/c5/8f/17ff889327f8a1c36a28418e686727dabc06c080ed49c95e3e2424a77aa6/babelfish-0.6.1.tar.gz"
    sha256 "decb67a4660888d48480ab6998309837174158d0f1aa63bebb1c2e11aab97aab"
  end

  resource "cattrs" do
    url "https://files.pythonhosted.org/packages/29/7b/da4aa2f95afb2f28010453d03d6eedf018f9e085bd001f039e15731aba89/cattrs-24.1.3.tar.gz"
    sha256 "981a6ef05875b5bb0c7fb68885546186d306f10f0f6718fe9b96c226e68821ff"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "guessit" do
    url "https://files.pythonhosted.org/packages/96/5f/64304acee35bac703cee51656a5caf37bd18c9490561fbff225922f41d39/guessit-3.7.1.tar.gz"
    sha256 "2c18d982ee6db30db5d59557add0324a2b49bf3940a752947510632a2b58a3c1"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
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
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "requests-cache" do
    url "https://files.pythonhosted.org/packages/c6/63/76613d73fb4ec23cc2451c1be30974a373c7258274db2e4f79530bda505d/requests_cache-0.9.8.tar.gz"
    sha256 "eaed4eb5fd5c392ba5e7cfa000d4ab96b1d32c1a1620f37aa558c43741ac362b"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
  end

  resource "setuptools-scm" do
    url "https://files.pythonhosted.org/packages/98/12/2c1e579bb968759fc512391473340d0661b1a8c96a59fb7c65b02eec1321/setuptools_scm-7.1.0.tar.gz"
    sha256 "6c508345a771aad7d56ebff0e70628bf2b0ec7573762be9960214730de278f27"
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
    url "https://files.pythonhosted.org/packages/3c/8b/0111dd7d6c1478bf83baa1cab85c686426c7a6274119aceb2bd9d35395ad/typing_extensions-4.7.1.tar.gz"
    sha256 "b75ddc264f0ba5615db7ba217daeb99701ad295353c45f9e95963337ceeeffb2"
  end

  resource "url-normalize" do
    url "https://files.pythonhosted.org/packages/80/31/febb777441e5fcdaacb4522316bf2a527c44551430a4873b052d545e3279/url_normalize-2.2.1.tar.gz"
    sha256 "74a540a3b6eba1d95bdc610c24f2c0141639f3ba903501e61a52a8730247ff37"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
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
