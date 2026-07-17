class Paseo < Formula
  desc "Control your AI coding agents from the command-line"
  homepage "https://github.com/getpaseo/paseo"
  url "https://registry.npmjs.org/@getpaseo/cli/-/cli-0.1.110.tgz"
  sha256 "a24fbb856c628e93310b755ef0b9810cc694396188eeae676119b6fa1b23ca24"
  license "AGPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "db996986b431d91ddb7f9596f09ca231c5aee85814cb54ca091edcd256c44145"
    sha256               arm64_sequoia: "db996986b431d91ddb7f9596f09ca231c5aee85814cb54ca091edcd256c44145"
    sha256               arm64_sonoma:  "db996986b431d91ddb7f9596f09ca231c5aee85814cb54ca091edcd256c44145"
    sha256 cellar: :any, arm64_linux:   "2c2f0e47f3d7d29b931bf7945157036600fa13ed0b821a08378232155bf672b0"
    sha256 cellar: :any, x86_64_linux:  "b9b0572d51aac4063fd91479c27cf63ca57e94c63eaf33cebd2f0cf18ab59997"
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
