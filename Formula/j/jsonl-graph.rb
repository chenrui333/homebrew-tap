class JsonlGraph < Formula
  desc "CLI for JSONL Graph"
  homepage "https://github.com/nikolaydubina/jsonl-graph"
  url "https://github.com/nikolaydubina/jsonl-graph/archive/refs/tags/v1.2.3.tar.gz"
  sha256 "cd61614046413f942cb9bb1417d1e8ff2aa5ab9ccad8c78bd2aab73fb455ae3d"
  license "MIT"
  head "https://github.com/nikolaydubina/jsonl-graph.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "64bbb371ef954ef091f804f5a0e3478b3f20948f63266d5ee3a1da86e98757f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80c52de7a2d9397bf9ce7463b63e063cc7fdecf9c3031e9def510d9402d31fc7"
    sha256 cellar: :any_skip_relocation, ventura:       "ae3e1838f9ae00cbd3384e0a60050d4d20f9be241a393fc1c80bb7010c369ce5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b53974e89f26d6536c6ccfdc136e136245c18da34be1acc0641df1b5fcb6e3f"
  end

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
