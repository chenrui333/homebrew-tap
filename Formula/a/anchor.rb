class Anchor < Formula
  desc "CLI for archor.dev"
  homepage "https://anchor.dev/"
  url "https://github.com/anchordotdev/cli/archive/refs/tags/v0.1.12.tar.gz"
  sha256 "02b2f7de0443d6ddfb2d54cd198b7e4f263f94bd4bf438737563d5d19cb88add"
  license "MIT"
  head "https://github.com/anchordotdev/cli.git", branch: "main"

  depends_on "go" => :build

  def install
    # TODO: fix the ldflags version overload
    # ldflags = %W[
    #   -s -w
    #   -X github.com/anchordotdev/cli/cli.Version.Version=#{version}
    #   -X github.com/anchordotdev/cli/cli.Version.Commit=homebrew
    #   -X github.com/anchordotdev/cli/cli.Version.Date=#{build_time.iso8601}
    #   -X github.com/anchordotdev/cli/cli.SkipReleaseCheck=true
    #   -X github.com/anchordotdev/cli/cli.Executable=anchor
    # ]
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/anchor"

    generate_completions_from_executable(bin/"anchor", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    system bin/"anchor", "version"

    output = shell_output("#{bin}/anchor auth whoami")
    assert_match "not signed in", output
  end
end
