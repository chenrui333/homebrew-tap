class Paseo < Formula
  desc "Control your AI coding agents from the command-line"
  homepage "https://github.com/getpaseo/paseo"
  url "https://registry.npmjs.org/@getpaseo/cli/-/cli-0.8.0.tgz"
  sha256 "1275362b8b854d20448b3a388d4298bce2a84bcb99dee620115f91ca97327438"
  license "AGPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "38ad34545c78c19dbcb355d72d2cfa97fd0b1836a12b030bc24d28795a2d65ef"
    sha256               arm64_sequoia: "38ad34545c78c19dbcb355d72d2cfa97fd0b1836a12b030bc24d28795a2d65ef"
    sha256 cellar: :any, arm64_linux:   "72639cfd65eb4296336439910a148c14cbba39d687e2b832cc6489a4e8e5460d"
    sha256 cellar: :any, x86_64_linux:  "141f4b21d022dd39f1ad24b08e0f501441e2c60c4d2629114b2ca48c67293050"
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
