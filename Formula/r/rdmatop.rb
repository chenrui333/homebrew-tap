class Rdmatop < Formula
  desc "Real-time terminal monitor for RDMA network interfaces"
  homepage "https://github.com/uccl-project/rdmatop"
  # The published Cargo source package includes the release's lockfile.
  url "https://static.crates.io/crates/rdmatop/rdmatop-0.1.33.crate"
  sha256 "7cbc1dfe0071ee05b84cf78815d0060c6e75f6a6b09f6e109d6d392ce6e9c0e0"
  license "Apache-2.0"
  head "https://github.com/uccl-project/rdmatop.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_linux:  "2baf5f0863820774a0821c1354233015f1abc50ec51042d7f7d3060c63388d79"
    sha256 cellar: :any, x86_64_linux: "7c19cb1db0bdbc5ff2cd1424882dd06913453a49c952a0dc0a464ca335137ea3"
  end

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
