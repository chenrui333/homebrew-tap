class Kcl < Formula
  desc "CLI for the KCL programming language"
  homepage "https://github.com/kcl-lang/cli"
  url "https://github.com/kcl-lang/cli/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "cab864ab3641ad9bacba5e13c0241a2ae495682d2b2a9327c7c4804213c97a1b"
  license "Apache-2.0"
  head "https://github.com/kcl-lang/cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "620e38ee0fc211100dc7a7fcc789ed9e5a976018e7215881a02dab04e5312f0c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bef349d53c605a02db7a81f440c4bbe39b6fb53ee8f825365a4688ec5aa80b04"
    sha256 cellar: :any_skip_relocation, ventura:       "3de95c6c7c7b0d349ea725983e21dd5bbfe7e4d0accb0e3ad9850649d1d8f6c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b0d5e2c65ab4ef3a93bdd85bbe7c280d029a4fa801a0d31b01c91bf2327809c"
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
