class Kcl < Formula
  desc "CLI for the KCL programming language"
  homepage "https://github.com/kcl-lang/cli"
  url "https://github.com/kcl-lang/cli/archive/refs/tags/v0.12.4.tar.gz"
  sha256 "f9b70ff4aa01661ebae8d84d40c05911a28db9ca8c668f930e46b8bb59ed9e36"
  license "Apache-2.0"
  head "https://github.com/kcl-lang/cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c196886ef5812aa741efe9fd47552022d0b78d1fd323cc86b92d557ca4d2dd6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "371cf2a8c541ce999c0cfb374d8c723dfaa24d2b6cb01089e712b7fb7cd8d9f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "517a02b135b8e65565b844b3d8becfaf1e91c00fa1c3e3c1c29c3956e89cdb93"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ec9f5c23ae038bdea87f0178bf1e4883d3e88f0635a7b2795242b4c53b7c692"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28e174056fa5987288e9dfa23337cad945971fe77f7fa6a9e257f704a6ad8f03"
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
