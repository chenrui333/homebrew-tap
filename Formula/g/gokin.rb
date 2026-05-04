class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.78.58.tar.gz"
  sha256 "38646f4c598499bcf9a3085e16ce70f8fa8ef663e41adcbc516b7d328f216d0c"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cb44e69eb041076a8abaadc1cb81a8eb9448e16e9e42b87ba6b43139fc53e6e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb44e69eb041076a8abaadc1cb81a8eb9448e16e9e42b87ba6b43139fc53e6e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb44e69eb041076a8abaadc1cb81a8eb9448e16e9e42b87ba6b43139fc53e6e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "202891c942fa8726d26603c33ba1203e6b7b9e45e2094870b4fd637c309a90e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "345f7b4087c5858deff62270f3930331bb57b36d4b6058f6367834214defc9ae"
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
