class FuckUCode < Formula
  desc "Detect legacy code mess and generate a beautiful report"
  homepage "https://github.com/Done-0/fuck-u-code"
  url "https://github.com/Done-0/fuck-u-code/archive/refs/tags/v1.0.0-beta.1.tar.gz"
  sha256 "0ca19c3d57da39ea091b47e829cea18e5a2420c68468e7c03995a3c9649a40bf"
  license "MIT"
  head "https://github.com/Done-0/fuck-u-code.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = "-s -w"
    system "go", "build", *std_go_args(ldflags:), "./cmd/fuck-u-code"

    generate_completions_from_executable(bin/"fuck-u-code", "completion")
  end

  test do
    assert_match "🌸 屎山代码分析报告 🌸", shell_output("#{bin}/fuck-u-code analyze")
  end
end
