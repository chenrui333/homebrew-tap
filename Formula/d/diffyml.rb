class Diffyml < Formula
  desc "Structural YAML diff tool with Kubernetes intelligence"
  homepage "https://github.com/szhekpisov/diffyml"
  url "https://github.com/szhekpisov/diffyml/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "86d1746ff1dad438da46ddbaae4681ab79cf65ad6d4c4a356eb1cd3c9fb1813b"
  license "MIT"
  head "https://github.com/szhekpisov/diffyml.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "336b36a1c86367acd1d64e7a69a3a353253214d9c73ffef8aa98beca37aec2b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "336b36a1c86367acd1d64e7a69a3a353253214d9c73ffef8aa98beca37aec2b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "336b36a1c86367acd1d64e7a69a3a353253214d9c73ffef8aa98beca37aec2b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "29175b972efa88732c5eb67fb8ec6bd25a161f75bf556572fd48d5fd5c9420fb"
    sha256 cellar: :any,                 x86_64_linux:  "9cc6827ee4d2055cd9f7f485267a3fce0d96339796bd49cd969bdff87127bf83"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.buildDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/diffyml --version")

    (testpath/"from.yml").write "name: old\n"
    (testpath/"to.yml").write "name: new\n"
    output = shell_output("#{bin}/diffyml --color never from.yml to.yml")
    assert_match "Found one difference", output
    assert_match "+ new", output
  end
end
