class Paseo < Formula
  desc "Control your AI coding agents from the command-line"
  homepage "https://github.com/getpaseo/paseo"
  url "https://registry.npmjs.org/@getpaseo/cli/-/cli-0.5.0.tgz"
  sha256 "695addadd52885a27e1b5293c93a497b26a2f49057afb1759ed21d45e77bd17e"
  license "AGPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "e4cae22fd392ba464af4a561c716c575c91eaa4a988ebeea8a55c79750d5db02"
    sha256               arm64_sequoia: "e4cae22fd392ba464af4a561c716c575c91eaa4a988ebeea8a55c79750d5db02"
    sha256               arm64_sonoma:  "e4cae22fd392ba464af4a561c716c575c91eaa4a988ebeea8a55c79750d5db02"
    sha256 cellar: :any, arm64_linux:   "e829acec0bab323fa42f2ff6b499732b359ee28864cdb72437271164b685284c"
    sha256 cellar: :any, x86_64_linux:  "92800f755f1edb211e4c62c1d94a62b928276002a43bfcfa0eabf5a5b1daec09"
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
