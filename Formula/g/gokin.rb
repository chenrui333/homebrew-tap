class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.69.0.tar.gz"
  sha256 "db0e4545beebca0cab689dbdabf6504fdb231f935303043528f6c987761e7c06"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "59abbe34d166fcc2b1ec0516d7d0eace8693b443cca71ffc99a2cf028bd78eea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59abbe34d166fcc2b1ec0516d7d0eace8693b443cca71ffc99a2cf028bd78eea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59abbe34d166fcc2b1ec0516d7d0eace8693b443cca71ffc99a2cf028bd78eea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f2f021bd37cf47694906a95725b52e660cc7fba63b41008a3d57515e8a04744"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d727ccef9f1b6485eab2a8e5209402eb9eb46fb95f0702dcd7783b0dadb444f"
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
