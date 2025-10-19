class Chatlog < Formula
  desc "Easily use your own chat data"
  homepage "https://github.com/sjzar/chatlog"
  url "https://github.com/sjzar/chatlog/archive/refs/tags/v0.0.31.tar.gz"
  sha256 "e2eb72bdfcfb36bef2fe6f7c4e983db8ebf60ecb124e43de49562d711b3b9a65"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ca07a5f201836171c5faaac8bb9eb2ce5188d9a774c74a89dadcaad5c985d0fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45060f5a399f54ac44f19f2b3efdfaf42de4265fb8d3fafde24ff9af1d279472"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c6a563481df98dc069f1d7cb7b1b989ecc40f3f3c281c759c465ec292a5c67f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2904ff0491789491e388a90068756ccd4b892ffec145cc0a537500760b29d0fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9355464eabe88f5d41ad0d5462cc44520a89b99dd976401cf957ef0cc3bced2f"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

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
