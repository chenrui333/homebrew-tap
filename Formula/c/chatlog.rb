class Chatlog < Formula
  desc "Easily use your own chat data"
  homepage "https://github.com/sjzar/chatlog"
  url "https://github.com/sjzar/chatlog/archive/refs/tags/v0.0.18.tar.gz"
  sha256 "9ab5b5ae4d245d9b6d2a2dfa8c23272dd56f1766d95c1549c14cac43b3c776c7"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41002d8dbbf1cd51fa7c83ac1c31913543e639d7352d0e1f895bce855cc9455a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "90c288f79ac7e80496571f5bfbf744eaee22681aef3d96bbc4e91471a2a7232a"
    sha256 cellar: :any_skip_relocation, ventura:       "ec6967a749f4a238fb9a57b45d649ad994115c1df97d9f0feb812a58e60d85b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3a5fb2816cfdd82d9ca0b2ba8363c3e0996bc52f214dc404b41318f6951da1a"
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
