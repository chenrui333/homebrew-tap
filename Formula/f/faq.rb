class Faq < Formula
  desc "More flexible jq supporting additional formats (YAML/TOML/CSV)"
  homepage "https://github.com/jzelinskie/faq"
  url "https://github.com/jzelinskie/faq/archive/73f2ae41cd93b3f36ccbd49c66a1df45d6ee6fb3.tar.gz"
  version "0.0.7"
  sha256 "30bb89d9072ab4f185da3f2dcee0442205cfe4612cf479d988bea3338283d4b8"
  license "Apache-2.0"
  head "https://github.com/jzelinskie/faq.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4102e983ec2e589f944132971d1bd2f3419fdeacbd460d416ec44559dfead456"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3536576cd43a4b627df78f67331f3d4702051b9709c7379b78a2c2e72e367a1c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e0703862c1dfb873ed8e7ccbcb2a05c6f14d3f62777556631f318a01c13e4ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3201b6bd913cc939238e5bcbe76dd50d044f2544bc7ca15f8c4e212df1827fe0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2acbfb82efe4cf6b4fc5703913c827dac13598b90714b2184f09e4ae160608bb"
  end

  depends_on "go" => :build
  depends_on "jq"

  on_macos do
    depends_on "oniguruma"
  end

  def install
    ldflags = "-s -w -X github.com/jzelinskie/faq/internal/version.Version=#{version}"
    system "go", "build", "-tags", "netgo", *std_go_args(ldflags:), "./cmd/faq"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/faq --version")

    (testpath/"test.json").write <<~JSON
      {"foo": {"bar": "baz"}}
    JSON
    out = shell_output("#{bin}/faq -f json '.foo.bar' #{testpath}/test.json")
    assert_equal "\"baz\"", out.chomp

    (testpath/"test.yml").write <<~YAML
      a: 42
    YAML
    out2 = shell_output("#{bin}/faq -f yaml '.a' #{testpath}/test.yml")
    assert_equal "42\n", out2
  end
end
