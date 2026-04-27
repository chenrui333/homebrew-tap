class Tabminal < Formula
  desc "Cloud-Native, Proactive AI Integrated Terminal works in modern browsers"
  homepage "https://github.com/Leask/Tabminal"
  url "https://registry.npmjs.org/tabminal/-/tabminal-3.0.39.tgz"
  sha256 "d04c50297e11b192197eab651a160c909549b8dd6954fe3d2818eac36948c51b"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "62ece0365f537ce505f92d670ffdb2a2b206b9307dc89d8189a6cd7c34a69b20"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62ece0365f537ce505f92d670ffdb2a2b206b9307dc89d8189a6cd7c34a69b20"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62ece0365f537ce505f92d670ffdb2a2b206b9307dc89d8189a6cd7c34a69b20"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "376848e99825779f9c1643e5933bd300adbab1f5a2852587f3011dbd26c8e171"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "554f968591ddb1d6b8e7c38ad00884af3d26026f27a2b83d4e8f99f7bc83e9b5"
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
