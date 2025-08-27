class Chatlog < Formula
  desc "Easily use your own chat data"
  homepage "https://github.com/sjzar/chatlog"
  url "https://github.com/sjzar/chatlog/archive/refs/tags/v0.0.26.tar.gz"
  sha256 "5c3fb3675615fe3abaad0565b018bb2a2645a60399fc9564267015ec397a5273"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac01589938363553cb507150eaa92b4361d3e821731a994c1c44d144ca194c9d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ab371b667d8bd7c233915d05e90cc68367567575bbc0aa812066cf19472f8ac"
    sha256 cellar: :any_skip_relocation, ventura:       "9f1156b6983eeeda6cd9ad1e5c77282a3c3489be1af77a07817e5757c2774a8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b7157f2c34a3aa633c432b48329ce80ed37877dd9cba32750dc32924ed9081b"
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
