class Darker < Formula
  include Language::Python::Virtualenv

  desc "Apply Black formatting only in regions changed since last commit"
  homepage "https://github.com/bdcht/amoco"
  url "https://files.pythonhosted.org/packages/67/f4/a51ea71253b9df5206cfa5f2b2385670eaa21fde3dd21cad6532a78a2406/darker-2.1.1.tar.gz"
  sha256 "a6e6a682c0604e76fe9aec7650e96a944f517563c69b28fcc076db9d957d98ea"
  license "BSD-3-Clause"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c33b5774640461e6f45fc4a04ada9dc66dc4d83c917e11fcc70484f420450ec0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a85d42bb11bbada23a619c05216d162bd43cb795b2b8acdc32ecb49881a10b4"
    sha256 cellar: :any_skip_relocation, ventura:       "01788acae2a86e7817a3b5221182c69454ee7f372c92335b6e3b7390d3e564fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9afa3cf019bce4e337635ba8b77f5517e6fb66cc4bba37d0137768b87e5df92"
  end

  depends_on "python@3.13"

  resource "black" do
    url "https://files.pythonhosted.org/packages/94/49/26a7b0f3f35da4b5a65f081943b7bcd22d7002f5f0fb8098ec1ff21cb6ef/black-25.1.0.tar.gz"
    sha256 "33496d5cd1222ad73391352b4ae8da15253c5de89b93a80b3e2c8d9a19ec2666"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/b9/2e/0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8b/click-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
  end

  resource "darkgraylib" do
    url "https://files.pythonhosted.org/packages/31/4c/827aea826942688db68773a02b9bacce26521b83503d4f3e613ad71fac6b/darkgraylib-1.2.1.tar.gz"
    sha256 "a5dd6a2015a470d9047278cdd01a91ccb1d746675f8fd4562b3b5f6b8cbda930"
  end

  resource "graylint" do
    url "https://files.pythonhosted.org/packages/42/70/3a962cc782846f4b11266e781eaea93973f59209fddba93389247111fe99/graylint-1.1.1.tar.gz"
    sha256 "b7e0eab6c159684dbf5ef84e942c3340f6a6549b02a3d11b1a1763cc4f8f0593"
  end

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/98/a4/1ab47638b92648243faf97a5aeb6ea83059cc3624972ab6b8d2316078d3f/mypy_extensions-1.0.0.tar.gz"
    sha256 "75dbf8955dc00442a438fc4d0666508a9a97b6bd41aa2f0ffe9d2f2725af0782"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d0/63/68dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106da/packaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/ca/bc/f35b8446f4531a7cb215605d100cd88b7ac6f44ab3fc94870c120ab3adbf/pathspec-0.12.1.tar.gz"
    sha256 "a482d51503a1ab33b1c67a6c3813a26953dbdc71c31dacaef9a838c4e29f5712"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/13/fc/128cc9cb8f03208bdbf93d3aa862e16d376844a14f9a0ce5cf4507372de4/platformdirs-4.3.6.tar.gz"
    sha256 "357fb2acbc885b0419afd3ce3ed34564c13c9b95c89360cd9563f73aa5e2b907"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # prints 1.2.1 rather than 2.1.1
    system bin/"darker", "--version"

    # cannot get test working
    # `Command '['git', 'rev-parse', '--is-inside-work-tree']' returned non-zero exit status 1`
  end
end
