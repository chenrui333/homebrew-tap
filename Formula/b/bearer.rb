class Bearer < Formula
  desc "SAST tool to find, filter, and prioritize code security & privacy risks"
  homepage "https://docs.bearer.com/"
  url "https://github.com/Bearer/bearer/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "983c2e2b0be5409b5f2278f40b58ee136e4ae3fc5184de382598ca70fb72d26b"
  license "Elastic-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "df4f6c023d10461df8ffcfef5656f3230d2e373e15b03a9d0422f82cefbec70c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be564e89c015fd6a9b8b226ee98690cb103a3db3129b7f4ac9957726df524321"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a5983a6e4c82bdebbb11e6ffa3f2b39aec53fdd3ee24505721c4d0c1c3fac41"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "efbbd1005cd80d0295218ede8c856fca2cb1c1c518134e851453b5c6053ef2db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f737dd2c6e3bd044110479a51974f9eb4a7dcae6b53cad9e768eb31d2888416"
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
