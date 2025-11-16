class Xleak < Formula
  desc "Terminal Excel viewer with an interactive TUI"
  homepage "https://github.com/bgreenwell/xleak"
  url "https://github.com/bgreenwell/xleak/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "f5d95817d3729ed47f45afa499e7de7209cb41a5bc44fc1a9d121b14d9838191"
  license "MIT"
  head "https://github.com/bgreenwell/xleak.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1485eb2196a70f10b28cf30c9667ecbabd339d58c064af372da8d23d4e777c11"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "899ee0cac191f45ea20386f7fc7ebe7131926f72b1b3875d1639968ca47be329"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39228dd3d0ac4eaf56a2a0187a0911bcf436920433332e53cd4893def68958d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55360688f5aaffbb67b1b982ef076c056df9e7522dd0b35c1f818442491b5862"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9df1b050d9a1203cb2fbf97746aa97b370a1f06f11861d09f46c2222f3e34616"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xleak --version")

    resource "testfile" do
      url "https://github.com/chenrui333/github-action-test/releases/download/2025.11.16/test.xlsx"
      sha256 "1231165a2dcf688ba902579f0aafc63fc1481886c2ec7c2aa0b537d9cfd30676"
    end

    testpath.install resource("testfile")
    output = shell_output("#{bin}/xleak #{testpath}/test.xlsx")
    assert_match "Total: 5 rows × 2 columns", output
  end
end
