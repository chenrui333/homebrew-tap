class FuckUCode < Formula
  desc "Detect legacy code mess and generate a beautiful report"
  homepage "https://github.com/Done-0/fuck-u-code"
  url "https://github.com/Done-0/fuck-u-code/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "4fd5eb391cd088eca2d329aca2a82eee330fdb5ba405d2c664726758e6401e45"
  license "MIT"
  head "https://github.com/Done-0/fuck-u-code.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a5c60b79d5e0f212fff90cd93da78773fb2e0d74d47bc11c097caab5b81729ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a5c60b79d5e0f212fff90cd93da78773fb2e0d74d47bc11c097caab5b81729ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5c60b79d5e0f212fff90cd93da78773fb2e0d74d47bc11c097caab5b81729ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15c0559b4965560531344b796b08064141bf5e3d0a90b3f34f9badf90814d20f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab7183b33a5c2ec4bc4644634c20292e430d53daf85770535912d34c4a39d74b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/fuck-u-code"

    generate_completions_from_executable(bin/"fuck-u-code", shell_parameter_format: :cobra)
  end

  test do
    assert_match "🌸 屎山代码分析报告 🌸", shell_output("#{bin}/fuck-u-code analyze")
  end
end
