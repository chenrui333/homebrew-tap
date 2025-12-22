class Pygitzen < Formula
  include Language::Python::Virtualenv

  desc "Python native terminal based Git client"
  homepage "https://github.com/SunnyTamang/pygitzen"
  url "https://files.pythonhosted.org/packages/2c/d1/34ffe7c01b2205c9f6fbe8081b6ff63f6cea1c816ba4450b734708c90f8b/pygitzen-0.2.6.tar.gz"
  sha256 "14d318b35547f2d38f6386f04a98cc9997c66d0de0a495fa1a6f11f2df9e5b36"
  license "MIT"
  head "https://github.com/SunnyTamang/pygitzen.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "95b6c5b6d0f6ce0f91f118ccafb3d6acec0d1275b1fb3ceca11807e042dbd669"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "980613db2d3e7faefa019b8f56e238a76403fe9977f074ef43b795d0d0f9507c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54af264469fec03ed0562b56a0de2135eac204b72cfb51bcb63f8d8798413306"
    sha256 cellar: :any_skip_relocation, sequoia:       "74f46c7a1ef756e06156e128291b29c896596e6ec4b6221ffcb41fa61070828f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a86ca0c5d28160e6b2201c2d881cd6be5618b713b4e3e32b8656fcf952e0c407"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57f8b58c3b02bc76b7951e79be3a836d052c2c5ba354b39caed32df0739dc9fd"
  end

  depends_on "python@3.14"

  resource "dulwich" do
    url "https://files.pythonhosted.org/packages/6f/97/f65ab4c7d999bb10c717cace283bfe60dcaa02993ba445574e217ae7c71e/dulwich-0.25.0.tar.gz"
    sha256 "baa84b539fea0e6a925a9159c3e0a1d08cceeea5260732b84200e077444a4b0e"
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
    url "https://files.pythonhosted.org/packages/fb/d2/8920e102050a0de7bfabeb4c4614a49248cf8d5d7a8d01885fbb24dc767a/rich-14.2.0.tar.gz"
    sha256 "73ff50c7c0c1c77c8243079283f4edb376f0f6442433aecb8ce7e6d0b92d1fe4"
  end

  resource "textual" do
    url "https://files.pythonhosted.org/packages/55/06/906f86bbc59ec7cd3fb424250e19ce670406d1f28e49e86c2221e9fd7ed2/textual-6.11.0.tar.gz"
    sha256 "08237ebda0cfbbfd1a4e2fd3039882b35894a73994f6f0fcc12c5b0d78acf3cc"
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
    url "https://files.pythonhosted.org/packages/1e/24/a2a2ed9addd907787d7aa0355ba36a6cadf1768b934c652ea78acbd59dcd/urllib3-2.6.2.tar.gz"
    sha256 "016f9c98bb7e98085cb2b4b17b87d2c702975664e4f060c6532e64d1c1a5e797"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "The directory you specified is not a Git repository", shell_output("#{bin}/pygitzen 2>&1", 1)
  end
end
