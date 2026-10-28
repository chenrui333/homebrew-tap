class Kcl < Formula
  desc "CLI for the KCL programming language"
  homepage "https://github.com/kcl-lang/cli"
  url "https://github.com/kcl-lang/cli/archive/refs/tags/v0.13.3.tar.gz"
  sha256 "03e1f3292c3232cd67d77d22794c0a555a1914e5d32b7479933a5dae34d43eb3"
  license "Apache-2.0"
  head "https://github.com/kcl-lang/cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a4adb6a3881a83fb162cb901f2cc64637772bfc23ca7d3d4a60f1a8e1a9c5f88"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e11a08c133078a1ded78001bdc23c60c9efa820f521cc2d02e7dc3d6eaf14785"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "511ab25577b4e1706e5bfef5d1232b078e171af27e34933d30749703630fcc7c"
    sha256 cellar: :any,                 x86_64_linux:  "0752ff7bf26ffcf95e0765ea7d08657784eaa1ed1a519f8c45fc07513b5a8d16"
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
