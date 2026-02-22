class Envlens < Formula
  desc "Inspect, search, and copy environment variables from the terminal"
  homepage "https://github.com/craigf-svg/envlens"
  url "https://github.com/craigf-svg/envlens/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "47e655fcd0736efc661652f5460e645759f8450907e2aa3978cc1145db9fc089"
  license "MIT"
  head "https://github.com/craigf-svg/envlens.git", branch: "master"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/envlens --version")

    output = shell_output("#{bin}/envlens --definitely-invalid-flag 2>&1", 2)
    assert_match "flag provided but not defined", output
  end
end
