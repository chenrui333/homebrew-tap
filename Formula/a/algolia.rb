class Algolia < Formula
  desc "CLI for Algolia"
  homepage "https://www.algolia.com/doc/tools/cli"
  url "https://github.com/algolia/cli/archive/refs/tags/v1.6.11.tar.gz"
  sha256 "0965dadab1519128130532141701efbf56310f7cb9735c1da596cf6f2aad4657"
  license "MIT"
  head "https://github.com/algolia/cli.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/algolia/cli/pkg/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/algolia"

    generate_completions_from_executable(bin/"algolia", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/algolia --version")

    output = shell_output("#{bin}/algolia apikeys list 2>&1", 4)
    assert_match "you have not configured your Application ID yet", output
  end
end
