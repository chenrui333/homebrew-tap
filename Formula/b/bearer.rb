class Bearer < Formula
  desc "SAST tool to find, filter, and prioritize code security & privacy risks"
  homepage "https://docs.bearer.com/"
  url "https://github.com/Bearer/bearer/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "677105bd9f3d270196d82f7f19d6fd7cf68b3a70a8339a6f4119010b02ef6509"
  license "Elastic-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eb38df92361051d0616e748e029df3048089a87101c6854338ec0104a661fafb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb87fdbe7ee94737e68b75abfd4d9ce89f38bda3a30321aac83231e619e18319"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a0bb63de7b3fbb979a5ce6d1cfcae66c5b4e563900aaf4079e5300b97568a478"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a4fd8d49f6982074d926707c80a2a8c44d4f56f3754c2b877b5d77e12b15f65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3989cb7950460bcc78c2afc22b8688c9d2c0b7d2b223a6aace66d786a3a0eec"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -s -w
      -X github.com/bearer/bearer/cmd/bearer/build.Version=#{version}
      -X github.com/bearer/bearer/cmd/bearer/build.CommitSHA=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/bearer"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bearer version 2>&1")

    (testpath/"test.js").write <<~JS
      const password = "this is my password";
      console.log(password);
    JS
    output = shell_output("#{bin}/bearer scan #{testpath}/test.js 2>&1", 1)
    assert_match "CRITICAL: Usage of hard-coded secret [CWE-798]", output
  end
end
