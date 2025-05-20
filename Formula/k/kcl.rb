class Kcl < Formula
  desc "CLI for the KCL programming language"
  homepage "https://github.com/kcl-lang/cli"
  url "https://github.com/kcl-lang/cli/archive/refs/tags/v0.11.2.tar.gz"
  sha256 "b4cb6ea7ab36a7a5ca94316e5db49852c703c83233f7a4da5c73a2ecee24b8fa"
  license "Apache-2.0"
  head "https://github.com/kcl-lang/cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3210183b28b514bdc0b2f9678b8063fcd72cd79a522b4814b0ac3dc07f0dd14b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1745f5878661ac5e496d48ff43bcf02db8eebf1f2a5d624c763d82c2f1190dae"
    sha256 cellar: :any_skip_relocation, ventura:       "0bfcca9f44ad265a39cdea3746b63e703a1339929fee65870ec55fb214b18eae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfbf6785011686b51ec80dc8297a58b16ef45a21df470d84668498004ed1b9a1"
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
