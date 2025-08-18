class Chatlog < Formula
  desc "Easily use your own chat data"
  homepage "https://github.com/sjzar/chatlog"
  url "https://github.com/sjzar/chatlog/archive/refs/tags/v0.0.18.tar.gz"
  sha256 "9ab5b5ae4d245d9b6d2a2dfa8c23272dd56f1766d95c1549c14cac43b3c776c7"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48098291f9fc9f74b54579a5bc0d04c5feae9baa4234ee162222d38698ac9721"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42c502eb8068cc1afd24f137d77963929206dd2c66e91b1a79cabb8a320aa765"
    sha256 cellar: :any_skip_relocation, ventura:       "d89e1440a69114a2ebcbcc7faa3be354ccbe019297feb73b87e1e359a83d4c30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01c85eeb63e78c379f093c3f48cafd27456b313693ebb4d06acef0edfe3e2bc6"
  end

  depends_on "go" => :build

  def install
    # Prevent init() from overwriting ldflags version
    inreplace "pkg/version/version.go",
              "if len(bi.Main.Version) > 0",
              "if len(bi.Main.Version) > 0 && Version == \"(dev)\""

    ldflags = "-s -w -X github.com/sjzar/chatlog/pkg/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chatlog version")
    assert_match "failed to get key", shell_output("#{bin}/chatlog key 2>&1")
  end
end
