# framework: cobra
class Togo < Formula
  desc "Fast and simple terminal-based task and todo manager"
  homepage "https://github.com/prime-run/togo"
  url "https://github.com/prime-run/togo/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "c908fb2cdc8a166b1ff030aa58bec728bd872373c1e22fc7daac2bf35be87abb"
  license "MIT"
  head "https://github.com/prime-run/togo.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d2e2b06327895e175873b8d0e5dd96f5c71bc0a102835989a18c2c6ede4ef2a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d2e2b06327895e175873b8d0e5dd96f5c71bc0a102835989a18c2c6ede4ef2a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad5899aa8a627c33434c1d476f9022d9345bce3eaeac9d1f3adea27c3b9ae79f"
    sha256 cellar: :any,                 x86_64_linux:  "b9376f9eb50920d5762fcf44dbfb83be68e526ed75e60ad00895ea7a8f0619ca"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin/"togo", shell_parameter_format: :cobra)
  end

  test do
    require "json"

    init_output = shell_output("#{bin/"togo"} init")
    assert_match "Initialized .togo in:", init_output

    add_output = shell_output("#{bin/"togo"} --source project add \"write docs\"")
    assert_match "Todo added successfully", add_output

    add_output = shell_output("#{bin/"togo"} --source project add \"ship formula\"")
    assert_match "Todo added successfully", add_output

    todo_path = testpath/"todos.json"
    assert_path_exists todo_path

    todos = JSON.parse(todo_path.read)
    assert_equal 2, todos["todos"].length
    assert_equal "write docs", todos["todos"][0]["title"]
    assert_equal false, todos["todos"][0]["completed"]
    assert_equal "ship formula", todos["todos"][1]["title"]
    assert_equal 3, todos["next_id"]
  end
end
