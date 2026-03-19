class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.55.6.tar.gz"
  sha256 "4859331da336dd3d30395b69ca85051f852aa89007dfa8615583646be3950466"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "858df703f8b38c20b86a397a3cea3292fa81dedfd2ec5bff83608b1f4c4dbc78"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "858df703f8b38c20b86a397a3cea3292fa81dedfd2ec5bff83608b1f4c4dbc78"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "858df703f8b38c20b86a397a3cea3292fa81dedfd2ec5bff83608b1f4c4dbc78"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a9a156de726483ce8d419c08de145aa03fcf9f6045e1ac8541d27501fa030f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "caed14c5b38787db1eefee881bdde4c2c89d82b47c7d787b39cb0acdfec10f6a"
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
