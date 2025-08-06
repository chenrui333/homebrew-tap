class JetsonStats < Formula
  include Language::Python::Virtualenv

  desc "Simple package for monitoring and control your NVIDIA Jetson series"
  homepage "https://rnext.it/jetson_stats/"
  url "https://files.pythonhosted.org/packages/a8/c1/0b24527991f60379a6ae270b772d0fb05f680e4607e3246862b27b2e8e2c/jetson-stats-4.3.2.tar.gz"
  sha256 "2b033cb02b9d4cf70d13cdb915b5cf58b864a742d612704513e196943dc0a397"
  license "AGPL-3.0-or-later"

  depends_on :linux
  depends_on "python@3.13"

  resource "distro" do
    url "https://files.pythonhosted.org/packages/fc/f8/98eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3/distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "smbus2" do
    url "https://files.pythonhosted.org/packages/10/c9/6d85aa809e107adf85303010a59b340be109c8f815cbedc5c08c73bcffef/smbus2-0.5.0.tar.gz"
    sha256 "4a5946fd82277870c2878befdb1a29bb28d15cda14ea4d8d2d54cf3d4bdcb035"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jetson-stats --version")
  end
end
