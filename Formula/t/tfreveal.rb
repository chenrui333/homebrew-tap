# framework: urfave/cli
class Tfreveal < Formula
  desc "CLI to show Terraform plan with all the secret (sensitive) values revealed"
  homepage "https://github.com/breml/tfreveal"
  url "https://github.com/breml/tfreveal/archive/refs/tags/v0.0.4.tar.gz"
  sha256 "392ea05d250c6a19254e10643ba45a5bff16c566b81cba8a0e5527aff3317ced"
  license "MIT"
  head "https://github.com/breml/tfreveal.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f796f528b963022849e26d3580bee3b2dd30c35a3e2667dd1dc681d5b245adfd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ead5e6bd914141a882ba3e712cdf7d3fabf3e6c97765a4e45f961548d2a9dda"
    sha256 cellar: :any_skip_relocation, ventura:       "d874ab163e8fe032a5ced17e80df1fb2a1d1afc515662f39c4db9b79223ecafb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0cc99c05370b2e1a94642a802d681675ed414a4a0ee52b3df4ebacf005d4b57a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    resource "tfplan.json" do
      url "https://raw.githubusercontent.com/breml/tfreveal/refs/heads/master/testdata/sensitive/plan.json"
      sha256 "56e1460d2eab4978ff3348a22718fc89c4eebc2e4af41d29efcb1cd10589dc5f"
    end

    assert_match version.to_s, shell_output("#{bin}/tfreveal -v")

    testpath.install resource("tfplan.json")
    output = shell_output("#{bin}/tfreveal --no-color #{testpath}/plan.json")
    assert_match "null_resource.sensitive must be replaced", output
  end
end
