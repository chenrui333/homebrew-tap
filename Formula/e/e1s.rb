class E1s < Formula
  desc "TUI for managing AWS ECS, inspired by k9s"
  homepage "https://github.com/keidarcy/e1s"
  url "https://github.com/keidarcy/e1s/archive/refs/tags/v1.0.51.tar.gz"
  sha256 "c0f368ca487386b9105b675aff066eb9d1f03a31e1edcd2986bccb687c07058e"
  license "Apache-2.0"
  head "https://github.com/keidarcy/e1s.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "124254b8071bd2c12d297884f09847f9d9ea5ac99c090292128d5c1394d2af37"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "124254b8071bd2c12d297884f09847f9d9ea5ac99c090292128d5c1394d2af37"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "124254b8071bd2c12d297884f09847f9d9ea5ac99c090292128d5c1394d2af37"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9acf669670678bc540c572e29bb975cbb4736ac31dfc31181b7f3dc6d86deff1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "475f4d937ebd795ed25402325f04b04493d060431ebc3d8dfb2a8a9bf2b0b715"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/e1s"
  end

  test do
    ENV["AWS_REGION"] = "us-east-1"
    ENV["AWS_ACCESS_KEY_ID"] = "test"
    ENV["AWS_SECRET_ACCESS_KEY"] = "test"

    assert_match version.to_s, shell_output("#{bin}/e1s --version")

    output = shell_output("#{bin}/e1s --json --region us-east-1 2>&1", 1)
    assert_match "e1s failed to start, please check your aws cli credential and permission", output
  end
end
