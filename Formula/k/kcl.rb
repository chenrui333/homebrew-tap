class Kcl < Formula
  desc "CLI for the KCL programming language"
  homepage "https://github.com/kcl-lang/cli"
  url "https://github.com/kcl-lang/cli/archive/refs/tags/v0.13.2.tar.gz"
  sha256 "c9319b86fb5fa3f36c09437d1e7620703b75cfad5e4419b9a4a2ace08ab5f38a"
  license "Apache-2.0"
  head "https://github.com/kcl-lang/cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c704f2ada670ef94c44abd1ed147b30ea47830d8227f72d2285fe3a00f8ef38f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9115e504c6508e6fee3ac9c51de67e5914846aa073a52e48e3a6a72856668079"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e76ce757603b1e7891d81fa29e2f77c0d09e7c1baa3c434524d34c1ed392b5a7"
    sha256 cellar: :any,                 x86_64_linux:  "d12680520153c0a5a04ad236ad5ac9c54f1b537f12d19c15439309adaec48c64"
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
