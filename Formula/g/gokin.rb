class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.100.49.tar.gz"
  sha256 "72d9376a1f16959efc6281d8396cf56f8bc4abc4526769d7cfbcf3902c9e27cf"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ef0085dc2d2ba09c72bf24e0c193e0af4871dd2e51db876e3d2fa699f50dc6f4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef0085dc2d2ba09c72bf24e0c193e0af4871dd2e51db876e3d2fa699f50dc6f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef0085dc2d2ba09c72bf24e0c193e0af4871dd2e51db876e3d2fa699f50dc6f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "03c5ee55e8df739a3bd80bb2d49a783e289df79e7392b3228d74b8985c67bcde"
    sha256 cellar: :any,                 x86_64_linux:  "c031ccda65e6e64c15c097ae472ac61311710e9ea7b792f568e708605d902c78"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gokin"

    generate_completions_from_executable(bin/"gokin", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gokin version")
    output = shell_output("#{bin}/gokin not-a-real-command 2>&1", 1)
    assert_match "unknown command", output
  end
end
