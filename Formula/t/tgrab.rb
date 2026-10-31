class Tgrab < Formula
  desc "Fetch text content from YouTube, Twitter/X, and Bluesky"
  homepage "https://github.com/ryoppippi/tgrab"
  url "https://github.com/ryoppippi/tgrab/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "cc819752ec4bb8277a0735048740c5e3450f1e8aa932692cb612c188fa1c47a0"
  license "MIT"
  head "https://github.com/ryoppippi/tgrab.git", branch: "main"

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
