class Ctxmv < Formula
  desc "Migrate conversation sessions between AI coding agents"
  homepage "https://github.com/Ryu0118/ctxmv"
  url "https://github.com/Ryu0118/ctxmv/archive/refs/tags/0.4.0.tar.gz"
  sha256 "061aa4cc08a96851ab0a8f1b5bfca2db4a1bdcfe4850ad5db5ef186b3602c234"
  license "MIT"
  head "https://github.com/Ryu0118/ctxmv.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d790d3e31db55aff29fd412aab292c432c58f063bfdd6123732a018469e4cca4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04ef0a8ef26bfd5d00a5c42dd2ada485aab257d1051d899dfc6a61e909361632"
    sha256 cellar: :any_skip_relocation, sequoia:       "de225d925afc527a2da5055c739367bf048eb47bb8888c06fbbdb8a0c0a825a0"
  end

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
