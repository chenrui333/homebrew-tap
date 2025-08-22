class Chatlog < Formula
  desc "Easily use your own chat data"
  homepage "https://github.com/sjzar/chatlog"
  url "https://github.com/sjzar/chatlog/archive/refs/tags/v0.0.20.tar.gz"
  sha256 "74eae6595f72ef5aa053e363af0cae240ee6ff5fb9a605a8cdfaed2c8db06bf2"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "818acd9ed28d15de768b6bf9de4d65710b901a5f032557f1dae2a58c7524f4ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3c2411ba05a302c374d17af87d66ec9a50291f3a766a875f9788b78f143bac1"
    sha256 cellar: :any_skip_relocation, ventura:       "1ae027600ba12184a822ca99da4ceb5c95a8269c38951229cf7047ecca126a1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aefcb0328367af1812c090548a5c0ce476dd42726091854de0737e3074ab0672"
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
