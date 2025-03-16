class Gut < Formula
  desc "Beginner friendly porcelain for git"
  homepage "https://gut-cli.dev/"
  url "https://github.com/julien040/gut/archive/refs/tags/0.3.1.tar.gz"
  sha256 "6e9f8bed00dcdf6ccb605384cb3b46afea8ad16c8b4a823c0cc631f9e92a9535"
  license "MIT"
  head "https://github.com/julien040/gut.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/julien040/gut/src/telemetry.gutVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"gut", "completion")
  end

  test do
    system bin/"gut", "telemetry", "disable"

    assert_match version.to_s, shell_output("#{bin}/gut --version")

    system "git", "init", "--initial-branch=main"
    system "git", "commit", "--allow-empty", "-m", "test"
    assert_match "on branch main", shell_output("#{bin}/gut whereami")
  end
end
