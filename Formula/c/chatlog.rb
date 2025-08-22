class Chatlog < Formula
  desc "Easily use your own chat data"
  homepage "https://github.com/sjzar/chatlog"
  url "https://github.com/sjzar/chatlog/archive/refs/tags/v0.0.20.tar.gz"
  sha256 "74eae6595f72ef5aa053e363af0cae240ee6ff5fb9a605a8cdfaed2c8db06bf2"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf2166abb800fd435336f39340b2cacb3f6964d34961784960debbe634296762"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cffa0f2e96accd35b018be13a6bbe648531572058d9fd6b33c7f61c94793597f"
    sha256 cellar: :any_skip_relocation, ventura:       "298a4f711d0968423b483d9dfeb4e943895596380797fd620adc7d57fb022feb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62e5f51b5f8d9ea404a0ed3ebf3c7db302276a091b29f8c2ec93acae2c9f6a3a"
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
