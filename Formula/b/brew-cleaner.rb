class BrewCleaner < Formula
  include Language::Python::Virtualenv

  desc "Clean up your installed Homebrew formulae"
  homepage "https://github.com/googlecloudplatform/cloud-run-mcp"
  url "https://files.pythonhosted.org/packages/c1/2b/c7b4a23d1030b3e9a7a7b870c4ee5c8d8561e6a14f077c5b17ed3fc8cfef/brew_cleaner-0.1.0.tar.gz"
  sha256 "f1d04ab0e62743ca3a72bc3715c7ec3a5e580dc6a835886ea1d79ed30d298138"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "5e1e12bc9cca20c43960661493e433932443fb7ec5a29f90f7f1650aa59dd93c"
  end

  depends_on "python@3.14"

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/bb/6e/9d084c929dfe9e3bfe0c6a47e31f78a25c54627d64a66e884a8bf5474f1c/prompt_toolkit-3.0.51.tar.gz"
    sha256 "931a162e3b27fc90c86f1b48bb1fb2c528c2761475e57c9c06de13311c7b54ed"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/24/30/6b0809f4510673dc723187aeaf24c7f5459922d01e2f794277a3dfb90345/wcwidth-0.2.14.tar.gz"
    sha256 "4d478375d31bc5395a3c55c40ccdf3354688364cd61c4f6adacaa9215d0b3605"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output_log = testpath/"output.log"
    pid = spawn bin/"brew-cleaner", testpath, [:out, :err] => output_log.to_s
    sleep 1
    if OS.mac?
      assert_empty output_log.read
    else
      assert_match "This script requires an interactive terminal", output_log.read
    end
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
