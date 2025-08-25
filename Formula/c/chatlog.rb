class Chatlog < Formula
  desc "Easily use your own chat data"
  homepage "https://github.com/sjzar/chatlog"
  url "https://github.com/sjzar/chatlog/archive/refs/tags/v0.0.24.tar.gz"
  sha256 "b9ac29f1a2947bdd525c45bb4331a6637de35b9c3ad3007b1176ce8257768ee4"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf7fbd1f4e90855b0e534f257b0ef85d54d9e6c30f01da1dbd35f02d16e76967"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b370d7550d442040e8111c8fab481364fb7b9cb1a26dc37163a0eb850a2b100"
    sha256 cellar: :any_skip_relocation, ventura:       "f28cdebe38bc7fcb235f1aacdbe136dddb421e19295bb0eba61e0fd86347088d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ddd510637a7c16fe061cdbe3f9e563525f59423241dc8cacb179f3d71d9eb28a"
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
