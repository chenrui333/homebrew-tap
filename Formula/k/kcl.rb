class Kcl < Formula
  desc "CLI for the KCL programming language"
  homepage "https://github.com/kcl-lang/cli"
  url "https://github.com/kcl-lang/cli/archive/refs/tags/v0.12.10.tar.gz"
  sha256 "cf06ef38bc01613b8b597fa8957d29e05a149a9d7532c5e4d56d14acb25aa8b0"
  license "Apache-2.0"
  head "https://github.com/kcl-lang/cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f1a9f01442f072fe41508fb951c21bf61745e0ed2c9aceef0dccd8e051f18b9a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc6f74506f2a4c9f28c944b31b03e9a1e2ac8abf76ac6ab80dccfad9ccd70143"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e0dc37893dafc8dddc7d145bf0c9fa464bae56b0d77d8e1d1f1157eccb3ef9c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67d681e080a79d044cada3989a036afb4bf48a77c715f615ce8614f4632a8613"
    sha256 cellar: :any,                 x86_64_linux:  "af9a219ffafa6c23df360649b53cefaba6a4116928194e9751ee199f08c6c9e5"
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
