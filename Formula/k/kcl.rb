class Kcl < Formula
  desc "CLI for the KCL programming language"
  homepage "https://github.com/kcl-lang/cli"
  url "https://github.com/kcl-lang/cli/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "e1f4ca172414ad1bc4b6ee6e3696c7e85442b13a105bca8bfa2e40a8917161e8"
  license "Apache-2.0"
  head "https://github.com/kcl-lang/cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1f650cf96685bcbcc81a616c2cb984998f89e5912624921ac7ecb702ddb38c51"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff54c0a9881613f4b88e06e4ed7f89a782c121c191544761ef08f0fd2fcbadc2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ffb9069bb4dce75071e1e9c090784cf85d82e3814165ab654ac5b18f0eeb78a3"
    sha256 cellar: :any,                 x86_64_linux:  "e0ae6c7ec635b1e7d5bd363a223e661a4148789f11b36e71ad39f13df2c5a0fc"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
