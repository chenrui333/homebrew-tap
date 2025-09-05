class BrewCleaner < Formula
  include Language::Python::Virtualenv

  desc "Clean up your installed Homebrew formulae"
  homepage "https://github.com/googlecloudplatform/cloud-run-mcp"
  url "https://files.pythonhosted.org/packages/c1/2b/c7b4a23d1030b3e9a7a7b870c4ee5c8d8561e6a14f077c5b17ed3fc8cfef/brew_cleaner-0.1.0.tar.gz"
  sha256 "f1d04ab0e62743ca3a72bc3715c7ec3a5e580dc6a835886ea1d79ed30d298138"
  license "MIT"

  depends_on "python@3.13"

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/bb/6e/9d084c929dfe9e3bfe0c6a47e31f78a25c54627d64a66e884a8bf5474f1c/prompt_toolkit-3.0.51.tar.gz"
    sha256 "931a162e3b27fc90c86f1b48bb1fb2c528c2761475e57c9c06de13311c7b54ed"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/6c/63/53559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598/wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
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
