class TfSummarize < Formula
  desc "CLI to print the summary of the terraform plan"
  homepage "https://github.com/dineshba/tf-summarize"
  url "https://github.com/dineshba/tf-summarize/archive/refs/tags/v0.3.14.tar.gz"
  sha256 "c4ea4825aef3bb393917aaa97beec66a07e58890229bd4832f719b1dad4f449e"
  license "MIT"
  head "https://github.com/dineshba/tf-summarize.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30256999609720794a429bedba204f6b4d6d9a712d4e1f685186a410b566f61e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44fec917e18bc9bc08eb079a368b1d0b7df3ee8abf34815119c9c91258924446"
    sha256 cellar: :any_skip_relocation, ventura:       "49565fbe02c7316fce7d58910c6bc3c0c33ebbc0a0915eebb2e4743061f52c06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff9fff28bb1a2f8fde625f144b5e0accc4fb4c4ddde198390828b567b28402c1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    resource "tfplan.json" do
      url "https://raw.githubusercontent.com/dineshba/tf-summarize/c447ded989b8e84b52d993e0b0e30139b5fb5818/example/tfplan.json"
      sha256 "ceca61c72c77b4400d4170e58abc0cafd3ad1d42d622fe8a5b06cdfba3273131"
    end

    assert_match version.to_s, shell_output("#{bin}/tf-summarize -v")

    testpath.install resource("tfplan.json")
    output = shell_output("#{bin}/tf-summarize -json-sum #{testpath}/tfplan.json")

    # {
    #   "changes": {
    #     "add": 7,
    #     "delete": 0,
    #     "import": 0,
    #     "recreate": 0,
    #     "update": 0
    #   }
    # }
    assert_match "7", JSON.parse(output)["changes"]["add"].to_s
  end
end
