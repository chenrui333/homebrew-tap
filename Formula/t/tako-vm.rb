class TakoVm < Formula
  include Language::Python::Virtualenv

  desc "Secure Python code execution in isolated Docker containers"
  homepage "https://github.com/las7/TakoVM"
  url "https://github.com/las7/TakoVM/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "a9e14008fa067bd47548ec1625241e4131eb982d888e66a9870a1c1dd557d92f"
  license "Apache-2.0"
  head "https://github.com/las7/TakoVM.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8408d479b0b939f86dbc5314686b20b663506ecb81abb775d8e3c6567154db95"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f039103ec14c81f1c726a6ca9847b9b808fd2cd273b9a36c18d68d5b015bde24"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11ae3dfc6c03b73e9b2c84dce1074536ae29ad6bcd371b4196d5332704e58b04"
    sha256 cellar: :any,                 arm64_linux:   "8aef775594c9955de46ab83e2f047c187965004a04ce86481b2dfd22031d56f2"
    sha256 cellar: :any,                 x86_64_linux:  "15c4ab664460c57f63f7d9183971829a209fba326b0eab9e751cffcb88445392"
  end

  depends_on "certifi" => :no_linkage
  depends_on "libpq"
  depends_on "libyaml"
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.13"

  pypi_packages exclude_packages: %w[certifi pydantic]

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e7/a1/67fe25fac3c7642725500a3f6cfe5821ad557c3abb11c9d20d12c7008d3e/charset_normalizer-3.4.7.tar.gz"
    sha256 "ae89db9e5f98a11a4bf50407d4363e7b09b31e55bc117b4f7d80aab97ba009e5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cd/63/9496c57188a2ee585e0f1db071d75089a11e98aa86eb99d9d7618fc1edce/idna-3.18.tar.gz"
    sha256 "ffb385a7e039654cef1ab9ef32c6fafe283c0c0467bba1d9029738ce4a14a848"
  end

  resource "psycopg" do
    url "https://files.pythonhosted.org/packages/db/2f/cb91e5502ec9de1de6f1b76cfbf69531932725361168bb06963620c77e2e/psycopg-3.3.4.tar.gz"
    sha256 "e21207764952cff81b6b8bdacad9a3939f2793367fdac2987b3aac36a651b5bc"
  end

  resource "psycopg-pool" do
    url "https://files.pythonhosted.org/packages/90/82/7a23d26039827ecd4ebe93905651029ddd307c5182ad59296dfb6f67b528/psycopg_pool-3.3.1.tar.gz"
    sha256 "b10b10b7a175d5cc1592147dc5b7eec8a9e0834eb3ed2c4a92c858e2f51eb63c"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  def install
    virtualenv_install_with_resources
  end

  def caveats
    <<~EOS
      tako-vm requires Docker to be installed and running for code execution.
      Install Docker Desktop or Docker Engine before using this tool.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tako-vm version")
    output = shell_output("#{bin}/tako-vm --not-a-real-option 2>&1", 2)
    assert_match "not-a-real-option", output
  end
end
