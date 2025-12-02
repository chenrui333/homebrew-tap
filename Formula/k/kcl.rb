class Kcl < Formula
  desc "CLI for the KCL programming language"
  homepage "https://github.com/kcl-lang/cli"
  url "https://github.com/kcl-lang/cli/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "c4ba1850c3bdeb9f82facff1b5edf373378c367d24898b591187f6500eb2c4c7"
  license "Apache-2.0"
  head "https://github.com/kcl-lang/cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "78053b91f17e959720b00eadfe396df7cdf01b7b7ad148cb4dbe45737f4d9574"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73782c01627357104185f00370a6ff15a0b75113a95a32b43518903a08a63ac1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ccdb81fd6e6901f59b9ec5bda4b917dd31fa022b4da686d145a26c7c0e4bdd4a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "69e31fb61dffed4a7e8172a197a6a45b39c45d65ab879cf7b22ffe90f7eaba2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61acf26709f9b0f04224b7ec29b455d942c319fd9ff2071524a294155df472cb"
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
