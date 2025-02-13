class Kcl < Formula
  desc "CLI for the KCL programming language"
  homepage "https://github.com/kcl-lang/cli"
  url "https://github.com/kcl-lang/cli/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "cab864ab3641ad9bacba5e13c0241a2ae495682d2b2a9327c7c4804213c97a1b"
  license "Apache-2.0"
  head "https://github.com/kcl-lang/cli.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X kcl-lang.io/cli/pkg/version.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/kcl"

    generate_completions_from_executable(bin/"kcl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kcl --version")

    (testpath/"test.k").write <<~EOS
      hello = "KCL"
    EOS
    assert_equal "hello: KCL", shell_output("#{bin}/kcl run #{testpath}/test.k").chomp
  end
end
