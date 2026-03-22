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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "96934431cbe074cd7397b6adbeb09c0e1b6c0ad2d3680c311de58fcc62f0e748"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96934431cbe074cd7397b6adbeb09c0e1b6c0ad2d3680c311de58fcc62f0e748"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "96934431cbe074cd7397b6adbeb09c0e1b6c0ad2d3680c311de58fcc62f0e748"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c116fe1067f96ac31c9e70e8b1ec5a415ddc6b74743bc32dd1d5e90fa8088108"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bbae20d9130231b8dc057336e81a1c70ba0bd1f8d29e1a5e90c61ea678d9ecd2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin/"togo", "completion", shell_parameter_format: :cobra)
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
