class JsonlGraph < Formula
  desc "CLI for JSONL Graph"
  homepage "https://github.com/nikolaydubina/jsonl-graph"
  url "https://github.com/nikolaydubina/jsonl-graph/archive/refs/tags/v1.2.3.tar.gz"
  sha256 "cd61614046413f942cb9bb1417d1e8ff2aa5ab9ccad8c78bd2aab73fb455ae3d"
  license "MIT"
  head "https://github.com/nikolaydubina/jsonl-graph.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5adf16cd42f88f30e17a36cba7ba08b1e7f7c8cf907dfb54a4b7829ecc1e9a34"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5adf16cd42f88f30e17a36cba7ba08b1e7f7c8cf907dfb54a4b7829ecc1e9a34"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dfa63b8e65f73d1f13dd0f8052b137ab80c148547f181114ee2f1239abc589c4"
    sha256 cellar: :any,                 x86_64_linux:  "87f99c6a09a45ff4472e6e4885c0ccfeb296f93e144d3f926960412c040156d6"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    # FIXME: Upstream does not expose a version command; replace with a version assertion when available.
    (testpath/"test.jsonl").write <<~JSON
      {
        "to": "Pod:nginx-6799fc88d8-j4vv8",
        "from": "ReplicaSet:nginx-6799fc88d8"
      }
      {
        "to": "Pod:nginx-6799fc88d8-np6b7",
        "from": "ReplicaSet:nginx-6799fc88d8"
      }
      {
        "to": "Pod:nginx-6799fc88d8-xjd9w",
        "from": "ReplicaSet:nginx-6799fc88d8"
      }
    JSON

    test_file = (testpath/"test.jsonl").read
    output = pipe_output(bin/"jsonl-graph", test_file)
    assert_match "Pod:nginx-6799fc88d8-j4vv8", output
    assert_match '"ReplicaSet:nginx-6799fc88d8" -> "Pod:nginx-6799fc88d8-j4vv8"', output
  end
end
