class Kcl < Formula
  desc "CLI for the KCL programming language"
  homepage "https://github.com/kcl-lang/cli"
  url "https://github.com/kcl-lang/cli/archive/refs/tags/v0.12.10.tar.gz"
  sha256 "cf06ef38bc01613b8b597fa8957d29e05a149a9d7532c5e4d56d14acb25aa8b0"
  license "Apache-2.0"
  head "https://github.com/kcl-lang/cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dcb7a35171793b0c26e0f1a27ed23b68e348205b5bfeff9ec3e1e13625f1a393"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aef491b16680cbbec015e1b8729c8a84ed4e004e42aa41d06fa8582c59ad2055"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b4b2c84f585fa859b8fbab1807894de88581dd64fd7554c9f891cd1fd306df2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1f45594a6598a3fa1a80d6802e91a552409d088c8f4372ddbe7d0ebdecfbd46"
    sha256 cellar: :any,                 x86_64_linux:  "266f65983ec79fefd425abedd5aedcc6bd655c2741b7274a35179ec09ee48d27"
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
