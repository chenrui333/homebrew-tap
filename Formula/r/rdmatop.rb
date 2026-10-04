class Rdmatop < Formula
  desc "Real-time terminal monitor for RDMA network interfaces"
  homepage "https://github.com/uccl-project/rdmatop"
  # The published Cargo source package includes the release's lockfile.
  url "https://static.crates.io/crates/rdmatop/rdmatop-0.1.32.crate"
  sha256 "58c029e0540867e4b210f885b5e8c31585a6586456c6534fabc14d7f8aab4e67"
  license "Apache-2.0"
  head "https://github.com/uccl-project/rdmatop.git", branch: "main"

  depends_on "rust" => :build
  depends_on :linux

  deny_network_access!

  def fetch
    system "cargo", "generate-lockfile" if build.head?
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # FIXME: Upstream does not expose a version command; replace with a version assertion when available.
    output = shell_output("#{bin}/rdmatop --format json 2>&1", 1)
    assert_match "unsupported format: json", output
    output = shell_output("#{bin}/rdmatop --format csv --output #{testpath}/trace.csv --device none --port 0 2>&1", 1)
    assert_match "port must be positive", output
  end
end
