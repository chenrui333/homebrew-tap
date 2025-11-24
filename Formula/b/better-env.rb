class BetterEnv < Formula
  desc "Secure, Developer-Friendly Alternative to .env"
  homepage "https://better-env.dev/docs"
  url "https://github.com/HarishChandran3304/better-env/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "181642d86edb6639df545e1317286b18cb0d416837b5614bd763983259249298"
  license "MIT"
  head "https://github.com/HarishChandran3304/better-env.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2cd496d1ff136919ea8cede59a9ad993a6a2d749eed2af6b6d7c7d3292e6cb5d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2cd496d1ff136919ea8cede59a9ad993a6a2d749eed2af6b6d7c7d3292e6cb5d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2cd496d1ff136919ea8cede59a9ad993a6a2d749eed2af6b6d7c7d3292e6cb5d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9b903c954aeb7326899668b1b3ac4833e9b855a8beb5c142f731db9cf7a74798"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1af2cfff78be361dca3c082c188ca9d71556e38471782b22628ddefa073c6ce8"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/HarishChandran3304/better-env/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/better-env --version")
    assert_match "better-env is not configured", shell_output("#{bin}/better-env init 2>&1", 1)
    assert_match ".better-env file not found", shell_output("#{bin}/better-env list 2>&1", 1)
  end
end
