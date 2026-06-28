class Ctxmv < Formula
  desc "Migrate conversation sessions between AI coding agents"
  homepage "https://github.com/Ryu0118/ctxmv"
  url "https://github.com/Ryu0118/ctxmv/archive/refs/tags/0.5.4.tar.gz"
  sha256 "558858ec11c75dd8eae90673ea28c67a7488dc19ea052f02c76419e1dbc1126f"
  license "MIT"
  head "https://github.com/Ryu0118/ctxmv.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e955d77a2195f24d15655ef1484084c123d7d71b68ec8b9320b9e2d93c6b30a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5f7ae91029c70915a549ac094778d45cb981a463ac395cd7e28e92444d6b908"
    sha256 cellar: :any_skip_relocation, sequoia:       "553ea4f0111821f5bd6a3072d971959f1152a83062398aecfa6e46a6be005ad7"
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
