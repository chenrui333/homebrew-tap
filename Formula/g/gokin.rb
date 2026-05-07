class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.80.24.tar.gz"
  sha256 "910acd56cd89d53281afe78f8c2527bdf352f726c2cf280a0e2e73a5b1549a09"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b4ed8a7c00399382ac79f6f93fa3d6cbaf2feaf6335c6372f7426ecaff5ad697"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b4ed8a7c00399382ac79f6f93fa3d6cbaf2feaf6335c6372f7426ecaff5ad697"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b4ed8a7c00399382ac79f6f93fa3d6cbaf2feaf6335c6372f7426ecaff5ad697"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "db3cfbc51a8bd0d0045bf494942920ac986cb1ef41d84fefe13a85654c4a6aba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0de18ba84efc48e0f001a8c9b2f6e18b4855cc14fd798789ec622bff0610dae"
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
