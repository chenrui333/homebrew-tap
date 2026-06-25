class Diffcat < Formula
  desc "TUI for visualizing git diffs"
  homepage "https://github.com/trebaud/diffcat"
  url "https://github.com/trebaud/diffcat/archive/refs/tags/v0.16.2.tar.gz"
  sha256 "df9daaee935c31cb89b64437121d8acb80d0f2d08f2dbb6e732cabf7106bde72"
  license "MIT"
  head "https://github.com/trebaud/diffcat.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c991cc985f1b8df7e53783b1f2dd1c3bf11e67a2f29079d972048a1ac2d6a5a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c991cc985f1b8df7e53783b1f2dd1c3bf11e67a2f29079d972048a1ac2d6a5a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c991cc985f1b8df7e53783b1f2dd1c3bf11e67a2f29079d972048a1ac2d6a5a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f383144173959252b5b9985873a5d33e47a30ac74ac4960cc370237aa83bd73"
    sha256 cellar: :any,                 x86_64_linux:  "3a36eabd5552cc99b3c6a302f16843ab88e84534438e4fb26c903bf6c70170e2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.ldflagsVersion=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/diffcat"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/diffcat --version")
    output = shell_output("#{bin}/diffcat not-a-real-command 2>&1", 1)
    assert_match "not a git repository", output
  end
end
