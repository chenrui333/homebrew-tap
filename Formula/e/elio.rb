class Elio < Formula
  desc "Terminal file manager with rich previews and inline images"
  homepage "https://elio-fm.github.io/docs/"
  url "https://github.com/elio-fm/elio/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "89c8bcb656dbee17cccfd4b0e676523bc1f3ff34c63a84ab8327646ce72984c6"
  license "MIT"
  head "https://github.com/elio-fm/elio.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b4b8371a895812e2337ad2adc88b2821c8a0a8075d07c8c59aa90fc9f0bcee1d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9214e49c614c49cbff12c0e32a731fc27023e65a4a269744a43967ef9086551"
    sha256 cellar: :any,                 arm64_linux:   "f29c42204929d1d0a7ea8908e9de93a76ec7e1284381a89584bb03128df547ae"
    sha256 cellar: :any,                 x86_64_linux:  "315bc142c1c38d9256d7fd4281759b6c229bc21eff9ca475a130d929e0c850f4"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked"
  end

  def install
    ENV["CARGO_NET_OFFLINE"] = "true"
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/elio --version")
    assert_match "elio() {", shell_output("#{bin}/elio shell init zsh")
  end
end
