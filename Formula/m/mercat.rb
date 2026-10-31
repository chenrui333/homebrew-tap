class Mercat < Formula
  desc "Render Markdown and Mermaid diagrams in the terminal"
  homepage "https://github.com/tawago/mercat"
  url "https://github.com/tawago/mercat/archive/refs/tags/v0.3.5.tar.gz"
  sha256 "ef7971d31c5f3bab23eb25ef7fa96927f1ac2e6c32af896e6e8b1e57e9a7d156"
  license "GPL-3.0-or-later"
  head "https://github.com/tawago/mercat.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7d45bf41af034b261eea3c47461c1514a690530db2a76b40276bea82d4582cb5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c55c025dd8452dc6101444cfa5f3c7b4c8f9417e577e70981a58f636ebddd7a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6046d7cdd05a9268cfb3d5a38eb50f3594a6e679b5cdae0ff1062f78c5d1d7c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d4a8edf5fc9178224f09529e8c3e6fc57bda71537784490b95ee78fbad1b25c"
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
