class Mcptoon < Formula
  include Language::Python::Virtualenv

  desc "Token-efficient MCP client and tool gateway"
  homepage "https://github.com/activeing123/mcptoon"
  url "https://files.pythonhosted.org/packages/e0/8d/22fc973b311efbd1e62029994d195ff7835b55c4126ff0dfc216cbe1447c/mcptoon-0.8.34.tar.gz"
  sha256 "289ad4bbe64420e217d2adc07a522a65ec927fa1cb9dad0738ece89b5733ef3b"
  license "Apache-2.0"
  head "https://github.com/activeing123/mcptoon.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "eed5a35001f36585fa5c5361e9f36a75e1bc66db2a545798eb288275c3835969"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.15"

  deny_network_access!

  def install
    venv = virtualenv_create(libexec, "python3.15")
    venv.pip_install_and_link buildpath, build_isolation: false
    generate_completions_from_executable(bin/"mcptoon", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mcptoon --version")

    system bin/"mcptoon", "--dir", testpath/"config", "add", "homebrew-test", "--stdio", "/usr/bin/false"
    assert_match "homebrew-test", shell_output("#{bin}/mcptoon --dir #{testpath}/config list")
    system bin/"mcptoon", "--dir", testpath/"config", "remove", "homebrew-test"
    refute_match "homebrew-test", shell_output("#{bin}/mcptoon --dir #{testpath}/config list")
  end
end
