class MoltbookTui < Formula
  desc "TUI client for Moltbook, the social network for AI Agents"
  homepage "https://terminaltrove.com/moltbook-tui/"
  url "https://github.com/terminaltrove/moltbook-tui/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "b970101d47776b976ef848424454742a047fcaf1b4fb24f4d0bc4bfdc5b954b7"
  license "MIT"
  revision 1
  head "https://github.com/terminaltrove/moltbook-tui.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "675aef58c095808c2b5a095d7ccafc742724c9951d6d90b4c82757068517bf32"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "259d19bd55546817539b80f5f022e2608e8634d79a562568576780ec7b03f81e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "863599e371cb359327b3098dadca5465c72b16d854e16230b2812b19c1924539"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b266a9b56ea3fdbbda7f6d937a15154b4b9a9be1c0d5e0c6ff3a641ea45dbb5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa0b43be778504094a68663399c97800f564bbd9b85d335b4c97562bec415472"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/moltbook --version")

    ENV["TERM"] = "xterm"
    cmd = if OS.mac?
      "printf 'q' | script -q /dev/null #{bin}/moltbook --no-refresh"
    else
      "printf 'q' | script -q -c '#{bin}/moltbook --no-refresh' /dev/null"
    end

    assert system(cmd)
  end
end
