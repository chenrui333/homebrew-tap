class Kcl < Formula
  desc "CLI for the KCL programming language"
  homepage "https://github.com/kcl-lang/cli"
  url "https://github.com/kcl-lang/cli/archive/refs/tags/v0.12.3.tar.gz"
  sha256 "5cb96af40b065af620a2adb28615019bba8ceafa52e0f7325e6dea16bb143cfc"
  license "Apache-2.0"
  head "https://github.com/kcl-lang/cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8a700e18acc1364c1841b95213b24c85847ef8204ee0d142fd43edaa8e21cdc5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75f848aeb8b35f6bb6054a00b45f22d34603fb7fef1c21445c59c3a47a61c931"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d82d352253a66f4fa0b5ee7591592b6615925ee62365a41c9673f7faedce3460"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a404048ea35ba0fb0f028abdc9947e07137ff49540f84f85c03431157f6145c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab1d18d940d0db2fa033fdf29cfe84d0da4ab1547bd168acc5c9de6882a10d1d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X kcl-lang.io/cli/pkg/version.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/kcl"

    generate_completions_from_executable(bin/"kcl", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kcl --version")

    (testpath/"test.k").write <<~EOS
      hello = "KCL"
    EOS
    assert_equal "hello: KCL", shell_output("#{bin}/kcl run #{testpath}/test.k").chomp
  end
end
