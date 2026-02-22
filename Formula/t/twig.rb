class Twig < Formula
  include Language::Python::Virtualenv

  desc "Terminal-based JSON and YAML viewer for exploring large files"
  homepage "https://twig.wtf/"
  url "https://github.com/workdone0/twig/archive/refs/tags/v2.1.4.tar.gz"
  sha256 "aaf5e2cbbd93fae419ab256221160765f0097cad3bdeb167eb5b6edaf7ae5cc8"
  license "MIT"
  head "https://github.com/workdone0/twig.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a1a8e62f21d92e4c8b6981975c02680b0f392c5d7399590e1b6f5264b7984971"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6aab0f1d5424bd209416d5cb9bc53e5d558e436e5ca78ce9680d443a7f7ac73c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b1454e7a51d32dc50e104832c97fa4fd5b403d55436b2306ba208e8e6d3e0e3c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5fa515ad74aaab9881f96577545b5db1c70c9380d8384569e492da4143e8e24b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7902f32ebb6167e57925777ad771a42ac01fa9ef20e570dac43cb97f0505e31a"
  end

  depends_on "libyaml"
  depends_on "python@3.13"

  resource "ijson" do
    url "https://files.pythonhosted.org/packages/2d/30/7ab4b9e88e7946f6beef419f74edcc541df3ea562c7882257b4eaa82417d/ijson-3.4.0.post0.tar.gz"
    sha256 "9aa02dc70bb245670a6ca7fba737b992aeeb4895360980622f7e568dbf23e41e"
  end

  resource "json-repair" do
    url "https://files.pythonhosted.org/packages/0c/9b/2a1500e587fd7c33f10dc90d4e26a6ad421bdfbc7ab84c244279b2515e42/json_repair-0.58.0.tar.gz"
    sha256 "8465fe2f8b7515d1cbf262a2608630e73d9498598bd42330c89f59923c50d0e4"
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
    url "https://files.pythonhosted.org/packages/1b/04/fea538adf7dbbd6d186f551d595961e564a3b6715bdf276b477460858672/platformdirs-4.9.2.tar.gz"
    sha256 "9a33809944b9db043ad67ca0db94b14bf452cc6aeaac46a88ea55b26e2e9d291"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/e8/52/d87eba7cb129b81563019d1679026e7a112ef76855d6159d24754dbd2a51/pyperclip-1.11.0.tar.gz"
    sha256 "244035963e4428530d9e3a6101a1ef97209c6825edab1567beac148ccc1db1b6"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/b3/c6/f3b320c27991c46f43ee9d856302c70dc2d0fb2dba4842ff739d5f46b393/rich-14.3.3.tar.gz"
    sha256 "b8daa0b9e4eef54dd8cf7c86c03713f53241884e814f4e2f5fb342fe520f639b"
  end

  resource "textual" do
    url "https://files.pythonhosted.org/packages/f7/08/1e1f705825359590ddfaeda57653bd518c4ff7a96bb2c3239ba1b6fc4c51/textual-8.0.0.tar.gz"
    sha256 "ce48f83a3d686c0fac0e80bf9136e1f8851c653aa6a4502e43293a151df18809"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "uc-micro-py" do
    url "https://files.pythonhosted.org/packages/91/7a/146a99696aee0609e3712f2b44c6274566bc368dfe8375191278045186b8/uc-micro-py-1.0.3.tar.gz"
    sha256 "d321b92cff673ec58027c04015fcaa8bb1e005478643ff4a500882eaab88c48a"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"sample.json").write <<~JSON
      {"a":1}
    JSON

    assert_match version.to_s, shell_output("#{bin}/twig --version")
    output = shell_output("#{bin}/twig --print #{testpath}/sample.json")
    assert_match "\"a\": 1", output
  end
end
