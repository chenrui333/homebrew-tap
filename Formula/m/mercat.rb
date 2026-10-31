class Mercat < Formula
  desc "Render Markdown and Mermaid diagrams in the terminal"
  homepage "https://github.com/tawago/mercat"
  url "https://github.com/tawago/mercat/archive/refs/tags/v0.3.5.tar.gz"
  sha256 "ef7971d31c5f3bab23eb25ef7fa96927f1ac2e6c32af896e6e8b1e57e9a7d156"
  license "GPL-3.0-or-later"
  head "https://github.com/tawago/mercat.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e667815327f998978cf700e5e4820f65e6a74369650438671d5be5e2801e95f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec96ee2fb8a946d0103961bfddc1d8461dc0a0965784b250f1f6084de6b36764"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ca3af11d2da79c577ecab4389c2a1ca8652072f00e90444cff10b915e4f006a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "54ca16797fd3f2b08f45dfc04509d76051b84cafb305d4f6a3b7306e6c43e658"
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
