class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.44.1.tar.gz"
  sha256 "a0b5a061e4a3c25fe01fe008b75c4d22dc9880ab6eb13c1ac603650c9507702d"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4e4d8632bfe21a865298f14aaebe5886bb706b494c4f0462012483c5ac74ef1c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e4d8632bfe21a865298f14aaebe5886bb706b494c4f0462012483c5ac74ef1c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e4d8632bfe21a865298f14aaebe5886bb706b494c4f0462012483c5ac74ef1c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e0aa7149bab60e1743ac12bd9207ef734d20d92e0ae39d502355eb02ffa16a60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "716bf18c5fde9e12fe951a01c45df5560dde1739a74c95b21d372e78efdf3931"
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
