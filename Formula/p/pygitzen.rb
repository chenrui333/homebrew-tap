class Pygitzen < Formula
  include Language::Python::Virtualenv

  desc "Python native terminal based Git client"
  homepage "https://github.com/SunnyTamang/pygitzen"
  url "https://files.pythonhosted.org/packages/10/88/769cb5eb4f5705cd4fa36a50bbd7f6e7fc0640ae2bdf16307b4966881d5e/pygitzen-0.2.7.tar.gz"
  sha256 "9ceb24c6fca0ad3b6c1822934ffbad5fcb0f8a9e9057c4d3b1606a439de71cf5"
  license "MIT"
  head "https://github.com/SunnyTamang/pygitzen.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4db528f0e2abf5a437888f182338cf45ba10321aa0613aa96e64726f345855fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b471d7347e78a93ed82b2b5410a5ed0304a938ac7e82735cb886f77fb3469ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20002df353d5f0cbe75323e803cfa3cebf80fdcb7a4726e38b166601622eecb2"
    sha256 cellar: :any_skip_relocation, sequoia:       "7549bd8f1251b28a60df5798034cc060d393b654cde0fe5ead7ac80276f24b28"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9a1a082ca9ddf7d74a8b08df1c4f59e5a4da3a90b8dee54c9b48d78c9fb2390"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ffa9181398af7e2dbf0612c17088f7c5c5ed8e7895831da69ce00e095711811"
  end

  depends_on "python@3.14"

  resource "dulwich" do
    url "https://files.pythonhosted.org/packages/ee/df/4178b6465e118e6e74fd78774b451953dd53c09fdec18f2c4b3319dd0485/dulwich-1.0.0.tar.gz"
    sha256 "3d07104735525f22bfec35514ac611cf328c89b7acb059316a4f6e583c8f09bc"
  end

  resource "linkify-it-py" do
    url "https://files.pythonhosted.org/packages/2a/ae/bb56c6828e4797ba5a4821eec7c43b8bf40f69cda4d4f5f8c8a2810ec96a/linkify-it-py-2.0.3.tar.gz"
    sha256 "68cda27e162e9215c17d786649d1da0021a451bdc436ef9e0fa0ba5234b9b048"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/5b/f5/4ec618ed16cc4f8fb3b701563655a69816155e79e24a17b651541804721d/markdown_it_py-4.0.0.tar.gz"
    sha256 "cb0a2b4aa34f932c007117b194e945bd74e0ec24133ceb5bac59009cda1cb9f3"
  end

  resource "mdit-py-plugins" do
    url "https://files.pythonhosted.org/packages/b2/fd/a756d36c0bfba5f6e39a1cdbdbfdd448dc02692467d83816dff4592a1ebc/mdit_py_plugins-0.5.0.tar.gz"
    sha256 "f4918cb50119f50446560513a8e311d574ff6aaed72606ddae6d35716fe809c6"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/cf/86/0248f086a84f01b37aaec0fa567b397df1a119f73c16f6c7a9aac73ea309/platformdirs-4.5.1.tar.gz"
    sha256 "61d5cdcc6065745cdd94f0f878977f8de9437be93de97c1c12f853c9c0cdcbda"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/74/99/a4cab2acbb884f80e558b0771e97e21e939c5dfb460f488d19df485e8298/rich-14.3.2.tar.gz"
    sha256 "e712f11c1a562a11843306f5ed999475f09ac31ffb64281f73ab29ffdda8b3b8"
  end

  resource "textual" do
    url "https://files.pythonhosted.org/packages/9f/38/7d169a765993efde5095c70a668bf4f5831bb7ac099e932f2783e9b71abf/textual-7.5.0.tar.gz"
    sha256 "c730cba1e3d704e8f1ca915b6a3af01451e3bca380114baacf6abf87e9dac8b6"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "uc-micro-py" do
    url "https://files.pythonhosted.org/packages/91/7a/146a99696aee0609e3712f2b44c6274566bc368dfe8375191278045186b8/uc-micro-py-1.0.3.tar.gz"
    sha256 "d321b92cff673ec58027c04015fcaa8bb1e005478643ff4a500882eaab88c48a"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c7/24/5f1b3bdffd70275f6661c76461e25f024d5a38a46f04aaca912426a2b1d3/urllib3-2.6.3.tar.gz"
    sha256 "1b62b6884944a57dbe321509ab94fd4d3b307075e0c2eae991ac71ee15ad38ed"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "The directory you specified is not a Git repository", shell_output("#{bin}/pygitzen 2>&1", 1)
  end
end
