class Av < Formula
  desc "Manage stacked PRs with Aviator"
  homepage "https://www.aviator.co/"
  url "https://github.com/aviator-co/av/archive/refs/tags/v0.1.12.tar.gz"
  sha256 "4d7ff2ae4b51421286c93f97a3f633734ffdf0882462374fac8ee08e20d14f1f"
  license "MIT"
  head "https://github.com/aviator-co/av.git", branch: "master"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/aviator-co/av/internal/config.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/av"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/av version")

    ENV["GITHUB_TOKEN"] = "testtoken"

    system "git", "init"

    output = shell_output("#{bin}/av init 2>&1", 1)
    assert_match "error: this repository doesn't have a remote origin", output
    assert_path_exists testpath/".git/av"
  end
end
