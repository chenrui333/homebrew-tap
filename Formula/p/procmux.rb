class Procmux < Formula
  include Language::Python::Virtualenv

  desc "Terminal multiplexer for processes"
  homepage "https://github.com/napisani/procmux"
  url "https://files.pythonhosted.org/packages/c1/c8/93ea9e5ffbede1999e96bb7bf6ad7d48870b8438ce55b4f3863ec9688ad8/procmux-2.0.3.tar.gz"
  sha256 "e91faee78f1411e5dd87e1dc363338e5e6307f1c144c12dad1c659b97f0c2271"
  license "MIT"
  head "https://github.com/napisani/procmux.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "13c4489bc3d60400a9558fc24b712246c5bbbcff0e2e3518ead85427535351b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b55972bc286463ec0074b7dc9acfee221948ee3a96f3ab977bd60969f6cc77fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fdd4125376c848ad56353de30085d692a16533bc148ad65f79725d929e30e70e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c0c6f64cc6f17627d0ea66318790d675bf79c36cd00e9ba923fbc55063b0a36c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ffaf321615a635bac45d3b8690f3d278cb27bd37be5fffe96cb0774695627560"
  end

  depends_on "libyaml"
  depends_on "python@3.14"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/6b/5c/685e6633917e101e5dcb62b9dd76946cbb57c26e133bae9e0cd36033c0a9/attrs-25.4.0.tar.gz"
    sha256 "16d5969b87f0859ef33a48b35d55ac1be6e42ae49d5e853b597db70c35c57e11"
  end

  resource "iniconfig" do
    url "https://files.pythonhosted.org/packages/72/34/14ca021ce8e5dfedc35312d08ba8bf51fdd999c576889fc2c24cb97f4f10/iniconfig-2.3.0.tar.gz"
    sha256 "c76315c77db068650d49c5b56314774a7804df16fee4402c1f19d6d15d8c4730"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f9/e2/3e91f31a7d2b083fe6ef3fa267035b518369d9511ffab804f839851d2779/pluggy-1.6.0.tar.gz"
    sha256 "7dcc130b76258d33b90f61b658791dede3486c3e6bfb003ee5c9bfb396dd22f3"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/0c/37/7ad3bf3c6dbe96facf9927ddf066fdafa0f86766237cff32c3c7355d3b7c/prompt_toolkit-2.0.10.tar.gz"
    sha256 "f15af68f66e664eaa559d4ac8a928111eebd5feda0c11738b5998045224829db"
  end

  resource "ptterm" do
    url "https://files.pythonhosted.org/packages/3c/23/792677e3a8a68e86849ac116ceb9bcfa70f83681f491934f99d04f663968/ptterm-0.2.tar.gz"
    sha256 "a4f846fbf5d9f302a5442c8607d29b31beab08adb72ab34605085a7c55eb117a"
  end

  resource "py" do
    url "https://files.pythonhosted.org/packages/98/ff/fec109ceb715d2a6b4c4a85a61af3b40c723a961e8828319fbcb15b868dc/py-1.11.0.tar.gz"
    sha256 "51c75c4126074b472f746a24399ad32f6053d1b34b68d2fa41e558e6f4a98719"
  end

  resource "pyte" do
    url "https://files.pythonhosted.org/packages/9f/60/442cdc1cba83710770672ef61e186be8746f419a12b2c84ba36e9a96276d/pyte-0.8.1.tar.gz"
    sha256 "b9bfd1b781759e7572a6e553c010cc93eef58a19d8d1590446d84c19b1b097b0"
  end

  resource "pytest" do
    url "https://files.pythonhosted.org/packages/a4/a7/8c63a4966935b0d0b039fd67ebf2e1ae00f1af02ceb912d838814d772a9a/pytest-7.1.3.tar.gz"
    sha256 "4f365fec2dff9c1162f834d9f18af1ba13062db0c708bf7b946f8a5c76180c39"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/52/ed/3f73f72945444548f33eba9a87fc7a6e969915e7b1acc8260b30e1f76a2f/tomli-2.3.0.tar.gz"
    sha256 "64be704a875d2a59753d80ee8a533c3fe183e3f06807ff7dc2232938ccb01549"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/24/30/6b0809f4510673dc723187aeaf24c7f5459922d01e2f794277a3dfb90345/wcwidth-0.2.14.tar.gz"
    sha256 "4d478375d31bc5395a3c55c40ccdf3354688364cd61c4f6adacaa9215d0b3605"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"procmux.yaml").write <<~YAML
      signal_server:
        enable: false
        host: localhost
        port: 9792
      procs:
        "echo test":
          shell: "echo 'Hello, Homebrew!'"
          autostart: false
          description: "test process"
    YAML

    output = shell_output("#{bin}/procmux signal-stop-running 2>&1", 1)
    assert_match "Signal server is not enabled in config", output
  end
end
