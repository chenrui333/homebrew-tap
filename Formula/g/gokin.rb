class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.55.7.tar.gz"
  sha256 "efefcd8b2fca7d92d0abd1f109c5e6e2bf021f3517eac60a6e58651912a485f5"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a0abedd383ecd21c194dbae885d0b58150cf438e77e63359bee1bc8b27802683"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0abedd383ecd21c194dbae885d0b58150cf438e77e63359bee1bc8b27802683"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a0abedd383ecd21c194dbae885d0b58150cf438e77e63359bee1bc8b27802683"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a4040394165c8f6a6bef9bfd597a70fb029349dc6b055db24e4e5bc12a1537b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76098e0144a770183f5d941a6ca800b7bbb5c302ff67affd7174fe8d4c9afd2c"
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
