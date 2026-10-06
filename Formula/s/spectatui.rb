class Spectatui < Formula
  desc "Terminal dashboard for GitHub Spec-Kit"
  homepage "https://github.com/tinesoft/spectatui"
  url "https://github.com/tinesoft/spectatui/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "73255d747dc31fc97b78d6a52750aaa7fedb4fcda85861a9b3bddc22e08986d4"
  license "MIT"
  head "https://github.com/tinesoft/spectatui.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fd86d52168edcbcf523014128c3f8010c44dbf3394afdb014fb195c3251ef67e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "644334dad51d5f2c93ec458406187ad11029908804090ba688895a85ed34887f"
    sha256 cellar: :any,                 arm64_linux:   "e423d91a438d91f1fce27a7d478f507d333e01eea64c4551cedb336862b27b41"
    sha256 cellar: :any,                 x86_64_linux:  "66490f90b4d7470749db7648158fcda2e9f151246e1cbd9a6c5f3c2703a429c1"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/spectatui")
  end

  test do
    # TODO: Upstream does not expose a version command; add a version assertion when available.
    output = shell_output("#{bin}/spectatui --project #{testpath}/missing 2>&1", 1)
    assert_match "failed to discover project", output
    assert_match "project root not found", output
  end
end
