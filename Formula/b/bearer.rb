class Bearer < Formula
  desc "SAST tool to find, filter, and prioritize code security & privacy risks"
  homepage "https://docs.bearer.com/"
  url "https://github.com/Bearer/bearer/archive/refs/tags/v1.51.1.tar.gz"
  sha256 "98bce2142f1a970395d233c774f4c8f52e2c65cb39da46d530f975396d95b093"
  license "Elastic-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "30dd64fd46a4c7a27264d2dde002909c3d8a1c8637108c8bfb97d0d3226a451d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c5bb189e6a4154772a6744c1a5eab738eb0597db03659229c2c0f9300b6169e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56a05bf70cf975e2409b3282f74c22eeea82a58b73dce0c5e091eafd46c6b975"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "808f718d9ec76f755434d7bff06b88ccb62331ee38a8f627c06eb6ac6a95c6af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f650dd655c455eae604aca584360cab772ed1a007d411793dbf31cea60d97a7"
  end

  depends_on "go" => :build

  def install
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
