class Filessh < Formula
  desc "Fast and convenient TUI file browser for remote servers"
  homepage "https://github.com/JayanAXHF/filessh"
  url "https://github.com/JayanAXHF/filessh/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "4398d76a41f66c0892e00136f7d9804b95f2f25b48c6f913bdab9e1e175baed7"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/JayanAXHF/filessh.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "09cabe80712914b740083bfde5a8e3f98e69d3690cabefabf091ea14873532de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf2f7c440b483e3909f3c76a365de9cec2b06f309e8f49c300cb11e328501d11"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e38d5443d00e8235715dd2d9cee3766ac08aa2a0ffe5b7a07cd5a45a3c72ed9b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5c5782d12d97952bc9434ea9f215b7080325c4cfc22bb7178a8a7dc3dfab365"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ab1a6bb5c29335c5d3939063e366e3bbaaa3c2f1084a57d847b1683b4325587"
  end

  depends_on "rust" => :build

  def install
    ENV["VERGEN_GIT_BRANCH"] = "main"
    ENV["VERGEN_GIT_COMMIT_TIMESTAMP"] = time.iso8601
    ENV["VERGEN_GIT_SHA"] = tap.user

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/filessh --version")
    assert_match "You must provide a host", shell_output("#{bin}/filessh connect 2>&1", 1)
  end
end
