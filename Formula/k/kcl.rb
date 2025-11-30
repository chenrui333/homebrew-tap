class Kcl < Formula
  desc "CLI for the KCL programming language"
  homepage "https://github.com/kcl-lang/cli"
  url "https://github.com/kcl-lang/cli/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "c5be30a27f83847ab75471ccf04182cedabd3f026b4ebe35f9dc0af59d2cb5eb"
  license "Apache-2.0"
  head "https://github.com/kcl-lang/cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8c0319b5d9bc8d9daa1f26cbedbe69456b94a44742dfce66ee363776396e5551"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd25aac594da618942b6fb6eb0a1c4a4528785c0e53ebd448e1c650550792bb5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e936e3a2f23d13064f763d8c4b872b668ef8fab47a4dc4d8ac111d300ab730b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "999f35c72416e05ddc5fc94dcdca9757c603e055f7dca557f2547b29bdc1e9aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "700e0ca598923408ccd69163f6bce45661946dd196976457295456eab9f20121"
  end

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
