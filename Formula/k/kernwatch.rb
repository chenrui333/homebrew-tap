class Kernwatch < Formula
  desc "Linux kernel observability terminal"
  homepage "https://github.com/matthart1983/kernwatch"
  url "https://github.com/matthart1983/kernwatch/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "9596b3b28b8764e4320d0d8e5ec0528cb82733e8f1587c949d82ae1bcb47c1b3"
  license "MIT"
  head "https://github.com/matthart1983/kernwatch.git", branch: "main"

  depends_on "llvm" => :build
  depends_on "rust" => :build
  depends_on :linux

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # Rebuild the embedded probes rather than using the checked-in objects.
    rm "probes/kernwatch.bpf.o"
    rm "probes/kernwatch-aarch64.bpf.o"
    ENV["CLANG"] = formula_opt_bin("llvm")/"clang"
    system "sh", "probes/build.sh"
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kernwatch --version")
    snapshot = JSON.parse(shell_output("#{bin}/kernwatch --demo --snapshot"))
    assert_equal true, snapshot.fetch("demo")
    assert_equal 32768, snapshot.fetch("mem_total")
    assert_match "NET_RX", snapshot.fetch("findings").join("\n")
  end
end
