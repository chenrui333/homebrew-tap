class Paseo < Formula
  desc "Control your AI coding agents from the command-line"
  homepage "https://github.com/getpaseo/paseo"
  url "https://registry.npmjs.org/@getpaseo/cli/-/cli-0.11.0.tgz"
  sha256 "823040e94cd7d1ad631e8248e2d05d2bb647a1610f33bfe574abc4d37b7d129b"
  license "AGPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "894ebe52ca07cb4ab3306f5d202ed326ab30ec5ab9438b6a44397f817e3f4953"
    sha256               arm64_sequoia: "894ebe52ca07cb4ab3306f5d202ed326ab30ec5ab9438b6a44397f817e3f4953"
    sha256 cellar: :any, arm64_linux:   "c64c85413aa98751ba9c116fe2a2159068a1a9f807542201d830ca49de769fc8"
    sha256 cellar: :any, x86_64_linux:  "585bb9d0b0a951d0585013f51cf1cae6c1e5c185e8c3e850aed8012b769f2019"
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
    native_prebuild = "#{OS.mac? ? "darwin" : "linux"}-#{Hardware::CPU.arm? ? "arm64" : "x64"}"
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
