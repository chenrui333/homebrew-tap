class Paseo < Formula
  desc "Control your AI coding agents from the command-line"
  homepage "https://github.com/getpaseo/paseo"
  url "https://registry.npmjs.org/@getpaseo/cli/-/cli-0.7.0.tgz"
  sha256 "b3329fbae6e2da87b1feb36fa8c9a07367ee967d40239544c8f7c52af8ebe0c1"
  license "AGPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "70d81bccde2f8968291757fcb4de76e4c10b4a7d5dbb24b911f14081cbbc9be3"
    sha256               arm64_sequoia: "70d81bccde2f8968291757fcb4de76e4c10b4a7d5dbb24b911f14081cbbc9be3"
    sha256               arm64_sonoma:  "70d81bccde2f8968291757fcb4de76e4c10b4a7d5dbb24b911f14081cbbc9be3"
    sha256 cellar: :any, arm64_linux:   "cd14022252b3804b572c823a4ad3fb3bf5416ff2ef74e97a4a43fb1dfea9bc08"
    sha256 cellar: :any, x86_64_linux:  "f1046f4a730d6523238b09ad3ad4cbf24b0250900e3aa07ef2345ff91b8fab93"
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
