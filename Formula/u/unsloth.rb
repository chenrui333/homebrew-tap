class Unsloth < Formula
  include Language::Python::Virtualenv

  desc "CLI for Unsloth training and studio workflows"
  homepage "https://github.com/unslothai/unsloth"
  # PyPI sdist metadata currently pulls in Unsloth's full GPU stack, while the
  # GitHub release archive exposes the lightweight CLI dependency set.
  url "https://github.com/unslothai/unsloth/archive/refs/tags/March-2026.tar.gz"
  version "2026.3.5"
  sha256 "4a22f8920388f67c5512001b67ef61d8c53c9e670a850c5aa62d4e0cbe4d8231"
  license all_of: ["Apache-2.0", "AGPL-3.0-only"]
  head "https://github.com/unslothai/unsloth.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "61ea00e0507c27c2c32fbf37e03a8708d462eacc201b63388741e9d83caa0ca7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9dcc5fc8c5c862e871e2ae10c8e25bb78b8b724ffbae350216466e9ae63a82f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6134d03dcb7c1d5187754a3817617a64e14e53c7ef3e0ea42db55dde17005ed"
    sha256 cellar: :any,                 arm64_linux:   "ba05937608394f4b9481717a2676696010ebd8aa81bc09f9d8efda0174e4748d"
    sha256 cellar: :any,                 x86_64_linux:  "f64263510253ac5e5ca2faa497ba810053ace40aa78d005124c597106e7c3ff4"
  end

  depends_on "libyaml"
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.14"

  pypi_packages exclude_packages: ["pydantic"]

  resource "annotated-doc" do
    url "https://files.pythonhosted.org/packages/57/ba/046ceea27344560984e26a590f90bc7f4a75b06701f653222458922b558c/annotated_doc-0.0.4.tar.gz"
    sha256 "fbcda96e87e9c92ad167c2e53839e57503ecfda18804ea28102353485033faa4"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/3d/fa/656b739db8587d7b5dfa22e22ed02566950fbfbcdc20311993483657a5c0/click-8.3.1.tar.gz"
    sha256 "12ff4785d337a1bb490bb7e9c2b1ee5da3112e94a8622f26a6c77f5d2fc6842a"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/5b/f5/4ec618ed16cc4f8fb3b701563655a69816155e79e24a17b651541804721d/markdown_it_py-4.0.0.tar.gz"
    sha256 "cb0a2b4aa34f932c007117b194e945bd74e0ec24133ceb5bac59009cda1cb9f3"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "nest-asyncio" do
    url "https://files.pythonhosted.org/packages/83/f8/51569ac65d696c8ecbee95938f89d4abf00f47d58d48f6fbabfe8f0baefe/nest_asyncio-1.6.0.tar.gz"
    sha256 "6f172d5449aca15afd6c646851f4e31e02c598d553a667e38cafa997cfec55fe"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/b3/c6/f3b320c27991c46f43ee9d856302c70dc2d0fb2dba4842ff739d5f46b393/rich-14.3.3.tar.gz"
    sha256 "b8daa0b9e4eef54dd8cf7c86c03713f53241884e814f4e2f5fb342fe520f639b"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/58/15/8b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58e/shellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/f5/24/cb09efec5cc954f7f9b930bf8279447d24618bb6758d4f6adf2574c41780/typer-0.24.1.tar.gz"
    sha256 "e39b4732d65fbdcde189ae76cf7cd48aeae72919dea1fdfc16593be016256b45"
  end

  def install
    virtualenv_install_with_resources
    generate_completions_from_executable(bin/"unsloth", shell_parameter_format: :typer)
  end

  test do
    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.

    output = shell_output("#{bin}/unsloth train --model test-model --dataset test-dataset --dry-run")
    assert_match "model: test-model", output
    assert_match "dataset: test-dataset", output
  end
end
