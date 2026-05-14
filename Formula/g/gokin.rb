class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.81.4.tar.gz"
  sha256 "72bf81adbe8bea541a945992d080cf2918350c0ef94784fdffca2d4b34744885"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "373191b5213fb1cd376995d3702e0992d8639805ae3a17e11e6e24ec1541c2fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "373191b5213fb1cd376995d3702e0992d8639805ae3a17e11e6e24ec1541c2fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "373191b5213fb1cd376995d3702e0992d8639805ae3a17e11e6e24ec1541c2fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "841b9ae7ae6ecfaecf115c07f25099e9bf5f6ac9854d8d2ab5b187b4371753ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97bbd8c2064652235078f042493bf22e6b7acd4c57e6ea999e536191766dfdb8"
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
