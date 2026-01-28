class Bearer < Formula
  desc "SAST tool to find, filter, and prioritize code security & privacy risks"
  homepage "https://docs.bearer.com/"
  url "https://github.com/Bearer/bearer/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "983c2e2b0be5409b5f2278f40b58ee136e4ae3fc5184de382598ca70fb72d26b"
  license "Elastic-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "96f1b2c85934651d9489218d5aab0abcb5e0c9f81e976704992378e782df9d13"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aeababd3b16c0e0bc7271587a602641e5060d66cbd08309a12adecf87cc1932f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e11e4900eb9127ece85cad215828558651ed13a010bd287a9cf6f674afdd5833"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d7af5a1ed236516f798267163b23bc49c0514ac3e9bd65d7621dc99dbbe763f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92e3fb9b56cd244ccfc704a245b301bce0682ecb2ccfe4d1f76aa0c7521b4e72"
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
