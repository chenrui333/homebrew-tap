class GoGetter < Formula
  desc "Package for downloading things from a string URL using a variety of protocols"
  homepage "https://github.com/hashicorp/go-getter"
  url "https://github.com/hashicorp/go-getter/archive/refs/tags/v2.2.6.tar.gz"
  sha256 "4297ef8096ab42119ed20744ee236860870a6f057fee55725c7ba91ed0fa9cb0"
  license "MPL-2.0"
  head "https://github.com/hashicorp/go-getter.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "16a20cd2653106281cf6ac11bcc96e9a26b105d257727bf1d71946c05a416a18"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16a20cd2653106281cf6ac11bcc96e9a26b105d257727bf1d71946c05a416a18"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00df5865ebdd07738e850e586c75720ec0539bf6171b97ebdb9c2a18bbf4548e"
    sha256 cellar: :any,                 x86_64_linux:  "bf1a51f7c46fd5ebe7c44c0514c37dc6d8c1f6544836afe498fd2f6b69e0706e"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    cd "cmd/go-getter" do
      system "go", "mod", "download"
    end
  end

  def install
    ldflags = "-s -w -X main.GitCommit=#{version}"
    cd "cmd/go-getter" do
      system "go", "build", *std_go_args(ldflags:), "."
    end
  end

  test do
    (testpath/"src.txt").write("hi")
    system bin/"go-getter", "file://#{testpath}/src.txt", testpath/"dst"
    assert_equal "hi", (testpath/"dst/src.txt").read
  end
end
