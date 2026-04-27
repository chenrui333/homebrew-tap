class Tabminal < Formula
  desc "Cloud-Native, Proactive AI Integrated Terminal works in modern browsers"
  homepage "https://github.com/Leask/Tabminal"
  url "https://registry.npmjs.org/tabminal/-/tabminal-3.0.39.tgz"
  sha256 "d04c50297e11b192197eab651a160c909549b8dd6954fe3d2818eac36948c51b"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e3bc17db59847c1b27f354d0834f214c41a128c17eb23778d85a1df9cc6aa384"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3bc17db59847c1b27f354d0834f214c41a128c17eb23778d85a1df9cc6aa384"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e3bc17db59847c1b27f354d0834f214c41a128c17eb23778d85a1df9cc6aa384"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a2ac95d4c30e114e9ac56ccca64181655daaa286cca5105ab4508d38afff9e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3bfe49061c84301a8450cff2805f193aa4e9bd156a3910fe855a099e0aca093d"
  end

  depends_on "node"

  def install
    ENV["npm_config_build_from_source"] = "true" if OS.linux?
    system "npm", "install", *std_npm_args

    prebuilds = libexec/"lib/node_modules/tabminal/node_modules/node-pty/prebuilds"
    if OS.linux?
      cd libexec/"lib/node_modules/tabminal" do
        system "npm", "rebuild", "node-pty", "--build-from-source"
      end
      rm_r prebuilds if prebuilds.exist?
    elsif OS.mac? && Hardware::CPU.arm?
      rm_r prebuilds/"darwin-x64" if (prebuilds/"darwin-x64").exist?
    elsif OS.mac? && Hardware::CPU.intel?
      rm_r prebuilds/"darwin-arm64" if (prebuilds/"darwin-arm64").exist?
    end

    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match "\"version\": \"#{version}\"", (libexec/"lib/node_modules/tabminal/package.json").read

    output = shell_output("#{bin}/tabminal --help")
    assert_match "Tabminal - A modern web terminal", output
    assert_match "--accept-terms, -y", output
  end
end
