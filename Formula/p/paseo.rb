class Paseo < Formula
  desc "Control your AI coding agents from the command-line"
  homepage "https://github.com/getpaseo/paseo"
  url "https://registry.npmjs.org/@getpaseo/cli/-/cli-0.1.105.tgz"
  sha256 "480acfc4227623781c9dcc5ec3a01e9eb123373efb7d77221f6009e82c5f522d"
  license "AGPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "ab92513d6f8bfacdd6422ecf29f1a0430244d960d306177fe9c39e08d552c881"
    sha256               arm64_sequoia: "5a8820b82263f9f6a45e1f6934a7e154b249c5caa5fec00763592964188b0942"
    sha256               arm64_sonoma:  "5a8820b82263f9f6a45e1f6934a7e154b249c5caa5fec00763592964188b0942"
    sha256 cellar: :any, arm64_linux:   "d8b02c7f7d1185ce8f1fc359e8adfe59e8a2a015f0115f6f1ed694b0982ea5aa"
    sha256 cellar: :any, x86_64_linux:  "21316a91ff83000d58048d08ee4e03383aa13c38beb5efa6582a11a261db1c94"
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
