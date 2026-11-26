class HerdrCore < Formula
  desc "Terminal runtime for coding agents"
  homepage "https://herdr.dev/core"
  url "https://github.com/herdrdev/herdr-core/archive/refs/tags/v0.1.22.tar.gz"
  sha256 "f85c123cddca40e8e4fae7ea1b416fe8a022323ea956862759a9750f76154b53"
  license all_of: ["Apache-2.0", "MIT"]

  depends_on "rust" => :build
  depends_on "zig@0.16" => :build

  # Tagged GitHub archives omit the Ghostty submodule.
  resource "ghostty" do
    url "https://github.com/ghostty-org/ghostty/archive/1e5cdb865807abc990181efb8ebfa9122955cce2.tar.gz"
    sha256 "3157b5a1ddc11040763a772a154b709ed7939a9626c3d1cd9207ebbab3fd2811"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
    resource("ghostty").stage buildpath/"vendor/ghostty"
    ENV["ZIG_GLOBAL_CACHE_DIR"] = buildpath/"zig-cache"
    # Fetch transitive lazy dependencies used when Cargo builds libghostty-vt offline.
    args = %w[--fetch=all -Demit-lib-vt -Doptimize=ReleaseFast -Dcpu=baseline]
    args << "-Demit-xcframework=false" if OS.mac?
    cd "vendor/ghostty" do
      system "zig", "build", *args
    end
  end

  def install
    ENV["ZIG_GLOBAL_CACHE_DIR"] = buildpath/"zig-cache"
    system "cargo", "install", *std_cargo_args(path: "crates/herdr-core")
    bin.install_symlink "herdr-core" => "hc"
  end

  test do
    assert_equal (bin/"herdr-core").realpath, (bin/"hc").realpath
    assert_match version.to_s, shell_output("#{bin}/hc --version")
    # The embedded integration guide is usable without starting the Core process.
    skill = shell_output("#{bin}/hc --skill")
    assert_match "hc run", skill
    assert_match "hc wait", skill
    assert_match "hc read", skill
  end
end
