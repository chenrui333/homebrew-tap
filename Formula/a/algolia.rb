class Algolia < Formula
  desc "CLI for Algolia"
  homepage "https://www.algolia.com/doc/tools/cli"
  url "https://github.com/algolia/cli/archive/refs/tags/v1.6.11.tar.gz"
  sha256 "0965dadab1519128130532141701efbf56310f7cb9735c1da596cf6f2aad4657"
  license "MIT"
  head "https://github.com/algolia/cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ec24885ccff9da1162f16d61b4f7506f581da7f9598ffaa2af282542db566f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eae4a5fa07ca96e5bb60e5d24e02bb81f4b18b63e210f50a73ce9feccacd0bed"
    sha256 cellar: :any_skip_relocation, ventura:       "d0c697ed1b7161ebe459b2eae03e5f2cd5dcf9900e5ff3126c6ae75eca635cf2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80df9c535295608eb5317c1e9003b4896a2ec0843838843ad43af8a51c2e60ff"
  end

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
