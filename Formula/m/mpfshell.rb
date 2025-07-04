class Mpfshell < Formula
  include Language::Python::Virtualenv

  desc "Simple shell based file explorer for ESP8266 and WiPy Micropython devices"
  homepage "https://github.com/wendlers/mpfshell"
  url "https://files.pythonhosted.org/packages/6e/11/1780e054077ed7f6d779da44ae40e10d80188940a63e0e2b2445913bb7d5/mpfshell-0.9.3.tar.gz"
  sha256 "3b2f176e17e9f9e08ccaf30a57503fae5bd15859d8d9efe74cc25a09abd8f349"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2ff730ac0f90a37c2b0bbfe1ecaf23a32fe0673b7b211987b42414f6f3d899a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d3762b8ac057a071fd7de4e085d1bbdc442e388a4c38f47a99e9285e694cdfa"
    sha256 cellar: :any_skip_relocation, ventura:       "7f01e3e8dfa18907bfc55eb7aad4bf5435b15dd6097e7fa947a39f2752e9a1ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9aeb1690d110bbf3cad3a4eef5b6aa237eb49e5ea6b3288344cb1ab5f01795b"
  end

  # `telnetlib` module issue with py3.13
  depends_on "python@3.12"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "pyserial" do
    url "https://files.pythonhosted.org/packages/1e/7d/ae3f0a63f41e4d2f6cb66a5b57197850f919f59e558159a4dd3a818f5082/pyserial-3.5.tar.gz"
    sha256 "3c77e014170dfffbd816e6ffc205e9842efb10be9f58ec16d3e8675b4925cddb"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/e6/30/fba0d96b4b5fbf5948ed3f4681f7da2f9f64512e1d303f94b4cc174c24a5/websocket_client-1.8.0.tar.gz"
    sha256 "3239df9f44da632f96012472805d40a23281a991027ce11d2f45a6f24ac4c3da"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = pipe_output("#{bin}/mpfshell", "exit\n", 0)
    assert_match "Micropython File Shell v#{version}", output
  end
end
