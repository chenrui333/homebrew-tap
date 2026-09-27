class Kcl < Formula
  desc "CLI for the KCL programming language"
  homepage "https://github.com/kcl-lang/cli"
  url "https://github.com/kcl-lang/cli/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "e2409675a52d0bd656c7f2aa16304c5a2622c5b969412020159676b9c1753093"
  license "Apache-2.0"
  head "https://github.com/kcl-lang/cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "42ea4d6cb8388d328cf93a0a29258e84d1f2d323ae9312fba40f9ea10c2b399a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6582002689220af03f1345b061dc4d86c3e0c7a25ae6f81c1c62c0b29e36d39"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e47f5fc3c3166b83b1289b03df0016e86fecab0d74a0b562f2a2eaeb57aa8b57"
    sha256 cellar: :any,                 x86_64_linux:  "f035d56b0ab800abb8db51e51613425b6f74b21c04071a2af09c1bcd99c7d024"
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
