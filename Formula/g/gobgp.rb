class Gobgp < Formula
  desc "CLI tool for GoBGP"
  homepage "https://osrg.github.io/gobgp/"
  url "https://github.com/osrg/gobgp/archive/refs/tags/v3.37.0.tar.gz"
  sha256 "198c82cf77a73872350f10a3567096009b3794929a1aaf348c4924785a99d087"
  license "Apache-2.0"
  head "https://github.com/osrg/gobgp.git", branch: "master"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/gobgp"

    generate_completions_from_executable(bin/"gobgp", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gobgp --version")
    assert_match "context deadline exceeded", shell_output("#{bin}/gobgp neighbor 2>&1", 1)
  end
end
