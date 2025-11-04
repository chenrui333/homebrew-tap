class Tuios < Formula
  desc "Terminal UI OS (Terminal Multiplexer)"
  homepage "https://github.com/Gaurav-Gosain/tuios"
  url "https://github.com/Gaurav-Gosain/tuios/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "79106c86d45732fabee62c00502e2a40048445da3bce6ef38a490b175b437e68"
  license "MIT"
  head "https://github.com/Gaurav-Gosain/tuios.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fbac7576a8b735a42171c02ac4cda1e047e30a36e1692273b9244ffea16a8350"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46a2d96055f51167fdbc4874e95f347b2b1fc96e9ad7d051ef84c8be5c0090aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e8c91842462c184d7bf3f98777448e34318bda69b93791878a57f2033564ebd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7fa398471b11f43e75e7deaff8354ecc6592bf1dd29fbd5b5ba2ba880725b101"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68ee4f1692dd9334292ffd08eb0db33fc23c562c3002b7c7ffea013c1beb31e0"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601} -X main.builtBy=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/tuios"

    generate_completions_from_executable(bin/"tuios", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tuios --version")

    assert_match "git_hub_dark", shell_output("#{bin}/tuios --list-themes")
  end
end
