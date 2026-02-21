class Orla < Formula
  desc "High-performance execution engine for open-source agents"
  homepage "https://github.com/dorcha-inc/orla"
  url "https://github.com/dorcha-inc/orla/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "411c73b991fbb98849595ed6e5b42ec65b577f8b23b29bb62926bd4a8d65a17d"
  license "MIT"
  head "https://github.com/dorcha-inc/orla.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s
      -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"orla"), "./cmd/orla"
    generate_completions_from_executable(bin/"orla", "completion", shell_parameter_format: :cobra)
  end

  test do
    ENV["HOME"] = testpath
    (testpath/".orla/tools").mkpath
    assert_match version.to_s, shell_output("#{bin}/orla --version")
    assert_match "[]", shell_output("#{bin}/orla tool list --json")
  end
end
