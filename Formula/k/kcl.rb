class Kcl < Formula
  desc "CLI for the KCL programming language"
  homepage "https://github.com/kcl-lang/cli"
  url "https://github.com/kcl-lang/cli/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "c5be30a27f83847ab75471ccf04182cedabd3f026b4ebe35f9dc0af59d2cb5eb"
  license "Apache-2.0"
  head "https://github.com/kcl-lang/cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3ca0b30e3802928b0a58776f717f753717e8977dfb46860a542ab176ab013f3d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca8eb2528dd868fcf3fca5879fe94fdc14d57f1cdeed910221cc6f26e3fc1bfa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81ee8ff39955fd7a78af03774001da65a1a3eb9b8ed2db9ef81e021c7129c3ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd9c2c09e8b1b20e0ff9eed9d55f62610ee7adeec2f1d451ff7070462e39fe3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36aa134a26005b5c67f2b88b385205545b5544f66ada9f4b4a1b6cd76a9506c8"
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
