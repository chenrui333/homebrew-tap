class McpManager < Formula
  include Language::Python::Virtualenv

  desc "Manage Model Context Protocol servers across local clients"
  homepage "https://github.com/nstebbins/mcp-manager"
  url "https://github.com/nstebbins/mcp-manager/archive/refs/tags/v0.2.8.tar.gz"
  sha256 "9fa1ac9184148d9eef1364bb48220c4ece912442d9ffa68c6266fd18b9691c80"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "e1441722a7414475dafb7c1bba410dd3792ae11c8eef67749d3bea3a47496602"
  end

  depends_on "pydantic" => :no_linkage
  depends_on "python@3.14"

  pypi_packages exclude_packages: "pydantic"

  resource "click" do
    url "https://files.pythonhosted.org/packages/b9/2e/0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8b/click-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/5b/f5/4ec618ed16cc4f8fb3b701563655a69816155e79e24a17b651541804721d/markdown_it_py-4.0.0.tar.gz"
    sha256 "cb0a2b4aa34f932c007117b194e945bd74e0ec24133ceb5bac59009cda1cb9f3"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/ab/3a/0316b28d0761c6734d6bc14e770d85506c986c85ffb239e688eeaab2c2bc/rich-13.9.4.tar.gz"
    sha256 "439594978a49a09530cff7ebc4b5c7103ef57baf48d5ea3184f21d9a2befa098"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/58/15/8b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58e/shellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/ec/fe/802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1/tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/6c/89/c527e6c848739be8ceb5c44eb8208c52ea3515c6cf6406aa61932887bf58/typer-0.15.4.tar.gz"
    sha256 "89507b104f9b6a0730354f27c39fae5b63ccd0c95b1ce1f1a6ba0cfd329997c3"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    claude_config = Pathname.new(Dir.home)/"Library/Application Support/Claude/claude_desktop_config.json"
    claude_config.dirname.mkpath
    claude_config.write <<~JSON
      {"mcpServers": {}}
    JSON

    output = shell_output("#{bin}/mcp-manager config path")
    normalized_output = output.gsub(/\s+/, " ")
    assert_match "Current claude-desktop config path:", output
    assert_match claude_config.to_s.gsub(/\s+/, " "), normalized_output
    assert_match "Config exists: True", output

    assert_match "memory", shell_output("#{bin}/mcp-manager search memory")
    assert_match "filesystem", shell_output("#{bin}/mcp-manager info filesystem")
    assert_match "No MCP servers are currently installed", shell_output("#{bin}/mcp-manager list")
  end
end
