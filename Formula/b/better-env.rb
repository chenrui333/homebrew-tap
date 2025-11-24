class BetterEnv < Formula
  desc "Secure, Developer-Friendly Alternative to .env"
  homepage "https://better-env.dev/docs"
  url "https://github.com/HarishChandran3304/better-env/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "181642d86edb6639df545e1317286b18cb0d416837b5614bd763983259249298"
  license "MIT"
  head "https://github.com/HarishChandran3304/better-env.git", branch: "main"

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
