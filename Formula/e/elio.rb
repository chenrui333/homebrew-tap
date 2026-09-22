class Elio < Formula
  desc "Terminal file manager with rich previews and inline images"
  homepage "https://elio-fm.github.io/docs/"
  url "https://github.com/elio-fm/elio/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "89c8bcb656dbee17cccfd4b0e676523bc1f3ff34c63a84ab8327646ce72984c6"
  license "MIT"
  head "https://github.com/elio-fm/elio.git", branch: "main"

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
