class Ctxmv < Formula
  desc "Migrate conversation sessions between AI coding agents"
  homepage "https://github.com/Ryu0118/ctxmv"
  url "https://github.com/Ryu0118/ctxmv/archive/refs/tags/0.5.5.tar.gz"
  sha256 "716a5b2ee0cb8d65e27b826ea6308ee219b78df284643cc3277858d99fa731a0"
  license "MIT"
  head "https://github.com/Ryu0118/ctxmv.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2d5fb0216a7fd6d5e7bd5c53fd966013bd7a83fedd0bbb776a26e5621a60214a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c736de809990eb2896e1caef9828a90cb2b2be5f171947f2b6277047d335db4"
    sha256 cellar: :any_skip_relocation, sequoia:       "9d9e4bd2257ad01abe3acb5b53b248c67373cb9d5342ba43ea982fb81efc7599"
  end

  depends_on xcode: ["16.0", :build]
  depends_on :macos

  on_macos do
    depends_on macos: :sequoia
  end

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
