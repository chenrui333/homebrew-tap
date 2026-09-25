class Netwatch < Formula
  desc "Real time network diagnostics in your terminal"
  homepage "https://github.com/matthart1983/netwatch"
  url "https://github.com/matthart1983/netwatch/archive/refs/tags/v0.32.3.tar.gz"
  sha256 "f91dfa39c0cf0dd721d5f8ec82bac46666c3ec2be1eb234b00b7524bc58122ba"
  license "MIT"
  head "https://github.com/matthart1983/netwatch.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "898481fd20222c8c660f09d9c038af1164d4c561ba2677ab3310edbb907fcba8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef642fa32edf3cd9655c10d63a6da5be6913c55d7d578eb4c67cf14276cf6aa9"
    sha256 cellar: :any,                 arm64_linux:   "248d44d65df0bec391dd3dd161fe102838f7890c393bbca72033568d2d6a100e"
    sha256 cellar: :any,                 x86_64_linux:  "563451f49a5d3baa53c4ffac9a8e4fc44f911ee31d05d38a4c56c955b7fb4d01"
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
