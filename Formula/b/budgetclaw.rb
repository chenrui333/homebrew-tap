class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.27.tar.gz"
  sha256 "8ce67ae9ea1d4fc7aab73f6877a63f5d753cc4b3952e7ef2f0af1b8da9ab0035"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0c7214868f4ef4857e856880e0050d0a9dcb2dca603c91310bfd17268a1b2af3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4bbf9c40cc8a05666c6a7f0142cb0b4e04efdd81f5851a71b65d73924afedf22"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d580e31cfdc644cd096b4c815b78f031b49ac687ca31f22e558b37b7d7d66ef2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "593d9c1088f32ab4fa1e4998cda37291df3af5074133587482bbd499681aaa9a"
    sha256 cellar: :any,                 x86_64_linux:  "a5a5b997f07036beeab573d666e54e896e90f8ee81813de9ab497c9d296d2f7d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/RoninForge/budgetclaw/internal/version.version=#{version}
      -X github.com/RoninForge/budgetclaw/internal/version.commit=HEAD
      -X github.com/RoninForge/budgetclaw/internal/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/budgetclaw"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/budgetclaw version")
    assert_match "No activity tracked yet", shell_output("#{bin}/budgetclaw status")
  end
end
