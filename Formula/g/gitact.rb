class Gitact < Formula
  desc "Explore GitHub profiles, repositories, and activity from the terminal"
  homepage "https://github.com/nathbns/gitact"
  url "https://github.com/nathbns/gitact/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "518b350ce13c29239672e3a2b49d62c8d61bb74578e38198f82c8ea5868e7782"
  license "MIT"
  head "https://github.com/nathbns/gitact.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6924104651be2e1f9e815e3cb8c283fa8846f9d22bbc8fd93043d34f780fed44"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6924104651be2e1f9e815e3cb8c283fa8846f9d22bbc8fd93043d34f780fed44"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6924104651be2e1f9e815e3cb8c283fa8846f9d22bbc8fd93043d34f780fed44"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30251ee968b867d4c9f48b0a6e36b3151bee91f9ddc7a716ea35082e4fac4381"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b05f788c2383b94aefd99b278e2ac7e23ac21d1950fc4eab1c83b16f730ef5b5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "."
  end

  test do
    assert_match "GitHub Activity CLI - Modern Edition", shell_output("#{bin}/gitact --help")

    output = shell_output("#{bin}/gitact --repos 2>&1", 1)
    assert_match "error: --repos requires a username", output
    assert_match "usage: #{bin}/gitact --repos <username>", output
  end
end
