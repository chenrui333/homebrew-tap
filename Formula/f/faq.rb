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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f9044ac00542edde1f594cf12bb74ad754b79c18e0357d19bb76b158c4ed0bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89a0e130dff9f88e6082a207e7f5b856e70a10681fcc418705a1b3676a37cabb"
    sha256 cellar: :any_skip_relocation, ventura:       "788c94f5fa990884213466eec43139ed77fd1a181039fdf45574a83e422cd25f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6a3287e28561bf611f0cec3459a485142283a7624f6571b558464c65ff0ae83"
  end

  depends_on "go" => :build
  depends_on "jq"

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
