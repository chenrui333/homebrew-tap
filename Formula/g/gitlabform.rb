class Gitlabform < Formula
  include Language::Python::Virtualenv

  desc "Specialized configuration as a code tool for GitLab"
  homepage "https://gitlabform.github.io/gitlabform/"
  url "https://files.pythonhosted.org/packages/00/7a/3a93c5a11235f0cf46fd3e0079dd01075d03477185ea4ac190a7a04d5464/gitlabform-4.2.5.tar.gz"
  sha256 "5bcc0d817149461e8c6f16863d5a367040278196d7a63dc477403440e642049c"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92ee6bb065a589b926fed5af96d9532d7f1e3d497904ec175fbae38e534a238e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa83e78a985dee0db014a072f43e24141e3dd23b875250a19fb43d0330a01455"
    sha256 cellar: :any_skip_relocation, ventura:       "1dd8f6d1381cb6ac5ffe971ce76073218123f430dc48c9efa0c17ef8ec02f42a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "080baa38d882f0596f4af96eac8a7e08c21659677213b20937d99ee8512a44c0"
  end

  depends_on "python@3.13"

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/95/7d/4c1bd541d4dffa1b52bd83fb8527089e097a106fc90b467a7313b105f840/anyio-4.9.0.tar.gz"
    sha256 "673c0c244e15788651a4ff38710fea9675823028a6f08a5eda409e0c9840a028"
  end

  resource "backoff" do
    url "https://files.pythonhosted.org/packages/47/d7/5bbeb12c44d7c4f2fb5b56abce497eb5ed9f34d85701de869acedd602619/backoff-2.2.1.tar.gz"
    sha256 "03f829f5bb1923180821643f8753b0502c3b682293992485b0eef2807afa5cba"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/1c/ab/c9f1e32b7b1bf505bf26f0ef697775960db7932abeb7b516de930ba2705f/certifi-2025.1.31.tar.gz"
    sha256 "3d5da6925056f6f18f119200434a4780a94263f10d1c21d032a6f6b2baa20651"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e4/33/89c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12d/charset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "cli-ui" do
    url "https://files.pythonhosted.org/packages/21/63/70d8fefa7b4140367c45287b94fb5df535b6ba6f77464087b18fdae2bb47/cli_ui-0.19.0.tar.gz"
    sha256 "59cdab0c6a2a6703c61b31cb75a1943076888907f015fffe15c5a8eb41a933aa"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "ez-yaml" do
    url "https://files.pythonhosted.org/packages/a2/72/9102232c4cfde3cc62de8e873fe11689bc357c2b18c552e7c82ca1c51e29/ez_yaml-1.2.0.tar.gz"
    sha256 "563d6b6d096e353b673d7884d779d3ea37a20377a4acc70e18ee2dcb95deacbe"

    # patch to remove toml dependency
    patch :DATA
  end

  resource "gql" do
    url "https://files.pythonhosted.org/packages/34/ed/44ffd30b06b3afc8274ee2f38c3c1b61fe4740bf03d92083e43d2c17ac77/gql-3.5.3.tar.gz"
    sha256 "393b8c049d58e0d2f5461b9d738a2b5f904186a40395500b4a84dd092d56e42b"
  end

  resource "graphql-core" do
    url "https://files.pythonhosted.org/packages/c4/16/7574029da84834349b60ed71614d66ca3afe46e9bf9c7b9562102acb7d4f/graphql_core-3.2.6.tar.gz"
    sha256 "c08eec22f9e40f0bd61d805907e3b3b1b9a320bc606e23dc145eebca07c8fbab"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/06/94/82699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cb/httpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "luddite" do
    url "https://files.pythonhosted.org/packages/9e/93/23defe449b102db8744ea89984aafb4b10df7f91ddabc73ecae07ef13a6e/luddite-1.0.4.tar.gz"
    sha256 "e05001efc80eb6c1c7514439812fbc71a66d59e031e09f9a72772f3e6cddfab7"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b2/97/5d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62/markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "mergedeep" do
    url "https://files.pythonhosted.org/packages/3a/41/580bb4006e3ed0361b8151a01d324fb03f420815446c7def45d02f74c270/mergedeep-1.3.4.tar.gz"
    sha256 "0096d52e9dad9939c3d975a774666af186eda617e6ca84df4c94dec30004f2a8"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/91/2f/a3470242707058fe856fe59241eee5635d79087100b7042a867368863a27/multidict-6.4.4.tar.gz"
    sha256 "69ee9e6ba214b5245031b76233dd95408a0fd57fdb019ddcc1ead4790932a8e8"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "propcache" do
    url "https://files.pythonhosted.org/packages/a6/16/43264e4a779dd8588c21a70f0709665ee8f611211bdd2c87d952cfa7c776/propcache-0.3.2.tar.gz"
    sha256 "20d7d62e4e7ef05f221e0db2856b979540686342e7dd9973b815599c7057e168"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-gitlab" do
    url "https://files.pythonhosted.org/packages/d6/08/d35d0f28549c43611e942f39b6321a7b35c02189d5badceefe601c0207ce/python_gitlab-5.6.0.tar.gz"
    sha256 "bc531e8ba3e5641b60409445d4919ace68a2c18cb0ec6d48fbced6616b954166"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "requests-toolbelt" do
    url "https://files.pythonhosted.org/packages/f3/61/d7545dafb7ac2230c70d38d31cbfe4cc64f7144dc41f6e4e4b78ecd9f5bb/requests-toolbelt-1.0.0.tar.gz"
    sha256 "7681a0a3d047012b5bdc0ee37d7f8f07ebe76ab08caeccfc3921ce23c88d5bc6"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/46/a9/6ed24832095b692a8cecc323230ce2ec3480015fbfa4b79941bd41b23a3c/ruamel.yaml-0.17.21.tar.gz"
    sha256 "8b7ce697a2f212752a35c1ac414471dc16c424c9573be4926b56ff3f5d23b7af"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/ec/fe/802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1/tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "types-requests" do
    url "https://files.pythonhosted.org/packages/00/7d/eb174f74e3f5634eaacb38031bbe467dfe2e545bc255e5c90096ec46bc46/types_requests-2.32.0.20250328.tar.gz"
    sha256 "c9e67228ea103bd811c96984fac36ed2ae8da87a36a633964a21f199d60baf32"
  end

  resource "types-setuptools" do
    url "https://files.pythonhosted.org/packages/e9/6e/c54e6705e5fe67c3606e4c7c91123ecf10d7e1e6d7a9c11b52970cf2196c/types_setuptools-78.1.0.20250329.tar.gz"
    sha256 "31e62950c38b8cc1c5114b077504e36426860a064287cac11b9666ab3a483234"
  end

  resource "unidecode" do
    url "https://files.pythonhosted.org/packages/94/7d/a8a765761bbc0c836e397a2e48d498305a865b70a8600fd7a942e85dcf63/Unidecode-1.4.0.tar.gz"
    sha256 "ce35985008338b676573023acc382d62c264f307c8f7963733405add37ea2b23"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/8a/78/16493d9c386d8e60e442a35feac5e00f0913c0f4b7c217c11e8ec2ff53e0/urllib3-2.4.0.tar.gz"
    sha256 "414bc6535b787febd7567804cc015fee39daab8ad86268f1310a9250697de466"
  end

  resource "yamlpath" do
    url "https://files.pythonhosted.org/packages/3a/a4/eb264493c967e5dabf310c8d5bad6f435c6830eae087f1651e51d93aa065/yamlpath-3.8.2.tar.gz"
    sha256 "4f30cc214b5085d4b0e7756e06c3af3ae589ecde9650d2ada7e1d345ec4fda4f"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/3c/fb/efaa23fa4e45537b827620f04cf8f3cd658b76642205162e072703a5b963/yarl-1.20.1.tar.gz"
    sha256 "d017a4997ee50c91fd5466cef416231bb82177b93b029906cefc542ce14c35ac"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitlabform --version")

    (testpath/"config.yml").write <<~YAML
      config_version: 3
      project_settings:
        "*/*":
          merge_requests_access_level: "enabled"
    YAML

    output = shell_output("#{bin}/gitlabform -c config.yml --noop ALL_DEFINED 2>&1", 1)
    assert_match "Unable to find the key: gitlab.url", output
  end
end

__END__
diff --git a/setup.py b/setup.py
index 46e5f48..6f925be 100644
--- a/setup.py
+++ b/setup.py
@@ -1,17 +1,20 @@
 import setuptools
-import toml
 
-# 
-# get the data out of the toml file
-# 
-toml_info = toml.load("../pyproject.toml")
-package_info = {**toml_info["tool"]["poetry"], **toml_info["tool"]["extra"]}
+package_info = {
+    "name": "ez_yaml",
+    "version": "1.2.0",
+    "description": "Straightforward wrapper around Ruamel Yaml",
+    "url": "https://github.com/jeff-hykin/ez_yaml",
+    "author": "Jeff Hykin",
+    "author_email": "jeff.hykin@gmail.com",
+    "license": "MIT"
+}
 
-# 
-# get the data out of the readme file
-# 
-with open("../README.md", "r") as file_handle:
-    long_description = file_handle.read()
+try:
+    with open("README.md", "r") as file_handle:
+        long_description = file_handle.read()
+except FileNotFoundError:
+    long_description = package_info["description"]
 
 # 
 # generate the project
