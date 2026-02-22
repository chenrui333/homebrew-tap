class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.44.4.tar.gz"
  sha256 "1625f454c03848b44e13a6fecc1cb4aabf4890237f9461137afed42a5d05572d"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "88d1e226bf81a0e92365e1e42588d5081e91af46ae7e4eb24222184a349b4cfa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88d1e226bf81a0e92365e1e42588d5081e91af46ae7e4eb24222184a349b4cfa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88d1e226bf81a0e92365e1e42588d5081e91af46ae7e4eb24222184a349b4cfa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6799188d5b6d5a73e2a2ada23b9678ea88bccd222bc3b5a3c04cdbeaeb072a18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4df31af82f14a3c8eb659fb2d42ff838f8aec31d6bbd965d37486c83e7d69260"
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
