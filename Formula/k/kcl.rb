class Kcl < Formula
  desc "CLI for the KCL programming language"
  homepage "https://github.com/kcl-lang/cli"
  url "https://github.com/kcl-lang/cli/archive/refs/tags/v0.12.5.tar.gz"
  sha256 "c5c1906b8243593e7664560ff4e70620d187a7a928835b60a9694ee03df66ed0"
  license "Apache-2.0"
  head "https://github.com/kcl-lang/cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a4824c195dd782b634593a4ff3b3f9cd90d8d095a4175bdce1461bf826849f98"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a044d75bd1884ba1c1dcd3bca3a1559100a758f2c0e888b9a79564351ed139c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d751ff7046c9dee27a6c2b530f8168965e5cc52a63c363fc89ddbf7f5ef29c0b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ebe81547f852f266ac5590732694a7dbfe6e0735267fda2dd15b8050be401019"
    sha256 cellar: :any,                 x86_64_linux:  "a2046a079e89c583e35a9da55c2f1af0381794d8753c6295a9d0a17574be9993"
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
