class Diffyml < Formula
  desc "Structural YAML diff tool with Kubernetes intelligence"
  homepage "https://github.com/szhekpisov/diffyml"
  url "https://github.com/szhekpisov/diffyml/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "e0a71c1a69ab8247ade59b1265a68462f2bf415bebd1275dc0f02a4e036f73e5"
  license "MIT"
  head "https://github.com/szhekpisov/diffyml.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c84ad471bb055da3309e8268aca9814545fb466a05673650c96eaac367dadf0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c84ad471bb055da3309e8268aca9814545fb466a05673650c96eaac367dadf0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c84ad471bb055da3309e8268aca9814545fb466a05673650c96eaac367dadf0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "137a381f5efd375ac84abf434df3844d8b61809de3e6cdcd09a83cc21e158c14"
    sha256 cellar: :any,                 x86_64_linux:  "a43d1a10974486f0dbca31cd42ed138b6278f9424294f2ee312b55929673e3cc"
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
