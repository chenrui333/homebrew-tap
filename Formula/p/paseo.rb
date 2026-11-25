class Paseo < Formula
  desc "Control your AI coding agents from the command-line"
  homepage "https://github.com/getpaseo/paseo"
  url "https://registry.npmjs.org/@getpaseo/cli/-/cli-0.17.4.tgz"
  sha256 "1dbfffdc99718374801e787b6948f350bd2f63459e2031053c42534c1e078504"
  license "AGPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "8abc5daec2bab2bc2c31a226e3f4041298060e5f4b7aa85007d3f5a4e4dc279c"
    sha256               arm64_tahoe:   "58cfd82b4793b2ad91601d4630ee1f73581544c077fb21976875264df767ef5e"
    sha256               arm64_sequoia: "58cfd82b4793b2ad91601d4630ee1f73581544c077fb21976875264df767ef5e"
    sha256 cellar: :any, arm64_linux:   "73e4b2029da1efc26c84d3fbcce674cca89b78ad33a03014df3cf7cb1d83f826"
    sha256 cellar: :any, x86_64_linux:  "323f91fa42ee3db844a71d45f4f773c0c197a867bb17f511b5e29865a5697c78"
  end

  depends_on "node"

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    rm_r buildpath/"npm-fetch"
    system "npm", "install", "--offline", *std_npm_args

    # Keep only the native node-pty prebuild to avoid shipping non-native binaries.
    node_pty_prebuilds = libexec/"lib/node_modules/@getpaseo/cli/node_modules/node-pty/prebuilds"
    os = OS.mac? ? "darwin" : "linux"
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    native_prebuild = "#{os}-#{arch}"
    node_pty_prebuilds.children.each do |prebuild|
      rm_r prebuild if prebuild.basename.to_s != native_prebuild
    end

    # Homebrew Linux uses glibc; the optional musl binaries reference libc.so.
    if OS.linux?
      libexec.glob("lib/node_modules/@getpaseo/cli/node_modules/@msgpackr-extract/*/*.musl.node").each do |file|
        rm file
      end
    end

    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/paseo --version")
    output = shell_output("#{bin}/paseo --not-a-real-option 2>&1", 1)
    assert_match "not-a-real-option", output
  end
end
