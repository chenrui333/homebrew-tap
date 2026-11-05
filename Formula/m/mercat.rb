class Mercat < Formula
  desc "Render Markdown and Mermaid diagrams in the terminal"
  homepage "https://github.com/tawago/mercat"
  url "https://github.com/tawago/mercat/archive/refs/tags/v0.3.8.tar.gz"
  sha256 "bca35f10da27c4e936b6d8b56b1b9d4634cf23cfb22f42886f53af4cc376d6ee"
  license "GPL-3.0-or-later"
  head "https://github.com/tawago/mercat.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0b9b4b5d1e572e099d643e47b31f0eef7d82b7a0c66109786cc3996ff63f76cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4d54f9ad501ca87ad3cb7bdb867bb26a761e1bc42da941bc64669ede16db3f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a77b99771675ca64a0e7019ae11cdf6346d65780c15d0b0596b33899bca28c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3a39a9b1832d8d0d1225160f15e5972e8a660c9ca98c50a4055f1383446b3b4"
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
