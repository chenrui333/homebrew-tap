class Paseo < Formula
  desc "Control your AI coding agents from the command-line"
  homepage "https://github.com/getpaseo/paseo"
  url "https://registry.npmjs.org/@getpaseo/cli/-/cli-0.17.5.tgz"
  sha256 "51a138b95e0deaeb0c68325696e3c436b6575e0f7ab660261d8d7a17d39e84e6"
  license "AGPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "87e7a1b3ade053c2ac4cfa6429a77b02928d7646e5d7927e6fae038f20c6a5be"
    sha256               arm64_tahoe:   "c3054e7ef6d3d2849ab65c2ef4298245a99239a3608fc4f09790ea8b9aab5cf1"
    sha256               arm64_sequoia: "c3054e7ef6d3d2849ab65c2ef4298245a99239a3608fc4f09790ea8b9aab5cf1"
    sha256 cellar: :any, arm64_linux:   "599af7cf474fb5dcec4afd6c4e80a8a7e60d853832f4c12ee5e13664b4930580"
    sha256 cellar: :any, x86_64_linux:  "9c2b1e6efe9bd3accfea81059e79b41b24a3fe716417e428aed00b1b51624a86"
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
