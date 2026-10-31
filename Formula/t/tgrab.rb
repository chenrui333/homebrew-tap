class Tgrab < Formula
  desc "Fetch text content from YouTube, Twitter/X, and Bluesky"
  homepage "https://github.com/ryoppippi/tgrab"
  url "https://github.com/ryoppippi/tgrab/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "cc819752ec4bb8277a0735048740c5e3450f1e8aa932692cb612c188fa1c47a0"
  license "MIT"
  head "https://github.com/ryoppippi/tgrab.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e7c37d96480e03756bd381e444c398d5c01c980c1983ddb3065ac0ade941d0f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d31c4d139af985f68de5a7118e0386ad8266549ff378775af20822d56028900"
    sha256 cellar: :any,                 arm64_linux:   "9e5097689fab61f032df839a39dc0a7e53290a3807c090a974e1f4769c7e909c"
    sha256 cellar: :any,                 x86_64_linux:  "2c850c67f3ac7ea52bd0b9ff39f2c142b55257b1d74d58613d5d4e3585b1dd2e"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  deny_network_access!

  def fetch
    # Cargo.lock pins impit and its browser-impersonation TLS/HTTP forks.
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV.append "RUSTFLAGS", "--cfg reqwest_unstable"
    system "cargo", "install", *std_cargo_args
  end

  test do
    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    output = shell_output("#{bin}/tgrab https://example.com/unsupported 2>&1", 1)
    assert_match "Unsupported URL: https://example.com/unsupported", output

    output = shell_output("#{bin}/tgrab https://youtube.com/watch?v=short 2>&1", 1)
    assert_match "Unsupported URL: https://youtube.com/watch?v=short", output
  end
end
