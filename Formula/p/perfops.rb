class Perfops < Formula
  desc "Tool to interact with hundreds of servers around the world"
  homepage "https://perfops.net/cli"
  url "https://github.com/ProspectOne/perfops-cli/archive/refs/tags/v0.8.18.tar.gz"
  sha256 "05ace04f3dc3ff76e49e4b2971ebb9ded8b8e1cd91308984c38e47da2e0a51c2"
  license "Apache-2.0"
  head "https://github.com/ProspectOne/perfops-cli.git", branch: "develop"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/ProspectOne/perfops-cli/cmd.version=#{version}
      -X github.com/ProspectOne/perfops-cli/cmd.commitHash=#{tap.user}
      -X github.com/ProspectOne/perfops-cli/cmd.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/perfops --version 2>&1")

    output = shell_output("#{bin}/perfops ping --from 'eastern europe' google.com")
    assert_match "google.com ping statistics", output

    output = shell_output("#{bin}/perfops list countries")
    assert_match "Denmark", JSON.parse(output).first["name"]
  end
end
