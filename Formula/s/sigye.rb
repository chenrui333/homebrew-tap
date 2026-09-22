class Sigye < Formula
  desc "Feature-rich terminal clock with ASCII art fonts"
  homepage "https://github.com/am2rican5/sigye"
  url "https://github.com/am2rican5/sigye/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "8a5b440ee53d574af35eed8c85455ab5bd413052ee6fb8534d2e954b6530deac"
  license "MIT"
  head "https://github.com/am2rican5/sigye.git", branch: "main"

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked", "--manifest-path", buildpath/"Cargo.toml"
  end

  def install
    ENV["CARGO_NET_OFFLINE"] = "true"
    system "cargo", "install", *std_cargo_args(path: "crates/sigye")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sigye --version")
    output = shell_output("#{bin}/sigye --once --format unix")
    assert_match(/\A\d+\n\z/, output)
  end
end
