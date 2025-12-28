class Kcl < Formula
  desc "CLI for the KCL programming language"
  homepage "https://github.com/kcl-lang/cli"
  url "https://github.com/kcl-lang/cli/archive/refs/tags/v0.12.3.tar.gz"
  sha256 "5cb96af40b065af620a2adb28615019bba8ceafa52e0f7325e6dea16bb143cfc"
  license "Apache-2.0"
  head "https://github.com/kcl-lang/cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "edf5da01a7bb55179d776da08f6057cab3126c002d022e368ef54bbcbd6a46fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6aef938afd09f73943ebee089264c22e613c0d86ac75fdf54ba53cda44cbeb7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3969a23cad64b0cea228b573592398290efef20e3a43d8a7ef7a53dc9882d7c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b503504e4e04c26a2dd75677afeeeac092bb930bf30ae87097a684806e3e76eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d0535e245fd1f8ef7815bc2adc03a3546c4e2d9d5cf262fe4b40670af81b73e"
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
