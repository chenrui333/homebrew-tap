class Paseo < Formula
  desc "Control your AI coding agents from the command-line"
  homepage "https://github.com/getpaseo/paseo"
  url "https://registry.npmjs.org/@getpaseo/cli/-/cli-0.3.0.tgz"
  sha256 "c583b394db9638a1fdcd42a8b2706531e6cf0165bbcbdd1e98980becf3850cbb"
  license "AGPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "22fc7824d7f7b73337b2b535cd8fb880f1c128fe946aa20af81de9222c45ec2d"
    sha256               arm64_sequoia: "22fc7824d7f7b73337b2b535cd8fb880f1c128fe946aa20af81de9222c45ec2d"
    sha256               arm64_sonoma:  "22fc7824d7f7b73337b2b535cd8fb880f1c128fe946aa20af81de9222c45ec2d"
    sha256 cellar: :any, arm64_linux:   "6b4437658dcaa8a6c724ff4bebd5fedc5295db1e4d3aaebeff7bfe54f7a29258"
    sha256 cellar: :any, x86_64_linux:  "9bb3377b9e7cc145466a1e11450c29979ff081b1a48905cec4a51dd95a870b09"
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
