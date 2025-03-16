class JsonlGraph < Formula
  desc "CLI for JSONL Graph"
  homepage "https://github.com/nikolaydubina/jsonl-graph"
  url "https://github.com/nikolaydubina/jsonl-graph/archive/refs/tags/v1.2.3.tar.gz"
  sha256 "cd61614046413f942cb9bb1417d1e8ff2aa5ab9ccad8c78bd2aab73fb455ae3d"
  license "MIT"
  head "https://github.com/nikolaydubina/jsonl-graph.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
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
    assert_match "Pod:nginx-6799fc88d8-j4vv8", pipe_output("#{bin}/jsonl-graph", test_file)
  end
end
