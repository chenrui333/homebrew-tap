class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "a88075990e236e9a860c9236ac5c6165770971aeba698712b4fd7343db700af4"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2f618908d28501b5ae4d90efbc14ea964d037eeb4f12da0e35eaaa926d315530"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5c170d3c54dfdaf8740080a3256430bfecef8173971e9ad2a7bedcd3e1252cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b70fd2fe7f77a4cf67a2afca2d7d148626b2e2eca6e40c06d061f30ac1eae0bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4f25ef0bca0570ad35c2acaac89221278243317eb247f413e5ccd9cc20c79ad"
    sha256 cellar: :any,                 x86_64_linux:  "2caea93f46d2b76b5f02249dc313dd76d8116876bd8535c418122b24179c111c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/RoninForge/budgetclaw/internal/version.version=#{version}
      -X github.com/RoninForge/budgetclaw/internal/version.commit=HEAD
      -X github.com/RoninForge/budgetclaw/internal/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/budgetclaw"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/budgetclaw version")
    assert_match "No activity tracked yet", shell_output("#{bin}/budgetclaw status")
  end
end
