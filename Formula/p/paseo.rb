class Paseo < Formula
  desc "Control your AI coding agents from the command-line"
  homepage "https://github.com/getpaseo/paseo"
  url "https://registry.npmjs.org/@getpaseo/cli/-/cli-0.1.110.tgz"
  sha256 "a24fbb856c628e93310b755ef0b9810cc694396188eeae676119b6fa1b23ca24"
  license "AGPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "30b3db8639135d8fab67df4f6d117683d31fe4b71a294daf9aadbc95a19fdea8"
    sha256               arm64_sequoia: "30b3db8639135d8fab67df4f6d117683d31fe4b71a294daf9aadbc95a19fdea8"
    sha256               arm64_sonoma:  "30b3db8639135d8fab67df4f6d117683d31fe4b71a294daf9aadbc95a19fdea8"
    sha256 cellar: :any, arm64_linux:   "9abca33aa706b3bf42a33b06cece67ec75a9389be23ea1fc829b09399eefe67f"
    sha256 cellar: :any, x86_64_linux:  "260d924aa0422e8a620ba74abca3f59ce1d29e2e2edd5751c8198beb690f1ddc"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args

    # Keep only the native node-pty prebuild to avoid shipping non-native binaries.
    node_pty_prebuilds = libexec/"lib/node_modules/@getpaseo/cli/node_modules/node-pty/prebuilds"
    native_prebuild = "#{OS.mac? ? "darwin" : "linux"}-#{Hardware::CPU.arm? ? "arm64" : "x64"}"
    node_pty_prebuilds.children.each do |prebuild|
      rm_r prebuild if prebuild.basename.to_s != native_prebuild
    end

    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/paseo --version")
    output = shell_output("#{bin}/paseo --not-a-real-option 2>&1", 1)
    assert_match "not-a-real-option", output
  end
end
