class Asmdiff < Formula
  include Language::Python::Virtualenv

  desc "Compare per-function assembly across compilers"
  homepage "https://github.com/rt-rtos/asmdiff"
  url "https://files.pythonhosted.org/packages/8d/12/b91bac1948f7b90192a1e94366499a01a59fa048a61f5124bcecfc4c6851/asmdiff-0.3.3.tar.gz"
  sha256 "6313ac2adb5f903d4a4e30c288d4f23095ef92575429d3e1ad3a0ac1eabc6976"
  license "MIT"
  head "https://github.com/rt-rtos/asmdiff.git", branch: "main"

  depends_on "python@3.14"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/asmdiff --version")
    assert_match "SOURCE.c required", shell_output("#{bin}/asmdiff 2>&1", 2)
  end
end
