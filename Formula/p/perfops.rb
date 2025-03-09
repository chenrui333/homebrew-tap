class Perfops < Formula
  desc "Tool to interact with hundreds of servers around the world"
  homepage "https://perfops.net/cli"
  url "https://github.com/ProspectOne/perfops-cli/archive/refs/tags/v0.8.18.tar.gz"
  sha256 "05ace04f3dc3ff76e49e4b2971ebb9ded8b8e1cd91308984c38e47da2e0a51c2"
  license "Apache-2.0"
  head "https://github.com/ProspectOne/perfops-cli.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "219e971c9fe92f6790994e35d515df376542cfb8c4d050cd9ad41e5734c9cb30"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48624f1d1a4056a5aaf603b991b65c37d48240d918c5995c1f09ed6bcb72bca3"
    sha256 cellar: :any_skip_relocation, ventura:       "a8cfd205190823385f189246c63464723d4db317ed5795c2735e40caa921a39e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08ae269f5f8101329aa2c9a4e6f481fcc41d23a6c86b60f413d14ae3e6c0fc76"
  end

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
