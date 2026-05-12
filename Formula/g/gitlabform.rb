class Gitlabform < Formula
  include Language::Python::Virtualenv

  desc "Specialized configuration as a code tool for GitLab"
  homepage "https://gitlabform.github.io/gitlabform/"
  url "https://files.pythonhosted.org/packages/80/84/65afe2240fbd3b63c1e3bcefc4c7e829e49e976080704dbd9bb1b5e47aef/gitlabform-5.3.0.tar.gz"
  sha256 "0e94b49fb10f87f5341c95596d1fe015eea4685b99e7900c3fd6936a7f6fdaa7"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "adc05d6d6eaea98982efc1bbc257c782ae44185280864b55ad80e117c54893cd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1789bb606c3a0142893968f7e4ebaf113d9a1b7786eacfe569d60c5ee609cd35"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75f6957ee86f0e2cc8170e2277d320a46c7dbf10f29613bb0c254922487ee716"
    sha256 cellar: :any_skip_relocation, sequoia:       "d428106b8ebe3728f7f21457b681a6020218d5a4cdf7f3524067687a414346a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c29dfd575f37ae46a9a629c08a7a4ef49a26ae84cf2c433ddd93b08a985f7867"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec1d1f3e49dcea69dbff89cd7df1efbb67312c48d5da90a037a3c0f1994fbec7"
  end

  depends_on "certifi" => :no_linkage
  depends_on "python@3.13"

  pypi_packages exclude_packages: "certifi"

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/19/14/2c5dd9f512b66549ae92767a9c7b330ae88e1932ca57876909410251fe13/anyio-4.13.0.tar.gz"
    sha256 "334b70e641fd2221c1505b3890c69882fe4a2df910cba14d97019b90b24439dc"
  end

  resource "backoff" do
    url "https://files.pythonhosted.org/packages/47/d7/5bbeb12c44d7c4f2fb5b56abce497eb5ed9f34d85701de869acedd602619/backoff-2.2.1.tar.gz"
    sha256 "03f829f5bb1923180821643f8753b0502c3b682293992485b0eef2807afa5cba"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e7/a1/67fe25fac3c7642725500a3f6cfe5821ad557c3abb11c9d20d12c7008d3e/charset_normalizer-3.4.7.tar.gz"
    sha256 "ae89db9e5f98a11a4bf50407d4363e7b09b31e55bc117b4f7d80aab97ba009e5"
  end

  resource "ez-yaml" do
    url "https://files.pythonhosted.org/packages/a2/72/9102232c4cfde3cc62de8e873fe11689bc357c2b18c552e7c82ca1c51e29/ez_yaml-1.2.0.tar.gz"
    sha256 "563d6b6d096e353b673d7884d779d3ea37a20377a4acc70e18ee2dcb95deacbe"

    # patch to remove toml dependency
    patch :DATA
  end

  resource "gql" do
    url "https://files.pythonhosted.org/packages/06/9f/cf224a88ed71eb223b7aa0b9ff0aa10d7ecc9a4acdca2279eb046c26d5dc/gql-4.0.0.tar.gz"
    sha256 "f22980844eb6a7c0266ffc70f111b9c7e7c7c13da38c3b439afc7eab3d7c9c8e"
  end

  resource "graphql-core" do
    url "https://files.pythonhosted.org/packages/68/c5/36aa96205c3ecbb3d34c7c24189e4553c7ca2ebc7e1dd07432339b980272/graphql_core-3.2.8.tar.gz"
    sha256 "015457da5d996c924ddf57a43f4e959b0b94fb695b85ed4c29446e508ed65cf3"
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
    url "https://files.pythonhosted.org/packages/ce/cc/762dfb036166873f0059f3b7de4565e1b5bc3d6f28a414c13da27e442f99/idna-3.13.tar.gz"
    sha256 "585ea8fe5d69b9181ec1afba340451fba6ba764af97026f92a91d4eef164a242"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "luddite" do
    url "https://files.pythonhosted.org/packages/9e/93/23defe449b102db8744ea89984aafb4b10df7f91ddabc73ecae07ef13a6e/luddite-1.0.4.tar.gz"
    sha256 "e05001efc80eb6c1c7514439812fbc71a66d59e031e09f9a72772f3e6cddfab7"
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

  resource "mergedeep" do
    url "https://files.pythonhosted.org/packages/3a/41/580bb4006e3ed0361b8151a01d324fb03f420815446c7def45d02f74c270/mergedeep-1.3.4.tar.gz"
    sha256 "0096d52e9dad9939c3d975a774666af186eda617e6ca84df4c94dec30004f2a8"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/1a/c2/c2d94cbe6ac1753f3fc980da97b3d930efe1da3af3c9f5125354436c073d/multidict-6.7.1.tar.gz"
    sha256 "ec6652a1bee61c53a3e5776b6049172c53b6aaba34f18c9ad04f82712bac623d"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/65/ee/299d360cdc32edc7d2cf530f3accf79c4fca01e96ffc950d8a52213bd8e4/packaging-26.0.tar.gz"
    sha256 "00243ae351a257117b6a241061796684b084ed1c516a08c48a3f7e147a9d80b4"
  end

  resource "propcache" do
    url "https://files.pythonhosted.org/packages/ec/44/c87281c333769159c50594f22610f77398a47ccbfbbf23074e744e86f87c/propcache-0.5.2.tar.gz"
    sha256 "01c4fc7480cd0598bb4b57022df55b9ca296da7fc5a8760bd8451a7e63a7d427"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-gitlab" do
    url "https://files.pythonhosted.org/packages/77/9c/ec0073c260812bca170418e8e259a2ed0728200af4b3f7120badf2e6f05a/python_gitlab-8.2.0.tar.gz"
    sha256 "de874dc538db6dceb48929f4c8fb55d6064dd19cb3ffdad1100190f835c5b674"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/5f/a4/98b9c7c6428a668bf7e42ebb7c79d576a1c3c1e3ae2d47e674b468388871/requests-2.33.1.tar.gz"
    sha256 "18817f8c57c6263968bc123d237e3b8b08ac046f5456bd1e307ee8f4250d3517"
  end

  resource "requests-toolbelt" do
    url "https://files.pythonhosted.org/packages/f3/61/d7545dafb7ac2230c70d38d31cbfe4cc64f7144dc41f6e4e4b78ecd9f5bb/requests-toolbelt-1.0.0.tar.gz"
    sha256 "7681a0a3d047012b5bdc0ee37d7f8f07ebe76ab08caeccfc3921ce23c88d5bc6"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/46/a9/6ed24832095b692a8cecc323230ce2ec3480015fbfa4b79941bd41b23a3c/ruamel.yaml-0.17.21.tar.gz"
    sha256 "8b7ce697a2f212752a35c1ac414471dc16c424c9573be4926b56ff3f5d23b7af"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  resource "yamlpath" do
    url "https://files.pythonhosted.org/packages/3a/a4/eb264493c967e5dabf310c8d5bad6f435c6830eae087f1651e51d93aa065/yamlpath-3.8.2.tar.gz"
    sha256 "4f30cc214b5085d4b0e7756e06c3af3ae589ecde9650d2ada7e1d345ec4fda4f"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/23/6e/beb1beec874a72f23815c1434518bfc4ed2175065173fb138c3705f658d4/yarl-1.23.0.tar.gz"
    sha256 "53b1ea6ca88ebd4420379c330aea57e258408dd0df9af0992e5de2078dc9f5d5"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitlabform --version --skip-version-check")

    (testpath/"config.yml").write <<~YAML
      config_version: 4
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
