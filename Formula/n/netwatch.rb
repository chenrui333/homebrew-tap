class Netwatch < Formula
  desc "Real time network diagnostics in your terminal"
  homepage "https://github.com/matthart1983/netwatch"
  url "https://github.com/matthart1983/netwatch/archive/refs/tags/v0.25.7.tar.gz"
  sha256 "c363a044118c870d96a50999a989033a4b662cf0800fcfc8deb948bee99b0b2e"
  license "MIT"
  head "https://github.com/matthart1983/netwatch.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a34a76ff56ae2763a8b949c9f32c5958aad1d52025e7b6df8db82ea59f06d614"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a1a6d5d9c3e0e81f3dff6b99d01c8979a49aa2e0763a86df511094498687077"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7687d53e34afa8c7a5db6b1e02bb57e61d8ddd4f9fd004e59e13c4905e12f40c"
    sha256 cellar: :any,                 arm64_linux:   "7b6a282fcbb5ca5a5c80056db97cacdd99b3bfd6affe6310f6b98c429071e861"
    sha256 cellar: :any,                 x86_64_linux:  "94b0f2765b0c202bd178dfd99c907ab169e9fc984e7d34e6a694fc5bd3356da3"
  end

  depends_on "rust" => :build
  uses_from_macos "libpcap"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/netwatch --version")

    output = shell_output("#{bin}/netwatch --generate-config")
    assert_match "Config written to", output
  end
end
