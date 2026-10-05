class Netwatch < Formula
  desc "Real time network diagnostics in your terminal"
  homepage "https://github.com/matthart1983/netwatch"
  url "https://github.com/matthart1983/netwatch/archive/refs/tags/v0.35.3.tar.gz"
  sha256 "27cfa869f22d903e40b481ab61a60a9679afccbee5b622439243be4ebf722958"
  license "MIT"
  head "https://github.com/matthart1983/netwatch.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5eb4a20f762ae115ff0c9a7a0e84bda198fe15ccc53a429a09d79562077f871b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77e1962516372e96bc503286a03e6eeeab1056d7b8298e223b73a9cab6179d11"
    sha256 cellar: :any,                 arm64_linux:   "37dc3da568419a33d932ea6d6384d7297b6310f7efbb03d008fa760e09317647"
    sha256 cellar: :any,                 x86_64_linux:  "bb92c5576f429be2b066d534367ff7dd4fae59fd2af8a694142fbc8a1c702c69"
  end

  depends_on "rust" => :build
  uses_from_macos "libpcap"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/netwatch --version")

    output = shell_output("#{bin}/netwatch --generate-config")
    assert_match "Config written to", output
  end
end
