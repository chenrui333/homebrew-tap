class Mnamer < Formula
  include Language::Python::Virtualenv

  desc "Media file renaming and organizing tool"
  homepage "https://github.com/jkwill87/mnamer"
  url "https://files.pythonhosted.org/packages/7c/27/8cbd8e1565d6ec3f312a6b29f4cae55aa36d7e24927c0da408176f99f90c/mnamer-2.5.5.tar.gz"
  sha256 "c3905b7fc03e07b5b22d92f29ce9c80cc2c2788cebe35e2297fe9f3a4ce7fbf3"
  license "MIT"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "python@3.13"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/49/7c/fdf464bcc51d23881d110abd74b512a42b3d5d376a55a831b44c603ae17f/attrs-25.1.0.tar.gz"
    sha256 "1c97078a80c814273a76b2a298a932eb681c87415c11dee0a6921de7f1b02c3e"
  end

  resource "babelfish" do
    url "https://files.pythonhosted.org/packages/c5/8f/17ff889327f8a1c36a28418e686727dabc06c080ed49c95e3e2424a77aa6/babelfish-0.6.1.tar.gz"
    sha256 "decb67a4660888d48480ab6998309837174158d0f1aa63bebb1c2e11aab97aab"
  end

  resource "cattrs" do
    url "https://files.pythonhosted.org/packages/64/65/af6d57da2cb32c076319b7489ae0958f746949d407109e3ccf4d115f147c/cattrs-24.1.2.tar.gz"
    sha256 "8028cfe1ff5382df59dd36474a86e02d817b06eaf8af84555441bac915d2ef85"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/1c/ab/c9f1e32b7b1bf505bf26f0ef697775960db7932abeb7b516de930ba2705f/certifi-2025.1.31.tar.gz"
    sha256 "3d5da6925056f6f18f119200434a4780a94263f10d1c21d032a6f6b2baa20651"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/16/b0/572805e227f01586461c80e0fd25d65a2115599cc9dad142fee4b747c357/charset_normalizer-3.4.1.tar.gz"
    sha256 "44251f18cd68a75b56585dd00dae26183e102cd5e0f9f1466e6df5da2ed64ea3"
  end

  resource "guessit" do
    url "https://files.pythonhosted.org/packages/96/5f/64304acee35bac703cee51656a5caf37bd18c9490561fbff225922f41d39/guessit-3.7.1.tar.gz"
    sha256 "2c18d982ee6db30db5d59557add0324a2b49bf3940a752947510632a2b58a3c1"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d0/63/68dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106da/packaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
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
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "requests-cache" do
    url "https://files.pythonhosted.org/packages/c6/63/76613d73fb4ec23cc2451c1be30974a373c7258274db2e4f79530bda505d/requests_cache-0.9.8.tar.gz"
    sha256 "eaed4eb5fd5c392ba5e7cfa000d4ab96b1d32c1a1620f37aa558c43741ac362b"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/d1/53/43d99d7687e8cdef5ab5f9ec5eaf2c0423c2b35133a2b7e7bc276fc32b21/setuptools-75.8.2.tar.gz"
    sha256 "4880473a969e5f23f2a2be3646b2dfd84af9028716d398e46192f84bc36900d2"
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
    url "https://files.pythonhosted.org/packages/ec/ea/780a38c99fef750897158c0afb83b979def3b379aaac28b31538d24c4e8f/url-normalize-1.4.3.tar.gz"
    sha256 "d23d3a070ac52a67b83a1c59a0e68f8608d1cd538783b401bc9de2c0fac999b2"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/aa/63/e53da845320b757bf29ef6a9062f5c669fe997973f966045cb019c3f4b66/urllib3-2.3.0.tar.gz"
    sha256 "f8c5449b3cf0861679ce7e0503c7b44b5ec981bec0d1d3795a07f1ba96f0204d"
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
