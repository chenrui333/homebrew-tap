class Sidecar < Formula
  desc "Terminal UI for diffs, file trees, conversation history, and tasks"
  homepage "https://github.com/marcus/sidecar"
  url "https://github.com/marcus/sidecar/archive/refs/tags/v0.78.0.tar.gz"
  sha256 "e3467039423f63accea8c711e8664d24ca58e8c116a3b760ee83eeb7200214cc"
  license "MIT"
  head "https://github.com/marcus/sidecar.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "38354be47e8da30c973a7cee6baa408bb3b3fe77a9bccb128669a00e6d658eb3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a5f9d5507811a679f64b6be7cd9ae24231eba2eebc90e1cd78eded669eed23b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "366aa75773194d9228f4c0475b690c314b389dbf9cb28d7308dbc9f2affe7007"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "93ada70e26c4f7b1d9374ce412eb3f69f8d74e2c68d2e9fa84b4d0b44cf983ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6565a57dec575b6f37da3ee14a4f65224842a1c0ff2e3f041ad8d8c3f75c7b54"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version}"

    system "go", "build", *std_go_args(ldflags:, output: bin/"sidecar"), "./cmd/sidecar"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sidecar --version")
    assert_match "sidecar requires an interactive terminal",
                 shell_output("#{bin}/sidecar --project #{testpath} 2>&1", 1)
  end
end
