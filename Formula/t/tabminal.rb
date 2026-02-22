class Tabminal < Formula
  desc "Cloud-Native, Proactive AI Integrated Terminal works in modern browsers"
  homepage "https://github.com/Leask/Tabminal"
  url "https://registry.npmjs.org/tabminal/-/tabminal-2.0.2.tgz"
  sha256 "aae7d87958b459af48151dc9410accce1d4d8711c773d02aa7d414728983974c"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args

    prebuilds = libexec/"lib/node_modules/tabminal/node_modules/node-pty/prebuilds"
    if OS.mac? && Hardware::CPU.arm?
      rm_r prebuilds/"darwin-x64" if (prebuilds/"darwin-x64").exist?
    elsif OS.mac? && Hardware::CPU.intel?
      rm_r prebuilds/"darwin-arm64" if (prebuilds/"darwin-arm64").exist?
    elsif OS.linux? && Hardware::CPU.arm?
      rm_r prebuilds/"linux-x64" if (prebuilds/"linux-x64").exist?
    elsif OS.linux? && Hardware::CPU.intel?
      rm_r prebuilds/"linux-arm64" if (prebuilds/"linux-arm64").exist?
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
