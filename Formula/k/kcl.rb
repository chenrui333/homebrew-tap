class Kcl < Formula
  desc "CLI for the KCL programming language"
  homepage "https://github.com/kcl-lang/cli"
  url "https://github.com/kcl-lang/cli/archive/refs/tags/v0.12.9.tar.gz"
  sha256 "a828be2a3cceda090fe970a3c4c4d433cd0adda249158be50119b0bfdbc936b0"
  license "Apache-2.0"
  head "https://github.com/kcl-lang/cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b83aefd9fb2d1101a64fcfbd673ce4cbc0dc1d95831fc330f843eaf1bbd93c31"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b1cbcea0c07db3ae768fb79a9594d965c38630fd091f8d2bff927747b425907"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "049233c7d54a1fec9eb9b10eae9fc2b6c7ddcf2e107ec8d485d920c5f9c18df4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a010e298912ceb3309c52334903910d6966b54a7c97375fff3c6699f42a977c5"
    sha256 cellar: :any,                 x86_64_linux:  "daaf573d3df19686f31fd9632a59cd46bde452f87cfc25808e37e1ea30822b68"
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
