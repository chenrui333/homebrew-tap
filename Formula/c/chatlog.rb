class Chatlog < Formula
  desc "Easily use your own chat data"
  homepage "https://github.com/sjzar/chatlog"
  url "https://github.com/sjzar/chatlog/archive/refs/tags/v0.0.29.tar.gz"
  sha256 "3d89406c9b19e94fa3b0f7a8504d60233091eb1e86c95af69c8f24bf78e16755"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a43ce765564e6f7458f767f0b928d6d5d5a19b9c8da621028444e065e0e416a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9319fb665fb34df9010a6b053dae1dc7bf603e500012099f80a8cadf7ffd5bbd"
    sha256 cellar: :any_skip_relocation, ventura:       "3f4b33c248035a729e469a370277bc41acf2aa234672c85bd5087afccc20dc0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "291a8ed31e9a86176c64ba4e855579dff2dc795ddf88f28456661f743f9eb060"
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
