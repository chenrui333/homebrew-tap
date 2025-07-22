class Kcl < Formula
  desc "CLI for the KCL programming language"
  homepage "https://github.com/kcl-lang/cli"
  url "https://github.com/kcl-lang/cli/archive/refs/tags/v0.11.3.tar.gz"
  sha256 "c45c3566bb0eeac52ecc0ab401200f2e88e0339a3bb06101bb47315cf6822ae2"
  license "Apache-2.0"
  head "https://github.com/kcl-lang/cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af6bd3bea20abe5a4ec37d06c58d3860ed1d3d07d967aa6641a72b1603fb950b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61d16bc9ef200002cd4c355e513bf80a373e93d3c0ff7c42d82077abb8c3675a"
    sha256 cellar: :any_skip_relocation, ventura:       "735aec06b27e695555846c3937d9b95ca8241cdacea7292f2389f79c6161e6ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dbeea4b3d6c199faddbf22944abcde05d9da0eace2e414b460364db639bdf1f4"
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
