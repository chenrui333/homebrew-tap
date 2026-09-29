class DiTui < Formula
  desc "Simple terminal UI player for di.fm"
  homepage "https://github.com/acaloiaro/di-tui"
  url "https://github.com/acaloiaro/di-tui/archive/1d6166e390718df19aaff28b0e15dd47a465edee.tar.gz"
  version "1.15.0"
  sha256 "7fbb6d97d835879a1ff310e46f252ebcc636b1f7ff9f83eb987175dffd17dec4"
  license "BSD-2-Clause"
  head "https://github.com/acaloiaro/di-tui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7d8ae661c79a4a2f1ad65810583b630f4026b3f20875e0305460ecf768ceb4b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d8ae661c79a4a2f1ad65810583b630f4026b3f20875e0305460ecf768ceb4b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d8ae661c79a4a2f1ad65810583b630f4026b3f20875e0305460ecf768ceb4b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e019b074f71db7312fbd4c23b9cc693c4b1963162142b279ab4434f76e800292"
    sha256 cellar: :any,                 x86_64_linux:  "fe35a26750b3d2cf03ceafdcdb4f7cdd48345e837b687449ad371c1af5f6044d"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/di-tui --version")
    output = shell_output("#{bin}/di-tui --not-a-real-flag 2>&1", 2)
    assert_match "not-a-real-flag", output
  end
end
