class Mercat < Formula
  desc "Render Markdown and Mermaid diagrams in the terminal"
  homepage "https://github.com/tawago/mercat"
  url "https://github.com/tawago/mercat/archive/refs/tags/v0.3.8.tar.gz"
  sha256 "bca35f10da27c4e936b6d8b56b1b9d4634cf23cfb22f42886f53af4cc376d6ee"
  license "GPL-3.0-or-later"
  head "https://github.com/tawago/mercat.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d4a156b82de57fc086117d6753b493944662bd9d6aeef5a7e3fa0239c4bcd18a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44840a189325c57217ce09430293a51f4a5629a7cdc302416fc1ab0c1dfc0001"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6873a4eaf1f12e2b4914c28bae0ae55cd4951e12930587b3bfaf75edcba3cd3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3c9a19d61ad4c3aa967474766fa9faa7544ec00f9b79c68237680033e459487"
  end

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
