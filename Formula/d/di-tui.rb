class DiTui < Formula
  desc "Simple terminal UI player for di.fm"
  homepage "https://github.com/acaloiaro/di-tui"
  url "https://github.com/acaloiaro/di-tui/archive/refs/tags/v1.15.0.tar.gz"
  sha256 "b083c501064ad85901a57537706256d3e83d0c3b3ef5d6990304e7f98f883310"
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

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/di-tui --version")
    output = shell_output("#{bin}/di-tui --not-a-real-flag 2>&1", 2)
    assert_match "not-a-real-flag", output
  end
end
