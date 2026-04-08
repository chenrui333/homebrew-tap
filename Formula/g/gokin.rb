class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.56.7.tar.gz"
  sha256 "799bc2cd9048a8db1e4c7226ac3bc26f42edb5760ecbfc95e01eaedf43a63da9"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cd610e4e734cc67f048d2191eaea76166ca969dc6f15eaf87371aac5cd5ba6cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd610e4e734cc67f048d2191eaea76166ca969dc6f15eaf87371aac5cd5ba6cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd610e4e734cc67f048d2191eaea76166ca969dc6f15eaf87371aac5cd5ba6cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e23a4468885e276a86262cecfabcaf2c19563b5bac5b5a6b9a8ca81fff73c241"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90c73042e7434d4a3371475df1b36f3bbffc40e307e675714af834a8e3f1ad4f"
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
