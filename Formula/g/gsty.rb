class Gsty < Formula
  desc "Browse and apply Ghostty themes"
  homepage "https://github.com/tappunk/gsty"
  url "https://github.com/tappunk/gsty/archive/refs/tags/v0.1.19.tar.gz"
  sha256 "baa2f0a7b4e6c12c26f39c6418561039b96719a9d3f542befdc3c08f5095c11c"
  license "MIT"
  head "https://github.com/tappunk/gsty.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "85409b7617c41f72b46f938d869e1d7c50b864097af800c0a801ff1b8f172022"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de7c78fee6b58b9f3de659541bbc4f6fa10f6e2b548eb76340ac56036de03953"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e59683ec92feb4b813cb3007dcba2f8af422e101e03bf6eda22db658a01eb559"
    sha256 cellar: :any,                 arm64_linux:   "a060f5652329130e0fa54205a56278adf4c435fa2b1c3e82a4ae17f095644cf7"
    sha256 cellar: :any,                 x86_64_linux:  "a926849a1787310774c1d7ed0d56c79f5255d7a50a3d711f66a7fade5cc618d3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gsty --version")
    (testpath/".config/ghostty/themes/brew-test").write("background = #000000\nforeground = #ffffff\n")
    assert_match "brew-test", shell_output("#{bin}/gsty --list")
  end
end
