class Paseo < Formula
  desc "Control your AI coding agents from the command-line"
  homepage "https://github.com/getpaseo/paseo"
  url "https://registry.npmjs.org/@getpaseo/cli/-/cli-0.1.101.tgz"
  sha256 "38ef371ff05c642124b433c7d34d58f751ea71b900a6070a504ad3ede859dcd7"
  license "AGPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "8f3baa113cd462409542f0b86280be0f568f6b2a9ac35af4aa11ecea4f0ff6dd"
    sha256               arm64_sequoia: "9becf89aff8ce893cc2f042354e72b20ccc2e6128f18e4f68d6e432d626c942d"
    sha256               arm64_sonoma:  "9becf89aff8ce893cc2f042354e72b20ccc2e6128f18e4f68d6e432d626c942d"
    sha256 cellar: :any, arm64_linux:   "9ba071bed54609a391c299e928494b91d2801965e27d4c138f1c04a53dce0ce5"
    sha256 cellar: :any, x86_64_linux:  "96b6da5a1b9049b9ab12f28fa426e08f4531edac4461e57cd97f01976944575c"
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
