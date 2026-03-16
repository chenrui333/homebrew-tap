class Ctxmv < Formula
  desc "Migrate conversation sessions between AI coding agents"
  homepage "https://github.com/Ryu0118/ctxmv"
  url "https://github.com/Ryu0118/ctxmv/archive/refs/tags/0.3.0.tar.gz"
  sha256 "d03bdba5b269634cef483ead97b04bdfb08dafd2917532e1d9fb4a82c4845977"
  license "MIT"
  head "https://github.com/Ryu0118/ctxmv.git", branch: "main"

  depends_on xcode: ["16.0", :build]
  depends_on :macos
  depends_on macos: :sequoia

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/ctxmv"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ctxmv --version")
    output = shell_output("#{bin}/ctxmv list --source codex --project #{testpath} --limit 1")
    assert_match "No sessions found.", output
  end
end
