class Mercat < Formula
  desc "Render Markdown and Mermaid diagrams in the terminal"
  homepage "https://github.com/tawago/mercat"
  url "https://github.com/tawago/mercat/archive/refs/tags/v0.3.4.tar.gz"
  sha256 "4b720d1736ecc51113ad9cd283a18e4d62854b87fef416ddd29b98237cdc9903"
  license "GPL-3.0-or-later"
  head "https://github.com/tawago/mercat.git", branch: "main"

  depends_on "zig" => :build

  deny_network_access!

  def fetch
    ENV["ZIG_GLOBAL_CACHE_DIR"] = (buildpath/"zig-cache").to_s
    system "zig", "build", "--fetch=all"
    # Lazy dependencies also have their own pinned source dependency closures.
    cache = Pathname(ENV.fetch("ZIG_GLOBAL_CACHE_DIR"))
    fetched = []
    loop do
      urls = cache.glob("p/*/build.zig.zon").flat_map { |zon| zon.read.scan(/\.url\s*=\s*"([^"]+)"/).flatten }
      urls = urls.uniq - fetched
      break if urls.empty?

      urls.each { |url| system "zig", "fetch", url }
      fetched.concat(urls)
    end
  end

  def install
    ENV["ZIG_GLOBAL_CACHE_DIR"] = (buildpath/"zig-cache").to_s
    system "zig", "build", *std_zig_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mercat --version")
    output = pipe_output(bin/"mercat", "flowchart LR\n  Alpha-->Beta\n", 0)
    assert_match "Alpha", output
    assert_match "Beta", output
    assert_match "Offline heading", pipe_output(bin/"mercat", "# Offline heading\n\nHello Homebrew.\n", 0)
  end
end
