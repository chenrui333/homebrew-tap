class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.81.4.tar.gz"
  sha256 "72bf81adbe8bea541a945992d080cf2918350c0ef94784fdffca2d4b34744885"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e9828a7cca220a401a879af3c9a8be079be7e28da608f5106a168691e9d10dc7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9828a7cca220a401a879af3c9a8be079be7e28da608f5106a168691e9d10dc7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9828a7cca220a401a879af3c9a8be079be7e28da608f5106a168691e9d10dc7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f9cd20b731e86657751d8b9ddb669fd60e013a97d0ee71bb13ac4f4a68c8e423"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "794c752d30f7df675e5e3d4c331722dea9fa9e725f1680f2bebcc367aeddaccd"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gokin"

    generate_completions_from_executable(bin/"gokin", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gokin version")
    assert_match "Available Commands:", shell_output("#{bin}/gokin --help")
  end
end
