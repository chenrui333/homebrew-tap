class Panix < Formula
  desc "Deploy Nix configurations across machines"
  homepage "https://github.com/mihakrumpestar/panix"
  url "https://github.com/mihakrumpestar/panix/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "c32b471c1a837ccb5789fee895fd724784df0692f5130d8d6e29b18cc4804947"
  license "AGPL-3.0-only"
  head "https://github.com/mihakrumpestar/panix.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "976319cab17db6f666d24c91f56252c3857a2a9066e0634fae03c5168670aa87"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "976319cab17db6f666d24c91f56252c3857a2a9066e0634fae03c5168670aa87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e0b74b50783b7bc558edca88422b772b53970e93ffdd147eebe249d4c21a937d"
    sha256 cellar: :any,                 x86_64_linux:  "1810d6673f2ff301af172e178809565f68216364c5e00074baf366bf26898f02"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/panix"
    generate_completions_from_executable(bin/"panix", "completion", "--code")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/panix --version")
    output = shell_output("#{bin}/panix schema --output -")
    assert_match "Panix Configuration Schema", output
  end
end
